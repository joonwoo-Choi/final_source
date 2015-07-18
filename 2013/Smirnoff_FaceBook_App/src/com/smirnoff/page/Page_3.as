package com.smirnoff.page
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.smirnoff.events.SmirnoffEvents;
	import com.smirnoff.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class Page_3
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _txtArr:Array;
		private var _btnArr:Array;
		private var _cd:cdClip;
		
		public function Page_3(con:MovieClip)
		{
			TweenPlugin.activate([AutoAlphaPlugin, ColorTransformPlugin, DropShadowFilterPlugin]);
			_con = con;
			_model.addEventListener(SmirnoffEvents.PAGE_CHANGED, pageChanged);
			_model.addEventListener(SmirnoffEvents.GO_MAIN, goMain);
			
			_con.loader.alpha = 0;
			_con.loader.visible = false;
			_con.loader.loader.gotoAndStop(1);
			
			makeBtn();
		}
		
		protected function goMain(event:Event):void
		{
			if(_con.visible == false) return;
			outMotion("main", 1);
		}
		
		protected function pageChanged(e:SmirnoffEvents):void
		{
			if(int(e.value.pageNo) != 3) return;
			trace("3페이지 시작__!!");
			/**	트래킹	*/
			JavaScriptUtil.call("googleSender", "District", "step3");
			
			cdImgLoad();
			
			_btnArr = [];
			for (var i:int = 0; i < 2; i++) 
			{
				var commonBtn:MovieClip = _con.getChildByName("btn" + i) as MovieClip;
				commonBtn.no = i;
				_btnArr.push(commonBtn);
				ButtonUtil.makeButton(commonBtn, commonBtnHandler);
			}
			
			_con.alpha = 1;
			_con.visible = true;
			inMotion();
			_con.titleTxt.txt.text = "타이틀을 작성 하세요";
		}
		
		private function cdImgLoad():void
		{
			if(_cd.numChildren >= 2)
			{
				var cnt:int = _cd.numChildren;
				while(cnt > 1)
				{
					var ldr:Loader = _cd.getChildAt(_cd.numChildren-1) as Loader;
					var bmp:Bitmap = ldr.content as Bitmap;
					if(ldr.content != null) bmp.bitmapData.dispose();
					_cd.removeChild(ldr);
					ldr.unloadAndStop();
					cnt--;
					trace("cd자식수: " + _cd.numChildren);
				}
			}
			
			var imgLdr:Loader = new Loader();
			imgLdr.load(new URLRequest(String(_model.defaultPath + _model.sndList.original.cd[_model.cdNum].@img)));
			imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, cdimgLoadcomplete);
			_cd.addChild(imgLdr);
		}
		
		private function cdimgLoadcomplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			bmp.x = -251;
			bmp.y = -251;
		}
		
		private function inMotion():void
		{
			_con.titleTxt.alpha = 0;
			_cd.rotation = -45;
			_cd.alpha = 0;
			_cd.scaleX = _cd.scaleY = 0.95;
			TweenLite.to(_con.titleTxt, 1, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to(_cd, 1, {alpha:1, scaleX:1, scaleY:1, rotation:0, ease:Cubic.easeOut});
			
			for (var j:int = 0; j < _btnArr.length; j++) 
			{
				_btnArr[j].alpha = 0;
				TweenLite.to(_btnArr[j], 1, {alpha:1, ease:Cubic.easeOut});
			}
			
			for (var i:int = 0; i < _txtArr.length; i++) 
			{
				_txtArr[i].alpha = 0;
				_txtArr[i].scaleX = _txtArr[i].scaleY = 1.05;
				TweenLite.to(_txtArr[i], 0.75, {delay:0.1*i, alpha:1, scaleX:1, scaleY:1, onCompleteParams:["in", i], onComplete:motionComplete, ease:Cubic.easeOut});
			}
		}
		
		private function motionComplete(type:String, num:int, btnNum:int = -1):void
		{
			if(type == "in" && num == _txtArr.length - 1) _con.cover.visible = false;
			if(type == "out" && num == _txtArr.length - 1)
			{
				_con.alpha = 0;
				_con.visible = false;
				if(btnNum == 0) _model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:2}));
				else if(btnNum == 1) _model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:4}));
			}
			if(type == "main" && num == _txtArr.length - 1)
			{
				_con.alpha = 0;
				_con.visible = false;
				_model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:0}));
			}
		}
		
		private function outMotion(type:String, num:int):void
		{
			TweenLite.to(_con.titleTxt, 1, {alpha:0, ease:Cubic.easeOut});
			TweenLite.to(_cd, 1, {alpha:0, scaleX:0.95, scaleY:0.95, rotation:60, ease:Cubic.easeOut});
			
			for (var j:int = 0; j < _btnArr.length; j++) 
			{
				TweenLite.to(_btnArr[j], 1, {alpha:0, ease:Cubic.easeOut});
			}
			
			for (var i:int = 0; i < _txtArr.length; i++) 
			{
				TweenLite.to(_txtArr[i], 0.75, {delay:0.1*i, alpha:0, onCompleteParams:[type, i, num], onComplete:motionComplete, ease:Cubic.easeOut});
			}
		}
		
		private function makeBtn():void
		{
			_txtArr = [];
			for (var j:int = 0; j < 5; j++) 
			{
				var txt:MovieClip = _con.getChildByName("txt" + j) as MovieClip;
				_txtArr.push(txt);
			}
			
			_cd = new cdClip();
			_con.cdCon.addChild(_cd);
			TweenLite.to(_cd, 0, {dropShadowFilter:{color:0x000000, alpha:0.15, blurX:2, blurY:2, distance:2}});
//			_cd.x = 412;
//			_cd.y = 497
			
			_con.titleTxt.txt.addEventListener(FocusEvent.FOCUS_IN, tfFocusIn);
			_con.titleTxt.txt.addEventListener(FocusEvent.FOCUS_OUT, tfFocusOut);
			_con.stage.addEventListener(KeyboardEvent.KEY_UP, keyDown);
//			_con.titleTxt.txt.addEventListener(Event.CHANGE, txtChange);
		}
		
		protected function keyDown(e:KeyboardEvent):void
		{
			if(_con.titleTxt.txt.length >= 10) _con.titleTxt.txt.text = String(_con.titleTxt.txt.text).slice(0, 10);
//			_con.titleTxt.txt.text = restrictionStringBytes(_con.titleTxt.txt.text, 10);
		}
		
//		private function restrictionStringBytes( str: String, bytes: int ): String
//		{
//			var byte: ByteArray = new ByteArray();
//			byte.writeMultiByte( str, "euc-kr" );
//			byte.position = 0;
//			
//			var resctrictedByte: ByteArray = new ByteArray();
//			byte.readBytes( resctrictedByte, 0, bytes );
//			resctrictedByte.position = 0;
//			
//			var rtn: String = resctrictedByte.readMultiByte( resctrictedByte.length, "euc-kr" );
//			return rtn;
//		}
		
		private function tfFocusIn(e:FocusEvent):void
		{
			if(_con.titleTxt.txt.text == "타이틀을 작성 하세요") _con.titleTxt.txt.text = "";
		}
		
		private function tfFocusOut(e:FocusEvent):void
		{
			if(_con.titleTxt.txt.text == "") _con.titleTxt.txt.text = "타이틀을 작성 하세요";
		}
		
		private function commonBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK :
					trace(target.no);
					_con.cover.visible = true;
					if(target.no == 0) 
					{
						/**	트래킹	*/
						JavaScriptUtil.call("googleSender", "District", "step3btn1");
						
						for (var i:int = 0; i < 2; i++) 
						{	ButtonUtil.removeButton(_btnArr[i], commonBtnHandler);	}
						outMotion("out", target.no);
					}
					else if(target.no == 1) 
					{
						/**	트래킹	*/
						JavaScriptUtil.call("googleSender", "District", "step3btn2");
						
						sendUserData();
					}
					break;
			}
		}
		
		
		private function sendUserData():void
		{
			if(_con.titleTxt.txt.text == "" || _con.titleTxt.txt.text == "타이틀을 작성 하세요")
			{
				_con.cover.visible = false;
				JavaScriptUtil.alert("타이틀을 작성 하세요");
				return;
			}
			TweenLite.to(_con.loader, 0.5, {autoAlpha:1});
			_con.loader.loader.gotoAndPlay(1);
			
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.mnum = _model.cdNum + 1;
			vari.bnum = _model.selectedRemixNum[0] + 1;
			vari.dnum = _model.selectedRemixNum[1] + 1;
			vari.efnum = _model.selectedRemixNum[2] + 1;
			
			/**	20150525 개발 프로세스 제거 - 일정 시간 후 다음 스텝 연결 	*/
			_model.uTitle = _con.titleTxt.txt.text;
			setTimeout(saveComplate, 1500);
//			makeUrlLoader(vari, sendUserMusicComplete, _model.dataUrl + "process/CreateMusic.ashx");
		}
		
		private function makeUrlLoader(vari:URLVariables, fn:Function, url:String):void
		{
			var req:URLRequest = new URLRequest(url);
			req.data = vari;
			req.method =URLRequestMethod.POST;
			
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(req);
			urlLdr.addEventListener(Event.COMPLETE, fn);
		}
		
		private function sendUserMusicComplete(e:Event):void
		{
			trace("음악 파일명: " + e.target.data);
			_model.uTitle = _con.titleTxt.txt.text;
			_model.sndUrl = String(_model.outputSndUrl + e.target.data);
			
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.title = _con.titleTxt.txt.text;
			vari.musicFile = String(e.target.data);
			vari.fbname = _model.uName;
			vari.fbid = _model.FBID
			vari.token = _model.FBToken;
			
			/**	20150525 개발 프로세스 제거	*/
//			makeUrlLoader(vari, sendUserTitleComplete, _model.dataUrl + "process/EventComplete.ashx");
			/**	광고제 출품용	*/
//			makeUrlLoader(vari, sendUserTitleComplete, _model.dataUrl + "process/EventComplete2.ashx");
		}
		
		private function sendUserTitleComplete(e:Event):void
		{
			switch (int(e.target.data))
			{
				case 1: 
					trace("저장 완료");
					saveComplate();
					break;
				case -1: trace("파라미터가 올바르지 않음"); break;
				case -9: trace("관리자에게 문의"); break;
			}
		}
		
		private function saveComplate():void{
			for (var i:int = 0; i < 2; i++) 
			{	ButtonUtil.removeButton(_btnArr[i], commonBtnHandler);	}
			
			TweenLite.to(_con.loader, 0.5, {autoAlpha:0});
			_con.loader.loader.stop();
			
			outMotion("out", 1);
		}
	}
}