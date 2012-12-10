package application.view 
{
	import application.model.ApplicationData;
	import application.model.FileList;
	import com.greensock.TweenMax;
	import events.ApplicationEvent;
	import events.GameEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import game.model.Level;
	import game.model.LevelList;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class MainScreenMediator extends Mediator 
	{
		
		[Inject]
		public var fileList:FileList;
		
		[Inject]
		public var view:MainScreenView;
		
		[Inject]
		public var levelList:LevelList;
		
		[Inject]
		public var appData:ApplicationData;
		
		private var background:Sprite;
		private var clearSaveButton:StandardButtonView;
		private var levelListContainer:Sprite;
		private var buttonLevelRelationship:Dictionary;
		
		
		
		public function MainScreenMediator() 
		{
			
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
			
			view.alpha = 0;
			buttonLevelRelationship = new Dictionary(true);
			
			create();
			show();
		}
		
		public function create():void
		{
			
			createBackground();
			
			createLevelList();
			
			show();
			
			onStageResize(null);
			
			clearSaveButton = new StandardButtonView();
			clearSaveButton.caption = "DELETE SAVED DATA";
			clearSaveButton.x = 10;
			clearSaveButton.y = 10;
			view.addChild(clearSaveButton);
			
		}
		
		private function createBackground():void 
		{
			var bgImage:Bitmap = fileList.getFileByID("main_screen_background").loadedData.object as Bitmap;
			bgImage.smoothing = true;
			bgImage.cacheAsBitmap = true;
			
			background = new Sprite();
			background.alpha = 0.15;
			background.addChild(bgImage);
			
			contextView.stage.addEventListener(Event.RESIZE, onStageResize);
			view.addChild(background);
		}
		
		private function createLevelList():void 
		{
			levelListContainer = new Sprite();
			for (var i:uint = 0; i < levelList.levels.length; i++)
			{
				var label:TextField = new TextField();
				
				var cleared:Boolean = levelList.levels[i].levelData.cleared;
				var color:Number = (cleared) ? 0x88ff88 : 0xffffff;
				
				label.defaultTextFormat = new TextFormat("Verdana", 12, color);
				label.autoSize = TextFieldAutoSize.LEFT;
				label.text = levelList.levels[i].name + ((cleared) ? " * Cleared!" : "");
				
				var levelClick:Sprite = new Sprite();
				levelClick.mouseChildren = false;
				levelClick.buttonMode = true;
				levelClick.addEventListener(MouseEvent.CLICK, onLevelClick);
				levelClick.y = i * 25;
				
				if (appData.progressivePlay && (i > 0) && (levelList.levels[i - 1].levelData.cleared == false))
				{
					levelClick.alpha = 0.15;
					levelClick.mouseEnabled = false;
					levelClick.buttonMode = false;
				}
				
				buttonLevelRelationship[levelClick] = levelList.levels[i];
				
				levelClick.addChild(label);
				
				levelListContainer.addChild(levelClick)
			}
			view.addChild(levelListContainer);
		}
		
		public function show():void
		{
			TweenMax.to(view, 0.5, { delay:1, autoAlpha:1 } );
		}
		
		public function hide():void
		{
			TweenMax.to(view, 0.5, { autoAlpha:0, onComplete:removeSelf } );
		}
		
		public function removeSelf():void
		{
			view.parent.removeChild(view);
		}
		
		
		
		private function onStageResize(e:Event):void 
		{
			view.graphics.clear();
			view.graphics.beginFill(0x000000, 1);
			view.graphics.drawRect(0, 0, contextView.stage.stageWidth, contextView.stage.stageHeight);
			view.graphics.endFill();
			
			levelListContainer.x = contextView.stage.stageWidth * 0.5 - levelListContainer.width * 0.5;
			levelListContainer.y = contextView.stage.stageHeight * 0.5 - levelListContainer.height * 0.5;
			
			background.width = contextView.stage.stageWidth;
			background.height = contextView.stage.stageHeight;
		}
		
		private function onLevelClick(e:MouseEvent):void 
		{
			disableClicks();
			
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_LOADING));
			eventDispatcher.dispatchEvent(new GameEvent(GameEvent.LOAD_LEVEL, buttonLevelRelationship[e.target] as Level));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_MAINSCREEN));
			
		}
		
		private function disableClicks():void
		{
			for (var i:uint = 0; i < levelListContainer.numChildren; i++ )
			{
				(levelListContainer.getChildAt(i) as Sprite).mouseEnabled = false;
			}
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			
			contextView.stage.removeEventListener(Event.RESIZE, onStageResize);
			
			while (background.numChildren > 0)
			{
				background.removeChildAt(0);
			}
			
			while (levelListContainer.numChildren > 0)
			{
				buttonLevelRelationship[levelListContainer] = null;
				(levelListContainer.getChildAt(0) as Sprite).removeEventListener(MouseEvent.CLICK, onLevelClick);
				(levelListContainer.getChildAt(0) as Sprite).removeChildAt(0);
				levelListContainer.removeChildAt(0);
			}
			
			while (view.numChildren > 0)
			{
				view.removeChildAt(0);
			}
			
			buttonLevelRelationship = null;
			background = null;
			
			if (view.parent != null)
			{
				view.parent.removeChild(view);
			}
		}
		
	}

}