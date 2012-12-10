package application.command 
{
	import events.ApplicationEvent;
	import flash.net.SharedObject;
	import game.model.LevelList;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class ClearSavedDataCommand extends Command 
	{
		[Inject]
		public var list:LevelList;
		
		public function ClearSavedDataCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			var so:SharedObject = SharedObject.getLocal("danilonishimura_angryclone");
			so.clear();
			so.flush();
			
			for (var j:uint = 0; j < list.levels.length; j++)
			{
				list.levels[j].levelData.cleared = false;
				list.levels[j].highScore = Number.NaN;
			}
			
			
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.DATA_CLEARED));
		}
	}

}