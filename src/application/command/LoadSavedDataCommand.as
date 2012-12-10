package application.command 
{
	import events.ApplicationEvent;
	import flash.net.SharedObject;
	import game.model.Level;
	import game.model.LevelList;
	import game.model.SaveObject;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class LoadSavedDataCommand extends Command 
	{
		[Inject]
		public var list:LevelList;
		
		public function LoadSavedDataCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			var so:SharedObject = SharedObject.getLocal("danilonishimura_angryclone");
			
			if (so.data != null)
			{
				if (so.data.save != undefined)
				{
					var clearedLevels:Vector.<Object> = so.data.save.clearedLevels
					var highScores:Vector.<Number> = so.data.save.highScores;
					
					for (var j:uint = 0; j < clearedLevels.length; j++)
					{
						list.getLevelByID(String(clearedLevels[j])).levelData.cleared = true;
						list.getLevelByID(String(clearedLevels[j])).highScore = Number(String(highScores[j]));
					}
					
					eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.DATA_LOADED));
					
				}
				
			}
			
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_MAINSCREEN));
			
		}
	}

}