package application.view 
{
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class LoadingScreenMediator extends Mediator 
	{
		
		private var view:LoadingScreenView;
		private var message:TextField;
		
		public function LoadingScreenMediator() 
		{
			
		}
		
		override public function onRegister():void 
		{
			view = viewComponent as LoadingScreenView;
			create();
			super.onRegister();
		}
		
		public function create():void
		{
			view.graphics.beginFill(0x000000, 1);
			view.graphics.drawRect(0, 0, contextView.stage.stageWidth, contextView.stage.stageHeight);
			view.graphics.endFill();
			view.alpha = 0;
			
			message = new TextField();
			message.autoSize = TextFieldAutoSize.CENTER;
			message.defaultTextFormat = new TextFormat("Verdana", 20, 0xffffff, true, null, null, null, null, "center");
			message.text = "Loading...";
			view.addChild(message);
			
			contextView.addEventListener(Event.RESIZE, onStageResize);
			onStageResize(null);
		}
		
		private function onStageResize(e:Event):void 
		{
			message.x = contextView.stage.stageWidth * 0.5 - message.width * 0.5;
			message.y = contextView.stage.stageHeight * 0.5 - message.height * 0.5;
		}
		
		public function show():void
		{
			TweenMax.to(view, 0.25, { autoAlpha:1 } );
		}
		
		public function hide():void
		{
			TweenMax.to(view, 0.25, { delay:0.5, autoAlpha:0, onComplete:removeSelf } );
		}
		
		private function removeSelf():void 
		{
			view.parent.removeChild(view);
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			
			contextView.removeEventListener(Event.RESIZE, onStageResize);
			
			view.removeChild(message);
			view.graphics.clear();
			
			message = null;
		}
		
	}

}