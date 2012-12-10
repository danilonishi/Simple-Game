package application.command
{
	import application.view.MainScreenMediator;
	import application.view.MainScreenView;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class ShowMainScreenCommand extends Command
	{
		
		public function ShowMainScreenCommand()
		{
		
		}
		
		override public function execute():void
		{
			super.execute();
			
			if (injector.hasMapping(MainScreenMediator, "currentMainScreen"))
			{
				throw new Error("Previous MainScreenView was not destroyed");
				return;
			}
			
			var view:MainScreenView = new MainScreenView();
			contextView.addChild(view);
			
			var mediator:MainScreenMediator = mediatorMap.retrieveMediator(view) as MainScreenMediator;
			injector.mapValue(MainScreenMediator, mediator, "currentMainScreen");
		}
	
	}

}