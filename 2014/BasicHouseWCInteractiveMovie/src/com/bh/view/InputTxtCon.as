package com.bh.view
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.adqua.util.StringUtil;
	import com.bh.events.BhEvent;
	import com.bh.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;

	public class InputTxtCon
	{
		[Embed(source="/evt_20.png")]
		private var EVT_IMG:Class;
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		private var _slashArr:Vector.<MovieClip> = new Vector.<MovieClip>;
		private var _evtImg:Bitmap;
		
		public function InputTxtCon(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			for (var i:int = 0; i < 4; i++) 
			{
				var slash:MovieClip = _con.getChildByName("slash_" + i) as MovieClip;
				_slashArr.push(slash);
			}
			
			// 이벤트 배너 붙히기.. 2014/06/20
			_evtImg = new EVT_IMG();
			_evtImg.x = 775;
			_evtImg.y = -35;
			_con.addChild(_evtImg);
		}
		
		private function initInputField(e:BhEvent):void
		{
			showInputTxtCover();
			
			var tf:TextField;
			for (var i:int = 0; i < 5; i++) 
			{
				tf = _con.getChildByName("txtMsg_" + i) as TextField;
				tf.text = "";
			}
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(BhEvent.INIT_MAIN_INPUT, initInputField);
			_model.addEventListener(BhEvent.FINISH_CARDSECTION, hideInputTxt);
			
			_con.btnTxt.buttonMode = true;
			_con.btnTxt.addEventListener(MouseEvent.CLICK, btnTxtHandler);
			
			_con.btnCheer.buttonMode = true;
			_con.btnCheer.addEventListener(MouseEvent.CLICK, btnCheerHandler);
			
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		protected function hideInputTxt(e:BhEvent):void
		{
			if(_model.fullVideo)
			{
				for (var i:int = 0; i < _slashArr.length; i++) 
				{	TweenLite.to(_slashArr[i], 0.5, {alpha:0, ease:Cubic.easeOut});		}
			}
		}
		
		private function btnTxtHandler(e:MouseEvent):void
		{	hideInputTxtCover();	}
		
		private function hideInputTxtCover():void
		{	TweenLite.to(_con.btnTxt, 0.5, {autoAlpha:0, onComplete:showTxtMsg});	}
		
		private function showInputTxtCover():void
		{	TweenLite.to(_con.btnTxt, 0.5, {autoAlpha:1});	}
		
		private function showTxtMsg():void
		{
			for (var i:int = 0; i < _slashArr.length; i++) 
			{
				_slashArr[i].x = _slashArr[i].x - 4;
				TweenLite.to(_slashArr[i], 0.75, {delay:0.25*i, alpha:1, x:_slashArr[i].x+4, ease:Cubic.easeOut});
				_con.stage.focus = _con.txtMsg_0;
			}
		}
		
		private function btnCheerHandler(e:MouseEvent):void
		{
			for (var j:int = 0; j < _model.cardSectionArr.length; j++) 
			{	_model.cardSectionArr[j] = null;	}
			_model.cardSectionArr.length = 0;
			
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.evtType = "W";
			
			var tf:TextField;
			for (var i:int = 0; i < 5; i++) 
			{
				tf = _con.getChildByName("txtMsg_" + i) as TextField;
				if(StringUtil.isBlank(tf.text) == false)
				{	_model.cardSectionArr.push(tf.text);	}
			}
			
			for (var k:int = 0; k < _model.cardSectionArr.length; k++) 
			{
				vari["msg" + (k+1)] = _model.cardSectionArr[k];
				trace("메세지  " + vari["msg" + (k+1)]);
			}
			
			if(_model.cardSectionArr.length > 0)
			{
				var url:String;
				if(SecurityUtil.isWeb())
				{
					if(StringUtil.ereg(_model.commonPath, "adqua", "g")) url = "http://basichouse.adqua.co.kr/process/CheerMsgCheck.ashx";
					else url = "http://www.basichousecheer.co.kr/process/CheerMsgCheck.ashx"
				}
				else
				{
					url = "http://basichouse.adqua.co.kr/process/CheerMsgCheck.ashx"
				}
				var req:URLRequest = new URLRequest(url);
				req.data = vari;
				req.method =URLRequestMethod.POST;
				
				/**	20150525 개발 프로세스 제거	*/
//				var ldr:URLLoader = new URLLoader();
//				ldr.load(req);
//				ldr.addEventListener(Event.COMPLETE, resultLoadComplete);
				
				userInfoLoadComplete();
			}
		}
		
		/**	유저 정보 받기	*/
		private function resultLoadComplete(e:Event):void
		{
			var result:Array = String(e.target.data).split("=");
			trace("리턴 값::::::  " + result[1]);
			switch (int(result[1]))
			{
				case 1 : 
					trace("완료"); break;
					userInfoLoadComplete();
				case -1 : trace("메세지 입력 값 필요"); break;
				case 0 : trace("잠시후 다시 시도"); break;
			}
		}
		
		/**	유저 정보 로드 완료	*/
		private function userInfoLoadComplete():void{
//			_model.dispatchEvent(new BhEvent(BhEvent.PAUSE_VIDEO));
//			_model.dispatchEvent(new BhEvent(BhEvent.SHOW_MOVIE_COVER));
			JavaScriptUtil.call("Basichouse.CheerSNSCheck");
			_model.loop = false;
			_model.hideUI = true;
			_model.fullVideoEnd = false;
			_model.sceneNum = 0;
			_model.fullVideo = true;
			_model.scrap = true;
//			_model.fullCardsection = true;
			_model.dispatchEvent(new BhEvent(BhEvent.FINISH_CARDSECTION));
			_model.dispatchEvent(new BhEvent(BhEvent.PLAY_FULL_VIDEO));
			_model.dispatchEvent(new BhEvent(BhEvent.INIT_MAIN_INPUT));
			_model.dispatchEvent(new BhEvent(BhEvent.HIDE_MOVIE_COVER));
		}
		
		private function resizeHandler(e:Event = null):void
		{
			_con.x = int(_con.stage.stageWidth/2 - _con.width/2);
			_con.y = int(_con.stage.stageHeight - _con.height - 96);
			trace(_con.x, _con.stage.stageWidth/2, _con.width/2);
		}
	}
}