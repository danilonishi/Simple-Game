package application.command 
{
	import application.view.LoadingScreenMediator;
	import application.view.LoadingScreenView;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class ShowLoadingScreenCommand extends Command 
	{
		
		public function ShowLoadingScreenCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			var loadingView:LoadingScreenView = new LoadingScreenView();
			contextView.addChild(loadingView);
			
			var loadingMediator:LoadingScreenMediator = mediatorMap.retrieveMediator(loadingView) as LoadingScreenMediator;
			loadingMediator.show();
			
			injector.mapValue(LoadingScreenView, loadingView, "currentLoading");
		}
		
	}

}