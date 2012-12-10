package application.command 
{
	import application.view.LoadingScreenMediator;
	import application.view.LoadingScreenView;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class HideLoadingScreenCommand extends Command 
	{
		
		[Inject(name = "currentLoading")]
		public var loading:LoadingScreenView;
		
		public function HideLoadingScreenCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			injector.unmap(LoadingScreenView, "currentLoading");
			
			var loadingMediator:LoadingScreenMediator = mediatorMap.retrieveMediator(loading) as LoadingScreenMediator;
			loadingMediator.hide();
		}
		
	}

}