package kb_model
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import kb_model.modelGNB.ModelGNB;
	import kb_model.modelScroll.ContentListScroll;
	import kb_model.modelScroll.PopupPageScroll;
	import kb_model.popup.PopupFlvPlayer;
	import kb_model.popup.PopupPicture;
	
	[SWF(width="1920", height="1080", frameRate="30", backgroundColor="#ffffff")]
	
	public class ModelMain extends Sprite
	{
		
		/**	모델*/
		private var $model:Model;
		/**	메인 붙이기	*/
		private var $main:AssetModel;
		/**	FlvPlayer	*/
		private var $player:PopupFlvPlayer;
		/**	사진 팝업	*/
		private var $picPopup:PopupPicture;
		/**	버튼 수	*/
		private var $btnLength:int = 2;
		/**	스크롤 이벤트	*/
		private var $scrollPage:PopupPageScroll;
		
		private var $listContent:ContentListScroll;
		
		private var $gnb:ModelGNB;
		
		public function ModelMain()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		public function dispose():void
		{
			Model.getInstance().dispose();
			TweenMax.killAll();
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetModel();
			this.addChild($main);
			
			$player = new PopupFlvPlayer($main.movCon);
			
			$picPopup = new PopupPicture($main.picCon);
			
			$listContent = new ContentListScroll($main.listCon);
			
			$gnb = new ModelGNB($main.gnb);
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.MODEL_POPUP, showPopup);
			
			$main.movCon.visible = false;
			$main.picCon.visible = false;
			$main.popup0.visible = false;
			$main.popup1.visible = false;
			
			makeBtn();
		}
		
		protected function showPopup(e:Event):void
		{
			if($model.popupNum == 0)
			{
				TweenMax.to($main.movCon, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
			}
			else
			{
				TweenMax.to($main.picCon, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
			}
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, popupHandler);
				
				var btnModel:MovieClip = $main.getChildByName("btnModel" + i) as MovieClip;
				btnModel.no = i;
				btnModel.buttonMode = true;
				btnModel.addEventListener(MouseEvent.CLICK, btnModelHandler);
				
				var popup:MovieClip = $main.getChildByName("popup" + i) as MovieClip;
				popup.btnClose.no = i;
				popup.btnClose.buttonMode = true;
				popup.btnClose.addEventListener(MouseEvent.CLICK, popupCloseHandler);
				
				$scrollPage = new PopupPageScroll(popup, popup.maskMC.height);
			}
		}
		
		private function btnModelHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			$model.listArrayNum = target.no;
			$model.dispatchEvent(new ModelEvent(ModelEvent.LIST_CHANGE));
		}
		
		protected function popupHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			/**	이미지 Y값 초기화	*/
			var popup:MovieClip = $main.getChildByName("popup" + mc.no) as MovieClip;
			popup.imgCon.y = 68;
			
			switch (mc.no)
			{
				case 0 :
					TweenMax.to($main.popup0, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
					break;
				case 1 :
					TweenMax.to($main.popup1, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
					break;
			}
		}
		
		private function popupCloseHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch (mc.no)
			{
				case 0 :
					TweenMax.to($main.popup0, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					break;
				case 1 :
					TweenMax.to($main.popup1, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					break;
			}
		}
	}
}