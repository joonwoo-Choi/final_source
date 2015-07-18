package com.sw.net
{
	import com.sw.display.JPEGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	/**
	 * Bitmap 업로드
	 * */
	public class UploadBitmap
	{
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		
		private var data:Object;
		
		/**	업로드 완료후 반환 함수	*/
		private var complete:Function;	
		
		/**	생성자	*/
		public function UploadBitmap($url:String,$data:Object)
		{
			
			data = $data;
			if(data == null) data = new Object();
			
			urlRequest = new URLRequest();
			urlLoader = new URLLoader();	
			
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader('Cache-Control','no-cache'));
			urlRequest.requestHeaders.push
				( new URLRequestHeader('Content-Type','multipart/form-data;boundary='+
					UploadPostHelper.getBoundary()));	
			urlRequest.url = $url;
		}
		
		private function getByteArray(bitmap:Bitmap):ByteArray
		{	
			var bitmapData:BitmapData = new BitmapData(bitmap.width,bitmap.height);
			var drawingRectangle:Rectangle=  
				new Rectangle(0,0,bitmap.width,bitmap.height);
			bitmapData.draw(bitmap,new Matrix(),null,null,drawingRectangle,false);
			var objJPEGEnc:JPEGEncoder = new JPEGEncoder(80);   
			var byteArray:ByteArray = objJPEGEnc.encode(bitmapData);
			
			return byteArray;
		}
		
		/**	Bitmap 업로드	*/
		public function upload(bitmap:Bitmap,param:URLVariables=null):void
		{
			urlRequest.data = UploadPostHelper.getPostData("upload.jpg",getByteArray(bitmap),param);
			urlLoader.addEventListener(ProgressEvent.PROGRESS,onProgress);
			urlLoader.addEventListener(Event.COMPLETE,onUploadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			urlLoader.load(urlRequest);
		}
		
		private function onProgress(e:ProgressEvent):void
		{
			//trace(e.bytesLoaded+"/"+e.bytesTotal);
			if(data.onProgress != null) data.onProgress(e);
		}
		/**	업로드 완료된후	*/
		private function onUploadComplete(e:Event):void
		{
			//trace(urlLoader.data);
			if(data.onComplete != null) data.onComplete(urlLoader.data);
		}
		
		/**	업로드 과정중 에러	*/
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			trace(e);
		}
		/**	보안 에러	*/
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			trace(e);
		}
		
		/**	소멸자	*/
		public function destroy():void
		{
			urlLoader = null;
		}
		
	}//class
}//package