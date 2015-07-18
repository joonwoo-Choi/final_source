package com.sw.net
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.sw.display.Scene;
	import com.zade.events.LoadingEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	/**
	 * 로더 맥스로 대치.......
	 * */
	public class SWLoader extends Sprite
	{
		public var scope:Object;
		public var loader:Loader;
		public var mc:MovieClip;
		public var file:String;
		public var target:Sprite;
		
		public var cbk_init:Function;
		public var cbk_doing:Function;
		
		public function Loading($scope:Object,$dataObj:Object)
		{
			super();
			fN_init($scope,$dataObj);
		}
		public function fN_init($scope:Object,$dataObj:Object):void
		{
			this.name = "Loading";
			loader = new Loader();		//로더 설정
			
			file = (dataObj.file) ?	 		(dataObj.file) : null;
			target = (dataObj.target) ?	(dataObj.target) : null;
			cbk_init = (dataObj.init) ?	(dataObj.init) : null;
			cbk_doing = (dataObj.doing) ?	(dataObj.doing) : null;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onDoing);
			loader.contentLoaderInfo.addEventListener(Event.UNLOAD,onUnload);
			
			if(file != null && target != null) load(file,target);
		}
		public function load($file:String,$target:Sprite):void
		{
			$target.addChild(loader);
			loader.load(new URLRequest($file));	
		}
		
		private function onUnload(e:Event):void
		{

		}
		/*로딩 초기화 
		private function onInit(e:Event):void
		{
		
		}
		*/
		//로딩 진행중
		private function onDoing(e:ProgressEvent):void
		{		
			clip.txt.text = 
			Math.round((e.bytesLoaded/e.bytesTotal)*100)+"%";
			clip.loading_mask.x = 
				Math.round((e.bytesLoaded/e.bytesTotal)*65) - 65;
		}
		//로딩 완료후 
		private function onComplete(e:Event):void
		{
			
			//if(this.content != null) 
			if(mc.numChildren > 0)
			{
				//this.txt.text = String(this.content.name);
				//mc.removeChild(loader.content);
				var display:DisplayObject = mc.removeChildAt(0);
				display = null;
				//delete display;
				//this.txt.text = String(display);
			}
			
			mc.addChildAt(loader.content,0);
			//데이터 초기화
			this.loader.unload();
			this.loader = null;
			
			//로딩 이미지 사라지기
			TweenLite.to(this.clip,0.5,
			{alpha:0,onComplete:loadComplete,ease:Expo.easeOut});
			//로드된 내용 알파값 등장
			TweenLite.to(mc,0.5,{alpha:1,ease:Expo.easeOut});
			//외부에서 로딩완료후 수행할 내용 수행
			this.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_COMPLETE));
		}
		
		//로딩 이미지 알파값으로 사라지고 난후 움직임
		private function loadComplete():void
		{
			//this.txt.text = mc.name;
			removeChild(clip);
		}
		
		override public function onActive(e:Event):void
		{
			super.onActive(e);
			//로딩 이미지 센터 정렬
			clip.x = Math.round(( super.sw - clip.width)/2);	
			clip.y = Math.round(( super.sh - clip.height)/2);	
		}	
	}
}