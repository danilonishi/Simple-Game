package game.model 
{
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class TargetList 
	{
		
		public var list:Vector.<Target>;
		
		public function get length():uint 
		{
			return list.length;
		}
		
		public function TargetList() 
		{
			list = new Vector.<Target>();
		}
		
		
		
	}

}