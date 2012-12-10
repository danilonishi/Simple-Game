package game.view
{
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import events.GameEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.model.Level;
	import game.model.TargetList;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class GameTargetMediator extends Mediator
	{
		[Inject]
		public var view:GameTargetView;
		
		[Inject(name="currentLevel")]
		public var level:Level;
		
		public var hitObject:Sprite;
		
		public function GameTargetMediator()
		{
			
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			createHitObject();
			
			view.mouseChildren = false;
			//view.buttonMode = true;
			view.alpha = 1;
			//view.addEventListener(MouseEvent.CLICK, onTargetHit);
		}
		
		private function createHitObject():void 
		{
			hitObject = new Sprite();
			hitObject.graphics.beginFill(0xff0000);
			hitObject.graphics.drawCircle(view.width * 0.5 / view.scaleX, view.height * 0.5 / view.scaleY, view.width * 0.5 / view.scaleX);
			hitObject.graphics.endFill();
		}
		
		public function onTargetHit(e:MouseEvent = null):void
		{
			view.removeEventListener(MouseEvent.CLICK, onTargetHit);
			
			var motionParams:Object = new Object();
			//motionParams.x = view.x - (view.width / view.scaleX) * view.scaleX * 0.5;
			//motionParams.y = view.y - (view.height / view.scaleY) * view.scaleY * 0.5;
			motionParams.scaleX = view.scaleX * 2;
			motionParams.scaleY = view.scaleY * 2;
			motionParams.autoAlpha = 0;
			motionParams.ease = Expo.easeOut;
			motionParams.onComplete = function():void { view.parent.removeChild(view); }
			
			TweenMax.to(view, 0.5, motionParams );
			
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			while (view.numChildren > 0)
			{
				view.removeChildAt(0);
			}
			view.removeEventListener(MouseEvent.CLICK, onTargetHit);
		}
	}

}