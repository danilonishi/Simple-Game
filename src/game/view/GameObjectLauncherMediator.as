package game.view
{
	import events.GameEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.model.Level;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class GameObjectLauncherMediator extends Mediator
	{
		[Inject]
		public var view:GameObjectLauncherView;
		
		[Inject(name="currentLevel")]
		public var level:Level;
		
		public function GameObjectLauncherMediator()
		{
		
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			drawLaunchArea();
			
			view.buttonMode = true;
			view.mouseChildren = false;
			view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			eventDispatcher.addEventListener(GameEvent.DESTROY_LEVEL, onDestroyLevel);
		}
		
		private function onDestroyLevel(e:GameEvent):void 
		{
			view.mouseEnabled = false;
		}
		
		public function drawLaunchArea():void
		{
			view.graphics.lineStyle(2, 0xffffff);
			view.graphics.beginFill(0x000000, 0.5);
			view.graphics.drawCircle(0, 0, level.levelData.config.shootingRadius);
			view.graphics.endFill();
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			var dragLine:GameUserDragLineView = new GameUserDragLineView();
			dragLine.x = -view.x;
			dragLine.y = -view.y;
			view.addChild(dragLine);
			
			var previewLine:GamePreviewLineView = new GamePreviewLineView();
			previewLine.x = -view.x;
			previewLine.y = -view.y;
			view.addChild(previewLine);
			
			var shot:GameShotView = new GameShotView();
			shot.x = view.stage.mouseX;
			shot.y = view.stage.mouseY;
			this.contextView.addChild(shot);
			
			
		}
		
		override public function onRemove():void
		{
			view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			super.onRemove();
		}
	
	}

}