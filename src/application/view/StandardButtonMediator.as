package application.view 
{
	import events.ApplicationEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.robotlegs.mvcs.Mediator;
	
	/**
	 * ...
	 * @author Danilo Nishimura
	 */
	public class StandardButtonMediator extends Mediator 
	{
		
		[Inject]
		public var view:StandardButtonView;
		
		private var field:TextField;
		
		public function StandardButtonMediator() 
		{
			
		}
		
		override public function onRegister():void 
		{
			super.onRegister();
			
			createTextField();
			view.addChild(field);
			drawButton();
			
			view.alpha = 0.5;
			view.buttonMode = true;
			view.mouseChildren = false;
			view.addEventListener(MouseEvent.CLICK, onButtonClick);
			
		}
		
		private function onButtonClick(e:MouseEvent):void 
		{
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.CLEAR_DATA));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_MAINSCREEN));
			eventDispatcher.dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_MAINSCREEN));
		}
		
		private function createTextField():void 
		{
			field = new TextField();
			field.defaultTextFormat = new TextFormat("Verdana", 14, 0xffffff, true, null, null, null, null, "center");
			field.autoSize = TextFieldAutoSize.LEFT;
			field.text = view.caption;
			field.mouseEnabled = false;
			field.x = 10;
			field.y = 10;
		}
		
		private function drawButton():void 
		{
			view.graphics.lineStyle(1, 0xffffff, 1);
			view.graphics.beginFill(0x000000, 0.75);
			view.graphics.drawRect(0, 0, field.width + 20, field.height + 20);
			view.graphics.endFill();
		}
		
		override public function onRemove():void 
		{
			view.removeChild(field);
			field = null;
			view.graphics.clear();
			view.removeEventListener(MouseEvent.CLICK, onButtonClick);
			super.onRemove();
		}
	}

}