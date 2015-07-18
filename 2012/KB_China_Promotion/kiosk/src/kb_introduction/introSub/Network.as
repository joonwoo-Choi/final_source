package kb_introduction.introSub
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="768", height="1366", frameRate="30", backgroundColor="#ffffff")]
	
	public class Network extends Sprite
	{
		
		/**	모델*/
		private var $model:Model;
		/**	메인 붙이기	*/
		private var $main:AssetNetwork;
		
		private var $btnLength:int = 4;
		
		public function Network()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetNetwork();
			this.addChild($main);
			
			$main.popup.visible = false;
			
			$model = Model.getInstance();
			
			makeBtn();
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			$main.popup.btnClose.buttoMode = true;
			$main.popup.btnClose.addEventListener(MouseEvent.CLICK, popupCloseHandler);
		}
		
		protected function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			$main.popup.gotoAndStop(target.no + 1);
			
			TweenMax.to($main.popup, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
		}
		
		protected function popupCloseHandler(e:MouseEvent):void
		{
			TweenMax.to($main.popup, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
			trace(e.target.name);
		}
	}
}