package game.view
{
	import application.model.FileList;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.model.Level;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class GameBackgroundMediator extends Mediator
	{
		[Inject]
		public var view:GameBackgroundView;
		
		[Inject]
		public var fileList:FileList;
		
		[Inject(name="currentLevel")]
		public var level:Level;
		
		public var gameContainerView:GameContainerView;
		
		private var mouseDownPoint:Point;
		private var viewPositionOnMouseDown:Point;
		
		public function GameBackgroundMediator()
		{
		
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			gameContainerView = view.parent as GameContainerView;
			
			view.addChild(fileList.getFileByID(level.levelData.config.backgroundID).loadedData.object as Bitmap);
			
			view.stage.addEventListener(Event.RESIZE, onStageResize);
			
			/*
			view.mouseChildren = false;
			view.buttonMode = true;
			view.addEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown);
			view.addEventListener(MouseEvent.MOUSE_UP, onBackgroundMouseUp);
			*/
			
		}
		
		private function onStageResize(e:Event):void 
		{
			view.x = -view.parent.x + view.stage.stageWidth * 0.5 - view.width * 0.5;
			view.y = -view.parent.y + view.stage.stageHeight * 0.5 - view.height * 0.5;
		}
		
		private function onBackgroundMouseDown(e:MouseEvent):void
		{
			viewPositionOnMouseDown = new Point(gameContainerView.x, gameContainerView.y);
			mouseDownPoint = new Point(view.stage.mouseX, view.stage.mouseY);
			view.addEventListener(MouseEvent.MOUSE_MOVE, onBackgroundMouseMove);
		}
		
		private function onBackgroundMouseUp(e:MouseEvent):void
		{
			viewPositionOnMouseDown = null;
			mouseDownPoint = null;
			view.removeEventListener(MouseEvent.MOUSE_MOVE, onBackgroundMouseMove);
		}
		
		private function onBackgroundMouseMove(e:MouseEvent):void
		{
			gameContainerView.x = viewPositionOnMouseDown.x + (view.stage.mouseX - mouseDownPoint.x);
			gameContainerView.y = viewPositionOnMouseDown.y + (view.stage.mouseY - mouseDownPoint.y);
			
			limitViewToScreenSize();
		}
		
		private function limitViewToScreenSize():void
		{
			if (gameContainerView.x > 0)
			{
				gameContainerView.x = 0;
			}
			else if (gameContainerView.x < gameContainerView.stage.stageWidth - gameContainerView.width)
			{
				gameContainerView.x = gameContainerView.stage.stageWidth - gameContainerView.width;
			}
			
			if (gameContainerView.y > 0)
			{
				gameContainerView.y = 0;
			}
			else if (gameContainerView.y < gameContainerView.stage.stageHeight - gameContainerView.height)
			{
				gameContainerView.y = view.stage.stageHeight - gameContainerView.height;
			}
		}
		
		override public function onRemove():void
		{
			contextView.stage.removeEventListener(Event.RESIZE, onStageResize);
			
			view.removeEventListener(MouseEvent.MOUSE_MOVE, onBackgroundMouseMove);
			view.removeEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown);
			view.removeEventListener(MouseEvent.MOUSE_UP, onBackgroundMouseUp);
			
			while (view.numChildren > 0)
			{
				view.removeChildAt(0);
			}
			
			gameContainerView = null;
			mouseDownPoint = null;
			viewPositionOnMouseDown = null;
			
			super.onRemove();
		}
	
	}

}