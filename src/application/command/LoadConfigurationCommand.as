package application.command
{
	import application.model.ApplicationData;
	import application.model.File;
	import application.model.LoaderType;
	import events.ApplicationEvent;
	import events.FileEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class LoadConfigurationCommand extends Command
	{
		
		[Inject]
		public var data:ApplicationData;
		
		public function LoadConfigurationCommand()
		{
		
		}
		
		override public function execute():void
		{
			super.execute();
			
			var file:File = new File();
			file.id = "preload_data";
			file.path = "data/config/config.xml";
			file.loaderType = LoaderType.TYPE_URLLOADER;
			
			eventDispatcher.dispatchEvent(new FileEvent(FileEvent.LOAD, file, onLoadComplete));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_LOADING));
		}
		
		private function onLoadComplete(e:Event):void
		{
			data.configXml = XML(e.target.data);
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIG_LOADED));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.PARSE_CONFIG));
		}
		
		private function onError(e:IOErrorEvent):void
		{
			throw new Error(e.text);
		}
	
	}

}