package application.command
{
	import application.model.ApplicationData;
	import application.model.File;
	import application.model.FileList;
	import events.ApplicationEvent;
	import events.FileEvent;
	import flash.events.Event;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class LoadDependenciesCommand extends Command
	{
		
		[Inject]
		public var data:ApplicationData;
		
		[Inject]
		public var fileList:FileList;
		
		public function LoadDependenciesCommand()
		{
		
		}
		
		override public function execute():void
		{
			super.execute();
			
			var dependenciesList:XML = XML(data.configXml.dependencies);
			for (var i:uint = 0; dependenciesList.file[i] != null; i++)
			{
				var file:File = new File();
				file.id = dependenciesList.file[i].@id;
				file.name = dependenciesList.file[i].@name;
				file.path = dependenciesList.file[i].@path;
				file.loaderType = dependenciesList.file[i].@loadertype;
				
				fileList.files[fileList.files.length] = file;
				
				eventDispatcher.dispatchEvent(new FileEvent(FileEvent.LOAD, file, checkDependenciesLoad));
			}
		}
		
		public function checkDependenciesLoad(e:Event = null):void
		{
			if (areAllDependenciesLoaded())
			{
				eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_LOADING));
				eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.DEPENDENCIES_LOADED));
				eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.PARSE_LEVELS));
			}
		}
		
		public function areAllDependenciesLoaded():Boolean
		{
			var allLoaded:Boolean = true;
			for (var i:uint = 0; i < fileList.files.length; i++)
			{
				if (fileList.files[i].isLoaded == false)
				{
					allLoaded = false;
				}
			}
			return allLoaded;
		}
	
	}

}