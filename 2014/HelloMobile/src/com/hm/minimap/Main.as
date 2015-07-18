package com.hm.minimap
{
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.hm.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;

	public class Main
	{
		
		private var _con:MovieClip;
		
		private var _model:Model = Model.getInstance();
		
		private var _boxXml:XML;
		
		private var _rowLength:int = 23;
		private var _colLength:int = 22;
		private var _boxNum:int = 0;
		private var _tabBoxNum:int = 0;
		private var _tabBoxLength:int = 2;
		
		private var _startBoxY:int = 524;
		private var _endBoxY:int = 1716;
		
		private var _artWorkArr:Array;
		
		private var _boxArr:Array;
		private var _boxFaceFrame:Array = [
			[4,7,30,10,16,34,32],
			[31,1,9,26,19,14,13],
			[29,8,28,5,24,21],
			[3,25,18,27,11,35],
			[15,6,23,22,38,2],
			[37,20,36,12,33,17]
		];
		
		private var _hideBoxArr:Array;
		
		public function Main(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin, ColorTransformPlugin]);
			
			/**	박스	*/
			_boxArr = [];
			var boxIdx:int;
			for (var i:int = 0; i < _colLength; i++) 
			{
				var rowGroup:Array = [];
				for (var j:int = 0; j < _rowLength; j++) 
				{
					var box:boxFront = new boxFront();
					box.width = 5.3;
					box.height = 5.45;
					box.row = j;
					box.col = i;
					if(i >= 20 && j >= 20)
					{
						box.x = -2000;
						box.y = -2000;
						box.visible = false;
					}
					else
					{
						box.x = j*5.3;
						box.y = i*5.45;
						box.no = boxIdx;
						boxIdx++;
					}
					var boxFaceFrame:int = _boxFaceFrame[i%6][j%(_boxFaceFrame[i%6].length)];
					box.gotoAndStop(boxFaceFrame);
					_con.mapCon.boxCon.addChild(box);
					rowGroup.push(box);
				}
				_boxArr.push(rowGroup);
			}
			
			/**	아트웍	*/
			_artWorkArr = [];
			for (var k:int = 0; k < _tabBoxLength; k++) 
			{
				var artWork:MovieClip = _con.mapCon.getChildByName("artWork_" + k) as MovieClip;
				_artWorkArr.push(artWork);
			}
			trace(_artWorkArr);
		}
		
		private function initEventListener():void
		{
			if(ExternalInterface.available) ExternalInterface.addCallback("getWindowData", getWindowData);
			if(ExternalInterface.available) ExternalInterface.addCallback("getBoxData", getBoxData);
			if(ExternalInterface.available) ExternalInterface.addCallback("getChangeBoxNum", getChangeBoxNum);
		}
		
		/**	윈도우 정보 얻기	*/
		protected function getWindowData(scroll:String, height:String):void
		{
			var boxY:int;
			if(int(scroll) >= _startBoxY && int(scroll) < _endBoxY) boxY = Math.floor((int(scroll)-_startBoxY)/10);
			else if(int(scroll) >= _endBoxY) boxY = 118;
			else boxY = 0;
			
			var boxHeight:int;
			if(int(scroll) < _startBoxY)
				boxHeight = Math.floor((int(height) - (_startBoxY-int(scroll)))/9.5);
			else if(int(scroll) >= _startBoxY && int(scroll)+int(height) < _endBoxY)
				boxHeight = Math.floor(int(height)/9.5);
			else 
				boxHeight = Math.floor(120-boxY);
			
			TweenLite.to(_con.mapCon.strokeBox, 0.5, {y: boxY, ease:Cubic.easeOut});
			TweenLite.to(_con.mapCon.strokeBox.side, 0.5, {height: boxHeight, ease:Cubic.easeOut});
			TweenLite.to(_con.mapCon.strokeBox.down, 0.5, {y: boxHeight - 1, ease:Cubic.easeOut});
		}
		
		/**	박스 XML 받기	*/
		protected function getBoxData(boxData:String):void
		{
			_boxXml = XML(boxData);
			trace(_boxXml);
			_tabBoxNum = 0;
			/**	숨길 박스 배열 생성	*/
			_hideBoxArr = [];
			for (var i:int = 0; i < _boxXml.contents.hideBox.length(); i++) 
			{
				var hideBox:Array = String(_boxXml.contents.hideBox[i]).split(",");
				_hideBoxArr.push(hideBox);
			}
		}
		/**	박스 번호 변경	*/
		protected function getChangeBoxNum(boxNum:int):void
		{
			_tabBoxNum = boxNum;
			boxContentChange(_tabBoxNum);
		}
		/**	박스 배경 & 탭버튼 색상 변경	*/
		private function boxContentChange(contentNum:int):void
		{
			/**	박스 앞면 변경	*/
			boxFaceChange(contentNum);
		}
		/**	박스 내용 변경	*/
		private function boxFaceChange(contentNum:int):void
		{
			for (var i:int = 0; i < _colLength; i++) 
			{
				for (var j:int = 0; j < _rowLength; j++) 
				{
					for (var k:int = 0; k < _tabBoxLength; k++) 
					{
						var showFace:MovieClip = _boxArr[i][j].getChildByName("c" + k) as MovieClip;
						if(k == contentNum)
						{
							_boxArr[i][j].setChildIndex(showFace, _boxArr[i][j].numChildren - 1);
							showFace.alpha = 0;
							TweenLite.to(showFace, 0.5, {delay:i*0.015 + j*0.015, 
								colorTransform:{exposure:1.05}, 
								reversed:true,  
								ease:Cubic.easeOut, 
								onStartParams:[showFace, _boxArr[i][j], contentNum], 
								onStart:boxFaceShow});
						}
					}
				}
			}
			
			for (var i2:int = 0; i2 < _tabBoxLength; i2++) 
			{
				if(i2 == contentNum) TweenLite.to(_artWorkArr[i2], 0.5, {alpha:1});
				else TweenLite.to(_artWorkArr[i2], 0.5, {alpha:0});
			}
		}
		/**	박스페이스 변경 시작	*/
		private function boxFaceShow(showFace:MovieClip, box:MovieClip, contentNum:int):void
		{
			showFace.alpha = 1;
			
			var hide:Boolean = false;
			for (var j:int = 0; j < _hideBoxArr[contentNum].length; j++) 
			{
				if(int(box.no)+1 == int(_hideBoxArr[contentNum][j]))
				{
					hide = true;
					break;
				}
			}
			
			if(hide) TweenLite.to(box, 0.5, {autoAlpha:0});
			else TweenLite.to(box, 0.5, {autoAlpha:1});
		}
	}
}