package game.command 
{
	import events.GameEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.model.Level;
	import game.model.LevelData;
	import game.model.Target;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class ParseLevelCommand extends Command 
	{
		
		
		[Inject]
		public var event:GameEvent;
		
		private var level:Level;
		private var levelData:LevelData;
		
		public function ParseLevelCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			level = event.level;
			levelData = level.levelData;
			
			var config:XML = XML(levelData.levelXML.config);
			
			levelData.config.allowSkyShot = Boolean(Number(config.other.@allowSkyShot));
			levelData.config.backgroundID = config.other.@backgroundID;
			levelData.config.bounce.bottom = Number(config.bounce.@bottom);
			levelData.config.bounce.left = Number(config.bounce.@left);
			levelData.config.bounce.right = Number(config.bounce.@right);
			levelData.config.bounce.top = Number(config.bounce.@top);
			levelData.config.position = new Point(Number(config.shootingArea.@x), Number(config.shootingArea.@y));
			levelData.config.shootingRadius = Number(config.shootingArea.@radius);
			
			levelData.config.levelDimensions = new Point(Number(config.levelDimensions.@width), Number(config.levelDimensions.@height));
			
			var targets:XML = XML(levelData.levelXML.targets);
			for (var t:uint = 0; targets.target[t] != null; t++)
			{
				var target:Target = new Target();
				target.position = new Point(targets.target[t].position.@x, targets.target[t].position.@y);
				target.scale = new Point(targets.target[t].scale.@x, targets.target[t].scale.@y)
				
				for (var m:uint = 0; targets.target[t].motion[m] != null; m++ )
				{
					var params:Object = new Object();
					
					for (var p:uint = 0; targets.target[t].motion[m].param[p] != null; p++)
					{
						params[targets.target[t].motion[m].param[p].@name] = Number(targets.target[t].motion[m].param[p].@value);
					}
					target.motionParams[target.motionParams.length] = params;
				}
				
				levelData.targets.list.push(target);
			}
			
			eventDispatcher.dispatchEvent(new GameEvent(GameEvent.LEVEL_PARSED, level));
			eventDispatcher.dispatchEvent(new GameEvent(GameEvent.BUILD_LEVEL, level));
		}
		
	}

}