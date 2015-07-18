package com.adqua.control
{
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.lol.model.Model
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	public class MotionController extends EventDispatcher
	{
		public static const MOTION_FINISHED:String = "motionFinished";
		public static const MOTION_LOAD_PROGRESS:String = "motionLoadProgress";
		public static const MOTION_LOAD_COMPLETE:String = "motionLoadComplete";
		
		private var _container:Sprite;
		private var _loader:SWFLoader;
		private var _frameChk:Boolean;
		private var _bitmap:Bitmap;
		
		private var _alphaTween:Boolean;
		private var _dispatcher:Shape;
		
		public function get mc():MovieClip
		{
			return _loader.rawContent;
		}
		
		public function MotionController($container:Sprite)
		{
			_container = $container;
			_dispatcher = new Shape;
			_loader = new SWFLoader("", {container:$container, onProgress:progressHandler, onComplete:swfLoadComplete});
			
			_bitmap = new Bitmap( new BitmapData($container.stage.stageWidth, $container.stage.stageHeight, true, 0x00ffffff), "auto", true);
			_bitmap.alpha = 0;
			$container.addChild(_bitmap);
		}
		
		private function progressHandler(e:LoaderEvent):void
		{
			var loadPercent:Number = e.target.bytesLoaded / e.target.bytesTotal;
			Model.getInstance().loadPercent = loadPercent;
			dispatchEvent( new Event(MOTION_LOAD_PROGRESS) );
		}
		
		private function swfLoadComplete(e:LoaderEvent):void
		{
			if(_alphaTween){
				TweenMax.to(_bitmap, 1, {alpha:0});
			}else{
				_bitmap.alpha = 0;
			}
			
			if(_frameChk){
				_dispatcher.addEventListener(Event.ENTER_FRAME, motionFrameChk);
			}
			
			dispatchEvent( new Event(MOTION_LOAD_COMPLETE) );
		}
		
		private function motionFrameChk(e:Event):void
		{
			var mc:MovieClip = _loader.rawContent;
			if(mc.currentFrame == mc.totalFrames){
				_dispatcher.removeEventListener(Event.ENTER_FRAME, motionFrameChk);
				motionEnd();
			}
		}
		
		private function motionEnd():void
		{
			trace("end");
			_loader.rawContent.stop();
			dispatchEvent( new Event(MOTION_FINISHED) );
		}
		
		public function load(path:String, frameChk:Boolean=false, alphaTween:Boolean=false):void
		{
			_frameChk = frameChk;
			_alphaTween = alphaTween;
			if(_loader.rawContent){
				if(_dispatcher.hasEventListener(Event.ENTER_FRAME)){
					_dispatcher.removeEventListener(Event.ENTER_FRAME, motionFrameChk);
				}
				
				var sw:Number = 1920, sh:Number = 1080;
				_bitmap.bitmapData.fillRect(new Rectangle(0,0,sw,sh), 0x00ffffff);
				_bitmap.bitmapData.draw(_loader.content);
				_bitmap.alpha = 1;
				
				_loader.unload();
			}
			_loader.url = path;
			_loader.load();
		}
		
		public function unload():void
		{
			if(_loader.rawContent){
				_loader.unload();
			}
		}
	}
}