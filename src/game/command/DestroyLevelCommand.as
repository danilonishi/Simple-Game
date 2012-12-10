package game.command 
{
	import com.greensock.loading.display.FlexContentDisplay;
	import com.greensock.TweenMax;
	import events.ApplicationEvent;
	import events.GameEvent;
	import game.model.Level;
	import game.view.GameContainerView;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class DestroyLevelCommand extends Command 
	{
		[Inject(name="currentGameContainer")]
		public var container:GameContainerView;
		
		public function DestroyLevelCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			TweenMax.to(container, 1, { alpha:0, onComplete:removeSelf} );
			
		}
		
		private function removeSelf():void 
		{
			if (container.parent)
			{
				container.parent.removeChild(container);
			}
			
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SAVE_DATA));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_MAINSCREEN));
		}
		
	}

}