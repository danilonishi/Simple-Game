package game.view
{
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.model.ShotData;
	import game.utils.MathUtils;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class GamePreviewLineMediator extends Mediator
	{
		[Inject]
		public var view:GamePreviewLineView;
		
		[Inject]
		public var shotData:ShotData;
		
		public var lineColor:Number = 0xff0000;
		
		private var angle:Number;
		private var distance:Number;
		private var mouseDownPosition:Point;
		
		public function GamePreviewLineMediator()
		{
		
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			shotData.startPoint = mouseDownPosition = new Point(view.mouseX, view.mouseY);
			
			view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			view.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			TweenMax.to(view, 1, { alpha: 0, onComplete: removeSelf } );
			
			if (!view.stage)
			{
				removeSelf();
				return;
			}
			view.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:Event):void
		{
			if (!view.stage)
			{
				removeSelf();
				return;
			}
			
			var currentMousePosition:Point = new Point(view.mouseX, view.mouseY);
			
			distance = shotData.distance = MathUtils.getDistance(mouseDownPosition, currentMousePosition);
			angle = shotData.angle = MathUtils.getAngle(mouseDownPosition, currentMousePosition);
			
			var acceleration:Point = new Point(Math.cos(angle) * distance * 2, Math.sin(angle) * distance * 2);
			var currentSegmentPosition:Point = new Point(mouseDownPosition.x, mouseDownPosition.y);
			
			view.graphics.clear();
			view.graphics.moveTo(mouseDownPosition.x, mouseDownPosition.y);
			
			for (var j:uint = 0; j < 60; j++)
			{
				view.graphics.lineStyle(1, lineColor, (1 - (j / 60)));
				view.graphics.lineTo(currentSegmentPosition.x -= (acceleration.x * 0.1), currentSegmentPosition.y -= ((acceleration.y -= 9.81) * 0.1));
			}
		}
		
		private function removeSelf():void
		{
			if (view.parent)
			{
				view.parent.removeChild(view);
			}
		}
		
		override public function onRemove():void
		{
			view.graphics.clear();
			super.onRemove();
		}
	}

}