package com.bh.view
{
	
	import com.bh.events.BhEvent;
	import com.bh.model.Model;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
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
		
		private var _maskTxtYpos:int = 560;
		private var _cardWidth:int = 5;
		private var _rowLength:int = 26;
		private var _colLength:int = 384;
		private var _totalLength:int;
		
		private var _cardLength:int;
		private var _hideCardCnt:int;
		private var _txtBmd:BitmapData;
		
		private var _hideTimeout:uint;
		
		private var _isCardsection:Boolean = false;
		private var _sndArr:Vector.<Sound> = new Vector.<Sound>;
		
		private var _tfNum:int;
		private var _tweenCard:uint;
		
		
		public function CardSection(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			_con.cardCon.rotationX = -9;
			_con.pattern0.img.mask = _con.maskTxt.txt;
			_con.pattern0.alpha = 0;
			_con.pattern1.img.mask = _con.maskTxt2.txt;
			_con.pattern1.alpha = 0;
//			_con.pattern0.rotationX = -9;
//			_con.pattern1.rotationX = -9;
			
			for (var i:int = 0; i < 4; i++) 
			{
				var snd:Sound = new Sound();
				snd.load(new URLRequest(_model.commonPath + "snd/Crowd " + (i+1) + ".mp3"));
				_sndArr.push(snd);
			}
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(BhEvent.FINISH_CARDSECTION, finishCaradsection);
			_model.addEventListener(BhEvent.FULL_CARDSECTION_START, fullCardsectionStart);
			_model.addEventListener(BhEvent.PAUSE_VIDEO, pauseVideo);
			_model.addEventListener(BhEvent.RESUME_CARDSECTION, resumeVideo);
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
//			_isCardsection = false;
			clearTimeout(_hideTimeout);
			if(_cardArr.length > 0) removeCardsection();
		}
		
		private function fullCardsectionStart(e:BhEvent):void
		{
			trace("카드섹션:::::  " + _model.cardSectionArr);
			if(_model.fullCardsection)
			{
				_model.fullCardsection = false;
				setTimeout(changeTxtMask, 1000, _model.cardSectionArr);
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
			
			_tfNum++;
			var cnt:int = _tfNum%2;
			if(cnt%2 == 0)
			{
				_con.maskTxt.txt.text = String(_cardSectionTxtArr[txtNum]).toUpperCase();
				_con.maskTxt.txt.autoSize = TextFieldAutoSize.CENTER;
			}
			else
			{
				_con.maskTxt2.txt.text = String(_cardSectionTxtArr[txtNum]).toUpperCase();
				_con.maskTxt2.txt.autoSize = TextFieldAutoSize.CENTER;
			}
//			_txtBmd = new BitmapData(1920, 1080, true, 0);
//			_txtBmd.draw(_con.maskTxt);
			
			playCard();
		}
		
		private function playCard():void
		{
			var cnt:int = _tfNum%2;
			if(cnt == 0)
			{
				TweenLite.to(_con.pattern0, 0.5, {alpha:1});
				TweenLite.to(_con.pattern1, 0.5, {alpha:0});
				trace("aaaaaaaaaaa  " + _con.pattern0.alpha, _con.pattern1.alpha);
			}
			else
			{
				TweenLite.to(_con.pattern0, 0.5, {alpha:1});
				TweenLite.to(_con.pattern1, 0.5, {alpha:0});
				trace("bbbbbbbbbbbbb  " + _con.pattern0.alpha, _con.pattern1.alpha);
			}
			
			_tweenCard = setTimeout(completeChk, 2000);
		}
		
		private function completeChk():void
		{
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
		
		protected function hideCard():void
		{
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
			
			_txtBmd.dispose();
			_txtBmd = null;
			
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
		
		private function resizeHandler(e:Event = null):void
		{
			
		}
	}
}

