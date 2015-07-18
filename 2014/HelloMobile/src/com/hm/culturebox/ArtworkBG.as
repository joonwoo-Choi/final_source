package com.hm.culturebox
{
	
	import com.greensock.TweenLite;
	import com.hm.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ArtworkBG
	{
		
		private var _con:MovieClip;
		
		private var _model:Model = Model.getInstance();
		
		private var _imgArr:Array;
		private var _imgLength:int = 3;
		
		private var _imgLoadCnt:int;
		private var _imgLoadCom:Boolean = false;
		
		public function ArtworkBG(con:MovieClip)
		{
			_con = con;
			
			init();
		}
		
		private function init():void
		{
			_imgArr = [];
			for (var i:int = 0; i < _imgLength; i++) 
			{
				var imgLdr:Loader = new Loader();
				imgLdr.load(new URLRequest(_model.commonPath + "cultureBox_img/img_" + i + ".jpg"));
				_imgArr.push(imgLdr);
				imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
				_con.addChild(imgLdr);
			}
		}
		
		
		private function imgLoadComplete(e:Event):void
		{
			_imgLoadCnt++;
			if(_imgLoadCnt == 3)
			{
				_imgLoadCom = true;
				artworkChange(_model.boxTabNum);
			}
			
//			var bmp:Bitmap = Bitmap(e.target.content);
//			bmp.smoothing = true;
		}
		
		public function artworkChange(imgNum:int):void
		{
			if(_imgLoadCom ==false) return;
			
			for (var i:int = 0; i < _imgLength; i++) 
			{
				if(i == imgNum) TweenLite.to(_imgArr[i], 0.5, {alpha:1});
				else TweenLite.to(_imgArr[i], 0.5, {alpha:0});
			}
		}
	}
}