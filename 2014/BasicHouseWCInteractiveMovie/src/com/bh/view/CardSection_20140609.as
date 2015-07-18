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
	import flash.filters.DropShadowFilter;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class CardSection_20140609
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _cardArr:Vector.<Vector.<Sprite>> = new Vector.<Vector.<Sprite>>;
		private var _cardSectionTxtArr:Array = [];
		private var _cardSectionLength:int;
		private var _finishCnt:int;
		
		private var _maskTxtYpos:int = 515;
		private var _cardWidth:int = 4;
		private var _rowLength:int = 33;
		private var _colLength:int = 384;
		
		private var _cardLength:int;
		private var _hideCardCnt:int;
		private var _txtBmd:BitmapData;
		
		private var _showNum:int;
		private var _isCardsection:Boolean = false;
		
		private var _hideTimeout:uint;
		private var _isPause:Boolean = false;
		
		
		public function CardSection(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
//			_con.maskTxt.txt.scaleX = _con.maskTxt.txt.scaleY = 1.1;
			_con.cardCon.rotationX = -15;
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(BhEvent.CARD_RESIZE, cardResize);
			_model.addEventListener(BhEvent.CHANGE_VIDEO, changeVideo);
			_model.addEventListener(BhEvent.FINISH_CARDSECTION, finishCaradsection);
			_model.addEventListener(BhEvent.FULL_CARDSECTION_START, fullCardsectionStart);
			_model.addEventListener(BhEvent.PAUSE_VIDEO, pauseVideo);
			_model.addEventListener(BhEvent.RESUME_VIDEO, resumeVideo);
			
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		private function pauseVideo(e:BhEvent):void
		{
			_isPause = true;
			clearTimeout(_hideTimeout);
			if(_cardArr.length > 0) hideCard();
		}
		
		private function resumeVideo(e:BhEvent):void
		{
			_isPause = false;
			if(_isCardsection) changeCard(_finishCnt);
		}
		
		private function cardResize(e:BhEvent):void
		{
			resizeHandler();
		}
		
		private function finishCaradsection(e:BhEvent):void
		{
			_isCardsection = false;
			_finishCnt = 0;
			_showNum = 0;
			clearTimeout(_hideTimeout);
			if(_cardArr.length > 0) hideCard();
		}
		
		private function changeVideo(e:BhEvent):void
		{
			if(_model.sceneNum == 1) _showNum = 0;
			else _isCardsection = false;
		}
		
		private function fullCardsectionStart(e:BhEvent):void
		{
			trace("카드섹션:::::  " + _model.cardSectionArr);
			changeTxtMask(_model.cardSectionArr);
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
			
			_con.maskTxt.txt.text = _cardSectionTxtArr[txtNum];
			_con.maskTxt.txt.autoSize = TextFieldAutoSize.CENTER;
			_txtBmd = new BitmapData(1920, 1080, true, 0);
			_txtBmd.draw(_con.maskTxt);
			
			var i:int;
			var xPos:int;
			var yPos:int;
			var zPos:int;
			var shadowFilter:DropShadowFilter = new DropShadowFilter(1, 90, 0x000000, 0.75, 1.5, 1.5, 0.5, 0.5);
			var reflection:Boolean = Math.round(Math.random());
			_colLength = Math.ceil(_con.maskTxt.txt.width/5);
			
			var color:int = Math.round(Math.random()*3);
			var sampleBmd:BitmapData = new BitmapData(1920, 1080, true, 0);
			
			switch(color)
			{
				case 0: sampleBmd.draw(_con.sampleColor0); break;
				case 1: sampleBmd.draw(_con.sampleColor1); break;
				case 2: sampleBmd.draw(_con.sampleColor2); break;
				case 3: sampleBmd.draw(_con.sampleColor3); break;
				case 4: sampleBmd.draw(_con.sampleColor4); break;
			}
			
			for (i = 0; i < _rowLength; i++) 
			{
				var rowArr:Vector.<Sprite> = new Vector.<Sprite>;
				var j:int;
				var sp:Sprite;
				for (j = 0; j < _colLength; j++) 
				{
					xPos = j * (_cardWidth+1) + _con.maskTxt.txt.x + 2;
					yPos = i * (_cardWidth+1) + _maskTxtYpos + 2;
					zPos = 15 - i*3;
					var value:uint = _txtBmd.getPixel(xPos, yPos); 
					if(reflection)
					{
						if(_txtBmd.getPixel(xPos, yPos) > 0) {
							rowArr.push(null);
						}
						else
						{
							if(_con.maskTxt.txt.x > xPos || _con.maskTxt.txt.x + _con.maskTxt.txt.width < xPos){
								rowArr.push(null);
							}else{
								sp = makeCard(sampleBmd, xPos, yPos, zPos, shadowFilter);
								rowArr.push(sp);
								_cardLength++;
							}
						}
					}
					else
					{
						if(_txtBmd.getPixel(xPos, yPos) > 0)
						{
							sp = makeCard(sampleBmd, xPos, yPos, zPos, shadowFilter);
							rowArr.push(sp);
							_cardLength++;
						}
						else 
						{
							rowArr.push(null);
						}
					}
				}
				_cardArr.push(rowArr);
			}
			playCard();
		}
		
		private function makeCard(sampleBmd:BitmapData, xPos:int, yPos:int, zPos:int, shadowFilter:DropShadowFilter):Sprite
		{
			var sp:Sprite = new Sprite();
			var cadrBmd:BitmapData = new BitmapData(_cardWidth, _cardWidth, false, 0);
			cadrBmd.copyPixels(sampleBmd, new Rectangle(xPos-2, yPos-2, _cardWidth, _cardWidth), new Point(0, 0));
			sp.graphics.beginBitmapFill(cadrBmd);
			sp.graphics.drawRect(0, 0, 4, 4);
			sp.graphics.endFill();
			sp.x =xPos;
			sp.y =yPos;
			sp.z = zPos;
			sp.filters = [shadowFilter];
			_con.cardCon.addChild(sp);
			sp.alpha = 0;
			
			return sp;
		}
		
		/**	등장후 반복 모션	*/
		private function intervalMotion(sp:Sprite):void
		{	TweenLite.to(sp, 0.75, {delay:Math.random(), z:sp.z+6, onComplete:repeatMotion, onCompleteParams:[sp], ease:Cubic.easeOut});	}
		private function repeatMotion(sp:Sprite):void
		{	TweenLite.to(sp, 0.75, {z:sp.z-6, onComplete:intervalMotion, onCompleteParams:[sp], ease:Cubic.easeOut});	}
		
		private function playCard():void
		{
			var reflection:Boolean = Math.round(Math.random());
			var i:int;
			var j:int;
			if(reflection)
			{
				for (i = 0; i < _rowLength; i++) 
				{
					for (j = 0; j < _colLength; j++) 
					{
						if(_cardArr[i][j] != null)
						{
							_cardArr[i][j].rotationY = 90;
							TweenLite.to(_cardArr[i][j], 0.4, {delay:i*0.007 + j*0.007, 
							rotationY:0, alpha:1, onComplete:intervalMotion, onCompleteParams:[_cardArr[i][j]]});
						}
					}
				}
			}
			else
			{
				for (i = _rowLength-1; i >= 0; i--) 
				{
					for (j = _colLength-1; j >= 0; j--) 
					{
						if(_cardArr[i][j] != null)
						{
							_cardArr[i][j].rotationY = -90;
							TweenLite.to(_cardArr[i][j], 0.4, {delay:(_rowLength-i)/190 + (_colLength-j)/190,
							rotationY:0, alpha:1, onComplete:intervalMotion, onCompleteParams:[_cardArr[i][j]]});
						}
					}
				}
			}
			_hideTimeout = setTimeout(hideCard, 3500);
		}
		
		protected function hideCard():void
		{
			var reflection:Boolean = Math.round(Math.random());
			var i:int;
			var j:int;
			if(reflection)
			{
				for (i = 0; i < _rowLength; i++) 
				{
					for (j = 0; j < _colLength; j++) 
					{
						if(_cardArr[i][j] != null)
						{
							TweenLite.killTweensOf(_cardArr[i][j]);
							TweenLite.to(_cardArr[i][j], 0.4, {delay:i*0.007 + j*0.007, rotationY:90, alpha:0, onComplete:hideCompleteCheck});
						}
					}
				}
			}
			else
			{
				for (i = _rowLength-1; i >= 0; i--) 
				{
					for (j = _colLength-1; j >= 0; j--) 
					{
						if(_cardArr[i][j] != null)
						{
							TweenLite.killTweensOf(_cardArr[i][j]);
							TweenLite.to(_cardArr[i][j], 0.4, {delay:(_rowLength-i)/190 + (_colLength-j)/190, rotationY:-90, alpha:0, onComplete:hideCompleteCheck});
						}
					}
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
			while (_con.cardCon.numChildren > 0)
			{
				var sp:Sprite = _con.cardCon.getChildAt(0) as Sprite;
				TweenLite.killTweensOf(sp);
				sp.graphics.clear();
				sp.filters = [];
				_con.cardCon.removeChild(sp);
			}
			
			var i:int;
			var j:int;
			for (i = 0; i < _rowLength; i++) 
			{
				for (j = 0; j < _colLength; j++) 
				{
					if(_cardArr[i][j] != null)
					{
						_cardArr[i][j] = null;
					}
				}
				_cardArr[i].length = 0;
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
			
			/**	포즈 상태면 리턴	*/
			if(_isPause == true) return;
			
			/**	보여준 카드섹션수 체크	*/
			_finishCnt++;
			if(_finishCnt >= _cardSectionLength)
			{
				trace("카드섹션 종료___! 다음 유저 플레이___>>>>");
				_finishCnt = 0;
				if(_model.fullVideo == false)
				{
					_showNum ++;
					if(_showNum < 3) _model.dispatchEvent(new BhEvent(BhEvent.CARDSECTION_CHANGE));
				}
			}
			else
			{
				changeCard(_finishCnt);
			}
		}
		
		private function resizeHandler(e:Event = null):void
		{
			if(_con.stage.stageWidth >= 1920 || _con.stage.stageHeight >= 1080 || _model.isIntro)
			{
				_con.width = _con.stage.stageWidth;
				_con.height = _con.stage.stageHeight;
				_con.scaleX = _con.scaleY = Math.max(_con.scaleX, _con.scaleY);
			}
			else
			{
				_con.scaleX = _con.scaleY = 1;
			}
			_con.x = int(_con.stage.stageWidth/2 - _con.width/2);
			_con.y = int(_con.stage.stageHeight/2 - _con.height/2);
			
			var pp:PerspectiveProjection=new PerspectiveProjection();
			pp.projectionCenter=new Point(1920/2,1080/2);
			_con.transform.perspectiveProjection=pp;
		}
	}
}

