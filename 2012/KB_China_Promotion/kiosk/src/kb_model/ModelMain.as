package kb_model
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kb.utils.MotionController;
	
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
	
	[SWF(width="768", height="1366", frameRate="30", backgroundColor="#ffffff")]
	
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
		/**	스크롤 이벤트	*/
		private var $scrollPage:PopupPageScroll;
		
		private var $listContent:ContentListScroll;
		
		private var $gnb:ModelGNB;
		
		private var _moController:MotionController;

		
		/**	모션 SWF 리스트	*/
		private var $motionList:XML;
		/**	버튼 갯수	*/
		private var $btnLength:int = 4;
		/**	현재 서브 메뉴	*/
		private var $nowSub:Array = [];
		/**	서브 SWF 리스트	*/
		private var $subList:XML;
		/**	루프 영상 재생	*/
		private var $loopChk:Boolean = true;
		/**	팝업 영상 플레이어	*/
		private var $popupPlayer:PopupFlvPlayer;
		
		public function ModelMain()
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
			
			$main = new AssetModel();
			this.addChild($main);
			
			$gnb = new ModelGNB($main.gnb);
			
			$model = Model.getInstance();
			
			$main.popup.visible = false;
			$main.photoCon.visible = false;
			
			_moController = new MotionController($main.movCon);
			_moController.addEventListener(MotionController.MOTION_FINISHED, motionFinished);
			
			xmlLoad();
			makeBtn();
			trace("$main.photoCon.movCon.btnPlay: ",$main.photoCon.movCon.btnPlay);
			$player = new PopupFlvPlayer($main.photoCon.movCon);
			
			$picPopup = new PopupPicture($main.photoCon.picCon);
			
			$listContent = new ContentListScroll($main.photoCon.listCon);
			
			$gnb = new ModelGNB($main.gnb);
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.MODEL_POPUP, showPopup);
			$model.addEventListener(ModelEvent.GO_TO_MODEL_MAIN, gotoModelMain);
			
			$main.photoCon.movCon.visible = false;
			$main.photoCon.picCon.visible = false;
		}
		
		protected function gotoModelMain(event:Event):void
		{
			// TODO Auto-generated method stub
			$main.photoCon["btn0"].alpha = 0;
			$main.photoCon["btn1"].alpha = 0;
			$main.movCon.visible = true;
			$main.movCon.alpha = 1;
			$main.btnCon0.x = 429;
			$main.btnCon0.y = 350;	
			$main.btnCon1.x = 120;
			$main.btnCon1.y = 350;
			$main.btnCon0.visible = true;
			$main.btnCon1.visible = true;
			$main.setChildIndex($main.btnCon0,$main.numChildren-1);
			$main.setChildIndex($main.btnCon1,$main.numChildren-1);
			trace("$main.btnCon0: ",$main.btnCon0);
			xmlLoad();
			makeBtn();
		}
		
		private function btnSetting():void
		{
			for (var i:int = 0; i < 2; i++) 
			{
				var btn:MovieClip =	$main.photoCon["btn"+i];
				btn.myNum = i;
				btn.addEventListener(MouseEvent.CLICK,onClick);
				TweenLite.to(btn,.5,{alpha:1,delay:1.5});
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var mc:MovieClip = event.currentTarget as MovieClip;
			if(mc.myNum==0)$listContent.directionChange(-10);
			else $listContent.directionChange(10);
		}
		
		protected function motionFinished(e:Event):void
		{
			if($loopChk) _moController.load($model.defaultURL + $motionList.list[1],  false);
		}
		
		private function xmlLoad():void
		{
			var data:URLVariables = new URLVariables();
			data.rand = Math.random() * 10000;
			
			var motionLdr:URLLoader = new URLLoader();
			motionLdr.data = data;
			motionLdr.load(new URLRequest($model.defaultURL + "xml/modelMotionList.xml"));
			motionLdr.addEventListener(Event.COMPLETE, motionListLoadCompleteHandler);
		}
		
		protected function motionListLoadCompleteHandler(e:Event):void
		{
			$motionList = new XML(e.target.data);
			
			mainMovieLoad();
		}
		
		private function mainMovieLoad():void
		{
			_moController.load($model.defaultURL + $motionList.list[0],  true);
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			/**	김연아 버튼	*/
			for (var i:int = 0; i < $btnLength-2; i++) 
			{
				var btn:MovieClip = $main.btnCon0.getChildByName("btn" + i) as MovieClip;
				btn.buttonMode = true;
				btn.no = i;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			/**	이승기 버튼	*/
			for (var j:int = 2; j < $btnLength; j++) 
			{
				var btns:MovieClip = $main.btnCon1.getChildByName("btn" + j) as MovieClip;
				btns.buttonMode = true;
				btns.no = j;
				btns.addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			$main.popup.btnClose.addEventListener(MouseEvent.CLICK, popupCloseHandler);
		}
		
		protected function btnClickHandler(e:MouseEvent):void
		{
			btnSetting();
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (target.no)
			{
				case 0 :
					if($main.btnCon0.y == 350) return;
					$loopChk = false;
					$main.btnCon0.x = 429;
					$main.btnCon0.y = 350;
					$main.btnCon1.visible = false;
					_moController.load($model.defaultURL + $motionList.list[2],  true);
					$main.popup.gotoAndStop(1);
					TweenMax.to($main.popup, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
					break;
				case 1 :
					TweenMax.to($main.popup, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.movCon, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.photoCon, 0.75, {autoAlpha:1, ease:Cubic.easeOut, onComplete:removeMotion});
					$model.listArrayNum = 0;
					$model.dispatchEvent(new ModelEvent(ModelEvent.LIST_CHANGE));					
					break;
				case 2 :
					if($main.btnCon1.y == 350) return;
					$loopChk = false;
					$main.btnCon1.x = 120;
					$main.btnCon1.y = 350;
					$main.btnCon0.visible = false;
					_moController.load($model.defaultURL + $motionList.list[3],  true);
					$main.popup.gotoAndStop(2);
					TweenMax.to($main.popup, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
					break;
				case 3 :
					TweenMax.to($main.popup, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.movCon, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
					TweenMax.to($main.photoCon, 0.75, {autoAlpha:1, ease:Cubic.easeOut, onComplete:removeMotion});
					
					$model.listArrayNum = 1;
					$model.dispatchEvent(new ModelEvent(ModelEvent.LIST_CHANGE));					
					break;
			}
		}
		/**	SWF 모션 제거	*/
		private function removeMotion():void
		{
			_moController.unload();
		}
		
		private function popupCloseHandler(e:MouseEvent):void
		{
			$loopChk = true;
			_moController.load($model.defaultURL + $motionList.list[1],  false);
			TweenMax.to($main.popup, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
			
			/**	버튼 초기 설정	*/
			$main.btnCon0.visible = true;
			$main.btnCon1.visible = true;
			$main.btnCon0.x = 59;
			$main.btnCon1.x = 481;
			$main.btnCon0.y = $main.btnCon1.y = 355;
		}
		
		protected function showPopup(e:Event):void
		{
			if($model.popupNum == 0)
			{
				TweenMax.to($main.photoCon.movCon, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
			}
			else
			{
				TweenMax.to($main.photoCon.picCon, 0.75, {autoAlpha:1, ease:Cubic.easeOut});
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
	}
}