package game.view
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import game.model.Level;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class GameContainerMediator extends Mediator
	{
		
		[Inject]
		public var view:GameContainerView;
		
		[Inject(name="currentLevel")]
		public var level:Level;
		
		private var borders:Sprite;
		private var fadeTimer:Timer;
		
		public function GameContainerMediator()
		{
		
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			fadeTimer = new Timer(1000,1);
			fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeBorders);
			
			borders = new Sprite();
			view.addChild(borders);
			view.stage.addEventListener(Event.RESIZE, onStageResize);
		}
		
		private function fadeBorders(e:TimerEvent):void 
		{
			TweenMax.to(borders, 0.5, { alpha:0.2 } );
		}
		
		public function onStageResize(e:Event = null):void
		{
			view.x = view.stage.stageWidth * 0.5 - level.levelData.config.levelDimensions.x * 0.5;
			view.y = view.stage.stageHeight * 0.5 - level.levelData.config.levelDimensions.y * 0.5;
			
			view.swapChildrenAt(view.getChildIndex(borders), 1);
			borders.alpha = 1;
			borders.graphics.clear();
			borders.graphics.lineStyle(3, 0xff0000);
			borders.graphics.drawRect(0, 0, level.levelData.config.levelDimensions.x, level.levelData.config.levelDimensions.y);
			
			if (fadeTimer.running)
			{
				fadeTimer.stop();
				fadeTimer.reset();
			}
			fadeTimer.start();
		}
		
		override public function onRemove():void
		{
			contextView.stage.removeEventListener(Event.RESIZE, onStageResize);
			super.onRemove();
		}
	}

}