package game.model 
{
	import flash.geom.Point;
	import game.view.GameTargetView;
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class Target 
	{
		
		public var destroyed:Boolean;
		public var position:Point;
		public var scale:Point;
		public var motionParams:Vector.<Object>;
		public var view:GameTargetView;
		
		public function Target() 
		{
			position = new Point();
			scale = new Point();
			motionParams = new Vector.<Object>();
			view = new GameTargetView();
		}
		
	}

}