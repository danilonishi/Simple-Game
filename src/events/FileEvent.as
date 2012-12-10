package events 
{
	import application.model.File;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class FileEvent extends Event 
	{
		
		public static const LOAD:String = "FileEvent_load";
		public static const LOADED:String = "FileEvent_loaded";
		
		private var _file:File;
		private var _callback:Function = null;
		
		public function get file():File
		{
			return _file;
		}
		
		public function get callback():Function
		{
			return _callback;
		}
		
		public function FileEvent(type:String, file:File, callback:Function = null) 
		{ 
			_file = file;
			_callback = callback;
			super(type, false, false);
		} 
		
		public override function clone():Event 
		{ 
			return new FileEvent(type, _file);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FileEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}