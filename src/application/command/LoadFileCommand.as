package application.command 
{
	import application.model.File;
	import events.FileEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class LoadFileCommand extends Command 
	{
		[Inject]
		public var event:FileEvent;
		
		public function LoadFileCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			if (event.file.loaderType == "loader")
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.load(new URLRequest(event.file.path));
			}
			else if (event.file.loaderType == "urlloader")
			{
				var urlloader:URLLoader = new URLLoader();
				urlloader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				urlloader.addEventListener(Event.COMPLETE, onURLLoadComplete);
				urlloader.load(new URLRequest(event.file.path));
			}
			else
			{
				throw new Error("\"filetype\" not defined. Load path:\"" + event.file.path + "\"");
			}
		}
		
		private function onURLLoadComplete(e:Event):void 
		{
			event.file.loadedData.data = e.target.data;
			onDataSet(e);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			event.file.loadedData.object = (e.target as LoaderInfo).content;
			onDataSet(e);
		}
		
		private function onDataSet(completeEvent:Event):void
		{
			event.file.isLoaded = true;
			
			if (event.callback != null)
			{
				event.callback(completeEvent);
			}
			
			eventDispatcher.dispatchEvent(new FileEvent(FileEvent.LOADED, event.file));
			
			event = null;
			
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			throw new Error(e.text);
		}
		
	}

}