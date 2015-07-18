package com.bh.view
{
	import com.adqua.util.RandomText;
	import com.bh.events.BhEvent;
	import com.bh.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class Scene
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		private var _cardSection:CardSection;
		
		private var _userNum:int;
		
		public function Scene(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			_cardSection = new CardSection(_con);
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(BhEvent.FULL_CARDSECTION_START, fullCardsectionStart);
			_model.addEventListener(BhEvent.FULL_CARDSECTION_FINISHED, fullCardsectionFinished);
			_model.addEventListener(BhEvent.CARDSECTION_CHANGE, cardsectionChange);
			
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		private function fullCardsectionStart(e:BhEvent):void
		{
			TweenLite.to(_con.filter, 1, {autoAlpha:0.65});
			TweenLite.to(_con.userCon, 1, {alpha:1});
			
			var imgLdr:Loader = new Loader();
			imgLdr.alpha = 0;
			_con.userCon.imgCon.img.addChild(imgLdr);
			imgLdr.load(new URLRequest(_model.commonPath + _model.imgUrl));
			imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, userImgLoadComplete);
		}
		
		private function fullCardsectionFinished(e:BhEvent):void
		{
			TweenLite.to(_con.filter, 1, {autoAlpha:0});
			TweenLite.to(_con.userCon, 1, {alpha:0});
		}
		
		private function cardsectionChange(e:BhEvent):void
		{
			if(_model.nowPlay) return;
			_model.nowPlay = true;
			_userNum++;
			trace("유저 번호___>  " + _userNum);
			if(_userNum > _model.userLength) _userNum = 1;
			var imgLdr:Loader = new Loader();
			imgLdr.alpha = 0;
			_con.userCon.imgCon.img.addChild(imgLdr);
			imgLdr.load(new URLRequest(_model.commonPath + _model.userXml.user[_userNum-1].@imgUrl));
			imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, userImgLoadComplete);
		}
		/**	유저 이미지 로드 완료	*/
		protected function userImgLoadComplete(e:Event):void
		{
			var ldr:Loader = _con.userCon.imgCon.img.getChildAt(_con.userCon.imgCon.img.numChildren-1) as Loader;
//			var bmp:Bitmap = ldr.content as Bitmap;
//			bmp.smoothing = true;
			
			ldr.width = ldr.height = 53;
			ldr.scaleX = ldr.scaleY = Math.max(ldr.scaleX, ldr.scaleY);
			ldr.x = int(53/2 - ldr.width/2);
			ldr.y = int(52/2 - ldr.height/2);
			
			TweenLite.to(ldr, 0.75, {alpha:1, onComplete:removeImg, ease:Cubic.easeOut});
			
			var randomTxt:RandomText;
			var randomTxt2:RandomText;
			if(_model.fullVideo)
			{
				randomTxt = new RandomText(_con.userCon.toName, String(_model.toName), 35);
				randomTxt2 = new RandomText(_con.userCon.fromName, String(_model.fromName), 35);
			}
			else
			{
				randomTxt = new RandomText(_con.userCon.toName, String(_model.userXml.user[_userNum-1].@toName), 35);
				randomTxt2 = new RandomText(_con.userCon.fromName, String(_model.userXml.user[_userNum-1].@fromName), 35);
			}
			randomTxt.start();
			randomTxt2.start();
		}
		/**	이미지 제거	*/
		private function removeImg():void
		{
			if(_con.userCon.imgCon.img.numChildren >= 2)
			{
				while(1 < _con.userCon.imgCon.img.numChildren)
				{
					var ldr:Loader = _con.userCon.imgCon.img.getChildAt(0) as Loader;
//					var bmp:Bitmap = ldr.content as Bitmap;
//					if(ldr.content != null) bmp.bitmapData.dispose();
					_con.userCon.imgCon.img.removeChild(ldr);
					ldr.unloadAndStop();
					trace("이미지 컨테이너 자식 수" + _con.userCon.imgCon.img.numChildren);
				}
			}
			/**	카드섹션 시작	*/
			if(_model.fullVideo)
			{
				_cardSection.changeTxtMask(_model.cardSectionArr);
			}
			else
			{
				var txtArr:Array = [];
				for (var i:int = 0; i < _model.userXml.user[_userNum-1].msg.length(); i++) 
				{
					txtArr.push(_model.userXml.user[_userNum-1].msg[i]);
				}
				_cardSection.changeTxtMask(txtArr);
			}
		}
		
		private function resizeHandler(e:Event = null):void
		{
			
			trace(_con.stage.stageWidth, _con.stage.stageHeight);
		}
		
	}
}