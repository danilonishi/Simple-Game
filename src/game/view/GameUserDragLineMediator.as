package game.view
{
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class GameUserDragLineMediator extends Mediator
	{
		[Inject]
		public var view:GameUserDragLineView;
		
		private var mouseDownPosition:Point;
		
		public function GameUserDragLineMediator()
		{
		
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			mouseDownPosition = new Point(view.mouseX, view.mouseY);
			
			view.stage.addEventListener(MouseEvent.MOUSE_UP, killview);
			view.stage.addEventListener(MouseEvent.MOUSE_MOVE, drawLine);
		}
		
		private function drawLine(e:MouseEvent):void
		{
			if (!view.stage)
			{
				selfRemove();
				return;
			}
			view.graphics.clear();
			view.graphics.lineStyle(1, 0x000000, 0.2);
			view.graphics.moveTo(mouseDownPosition.x, mouseDownPosition.y);
			view.graphics.lineTo(view.mouseX, view.mouseY);
		}
		
		private function killview(e:MouseEvent):void
		{
			if (!view.stage)
			{
				selfRemove();
				return;
			}
			view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawLine);
			view.stage.removeEventListener(MouseEvent.MOUSE_UP, killview);
			
			TweenMax.to(view, 0.5, {autoAlpha: 0, onComplete: selfRemove});
		}
		
		private function selfRemove():void
		{
			if (view.parent)
			{
				view.parent.removeChild(view);
			}
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
	
	}

}