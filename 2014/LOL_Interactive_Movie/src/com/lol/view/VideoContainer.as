package com.lol.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class VideoContainer
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _dot:Dot;
		
		public function VideoContainer(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			_dot = new Dot();
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.DRAW_COVER, drawCover);
			_model.addEventListener(LolEvent.REMOVE_COVER, removeCover);
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		/**	망점 그리기	*/
		private function drawDot():void
		{
			_con.dot.graphics.clear();
			_con.dot.graphics.beginBitmapFill(_dot);
			_con.dot.graphics.drawRect(0, 0, _con.stage.stageWidth, _con.stage.stageHeight);
			_con.dot.graphics.endFill();
		}
		
		/**	마지막 장면 그리기	*/
		private function drawCover(e:LolEvent):void
		{
//			if(_con.intro.alpha > 0) return;
			if(_con.cover.numChildren >= 1) return;
			_con.cover.alpha = 1;
			var bmpData:BitmapData = new BitmapData(1280, 720);
			if(_model.videoType == "flv") bmpData.draw(_con.video);
			else if(_model.videoType == "swf") bmpData.draw(_con.swfCon);
			
			var bmp:Bitmap = new Bitmap(bmpData);
			bmp.smoothing = true;
			_con.cover.addChild(bmp);
			resizeHandler();
			trace("커버 그리기___>   " + _model.videoType, _con.cover.numChildren);
		}
		
		/**	마지막 장면 지우기	*/
		private function removeCover(e:LolEvent):void
		{
			TweenLite.killTweensOf(_con.cover);
			TweenLite.to(_con.cover, 0.75, {delay:0.5, alpha:0, ease:Cubic.easeOut, onComplete:removeCaptureImg});
//			if(_con.intro.alpha > 0) TweenLite.to(_con.intro, 0.75, {alpha:0, ease:Cubic.easeOut});
		}
		/**	이미지 제거	*/
		private function removeCaptureImg():void
		{
			/**	퀵버튼 클릭 가능	*/
			_model.quickReClick = true;
			while(_con.cover.numChildren > 0)
			{
				var childIdx:int = _con.cover.numChildren-1;
				var bmp:Bitmap = _con.cover.getChildAt(childIdx) as Bitmap;
				bmp.bitmapData.dispose();
				_con.cover.removeChild(bmp);
			}
			trace("커버 지우기 ==>  " + _con.cover.numChildren);
		}
		
		private function resizeHandler(e:Event = null):void
		{
			drawDot();
			
			var stageWidth:Number;
			var stageHeight:Number;
			if(_con.stage.stageWidth > 1024)
			{
				stageWidth = _con.stage.stageWidth;
//				_con.intro.width = _con.stage.stageWidth;
				_con.cover.width = _con.stage.stageWidth;
			}
			else
			{
				stageWidth = 1024;
//				_con.intro.width = 1024;
				_con.cover.width = 1024;
			}
			if(_con.stage.stageHeight > 600)
			{
				stageHeight = _con.stage.stageHeight;
//				_con.intro.height = _con.stage.stageHeight;
				_con.cover.height = _con.stage.stageHeight;
			}
			else
			{
				stageHeight = 600;
//				_con.intro.height = 600;
				_con.cover.height = 600;
			}
			
//			_con.intro.scaleX = _con.intro.scaleY = Math.max(_con.intro.scaleX, _con.intro.scaleY);
//			_con.intro.x = int(stageWidth/2 - _con.intro.width/2);
//			_con.intro.y = int(stageHeight/2 - _con.intro.height/2);
			
			_con.cover.scaleX = _con.cover.scaleY = Math.max(_con.cover.scaleX, _con.cover.scaleY);
			_con.cover.x = int(stageWidth/2 - _con.cover.width/2);
			_con.cover.y = int(stageHeight/2 - _con.cover.height/2);
		}
	}
}