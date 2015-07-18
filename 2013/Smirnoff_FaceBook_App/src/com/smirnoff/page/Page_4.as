package com.smirnoff.page
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.adqua.util.NetUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.smirnoff.control.SndControl;
	import com.smirnoff.events.SmirnoffEvents;
	import com.smirnoff.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;

	public class Page_4
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _sndControl:SndControl;
		private var _txtArr:Array;
		private var _cd:cdClip;
		
		public function Page_4(con:MovieClip)
		{
			TweenPlugin.activate([ColorTransformPlugin, DropShadowFilterPlugin]);
			_con = con;
			_con.loader.alpha = 0;
			_con.loader.visible = false;
			_con.loader.loader.stop();
			_sndControl = new SndControl(_con.playBar);
			_model.addEventListener(SmirnoffEvents.PAGE_CHANGED, pageChanged);
			_model.addEventListener(SmirnoffEvents.GO_MAIN, goMain);
			
			makeBtn();
		}
		
		protected function goMain(event:Event):void
		{
			if(_con.visible == false) return;
			_sndControl.initSnd();
			outMotion();
		}
		
		protected function pageChanged(e:SmirnoffEvents):void
		{
			if(int(e.value.pageNo) != 4) return;
			trace("4페이지 시작__!!");
			/**	트래킹	*/
			JavaScriptUtil.call("googleSender", "District", "step4");
			
			_con.alpha = 1;
			_con.visible = true;
			_con.cover.visible = false;
			_cd.rotation = 0;
			_con.txt1.uName.text = _model.uName;
			_con.txt2.uTitle.text = _model.uTitle;
			_con.txt1.uName.autoSize = TextFieldAutoSize.LEFT;
			_con.txt2.uTitle.autoSize = TextFieldAutoSize.LEFT;
			_con.txt1.bracket.x = int(_con.txt1.uName.x + _con.txt1.uName.textWidth + 12);
			_con.txt1.x = int(_con.stage.stageWidth/2 - _con.txt1.width/2) + 168;
			_con.txt2.x = int(_con.stage.stageWidth/2 - _con.txt2.width/2) + 85;
			
			inMotion();
			
			_sndControl.initSnd();
			_sndControl.loadSnd();
			_sndControl.selectedCD(_cd);
			
			useImgLoad();
		}
		
		private function useImgLoad():void
		{
			if(_con.cdCon.img.numChildren > 0)
			{
				var cnt:int = _con.cdCon.img.numChildren;
				while(cnt > 0)
				{
					var removeLdr:Loader = _con.cdCon.img.getChildAt(_con.cdCon.img.numChildren-1) as Loader;
					var bmp:Bitmap = removeLdr.content as Bitmap;
					if(removeLdr.content != null) bmp.bitmapData.dispose();
					trace(removeLdr, bmp, _con.cdCon.img.numChildren);
					_con.cdCon.img.removeChild(removeLdr);
					removeLdr.unloadAndStop();
					cnt--;
					trace("유저 이미지 자식 수" + _con.cdCon.img.numChildren);
				}
			}
			
			var ldr:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			if(SecurityUtil.isWeb())
			{
				context.checkPolicyFile = true;
				context.securityDomain = SecurityDomain.currentDomain;
				context.applicationDomain = ApplicationDomain.currentDomain;
			}
			ldr.load(new URLRequest(_model.defaultPath+_model.uImg), context);
			
			_con.cdCon.img.addChild(ldr);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, userImgLoadComplete);
			
			if(_cd.numChildren > 1)
			{
				var cnt2:int = _cd.numChildren;
				while(cnt2 > 1)
				{
					var removeLdr2:Loader = _cd.getChildAt(_cd.numChildren-1) as Loader;
					var bmp2:Bitmap = removeLdr2.content as Bitmap;
					if(removeLdr2.content != null) bmp2.bitmapData.dispose();
					_cd.removeChild(removeLdr2);
					removeLdr2.unloadAndStop();
					cnt2--;
					trace("CD 자식 수" + _con.cdCon.img.numChildren);
				}
			}
			
			var ldr2:Loader = new Loader();
			ldr2.load(new URLRequest(String(_model.defaultPath + _model.sndList.original.cd[_model.cdNum].@img)));
			ldr2.contentLoaderInfo.addEventListener(Event.COMPLETE, cdImgLoadComplete);
			_cd.addChild(ldr2);
		}
		
		private function userImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			
			bmp.width = 140;
			bmp.height = 140;
			bmp.scaleX = bmp.scaleY = Math.max(bmp.scaleX, bmp.scaleY);
			bmp.x = int(140/2 - bmp.width/2);
			bmp.y = int(140/2 - bmp.height/2);
		}
		
		private function cdImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			
			bmp.x = -251;
			bmp.y = -251;
		}
		
		private function inMotion():void
		{
			_con.cdCon.y = -_con.cdCon.height;
			_con.btnShare.alpha = 0;
			_con.playBar.alpha = 0;
			TweenLite.to(_con.cdCon, 1, {y:122, ease:Cubic.easeOut});
			TweenLite.to(_con.playBar, 1, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to(_con.btnShare, 1, {alpha:1, ease:Cubic.easeOut});
			
			for (var i:int = 0; i < _txtArr.length; i++) 
			{
				_txtArr[i].alpha = 0;
				_txtArr[i].scaleX = _txtArr[i].scaleY = 1.05;
				TweenLite.to(_txtArr[i], 1, {delay:0.1*i, alpha:1, scaleX:1, scaleY:1, ease:Cubic.easeOut});
			}
		}
		
		private function outMotion():void
		{
			TweenLite.to(_con.cdCon, 1, {y:-420, ease:Cubic.easeOut});
			TweenLite.to(_con.playBar, 1, {alpha:0, ease:Cubic.easeOut});
			TweenLite.to(_con.btnShare, 1, {alpha:0, ease:Cubic.easeOut});
			
			for (var i:int = 0; i < _txtArr.length; i++) 
			{
				TweenLite.to(_txtArr[i], 1, {
					delay:0.1*i, alpha:0, scaleX:1.05, scaleY:1.05, 
					onCompleteParams:[i], onComplete:outMotionComplete, 
					ease:Cubic.easeOut});
			}
		}
		
		private function outMotionComplete(cnt:int):void
		{
			if(cnt == _txtArr.length - 1)
			{
				_con.alpha = 0;
				_con.visible = false;
				_model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:0}));
			}
		}
		
		private function makeBtn():void
		{
			ButtonUtil.makeButton(_con.btnShare, btnShareHandler);
			
			_txtArr = [];
			for (var i:int = 0; i < 4; i++) 
			{
				var txt:MovieClip = _con.getChildByName("txt" + i) as MovieClip;
				_txtArr.push(txt);
			}
			
			_cd = new cdClip();
			_con.cdCon.addChildAt(_cd, 1);
			TweenLite.to(_cd, 0, {dropShadowFilter:{color:0x000000, alpha:0.15, blurX:2, blurY:2, distance:2}});
		}
		
		private function btnShareHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT : 
				TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1}});
				break;
				case MouseEvent.CLICK :
					/**	트래킹	*/
					JavaScriptUtil.call("googleSender", "District", "btn_share");
					
					_sndControl.initSnd();
					_con.loader.loader.gotoAndPlay(1);
					TweenLite.to(_con.loader, 0.5, {autoAlpha:1});
					/**	20150525 개발 프로세스 제거 - 일정 시간 후 다음 스텝 연결 	*/
//					sendFeed();
					setTimeout(shareComplete, 1500);
					break;
			}
		}
		
		private function sendFeed():void
		{
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.token = _model.FBToken;
			
			var req:URLRequest = new URLRequest(_model.dataUrl + "process/FacebookShare.ashx");
			req.data = vari;
			req.method =URLRequestMethod.POST;
			
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(req);
			urlLdr.addEventListener(Event.COMPLETE, sendUserMusicComplete);
		}
		
		private function sendUserMusicComplete(e:Event):void
		{
			switch (int(e.target.data))
			{
				case 1:
					trace("Feed발송 완료"); 
					break;
				case -1: trace("Token이 존재하지 않음"); break;
				case -2: trace("참여데이터가 존재하지 않음"); break;
				case -9: trace("관리자에게 문의"); break;
			}
		}
		
		private function shareComplete():void{
			TweenLite.to(_con.loader, 0.5, {autoAlpha:0});
			_con.loader.loader.stop();
			JavaScriptUtil.alert("나만의 리믹스를 페이스북 뉴스 피드에 게시하였습니다.");
		}
	}
}