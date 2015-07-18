package com.cj.external
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class DataCaller
	{
		public function DataCaller(){}
		
		/**
		 * 서버언어에서 결과값 받아오기 
		 * @param $url :: 경로
		 * @param $onComplete :: 로드완료 함수
		 * @param $data :: {vars:서버로 보낼 변수, method:전송방식(기본값post), format:리턴값 형식(데이터포맷)}
		 * 
		 */		
		public static function connect($url:String, $onComplete:Function, $data:Object=null, $onError:Function=null):void
		{
			var req:URLRequest = new URLRequest( $url );
			var loader:URLLoader = new URLLoader();
			var data:Object = ($data != null) ? $data : {};
			
			if(data.vars){
				req.method = (data.mehtod != null) ? data.mehtod : URLRequestMethod.POST;
				req.data = data.vars;
			}
			if(data.format){
				loader.dataFormat = data.format;
			}
			
			loader.addEventListener( Event.COMPLETE, onCompleteListener );
			loader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
			loader.load( req );
			
			function onCompleteListener(e:Event):void
			{
				trace("DATA COMPLETE!!");
				
				// 로드완료 메소드 넘기기
				$onComplete(e);
				
				loader.removeEventListener( Event.COMPLETE, onCompleteListener );
				loader = null;
			}
			
			function ioErrorHandler(e:IOErrorEvent):void
			{
				trace("IO ERROR");
				if($onError != $onError) $onError(e);
				//JSUtil.alert("파일을 읽어올수없습니다");
				
				loader.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
				loader = null;
			}
		}
	}
}