package day.day1
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import pEvent.PEventCommon;
	
	[SWF(width="961", height="541", frameRate="30", backgroundColor="0x999999")]
	
	public class Day1_2 extends AbstractMain
	{
		
		private var $main:AssetDay1_2;
		
		private var $choiceBtnLength:int = 2;
		
		private var $swf:SWFLoader;
		private var $skipTimer:Timer;
		private var $swimChkNum:Number = 0;
		private var $btnSkip:BtnSkip;
		
		
		public function Day1_2()
		{
			super();
			TweenPlugin.activate([AutoAlphaPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			//노란바
			_model.dispatchEvent(new PEventCommon(PEventCommon.YELLOW_OPEN));
			
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
			_model.addEventListener(PEventCommon.SKIP_INTERACTION, skipOff);
			
			$main = new AssetDay1_2();
			this.addChild($main);
			$main.alpha = 0;
			$main.visible = false;
			TweenLite.to($main, .5, {autoAlpha:1});
			
			//btnSkip버튼
			$btnSkip = new BtnSkip;
			addChild($btnSkip);
			$btnSkip.y = 463;
			$btnSkip.visible = false;
			$btnSkip.buttonMode = true;
			$btnSkip.addEventListener(MouseEvent.ROLL_OVER, skipOver);
			$btnSkip.addEventListener(MouseEvent.ROLL_OUT, skipOut);
			$btnSkip.addEventListener(MouseEvent.CLICK, skipClick);
			
			
			/**	테스트위한 XML 로드	*/
			if(_model.xmlData==null){
				var urlLdr:URLLoader = new URLLoader;
				if(SecurityUtil.isWeb()==true){
					urlLdr.load(new URLRequest(_model.urlDefaultWeb + "xml/movie.xml"));
				}else{
					urlLdr.load(new URLRequest(_model.urlDefault + "xml/movie_d.xml"));
				}
				urlLdr.addEventListener(Event.COMPLETE, xmlLoadComplete);
			}else{
				makeBtn();
			}
		}
		
		protected function skipOver(evt:MouseEvent):void
		{
			evt.currentTarget["skipMc"].gotoAndStop(2);
		}
		protected function skipOut(evt:MouseEvent):void
		{
			evt.currentTarget["skipMc"].gotoAndStop(1);
		}
		protected function skipClick(evt:MouseEvent):void
		{
			skipOff(null);
		}
		
		private function skipOff(evt:PEventCommon=null):void
		{
			TweenLite.to($main, .5, {autoAlpha:0});
			TweenLite.to($btnSkip, .5, {frame:1, onComplete:skipComplete});
		}
		
		private function skipComplete(evt:Event = null):void
		{
			skipInteraction();
			trace("스킵아웃");
			
			$btnSkip.stop();
			$btnSkip.visible = false;
			$btnSkip.alpha = 0;
			TweenLite.killTweensOf($btnSkip);
			_model.removeEventListener(PEventCommon.SKIP_OPEN_ON,skipOn);
		}
		
		//스킵온
		private function skipOn(evt:PEventCommon = null):void
		{
			trace("스킵온   _model.activeMenu  : ", _model.activeMenu)
			TweenLite.to($btnSkip, .5, {autoAlpha:1,frame:$btnSkip.totalFrames-1})
		}
		
		/**	XML로드 완료 모델에 저장	*/
		protected function xmlLoadComplete(e:Event):void
		{
			_model.xmlData = XML(e.target.data);
			makeBtn();
		}
		
		/**	스킵 타이머 - 인터랙션 종료	*/
		private function skipInteraction(e:PEventCommon = null):void
		{
			trace("skipInteraction:???????????????????????????? ");
			trace("_model.swimChkNum : ", _model.swimChkNum)
			_model.swimChkNum = 0;
			removeEvent();
			_controler.changeMovie([2,2,4]);
			TweenLite.to($main, 0.5, {autoAlpha:0, onComplete:destroy});
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			/**	방향 선택	*/
			for (var i:int = 0; i < $choiceBtnLength; i++) 
			{
				var btn:MovieClip = $main.btnCon.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				ButtonUtil.makeButton(btn, choiceHandler);
			}
		}
		
		/**	영상 선택	*/
		private function choiceHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenMax.to($main.btnCon["btn" + e.target.no]["mc"], 0.2, {frame:8});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenMax.to($main.btnCon["btn" + e.target.no]["mc"], 0.2, {frame:1});
					$main.btnCon["btn" + e.target.no].gotoAndStop(1);
					TweenMax.to($main.btnCon["btn" + e.target.no], 0.5, {frame:1});
					break;
				case MouseEvent.CLICK :
					
					//수영 3번 클릭시 (mainPlayer에서)
					_model.swimChkNum ++;
						
					if(_model.swimChkNum > 0 ){
						TweenLite.delayedCall(.8,skipOn)
					}
					
					if(e.target.no == 0){
						_controler.changeMovie([2,2,2]);
					}else if(e.target.no == 1){
						_controler.changeMovie([2,2,3]);
					}
					
					TweenMax.to($main.btnCon["btn" + e.target.no], 0.5, {frame:17});
					break;
			}
		}
		
		
		/**	초기화	*/
		private function destroy(e:Event=null):void
		{
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
		}
		
		private function removeEvent(e:Event=null):void
		{
			
			for (var i:int = 0; i < $choiceBtnLength; i++) 
			{
				var btn:MovieClip = $main.btnCon.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btn, choiceHandler);
			}
			
			$btnSkip.removeEventListener(MouseEvent.ROLL_OVER, skipOver);
			$btnSkip.removeEventListener(MouseEvent.ROLL_OUT, skipOut);
			$btnSkip.removeEventListener(MouseEvent.CLICK, skipClick);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
		}
	}
}