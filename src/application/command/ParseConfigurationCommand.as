package application.command 
{
	import application.model.ApplicationData;
	import events.ApplicationEvent;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class ParseConfigurationCommand extends Command 
	{
		[Inject]
		public var data:ApplicationData;
		
		public function ParseConfigurationCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			data.progressivePlay = Boolean(Number(data.configXml.applicationData.progressivePlay.@value));
			
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.CONFIG_PARSED));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LOAD_DEPENDENCIES));
		}
		
	}

}