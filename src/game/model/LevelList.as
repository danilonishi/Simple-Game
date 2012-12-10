package game.model 
{
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class LevelList 
	{
		
		public var levels:Vector.<Level>;
		
		public function LevelList() 
		{
			levels = new Vector.<Level>();
		}
		
		public function getLevelByID(id:String):Level
		{
			for (var i:uint = 0; i < levels.length; i++)
			{
				if (levels[i].id == id)
				{
					return levels[i];
				}
			}
			
			throw new Error("game.model.LevelList::getLevelByID :: Level \"" + id + "\" not found");
			
		}
		
	}

}