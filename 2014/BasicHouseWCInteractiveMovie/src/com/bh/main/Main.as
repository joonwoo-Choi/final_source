package com.bh.main
{
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.CurrencyFormat;
	import com.adqua.util.JavaScriptUtil;
	import com.adqua.util.RandomText;
	import com.bh.events.BhEvent;
	import com.bh.model.Model;
	import com.bh.view.InputTxtCon;
	import com.bh.view.Scene;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class Main
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		private var _inputTxtCon:InputTxtCon;
		private var _scene:Scene;
		private var _timeout:uint;
		
		private var _motionTimeout:uint;
		private var _cheersPopup:Boolean = false;
		private var _firstChk:Boolean = true;
		
		public function Main(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([FramePlugin, AutoAlphaPlugin]);
			
			_inputTxtCon = new InputTxtCon(_con.inputTxtCon);
			_scene = new Scene(_con.scene);
			_con.btnClose.visible = false;
			
			_con.inputTxtCon.alpha = 0;
			_con.inputTxtCon.visible = false;
			_con.cheersCon.alpha = 0;
			_con.cheersCon.visible = false;
			_con.scene.filter.visible = false;
			_con.scene.filter.mouseEnabled = false;
			_con.scene.filter.mouseChildren = false;
			
			_con.btnBrand.alpha = 0;
			_con.btnBrand.visible = false;
			_con.btnMall.alpha = 0;
			_con.btnMall.visible = false;
		}
		
		private function contentsInmotion(e:BhEvent):void
		{
//			_con.btnClose.visible = false;
			clearTimeout(_motionTimeout);
			_motionTimeout = setTimeout(motionChk, 1500);
		}
		
		private function motionChk():void
		{
			if(_model.hideUI) return;
//			_model.dispatchEvent(new BhEvent(BhEvent.FINISH_CARDSECTION));
			inMotion();
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(BhEvent.CHEERS_COUNT_CHECK, cheersCountCheck);
			_model.addEventListener(BhEvent.CHANGE_VIDEO, changeVideo);
			_model.addEventListener(BhEvent.FINISH_CARDSECTION, finishCardsection);
			_model.addEventListener(BhEvent.CONTENTS_INMOTION, contentsInmotion);
			
			_model.addEventListener(BhEvent.SHOW_MOVIE_COVER, showMovieCover);
			_model.addEventListener(BhEvent.HIDE_MOVIE_COVER, hideMovieCover);
			_model.addEventListener(BhEvent.HIDE_VIDEO_BUTTON, hideViedoBtn);
			
			_con.btnMall.buttonMode = true;
			_con.btnMall.addEventListener(MouseEvent.CLICK, btnMallHandler);
			_con.btnBrand.buttonMode = true;
			_con.btnBrand.addEventListener(MouseEvent.CLICK, btnBrandHandler);
			
			_con.cheersCon.buttonMode = true;
			_con.cheersCon.addEventListener(MouseEvent.CLICK, showGalleryPopup);
			
			_con.btnClose.buttonMode = true;
			_con.btnClose.addEventListener(MouseEvent.CLICK, videoClose);
			
			_con.btnSnd.buttonMode = true;
			_con.btnSnd.addEventListener(MouseEvent.CLICK, soundToggleHandler);
			_con.btnVideoSnd.buttonMode = true;
			_con.btnVideoSnd.addEventListener(MouseEvent.CLICK, soundToggleHandler);
			
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
			
			_model.dispatchEvent(new BhEvent(BhEvent.LIKE_PEOPLE_CHANGE));
		}
		
		private function showMovieCover(e:BhEvent):void
		{
			trace("SHOW 무비커버");
			TweenLite.to(_con.title, 1, {autoAlpha:0});
			TweenLite.to(_con.btnMall, 1, {autoAlpha:0});
			TweenLite.to(_con.btnBrand, 1, {autoAlpha:0});
			TweenLite.to(_con.cheersCon, 1, {autoAlpha:0});
			TweenLite.to(_con.inputTxtCon, 1, {autoAlpha:0});
			TweenLite.to(_con.btnSnd, 1, {autoAlpha:0});
			TweenLite.to(_con.scene.movieCover, 0.75, {alpha:1});
		}
		
		private function hideMovieCover(e:BhEvent):void
		{
			trace("HIDE 무비커버");
			TweenLite.to(_con.scene.movieCover, 0.75, {alpha:0});
		}
		
		private function hideViedoBtn(e:BhEvent):void
		{
			_con.btnClose.alpha = 0;
			_con.btnClose.visible = false;
			_con.btnVideoSnd.alpha = 0;
			_con.btnVideoSnd.visible = false;
		}
		
		private function videoClose(e:MouseEvent):void
		{
			_model.sceneNum = 0;
			_model.hideUI = false;
			_model.fullVideo = false;
			_model.isIntro = false;
			_con.btnClose.alpha = 0;
			_con.btnVideoSnd.alpha = 0;
			_con.btnClose.visible = false;
			_con.btnVideoSnd.visible = false;
			_model.dispatchEvent(new BhEvent(BhEvent.PLAY_VIDEO));
			_model.dispatchEvent(new BhEvent(BhEvent.CLOSED_FULL_VIDEO));
			TweenLite.to(_con.scene.userCon, 0.75, {alpha:0, onComplete:userImgHide});
			JavaScriptUtil.call("likeBoxCheck");
			clearTimeout(_motionTimeout);
			_motionTimeout = setTimeout(motionChk, 4500);
		}
		
		private function changeVideo(e:BhEvent):void
		{
			if(_firstChk)
			{
				_firstChk = false;
				clearTimeout(_motionTimeout);
				_motionTimeout = setTimeout(motionChk, 2500);
			}
			else
			{
				if(_model.loop == true) inMotion();
			}
		}
		
		private function soundToggleHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			if(target.currentFrame == 1)
			{
				_con.btnSnd.gotoAndStop(2);
				_con.btnVideoSnd.gotoAndStop(2);
				_model.mute = true;
			}
			else if(target.currentFrame == 2)
			{
				_con.btnSnd.gotoAndStop(1);
				_con.btnVideoSnd.gotoAndStop(1);
				_model.mute = false;
			}
			_model.dispatchEvent(new BhEvent(BhEvent.VOLUME_CHANGE));
		}
		
		/**	등장 모션	*/
		private function inMotion():void
		{
			_con.scene.userCon.toName.text = "";
			_con.scene.userCon.fromName.text = "";
//			TweenLite.to(_con.scene.defaultTxt, 1, {alpha:1, onComplete:hideDefaultTxt});
			TweenLite.killTweensOf(_con.scene.userCon);
			TweenLite.killTweensOf(_con.scene.filter);
			TweenLite.to(_con.scene.userCon, 1, {delay:1.5, alpha:1, ease:Cubic.easeOut});
			TweenLite.to(_con.scene.filter, 1, {delay:1.5, autoAlpha:0.4, onComplete:cardSectionStart});
			TweenLite.to(_con.title, 1, {autoAlpha:1});
			TweenLite.to(_con.btnMall, 1, {autoAlpha:1});
			TweenLite.to(_con.btnBrand, 1, {autoAlpha:1});
			TweenLite.to(_con.cheersCon, 1, {autoAlpha:1, onComplete:cheersCntChange});
			TweenLite.to(_con.inputTxtCon, 1, {autoAlpha:1});
			TweenLite.to(_con.btnSnd, 1, {autoAlpha:1});
			if(_con.btnClose.visible == true)
			{
				TweenLite.to(_con.btnVideoSnd, 1, {autoAlpha:0});
				TweenLite.to(_con.btnClose, 1, {autoAlpha:0});
			}
		}
//		private function hideDefaultTxt():void
//		{	TweenLite.to(_con.scene.defaultTxt, 1, {alpha:0, onComplete:showUserInfo});		}
//		private function showUserInfo():void
//		{	TweenLite.to(_con.scene.userCon, 1, {alpha:1, ease:Cubic.easeOut, onComplete:cardSectionStart});	}
		
		/**	나가는 모션	*/
		private function outMotion():void
		{
			trace("풀 영상인가??  " + _model.fullVideo);
			clearTimeout(_motionTimeout);
			TweenLite.killTweensOf(_con.scene.userCon);
			TweenLite.killTweensOf(_con.scene.filter);
			if(_model.fullVideo)
			{
				TweenLite.to(_con.btnVideoSnd, 1, {autoAlpha:1});
				TweenLite.to(_con.btnClose, 1, {autoAlpha:1});
			}
			if(!_model.loop)
			{
				TweenLite.to(_con.title, 1, {autoAlpha:0});
				TweenLite.to(_con.btnMall, 1, {autoAlpha:0});
				TweenLite.to(_con.btnBrand, 1, {autoAlpha:0});
				TweenLite.to(_con.cheersCon, 1, {autoAlpha:0});
				TweenLite.to(_con.inputTxtCon, 1, {autoAlpha:0});
				TweenLite.to(_con.btnSnd, 1, {autoAlpha:0});
			}
			TweenLite.to(_con.scene.filter, 1, {autoAlpha:0});
			TweenLite.to(_con.scene.userCon, 1, {alpha:0, onComplete:userImgHide});
		}
		/**	전광판 유저 이미지 제거	*/
		private function userImgHide():void
		{
			while(0 < _con.scene.userCon.imgCon.img.numChildren)
			{
				var ldr:Loader = _con.scene.userCon.imgCon.img.getChildAt(0) as Loader;
//				var bmp:Bitmap = ldr.content as Bitmap;
//				if(ldr.content != null) bmp.bitmapData.dispose();
				_con.scene.userCon.imgCon.img.removeChild(ldr);
				ldr.unloadAndStop();
				trace("이미지 컨테이너 자식 수" + _con.scene.userCon.imgCon.img.numChildren);
			}
		}
		/**	카드섹션 시작	*/
		private function cardSectionStart():void
		{
			_model.dispatchEvent(new BhEvent(BhEvent.CARDSECTION_CHANGE));
			if(_con.inputTxtCon.btnTxt.visible == false)
			{
				for (var i:int = 0; i < 4; i++) 
				{
					var slash:MovieClip = _con.inputTxtCon.getChildByName("slash_" + i) as MovieClip;
					slash.x = slash.x - 4;
					TweenLite.to(slash, 0.75, {delay:0.25*i, alpha:1, x:slash.x+4, ease:Cubic.easeOut});
					_con.stage.focus = _con.inputTxtCon.txtMsg_0;
				}
			}
			_model.loop = true;
		}
		
		private function finishCardsection(e:BhEvent):void
		{
//			clearTimeout(_timeout);
//			_timeout = setTimeout(outMotion, 1000);
			outMotion();
			
			if(_model.fullVideo) _con.btnClose.visible = true;
		}
		
		private function showGalleryPopup(e:MouseEvent):void
		{
			_model.galleryOpen = true;
			_model.dispatchEvent(new BhEvent(BhEvent.PAUSE_VIDEO));
			_model.dispatchEvent(new BhEvent(BhEvent.SHOW_MOVIE_COVER));
			JavaScriptUtil.call("showPopup", 2);
			outMotion();
		}
		
		private function cheersCntChange():void
		{
			var curr:CurrencyFormat = new CurrencyFormat();
			var cnt:String = curr.makeCurrency(_model.userXml.@cheersCnt, 3);
			trace("이벤트 참여자수::::: " + cnt);
			var randomTxt:RandomText = new RandomText(_con.cheersCon.mcCnt.cheersCnt, cnt, 75);
			randomTxt.start();
		}
		
		private function cheersCountCheck(e:BhEvent):void
		{
			var cnt:String = e.value.cheersCnt;
			_con.txtCheersCnt.text = cnt;
		}
		
		private function btnMallHandler(e:MouseEvent):void
		{	navigateToURL(new URLRequest("http://www.basichouse.co.kr"),"_blank" );	}
		
		private function btnBrandHandler(e:MouseEvent):void
		{	navigateToURL(new URLRequest("http://www.thebasichouse.co.kr"),"_blank" );	}
		
		private function resizeHandler(e:Event = null):void
		{
			_con.btnClose.x = int(_con.stage.stageWidth - _con.btnClose.width);
			_con.btnClose.y = 0;
			
			_con.btnVideoSnd.x = int(_con.stage.stageWidth - _con.btnVideoSnd.width);
			_con.btnVideoSnd.y = 51;
			
			_con.btnSnd.x = int(_con.stage.stageWidth - _con.btnSnd.width - 60);
			_con.btnSnd.y = 165;
			
			_con.title.x = int(_con.stage.stageWidth/2 - _con.title.width/2);
			_con.title.y = int((_con.stage.stageHeight*0.32)/2 - _con.title.height/2);
			
			_con.cheersCon.x = _con.stage.stageWidth - _con.cheersCon.width - 20;
			_con.cheersCon.y = 50;
			
			_con.btnMall.x = 50;
			_con.btnMall.y = int(_con.stage.stageHeight - _con.btnMall.height - 43);
			_con.btnBrand.x = 50;
			_con.btnBrand.y = int(_con.btnMall.y - _con.btnBrand.height - 15);
		}
	}
}