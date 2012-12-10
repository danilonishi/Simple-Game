package game.command
{
	import application.model.FileList;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import events.GameEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import game.model.Level;
	import game.model.LevelData;
	import game.view.GameBackgroundView;
	import game.view.GameContainerView;
	import game.view.GameObjectLauncherView;
	import game.view.GameTargetView;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class BuildLevelCommand extends Command
	{
		
		[Inject]
		public var event:GameEvent;
		
		public var levelData:LevelData;
		
		[Inject]
		public var fileList:FileList;
		
		public function BuildLevelCommand()
		{
		
		}
		
		override public function execute():void
		{
			super.execute();
			levelData = event.level.levelData;
			
			if (injector.hasMapping(Level, "currentLevel"))
			{
				injector.unmap(Level, "currentLevel");
			}
			
			if (injector.hasMapping(GameContainerView, "currentGameContainer"))
			{
				injector.unmap(GameContainerView, "currentGameContainer");
			}
			
			injector.mapValue(Level, event.level, "currentLevel");
			
			var gameContainer:GameContainerView = new GameContainerView();
			injector.mapValue(GameContainerView, gameContainer, "currentGameContainer");
			contextView.addChild(gameContainer);
			gameContainer.alpha = 0;
			TweenMax.to(gameContainer, 1, {alpha: 1});
			
			
			var gameBackground:GameBackgroundView = new GameBackgroundView();
			gameContainer.addChild(gameBackground);
			
			var gameObjectLauncher:GameObjectLauncherView = new GameObjectLauncherView();
			gameObjectLauncher.x = levelData.config.position.x;
			gameObjectLauncher.y = levelData.config.position.y;
			gameContainer.addChild(gameObjectLauncher);
			
			//Resize to set positions based on stage size
			contextView.stage.dispatchEvent(new Event(Event.RESIZE));
			
			for (var i:uint = 0; i < levelData.targets.list.length; i++)
			{
				
				var gameTarget:GameTargetView = new GameTargetView();
				gameTarget.x = levelData.targets.list[i].position.x;
				gameTarget.y = levelData.targets.list[i].position.y;
				gameTarget.scaleX = levelData.targets.list[i].scale.x;
				gameTarget.scaleY = levelData.targets.list[i].scale.y;
				gameTarget.cacheAsBitmap = true;
				var bitmap:Bitmap = new Bitmap((fileList.getFileByID("target").loadedData.object as Bitmap).bitmapData);
				bitmap.smoothing = true;
				bitmap.cacheAsBitmap = true;
				bitmap.x = -bitmap.width * 0.5;
				bitmap.y = -bitmap.height * 0.5;
				
				gameTarget.addChild(bitmap);
				
				levelData.targets.list[i].view = gameTarget;
				
				var params:Vector.<Object> = levelData.targets.list[i].motionParams;
				
				for (var mp:uint = 0; mp < params.length; mp++)
				{
					var time:Number = params[mp].time;
					delete params[mp].time;
					params[mp].ease = Sine.easeInOut;
					TweenMax.to(gameTarget, time, params[mp]);
				}
				
				gameContainer.addChild(gameTarget);
			}
			
			eventDispatcher.dispatchEvent(new GameEvent(GameEvent.LEVEL_BUILT, event.level));
		}
	
	}

}