package game.model 
{
	import application.model.HighScoreData;
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class Level 
	{
		public var name:String;
		public var id:String;
		public var path:String;
		
		public var levelData:LevelData;
		public var highScore:Number;
		
		public function Level() 
		{
			levelData = new LevelData();
		}
		
	}

}