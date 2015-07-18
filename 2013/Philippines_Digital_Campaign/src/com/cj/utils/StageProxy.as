package com.cj.utils 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;        
	
	public class StageProxy extends EventDispatcher 
	{                                 
		private var _maxWidth:Number = 3200;
		private var _maxHeight:Number = 1600;
		private var _minWidth:Number = 960;
		private var _minHeight:Number = 600;
		
		private var _width:Number = 100;
		private var _height:Number = 100;
		
		private var _stage:Stage;
		private var _reSizeFnc:Vector.<Function>;
		
		static private var instance:StageProxy;

		public static function getInstance():StageProxy 
		{
			if(instance==null) instance = new StageProxy(new PrivateConstructor());
			return instance;
		}
		
		public function StageProxy(priv:PrivateConstructor)
		{
			super();
			_reSizeFnc = new Vector.<Function>();
		}
		
		public function init(inStage:Stage, minWidth:int, minHeight:int):void
		{ 
			if(_stage) return;
			
			_minWidth = minWidth;
			_minHeight = minHeight;
			
			_stage = inStage;                                
			_stage.addEventListener( Event.RESIZE, update );
			
			updateNow();
		}
		
		public function update(e:Event=null):void
		{
			// 딜레이 적용 X
			updateNow();
		}
		
		public function get stage():Stage 
		{
			return _stage;
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		
		public function setBounds( minwidth:Number, minheight:Number, maxwidth:Number, maxheight:Number ):void 
		{
			_minWidth = minwidth;
			_minHeight = minheight;
			_maxWidth = maxwidth;
			_maxHeight = maxheight;
			update();
		}
		
		
		/**
		 * 등록된 리사이즈 함수들 실행 
		 * @param sw
		 * @param sh
		 * 
		 */
		public function execute(sw:Number, sh:Number):void
		{
			var total:uint = _reSizeFnc.length;
			if(total == 0) return;
			
			var i:int = 0;
			var fnc:Function;
			for(; i < total; ++i)
			{
				fnc = _reSizeFnc[i];
				if(fnc != null) fnc(sw, sh);
			}
		}
		
		
		/**
		 * 리사이즈 함수 등록 
		 * @param obj
		 * 
		 */		
		public function register(fnc:Function):void
		{
			var i:int = _reSizeFnc.indexOf(fnc);
			if(i == -1){
				_reSizeFnc.push(fnc);
			}
		}
		
		
		/**
		 * 리사이즈 함수 제거 
		 * @param obj
		 * 
		 */		
		public function remove(fnc:Function):void
		{
			var i:int = _reSizeFnc.indexOf(fnc);
			if(i > -1){
				_reSizeFnc.splice(i, 1);
			}
		}
		
		
		/**
		 * 리사이즈 이벤트 실행 
		 * 
		 */		
		public function updateNow():void 
		{   
			if(!stage) return;
			
			_width = Math.min( Math.max( stage.stageWidth, _minWidth), _maxWidth );
			_height = Math.min( Math.max( stage.stageHeight, _minHeight), _maxHeight );
			
			// 실행!!
			execute(_width, _height);
		}  
		
	}
}

class PrivateConstructor {}