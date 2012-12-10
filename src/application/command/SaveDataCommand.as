package application.command 
{
	import flash.net.SharedObject;
	import game.model.LevelList;
	import game.model.SaveObject;
	import org.robotlegs.mvcs.Command;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class SaveDataCommand extends Command 
	{
		[Inject]
		public var list:LevelList;
		
		public function SaveDataCommand() 
		{
			
		}
		
		override public function execute():void 
		{
			super.execute();
			
			var clearedLevels:Vector.<String> = new Vector.<String>();
			var highScores:Vector.<Number> = new Vector.<Number>();
			
			for (var i:uint = 0; i < list.levels.length; i++)
			{
				if (list.levels[i].levelData.cleared)
				{
					clearedLevels.push(list.levels[i].id);
					highScores.push(list.levels[i].highScore);
				}
			}
			
			var saveData:SaveObject = new SaveObject();
			saveData.clearedLevels = clearedLevels;
			saveData.highScores = highScores;
			
			var so:SharedObject = SharedObject.getLocal("danilonishimura_angryclone");
			so.data.save = saveData;
			so.flush();
			
		}
		
	}

}