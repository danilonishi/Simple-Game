package
{
	import application.command.*;
	import application.model.*;
	import application.view.*;
	import events.*;
	import flash.display.*;
	import game.command.*;
	import game.model.*;
	import game.view.*;
	import org.robotlegs.mvcs.Context;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 *
	   
		- missing "how to play" screen
		- level score screen
		- end game screen
		-- add target blockers
		-- dinamize gravity
		-- add a boss stage
		-- make the user hit the targets in a predefined order (or stage failed)
	
	 */
	public class GameContext extends Context
	{
		
		public function GameContext(contextView:DisplayObjectContainer)
		{
			super(contextView);
		}
		
		override public function startup():void
		{
			super.startup();
			
			injector.mapSingleton(ShotData);
			injector.mapSingleton(ApplicationData);
			injector.mapSingleton(FileList);
			injector.mapSingleton(LevelList);
			
			mediatorMap.mapView(LoadingScreenView, LoadingScreenMediator);
			mediatorMap.mapView(MainScreenView, MainScreenMediator);
			mediatorMap.mapView(StandardButtonView, StandardButtonMediator);
			mediatorMap.mapView(GameContainerView, GameContainerMediator);
			mediatorMap.mapView(GameBackgroundView, GameBackgroundMediator);
			mediatorMap.mapView(GameTargetView, GameTargetMediator);
			mediatorMap.mapView(GameObjectLauncherView, GameObjectLauncherMediator);
			mediatorMap.mapView(GamePreviewLineView, GamePreviewLineMediator);
			mediatorMap.mapView(GameUserDragLineView, GameUserDragLineMediator);
			mediatorMap.mapView(GameShotView, GameShotMediator);
			
			commandMap.mapEvent(FileEvent.LOAD, LoadFileCommand, FileEvent);
			commandMap.mapEvent(ApplicationEvent.LOAD_CONFIG, LoadConfigurationCommand);
			commandMap.mapEvent(ApplicationEvent.SHOW_LOADING, ShowLoadingScreenCommand);
			commandMap.mapEvent(ApplicationEvent.HIDE_LOADING, HideLoadingScreenCommand);
			commandMap.mapEvent(ApplicationEvent.PARSE_CONFIG, ParseConfigurationCommand);
			commandMap.mapEvent(ApplicationEvent.LOAD_DEPENDENCIES, LoadDependenciesCommand);
			commandMap.mapEvent(ApplicationEvent.PARSE_LEVELS, ParseLevelListCommand);
			commandMap.mapEvent(ApplicationEvent.LOAD_DATA, LoadSavedDataCommand);
			commandMap.mapEvent(ApplicationEvent.SHOW_MAINSCREEN, ShowMainScreenCommand);
			commandMap.mapEvent(ApplicationEvent.HIDE_MAINSCREEN, HideMainScreenCommand);
			commandMap.mapEvent(GameEvent.LOAD_LEVEL, LoadLevelCommand, GameEvent);
			commandMap.mapEvent(GameEvent.PARSE_LEVEL, ParseLevelCommand, GameEvent);
			commandMap.mapEvent(GameEvent.BUILD_LEVEL, BuildLevelCommand, GameEvent);
			commandMap.mapEvent(GameEvent.DESTROY_LEVEL, DestroyLevelCommand, GameEvent);
			commandMap.mapEvent(ApplicationEvent.SAVE_DATA, SaveDataCommand);
			commandMap.mapEvent(ApplicationEvent.CLEAR_DATA, ClearSavedDataCommand);
			
			// Kick-off
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.LOAD_CONFIG));
		}
	
	}

}