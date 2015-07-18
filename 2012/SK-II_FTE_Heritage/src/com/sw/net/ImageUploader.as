package com.sw.net
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;

	/**
	 * 이미지 업로더
	 * */
	public class ImageUploader extends EventDispatcher
	{
		private var url:String;
		private var data:Object;
		
		private var uploader:FileReference;
		
		/**
		 * 생성자 <br> 
		 *  (업로드 경로,<br>
		 * 	{onComplete:업로드완료,onStart:업로드시작,onDoing:업로드진행중,<br>
		 * 	onCancel:취소,onSelect:선택,onLoad:로드완료<br>
		 * 	})
		 * */
		public function ImageUploader($url:String,$data:Object=null)
		{
			url = $url;
			data = $data;
			if(data == null) data = {};
			
			init();	
			setListener();
		}
		
		/**	초기화	*/
		private function init():void
		{
			uploader = new FileReference();
		}
		
		/**	파일이름 반환	*/
		public function getFileName():String
		{	return uploader.name;	}
		
		/**	이벤트 셋팅	*/
		private function setListener():void
		{
			uploader.addEventListener(Event.SELECT,onSelect);
			uploader.addEventListener(Event.CANCEL,onCancel);
			uploader.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onComplete);
			uploader.addEventListener(ProgressEvent.PROGRESS,doingUpload);
			
			uploader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
			uploader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			uploader.addEventListener(Event.COMPLETE,onLoadComplete);
		}
		
		/**	업로드 */
		public function upload():void
		{
			//파일 선택
			uploader.browse(getType());
		}
		
		/**	업로드 데이터 타입 반환	*/
		private function getType():Array
		{
			var allTypes:Array = new Array(getImageTypeFilter());
			return allTypes;
		}
		
		/**	이미지 업로드	*/
		private function getImageTypeFilter():FileFilter 
		{	return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");	}
		
		/**	텍스트 데이터 업로드	*/
		private function getTextTypeFilter():FileFilter 
		{	return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");	}
		
		
		/**	업로드 할 파일 선택	*/
		private function onSelect(e:Event):void
		{
			//trace(uploader.name);
			if(url != "") uploader.upload(new URLRequest(url));
			if(data.onStart != null) data.onStart();
			
			if(data.onSelect != null) data.onSelect(uploader);
			
			if(data.onLoad != null) uploader.load();
		}
		
		/**	업로드 진행 중	*/
		private function doingUpload(e:ProgressEvent):void
		{
			//trace("progressHandler name=" + uploader.name + " bytesLoaded=" + e.bytesLoaded + " bytesTotal=" + e.bytesTotal);
			var num:int = Math.round((e.bytesLoaded/e.bytesTotal)*100);
			if(data.onDoing != null) data.onDoing(num);
		}
		/**	이미지 byteArray 로드 완료	*/
		private function onLoadComplete(e:Event):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadBytes);
			loader.loadBytes(uploader.data);
		}
		/**	이미지 Bitmap 로드 완료	*/
		private function onLoadBytes(e:Event):void
		{
			var loaderinfo:LoaderInfo = e.target as LoaderInfo;
			var loader:Loader = loaderinfo.loader;
			var bit:Bitmap = loader.content as Bitmap;
			
			if(data.onLoad != null) data.onLoad(bit);
			
			loader.unload();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadBytes);
			loader = null;
		}
		
		/**	업로드 완료	*/
		private function onComplete(e:DataEvent):void
		{
			//trace(e.data);
			if(data.onComplete != null) data.onComplete(e.data);
		}
		
		/**	업로드 할 파일 선택 취소	*/
		private function onCancel(e:Event):void
		{
			if(data.onCancel != null) data.onCancel();
		}
		
		/**	진행 과정중 에러	*/
		private function onError(e:Event):void
		{
			//FncOut.call("alert",e.text);
			trace(e);
		}
		
		/**
		 * 소멸자
		 * */
		public function destroy():void
		{
			uploader.removeEventListener(Event.SELECT,onSelect);
			uploader.removeEventListener(Event.CANCEL,onCancel);
			
			uploader.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onComplete);
			uploader.removeEventListener(ProgressEvent.PROGRESS,doingUpload);
			uploader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
			uploader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			
			uploader.removeEventListener(Event.COMPLETE,onLoadComplete);
			
			uploader = null;
			
		}
	}//class
}//package