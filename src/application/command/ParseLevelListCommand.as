package application.command 
{
	import application.model.ApplicationData;
	import events.ApplicationEvent;
	import events.GameEvent;
	import game.model.Level;
	import game.model.LevelList;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class ParseLevelListCommand extends Command 
	{
		
		[Inject]
		public var data:ApplicationData;
		
		[Inject]
		public var levelList:LevelList;
		
		public function ParseLevelListCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			var levels:XML = XML(data.configXml.levels);
			
			for (var i:uint = 0; levels.level[i] != null; i++)
			{
				var level:Level = new Level();
				level.name = levels.level[i].@name;
				level.id = levels.level[i].@id;
				level.path = levels.level[i].@path;
				levelList.levels.push(level);
			}
			
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LEVELS_PARSED));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LOAD_DATA));
		}
		
	}

}