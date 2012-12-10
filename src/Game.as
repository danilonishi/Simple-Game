package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class Game extends Sprite 
	{
		
		public var gameContext:GameContext;
		
		public function Game() 
		{
			if (stage)
			{
				_init(null);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, _init);
			}
		}
		
		private function _init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			
			prepareStage();
			
			gameContext = new GameContext(this);
		}
		
		private function prepareStage():void 
		{
			stage.frameRate = 60;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
	}

}