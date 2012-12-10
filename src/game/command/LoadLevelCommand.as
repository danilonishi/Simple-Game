package game.command 
{
	import application.command.LoadConfigurationCommand;
	import application.model.File;
	import application.model.LoaderType;
	import events.ApplicationEvent;
	import events.FileEvent;
	import events.GameEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.model.Level;
	import game.model.LevelData;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class LoadLevelCommand extends Command 
	{
		
		[Inject]
		public var event:GameEvent;
		
		
		private var levelData:LevelData;
		private var level:Level;
		
		public function LoadLevelCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			level = event.level;
			levelData = level.levelData = new LevelData();
			
			level.levelData = new LevelData();
			
			var file:File = new File();
			file.id = level.id;
			file.name = level.name;
			file.path = level.path;
			file.loaderType = LoaderType.TYPE_URLLOADER;
			
			eventDispatcher.dispatchEvent(new FileEvent(FileEvent.LOAD, file, onFileLoaded));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_LOADING));
		}
		
		private function onFileLoaded(e:Event):void 
		{
			/*
			trace(">");
			trace(e.target.data);
			trace("<");
			*/
			level.levelData.levelXML = XML(e.target.data);
			eventDispatcher.dispatchEvent(new GameEvent(GameEvent.LEVEL_LOADED, level));
			eventDispatcher.dispatchEvent(new GameEvent(GameEvent.PARSE_LEVEL, level));
		}
		
		
	}

}