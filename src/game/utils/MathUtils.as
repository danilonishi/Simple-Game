package game.utils 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class MathUtils 
	{
		
		static public function getDistance(origin:Point, target:Point):Number
		{
			return Math.sqrt(Math.pow(target.x - origin.x, 2) + Math.pow(target.y - origin.y, 2));
		}
		
		static public function getAngle(origin:Point, target:Point):Number
		{
			return Math.atan2(target.y - origin.y, target.x - origin.x);
		}
		
	}

}