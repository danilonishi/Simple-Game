package 
{
	import com.greensock.easing.Quad;
	import com.greensock.TimelineLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.FileReferenceList;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class Prototype extends Sprite 
	{
		
		private var _mDownPoint:Point = new Point(0, 0);
		private var distance:Number = 0;
		private var angle:Number = 0;
		private var ball:Sprite;
		private var target:Sprite;
		private var releaseTime:Timer;
		
		private var validDown:Boolean = false;
		private var maxHeight:Number = 0;
		private var power:Number = 0;
		
		private var heightScore:Number = 0;
		private var score:Number = 0;
		private var highScore:Number = 0;
		
		public function Prototype():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			releaseTime = new Timer(100);
			
			initFeedback();
			
		}
		
		private var acceleration:Point;
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (!validDown)
			{
				return;
			}
			
			this.removeEventListener(Event.ENTER_FRAME, draw);
			
			heightScore = 0;
			
			if (releaseTime != null || releaseTime.running)
			{
				releaseTime.stop();
				releaseTime.removeEventListener(TimerEvent.TIMER, countPoints);
				releaseTime.reset();
			}
			
			
			releaseTime.addEventListener(TimerEvent.TIMER, countPoints);
			releaseTime.start();
			
			if (ball != null)
			{
				ball.removeEventListener(Event.ENTER_FRAME, onBallEF);
				ball.parent.removeChild(ball);
				ball = null;
			}
			
			dots = new Vector.<Point>();
			this.removeEventListener(Event.ENTER_FRAME, draw);
			redraw();
			empty();
			
			ball = new Sprite();
			ball.graphics.beginFill(0xff0000, 1);
			ball.graphics.drawCircle(0, 0, 5);
			ball.graphics.endFill();
			ball.x = _mDownPoint.x;
			ball.y = _mDownPoint.y;
			addChild(ball);
			
			acceleration = new Point(Math.cos(angle) * distance, Math.sin(angle) * distance);
			power = distance;
			ball.addEventListener(Event.ENTER_FRAME, onBallEF);
		}
		
		private function countPoints(e:TimerEvent):void 
		{
			heightScore += Math.abs(ball.y - _mDownPoint.y);
		}
		
		private function onBallEF(e:Event):void 
		{
			ball.x -= acceleration.x*0.1;
			ball.y -= acceleration.y*0.1;
			acceleration.y -= 9.81;
			
			var v:Number = Math.abs(ball.y - _mDownPoint.y);
			if (v > maxHeight)
			{
				maxHeight = v;
			}
			
			if (ball.hitTestObject(target))
			{
				win();
			}
			else if (ball.x > stage.stageWidth || ball.x < 0 || ball.y < 0 || ball.y > stage.stageHeight)
			{
				lose();
			}
			
		}
		
		private function lose():void 
		{
			endRound();
			trace("Lost. Highscore: " + highScore);
		}
		
		private function win():void
		{
			trace("#### Win #### ");
			trace("Statistics:");
			
			var n:Number = 1 / getDistance(_mDownPoint, new Point(ball.x, ball.y)) * heightScore;
			score = Number(n.toFixed(2))*100;
			trace(" +- Shot Angle: " + (180 - (angle / Math.PI * 180)).toFixed(2) + "º");
			trace(" +- Power: " + power.toFixed(2) + " points.");
			trace(" +- Top Height: " + maxHeight + " pixels.");
			trace(" +- \"Ground\" distance: " + getDistance(_mDownPoint, new Point(ball.x, ball.y)).toFixed(1) + " pixels.");
			trace(" +- Flight Time: ~" + (releaseTime.currentCount / 10) + " seconds.");
			
			if (score > highScore)
			{
				trace(" +- New High Score: " + score + " pts.");
				highScore = score;
			}
			else
			{
				trace(" - Score: " + score + " pts. (High Score: " + highScore + " pts).");
			}
			endRound();
		}
		
		private function endRound():void
		{
			releaseTime.stop();
			releaseTime.removeEventListener(TimerEvent.TIMER, countPoints);
			releaseTime.reset();
			ball.removeEventListener(Event.ENTER_FRAME, onBallEF);
			ball.parent.removeChild(ball);
			ball = null;
		}
		
		private function draw(e:Event):void 
		{
			distance = getDistance(_mDownPoint, new Point(stage.mouseX, stage.mouseY));
			angle = Math.atan2(stage.mouseY - _mDownPoint.y, stage.mouseX - _mDownPoint.x);
			redraw();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			validDown = false;
			
			if (this.stage.mouseX > stage.stageWidth * 0.3)
			{
				return;
			}
			
			validDown = true;
			empty();
			this.addEventListener(Event.ENTER_FRAME, draw);
			_mDownPoint = new Point(this.stage.mouseX, this.stage.mouseY);
			dots.push(new Point(_mDownPoint.x, _mDownPoint.y));
		}
		
		private function redraw():void
		{
			drawDots();
		}
		
		//Debug Feedback
		
		private var spr:Sprite;
		private var dots:Vector.<Point>;
		
		private function getDistance(origin:Point, target:Point):Number
		{
			return Math.sqrt(Math.pow(target.x - origin.x, 2) + Math.pow(target.y - origin.y, 2));
		}
		
		private function getAngle(origin:Point, target:Point):Number
		{
			return Math.atan2(target.y - origin.y, target.x - origin.x);
		}
		
		private function initFeedback():void
		{
			spr = new Sprite();
			dots = new Vector.<Point>();
			addChild(spr);
			
			target = new Sprite();
			target.graphics.beginFill(0x404040, 1);
			target.graphics.drawRect(0, 0, 50, 50);
			target.graphics.endFill();
			
			target.x = stage.stageWidth * 0.7;
			target.y = stage.stageHeight - 50;
			TweenMax.to(target, 3, { x:stage.stageWidth - 50, yoyo:true, repeat: -1, ease:Quad.easeInOut } );
			TweenMax.to(target, 2.13, { y:stage.stageHeight - 150, yoyo:true, repeat: -1, ease:Quad.easeInOut } );
			
			var line:Sprite = new Sprite();
			line.x = stage.stageWidth * 0.3;
			line.graphics.lineStyle(1, 0x000000, 0.5);
			line.graphics.lineTo(0, stage.stageHeight);
			addChild(line);
			
			addChild(target);
			
		}
		
		private function drawDots(color:Number = 0xff0000):void
		{
			spr.graphics.clear();
			
			//Draw DOTS
			spr.graphics.beginFill(color, 1);
			for (var i:uint = 0; i < dots.length; i++)
			{
				spr.graphics.drawCircle(dots[i].x, dots[i].y, 5);
			}
			spr.graphics.endFill();
			
			
			//Draw Down-Up Line
			spr.graphics.lineStyle(1, 0x000000, 0.05);
			spr.graphics.moveTo(_mDownPoint.x, _mDownPoint.y);
			spr.graphics.lineTo(stage.mouseX, stage.mouseY);
			
			//Draw Prediction
			spr.graphics.lineStyle(1, 0x0000ff, 0.3);
			spr.graphics.moveTo(_mDownPoint.x, _mDownPoint.y);
			
			var acc:Point = new Point(Math.cos(angle) * distance, Math.sin(angle) * distance);
			var p:Point = new Point(_mDownPoint.x, _mDownPoint.y);
			
			for (var j:uint = 0; j < 80; j++)
			{
				p.x -= (acc.x * 0.1);
				p.y -= (acc.y * 0.1);
				spr.graphics.lineTo(p.x, p.y);
				acc.y -= 9.81;
			}
			
		}
		
		private function empty():void
		{
			dots = new Vector.<Point>();
		}
		
	}
	
}