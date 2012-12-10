package game.view
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import events.GameEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import game.model.Level;
	import game.model.ShotData;
	import game.model.TargetList;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class GameShotMediator extends Mediator
	{
		
		[Inject]
		public var view:GameShotView;
		
		[Inject]
		public var shotData:ShotData;
		
		[Inject(name="currentGameContainer")]
		public var container:GameContainerView;
		
		[Inject(name="currentLevel")]
		public var level:Level;
		
		private var acceleration:Point;
		private var deathTimer:Timer;
		
		public function GameShotMediator()
		{
		
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			draw();
			
			view.stage.addEventListener(MouseEvent.MOUSE_UP, shootBall);
			eventDispatcher.addEventListener(GameEvent.DESTROY_LEVEL, cancelShoot);
			
		}
		
		public function cancelShoot(e:GameEvent):void
		{
			destroyBall("canceled");
		}
		
		public function draw():void
		{
			view.graphics.clear();
			view.graphics.beginFill(0xffff00);
			view.graphics.drawCircle(0, 0, 5);
			view.graphics.endFill();
		}
		
		private function shootBall(e:MouseEvent):void 
		{
			acceleration = new Point(Math.cos(shotData.angle) * shotData.distance * 2, Math.sin(shotData.angle) * shotData.distance * 2);
			view.stage.removeEventListener(MouseEvent.MOUSE_UP, shootBall);
			view.addEventListener(Event.ENTER_FRAME, moveBall);
			
			deathTimer = new Timer(5000, 1);
			deathTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDeathTimerComplete);
			deathTimer.start();
		}
		
		private function onDeathTimerComplete(e:TimerEvent):void 
		{
			destroyBall("death timer");
		}
		
		private function moveBall(e:Event):void 
		{
			if (Math.abs(acceleration.x) < 1 && Math.abs(acceleration.y) < 1)
			{
				destroyBall("zero acceleration");
			}
			
			view.x -= (acceleration.x * 0.1);
			view.y -= (acceleration.y -= 9.81) * 0.1;
			
			if (checkWallColision())
			{
				checkTargetCollision();
			}
			
			checkLevelCompletion();
		}
		
		private function checkLevelCompletion():void 
		{
			var passed:Boolean = true;
			
			for (var i:uint = 0; i < level.levelData.targets.list.length; i++)
			{
				if (level.levelData.targets.list[i].destroyed == false)
				{
					passed = false;
				}
			}
			
			if (passed)
			{
				level.levelData.cleared = true;
				eventDispatcher.removeEventListener(GameEvent.DESTROY_LEVEL, cancelShoot);
				eventDispatcher.dispatchEvent(new GameEvent(GameEvent.DESTROY_LEVEL, level));
			}
			
		}
		
		private function checkTargetCollision():void
		{
			if (view.stage == null || view.parent == null)
			{
				destroyBall("no parent");
				return;
			}
			
			for (var i:uint = 0; i < level.levelData.targets.list.length; i++)
			{
				if (level.levelData.targets.list[i].destroyed == false && view.hitTestObject(level.levelData.targets.list[i].view))
				{
					level.levelData.targets.list[i].destroyed = true;
					var targetMediator:GameTargetMediator = mediatorMap.retrieveMediator(level.levelData.targets.list[i].view as GameTargetView) as GameTargetMediator;
					targetMediator.onTargetHit();
					destroyBall("Target hit");
					return;
				}				
			}
		}
		
		private function checkWallColision():Boolean 
		{
			if (view.x < container.x)
			{
				if (level.levelData.config.bounce.left)
				{
					view.x = container.x;
					acceleration.x *= -1 * (level.levelData.config.bounce.left);
					acceleration.y *= 1 * (level.levelData.config.bounce.bottom);
				}
				else
				{
					destroyBall("left wall");
					return false;
				}
			}
			else if (view.x > container.x + level.levelData.config.levelDimensions.x)
			{
				if (level.levelData.config.bounce.right)
				{
					view.x = level.levelData.config.levelDimensions.x;
					acceleration.x *= -1 * (level.levelData.config.bounce.right);
					acceleration.y *= 1 * (level.levelData.config.bounce.bottom);
				}
				else
				{
					destroyBall("right wall");
					return false;
				}
			}
			
			if (view.y < container.y)
			{
				if (level.levelData.config.bounce.bottom)
				{
					view.y = 0;
					acceleration.x *= 1 * (level.levelData.config.bounce.left);
					acceleration.y *= -1 * (level.levelData.config.bounce.bottom);
				}
				else
				{
					destroyBall("top wall");
					return false;
				}
			}
			else if (view.y > container.y + level.levelData.config.levelDimensions.y)
			{
				if (level.levelData.config.bounce.top)
				{
					view.y = level.levelData.config.levelDimensions.y;
					acceleration.x *= 1 * (level.levelData.config.bounce.right);
					acceleration.y *= -1 * (level.levelData.config.bounce.top);
				}
				else
				{
					destroyBall("bottom wall");
					return false;
				}
			}
			
			return  true;
		}
		
		
		private function destroyBall(reason:String):void
		{
			//trace("Ball destroyed: " + reason);
			if (view.parent)
			{
				view.parent.removeChild(view);
			}
			
			eventDispatcher.removeEventListener(GameEvent.DESTROY_LEVEL, cancelShoot);
			view.removeEventListener(Event.ENTER_FRAME, moveBall);
		}
		
		override public function onRemove():void
		{
			contextView.stage.removeEventListener(MouseEvent.MOUSE_UP, shootBall);
			view.removeEventListener(Event.ENTER_FRAME, moveBall);
			if (deathTimer != null)
			{
				deathTimer.stop();
				deathTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, destroyBall);
			}
			
			view.graphics.clear();
			super.onRemove();
		}
	
	}

}