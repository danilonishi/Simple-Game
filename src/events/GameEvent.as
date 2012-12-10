package events 
{
	import flash.events.Event;
	import game.model.Level;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class GameEvent extends Event 
	{
		
		public static const LOAD_LEVEL:String = "GameEvent_loadLevel";
		public static const LEVEL_LOADED:String = "GameEvent_levelLoaded";
		
		public static const BUILD_LEVEL:String = "GameEvent_buildLevel";
		public static const LEVEL_BUILT:String = "GameEvent_levelBuilt";
		
		public static const PARSE_LEVEL:String = "GameEvent_parseLevel";
		public static const LEVEL_PARSED:String = "GameEvent_levelParsed";
		
		public static const DESTROY_LEVEL:String = "GameEvent_destroyLevel";
		public static const LEVEL_DESTROYED:String = "GameEvent_levelDestroyed";
		
		private var _level:Level;
		
		public function get level():Level
		{
			return _level;
		}
		
		public function GameEvent(type:String, level:Level) 
		{
			_level = level;
			super(type, false, false);
		} 
		
	}
	
}