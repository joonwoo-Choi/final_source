package com.bh.view
{
	import com.adqua.util.ButtonUtil;
	import com.bh.events.BhEvent;
	import com.bh.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class LikePeopleCon
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		
		private var _likePeopleArr:Vector.<MovieClip> = new Vector.<MovieClip>;
		private var _likePeopleLength:int = 7;
		private var _thumbLoadCnt:int;
		
		public function LikePeopleCon(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			TweenPlugin.activate([FramePlugin, ColorTransformPlugin]);
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(BhEvent.LIKE_PEOPLE_CHANGE, likePeopleChange);
			
			ButtonUtil.makeButton(_con.btnLike, btnLikeHandler);
			_con.stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		/**	좋아요 사람들 이미지 변경	*/
		private function likePeopleChange(e:BhEvent):void
		{
			var i:int;
			for (i = 0; i < _likePeopleLength; i++) 
			{
				var clip:LikePeopleClip = new LikePeopleClip();
				clip.no = i;
				clip.x = (clip.width-3)*i;
				clip.y = clip.height;
				_likePeopleArr.push(clip);
				_con.imgCon.addChild(clip);
				ButtonUtil.makeButton(clip, likePeopleClipHandler);
				
				var imgLdr:Loader = new Loader();
				clip.img.addChild(imgLdr);
				imgLdr.load(new URLRequest(_model.commonPath + "img/like_thumb_" + i + ".jpg"));
				imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbImgLoadComplete);
			}
		}
		/**	썸네일 이미지 로드 완료	*/
		private function thumbImgLoadComplete(e:Event):void
		{
			_thumbLoadCnt++;
			if(_thumbLoadCnt >= _likePeopleLength)
			{
				for (var i:int = 0; i < _likePeopleLength; i++) 
				{
					var ldr:Loader = _likePeopleArr[i].img.getChildAt(0) as Loader;
//					var bmp:Bitmap = ldr.content as Bitmap;
//					bmp.smoothing = true;
					
					ldr.width = ldr.height = 32;
					ldr.scaleX = ldr.scaleY = Math.max(ldr.scaleX, ldr.scaleY);
					ldr.x = int(32/2 - ldr.width/2);
					ldr.y = int(32/2 - ldr.height/2);
				}
				
				_thumbLoadCnt = 0;
				changePeople();
			}
		}
		/**	이미지 체인지 모션	*/
		private function changePeople():void
		{
			var i:int;
			for (i = 0; i < _likePeopleLength; i++) 
			{
				TweenLite.to(_likePeopleArr[i], 0.5, {delay:0.05*i, y:0, ease:Cubic.easeOut});
			}
		}
		/**	썸네일 핸들러	*/
		private function likePeopleClipHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER : TweenLite.to(target.stroke, 0.5, {frame:target.stroke.totalFrames}); break;
				case MouseEvent.MOUSE_OUT : TweenLite.to(target.stroke, 0.5, {frame:0}); break;
				case MouseEvent.CLICK : trace("이미지__>  " + target.no); break;
			}
		}
		
		/**	좋아요 버튼 핸들러	*/
		private function btnLikeHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER : TweenLite.to(target, 0.5, {colorTransform:{exposure:1.1}}); break;
				case MouseEvent.MOUSE_OUT : TweenLite.to(target, 0.5, {colorTransform:{exposure:1}}); break;
				case MouseEvent.CLICK : trace("좋아요__!"); break;
			}
		}
		
		private function resizeHandler(e:Event = null):void
		{
			_con.x = int(_con.stage.stageWidth - _con.width - 71);
			_con.y = int(_con.stage.stageHeight - _con.height - 18);
		}
	}
}