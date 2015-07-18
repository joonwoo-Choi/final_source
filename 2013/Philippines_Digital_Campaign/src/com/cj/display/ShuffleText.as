package com.cj.display
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ShuffleText extends TextField
	{
		public function ShuffleText(str:String, format:TextFormat=null)
		{
			super();
			
			selectable = false;
			mouseEnabled = false;
			multiline = false;
			autoSize = TextFieldAutoSize.LEFT;
			if(format) defaultTextFormat = format;
			
			text = str;
		}
		
		//----------------------------------------------------------
		//
		//   Property 
		//
		//----------------------------------------------------------
		
		public var duration:int = 500;
		public var emptyCharacter:String = "-";
		public var isRunning:Boolean = false;
		//public var sourceRandomCharacter:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
		public var sourceRandomCharacter:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
		override public function set text(value:String):void
		{
			if(!value) return;
			
			_orijinalStr = value;
			_orijinalLength = value.length;
			super.text = value;
		}
		
		private var _orijinalLength:int = 0;
		private var _orijinalStr:String = "";
		private var _provider:Shape = new Shape();
		private var _randomIndex:Array = [];
		private var _timeCurrent:int = 0;
		private var _timeStart:int = 0;
		
		//----------------------------------------------------------
		//
		//   Function 
		//
		//----------------------------------------------------------
		
		public function start():void
		{
			stop();
			_randomIndex.length = 0;
			
			var str:String = "";
			for (var i:int = 0; i < _orijinalLength; i++)
			{
				var rate:Number = i / _orijinalLength;
				_randomIndex[i] = Math.random() * (1 - rate) + rate;
				str += emptyCharacter;
			}
			
			_timeStart = new Date().time;
			_provider.addEventListener(Event.ENTER_FRAME, tick);
			isRunning = true;
			
			super.text = str;
		}
		
		public function stop():void
		{
			if (isRunning) _provider.removeEventListener(Event.ENTER_FRAME, tick);
			isRunning = false;
		}
		
		public function dispose():void
		{
			duration = 0;
			emptyCharacter = null;
			isRunning = false;
			sourceRandomCharacter = null;
			_orijinalLength = 0;
			_orijinalStr = null;
			_provider = null;
			_randomIndex = null;
			_timeCurrent = 0;
			_timeStart = 0;
		}
		
		private function tick(e:Event):void
		{
			_timeCurrent = new Date().time - _timeStart;
			
			var percent:Number = _timeCurrent / duration;
			var str:String = "";
			
			for(var i:int = 0; i < _orijinalLength; i++)
			{
				if(percent >= _randomIndex[i]){
					str += _orijinalStr.charAt(i);
				}else{
					str += sourceRandomCharacter.charAt(Math.floor(Math.random() * (sourceRandomCharacter.length)));
				}
			}
			
			if(percent > 1)
			{
				str = _orijinalStr;
				_provider.removeEventListener(Event.ENTER_FRAME, tick);
				isRunning = false;
			}
			
			super.text = str;
		}
	}
}