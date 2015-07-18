package com.bh.view
{
	
	import com.bh.events.BhEvent;
	import com.bh.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class CardSection
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _cardArr:Vector.<Sprite> = new Vector.<Sprite>;
		private var _cardSectionTxtArr:Array = [];
		private var _cardSectionLength:int;
		private var _finishCnt:int;
		
		private var _maskTxtYpos:int = 550;
		private var _cardWidth:int = 5;
		private var _rowLength:int = 33;
		private var _colLength:int = 384;
		private var _totalLength:int;
		
		private var _cardLength:int;
		private var _hideCardCnt:int;
		private var _txtBmd:BitmapData;
		
		private var _hideTimeout:uint;
		
		private var _isCardsection:Boolean = false;
		private var _sndArr:Vector.<Sound> = new Vector.<Sound>;
		
		private var _removeTimer:Timer;
		/**	카드 반전	*/
		private var _reflection:Boolean;

		
		public function CardSection(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			_con.cardCon.rotationX = -7;
			
			_removeTimer = new Timer(3000, 1);
			_removeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, reClearCard);
			
			for (var i:int = 0; i < 4; i++) 
			{
				var snd:Sound = new Sound();
				snd.load(new URLRequest(_model.commonPath + "snd/Crowd " + (i+1) + ".mp3"));
				_sndArr.push(snd);
			}
			
			var tm:TextFormat = new TextFormat();
			tm.letterSpacing = -20;
			_con.maskTxt.txt.defaultTextFormat = tm;
		}
		
		private function reClearCard(e:TimerEvent):void
		{
			_removeTimer.reset();
			removeCardsection();
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(BhEvent.FINISH_CARDSECTION, finishCaradsection);
			_model.addEventListener(BhEvent.CLOSED_FULL_VIDEO, closedFullVideo);
			_model.addEventListener(BhEvent.SHOW_MOVIE_COVER, closedFullVideo);
//			_model.addEventListener(BhEvent.FULL_CARDSECTION_START, fullCardsectionStart);
			_model.addEventListener(BhEvent.PAUSE_VIDEO, pauseVideo);
			_model.addEventListener(BhEvent.RESUME_CARDSECTION, resumeVideo);
		}
		
		protected function closedFullVideo(e:Event):void
		{
			removeCardsection();
			_removeTimer.start();
		}
		
		private function pauseVideo(e:BhEvent):void
		{
			_isCardsection = false;
			removeCardsection();
		}
		
		private function resumeVideo(e:BhEvent):void
		{
			_isCardsection = _model.loop;
			if(_isCardsection) changeCard(_finishCnt);
		}
		
		private function removeCardsection():void
		{
			clearTimeout(_hideTimeout);
			while (_con.cardCon.numChildren > 0)
			{
				var sp:Sprite = _con.cardCon.getChildAt(0) as Sprite;
				TweenLite.killTweensOf(sp);
				sp.graphics.clear();
				sp.filters = [];
				_con.cardCon.removeChild(sp);
			}
			
			if(_cardArr.length > 0)
			{
				var i:int;
				for (i = 0; i < _totalLength; i++) 
				{
					if(_cardArr[i] != null)
					{
						_cardArr[i] = null;
					}
					_cardArr[i] = null;
				}
				_cardArr.length = 0;
			}
			
			if(_txtBmd != null)
			{
				_txtBmd.dispose();
				_txtBmd = null;
			}
			
			_hideCardCnt = 0;
			_cardLength = 0;
			_finishCnt = 0;
		}
		
		private function finishCaradsection(e:BhEvent):void
		{
			_isCardsection = false;
			_removeTimer.start();
			clearTimeout(_hideTimeout);
			if(_cardArr.length > 0) hideCard();
		}
		
//		private function fullCardsectionStart(e:BhEvent):void
//		{
//			trace("카드섹션:::::  " + _model.cardSectionArr);
//			if(_model.fullCardsection)
//			{
//				_model.fullCardsection = false;
//				changeTxtMask(_model.cardSectionArr);
//			}
//		}
		
		public function changeTxtMask(msg:Array):void
		{
			trace("카드 문구___>  " + msg);
			_isCardsection = true;
			_cardSectionTxtArr = msg;
			_cardSectionLength = _cardSectionTxtArr.length;
			changeCard(0);
		}
		
		private function changeCard(txtNum:int):void
		{
			if(_cardArr.length > 0) removeCards();
			trace("카드 변경___>>  " + txtNum, _cardSectionLength);
			
			_reflection = Boolean(Math.round(Math.random()));
			var tm:TextFormat = new TextFormat();
			if(_reflection)
			{
				tm.size = 150;
				tm.letterSpacing = -15;
				_con.maskTxt.txt.y = 555;
			}
			else
			{
				tm.size = 160;
				tm.letterSpacing = -20;
				_con.maskTxt.txt.y = 550;
			}
			(_con.maskTxt.txt as TextField).embedFonts = true;
			(_con.maskTxt.txt as TextField).defaultTextFormat = tm; 
			_con.maskTxt.txt.text = String(_cardSectionTxtArr[txtNum]).toUpperCase();
			_con.maskTxt.txt.autoSize = TextFieldAutoSize.CENTER;
//			_con.maskTxt.txt.width = _con.maskTxt.txt.width + 20;
			_txtBmd = new BitmapData(1920, 1080, true, 0);
			_txtBmd.draw(_con.maskTxt);
			
			var i:int;
			var xPos:int;
			var yPos:int;
			var zPos:int;
			var shadowFilter:DropShadowFilter = new DropShadowFilter(1, 90, 0x000000, 0.5, 2.5, 2.5, 0.5, 0.25);
//			var reflection:Boolean = Boolean(Math.round(Math.random()));
			_colLength = Math.ceil((_con.maskTxt.txt.width+15)/(_cardWidth));
			
//			var color:int = Math.floor(Math.random()*3);
			var sampleBmd:BitmapData = new BitmapData(1920, 1080, true, 0);
			sampleBmd.draw(_con.pattern0);
//			switch(color)
//			{
//				case 0: sampleBmd.draw(_con.pattern0); break;
//				case 1: sampleBmd.draw(_con.pattern1); break;
//				case 2: sampleBmd.draw(_con.pattern2); break;
//			}
//			trace("패턴 번호___> " + color);
			
			_totalLength = _rowLength * _colLength;
			var sp:Sprite;
			
			for (i = 0; i < _totalLength; i++) 
			{
				xPos = (i%_colLength)*(_cardWidth) + _con.maskTxt.txt.x;
				yPos = int(i/_colLength)*(_cardWidth) + _maskTxtYpos;
				zPos = 15 - int(i/_colLength)*3;
				var value:uint = _txtBmd.getPixel(xPos, yPos); 
				
				if(_reflection)
				{
					if(_txtBmd.getPixel(xPos, yPos) > 0) {
						_cardArr.push(null);
					}
					else
					{
						if(_con.maskTxt.txt.x > xPos || _con.maskTxt.txt.x + _con.maskTxt.txt.width+15 < xPos){
							_cardArr.push(null);
						}else{
							if(yPos >= 597 && 602 >= yPos){
								_cardArr.push(null);
							}else if(yPos >= 655 && 658 >= yPos){
								_cardArr.push(null);
							}else{
								sp = makeCard(sampleBmd, xPos, yPos, zPos, shadowFilter);
								_cardArr.push(sp);
								_cardLength++;
							}
						}
					}
				}
				else
				{
					if(_txtBmd.getPixel(xPos, yPos) > 0)
					{
						if(yPos >= 597 && 602 >= yPos){
							_cardArr.push(null);
						}else if(yPos >= 655 && 658 >= yPos){
							_cardArr.push(null);
						}else{
							sp = makeCard(sampleBmd, xPos, yPos, zPos, shadowFilter);
							_cardArr.push(sp);
							_cardLength++;
						}
					}
					else 
					{
						_cardArr.push(null);
					}
				}
			}
			playCard();
		}
		
		private var _spCnt:int;
		private function makeCard(sampleBmd:BitmapData, xPos:int, yPos:int, zPos:int, shadowFilter:DropShadowFilter):Sprite
		{
			var sp:Sprite = new Sprite();
			var cardBmd:BitmapData = new BitmapData(_cardWidth, _cardWidth, false, 0);
			cardBmd.copyPixels(sampleBmd, new Rectangle(xPos, yPos, _cardWidth, _cardWidth), new Point(0, 0));
			sp.graphics.beginBitmapFill(cardBmd);
			sp.graphics.drawRect(0, 0, _cardWidth, _cardWidth);
			sp.graphics.endFill();
			sp.x =xPos;
			sp.y =yPos;
			sp.z = zPos;
//			sp.filters = [shadowFilter];
			_con.cardCon.addChild(sp);
			
			_spCnt++;
			var delayNum:int = _spCnt%3;
			if(delayNum == 0)
			{
//				sp.scaleY = Math.random()*0.2 + 0.2;
				sp.alpha = Math.random()*0.6+0.2;
			}
			else
			{
//				sp.scaleY = 0;
				sp.alpha = 0;
			}
			
//			var num:int = Math.floor(Math.random()*2);
//			if(num == 0) sp.rotationY = Math.random()*45;
//			else sp.rotationZ = Math.random()*45;
			return sp;
		}
		
		/**	등장후 반복 모션	*/
		private function intervalMotion(sp:Sprite):void
		{
			var num:Number;
			if(sp.x <= 960) num = sp.x/960;
			else num = 2-(sp.x/960);
			TweenLite.to(sp, 0.75, {
				delay:Math.random(), 
				z:sp.z+(6*num), 
				rotationX:-45*Math.random(), 
				onComplete:repeatMotion, onCompleteParams:[sp, num], ease:Cubic.easeOut});
		}
		private function repeatMotion(sp:Sprite, num:Number):void
		{
			TweenLite.to(sp, 0.75, {
				z:sp.z-(6*num), 
				rotationX:45*Math.random(), 
				onCompleteParams:[sp], onComplete:intervalMotion, ease:Cubic.easeOut});	
		}
		
		private function playCard():void
		{
			if(_model.mute == false)
			{
				var randomNum:int = Math.floor(Math.random()*3);
				_sndArr[randomNum].play();
			}
			
			var reflection:Boolean = Boolean(Math.round(Math.random()));
			var i:int;
			var delayNum:int;
			for (i = 0; i < _totalLength; i++) 
			{
				if(_cardArr[i] != null)
				{
					delayNum = i%3;
					if(delayNum == 0) TweenLite.to(_cardArr[i], 0.5, {delay:Math.random()*0.2, alpha:1, onComplete:intervalMotion, onCompleteParams:[_cardArr[i]]});
					else TweenLite.to(_cardArr[i], 0.5, {delay:0.3, alpha:1, onComplete:intervalMotion, onCompleteParams:[_cardArr[i]]});
				}
			}
			_hideTimeout = setTimeout(hideCard, 2500);
		}
		
		protected function hideCard():void
		{
			var i:int;
			var delayNum:int;
			for (i = 0; i < _totalLength; i++) 
			{
				delayNum = i%3;
				if(_cardArr[i] != null)
				{
					TweenLite.killTweensOf(_cardArr[i]);
//					TweenLite.to(_cardArr[i], 0.35, {rotationX:90, alpha:0, onComplete:hideCompleteCheck});
					if(i == 0) TweenLite.to(_cardArr[i], 0.3, {delay:Math.random()*0.2, alpha:Math.random()*0.6+0.2, onComplete:hideCompleteCheck});
					else TweenLite.to(_cardArr[i], 0.3, {delay:Math.random()*0.2, alpha:0, onComplete:hideCompleteCheck});
					
				}
			}
		}
		
		private function hideCompleteCheck():void
		{
			_hideCardCnt++;
			if(_hideCardCnt >= _cardLength)
			{
				_hideCardCnt = 0;
				_cardLength = 0;
				removeCards();
			}
		}
		
		private function removeCards():void
		{
			/**	카드제거	*/
			trace("카드 제거___!!");
			_spCnt = 0;
			while (_con.cardCon.numChildren > 0)
			{
				var sp:Sprite = _con.cardCon.getChildAt(0) as Sprite;
				TweenLite.killTweensOf(sp);
				sp.graphics.clear();
				sp.filters = [];
				_con.cardCon.removeChild(sp);
			}
			
			var i:int;
			for (i = 0; i < _totalLength; i++) 
			{
				if(_cardArr[i] != null)
				{
					_cardArr[i] = null;
				}
				_cardArr[i] = null;
			}
			_cardArr.length = 0;
			
			if(_txtBmd != null)
			{
				_txtBmd.dispose();
				_txtBmd = null;
			}
			
			/**	카드섹션 가능 체크	*/
			if(_isCardsection == false)
			{
				_finishCnt = 0;
				return;
			}
			
			/**	보여준 카드섹션수 체크	*/
			_finishCnt++;
			if(_finishCnt >= _cardSectionLength)
			{
				trace("카드섹션 종료___! 다음 유저 플레이___>>>>");
				_finishCnt = 0;
				_model.nowPlay = false;
				if(_model.fullVideo == false)
				{
					_model.dispatchEvent(new BhEvent(BhEvent.CARDSECTION_CHANGE));
//					setTimeout(cardSectionUserChange, 500);
				}
				else
				{
					_model.dispatchEvent(new BhEvent(BhEvent.FULL_CARDSECTION_FINISHED));
				}
			}
			else
			{
				changeCard(_finishCnt);
			}
		}
		
//		private function cardSectionUserChange():void
//		{
//			_model.dispatchEvent(new BhEvent(BhEvent.CARDSECTION_CHANGE));
//		}
		
		private function resizeHandler(e:Event = null):void
		{
			
		}
	}
}

