package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class ApplicationEvent extends Event 
	{
		
		public static const LOAD_CONFIG:String = "ApplicationEvent_loadConfig";
		public static const CONFIG_LOADED:String = "ApplicationEvent_configLoaded";
		
		public static const PARSE_CONFIG:String = "ApplicationEvent_parseConfig";
		public static const CONFIG_PARSED:String = "ApplicationEvent_configParsed";
		
		public static const SAVE_DATA:String = "ApplicationEvent_saveData";
		public static const DATA_SAVED:String = "ApplicationEvent_dataSaved";
		
		public static const LOAD_DATA:String = "ApplicationEvent_loadData";
		public static const DATA_LOADED:String = "ApplicationEvent_dataLoaded";
		
		public static const CLEAR_DATA:String = "ApplicationEvent_clearData";
		public static const DATA_CLEARED:String = "ApplicationEvent_dataCleared";
		
		public static const LOAD_DEPENDENCIES:String = "ApplicationEvent_loadDependencies";
		public static const DEPENDENCIES_LOADED:String = "ApplicationEvent_dependenciesLoaded";
		
		public static const PARSE_LEVELS:String = "ApplicationEvent_parseLevels";
		public static const LEVELS_PARSED:String = "ApplicationEvent_levelsParsed";
		
		public static const SHOW_LOADING:String = "ApplicationEvent_showLoading";
		public static const HIDE_LOADING:String = "ApplicationEvent_hideLoading";
		
		public static const SHOW_MAINSCREEN:String = "ApplicationEvent_showMainScreen";
		public static const HIDE_MAINSCREEN:String = "ApplicationEvent_hideMainScreen";
		
		public function ApplicationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new ApplicationEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ApplicationEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}