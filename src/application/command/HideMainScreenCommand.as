package application.command
{
	import application.view.MainScreenMediator;
	import application.view.MainScreenView;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class HideMainScreenCommand extends Command
	{
		public function HideMainScreenCommand()
		{
		
		}
		
		override public function execute():void
		{
			super.execute();
			
			if (injector.hasMapping(MainScreenMediator, "currentMainScreen"))
			{
				(injector.getInstance(MainScreenMediator, "currentMainScreen") as MainScreenMediator).hide();
				injector.unmap(MainScreenMediator, "currentMainScreen");
			}
		}
	
	}

}