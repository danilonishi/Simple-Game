package game.model 
{
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class LevelData 
	{
		
		public var levelXML:XML;
		public var config:Config;
		public var cleared:Boolean;
		
		[Inject]
		public var targets:TargetList;
		
		public function LevelData() 
		{
			config = new Config();
			targets = new TargetList();
		}
		
	}

}

import flash.geom.Point;
import flash.geom.Rectangle;

internal class Config
{
	public var allowSkyShot:Boolean;
	public var backgroundID:String;
	public var bounce:Bounce;
	public var levelDimensions:Point;
	public var shotRelativePosition:Point;
	public var position:Point;
	public var shootingRadius:Number;
	
	public function Config()
	{
		bounce = new Bounce();
	}
}

internal class Bounce
{
	public var top:Number;
	public var left:Number;
	public var right:Number;
	public var bottom:Number;
}