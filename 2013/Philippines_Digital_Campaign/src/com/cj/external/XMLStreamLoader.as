package com.cj.external
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	public class XMLStreamLoader extends EventDispatcher
	{
		private var _loader:URLStream;
		private var _loaded: Boolean = false;
		private var _req: URLRequest;
		private var _charset: String;
		
		
		private var _xml: XML;
		public function get xml(): XML
		{
			return _xml;
		}
		
		public function XMLStreamLoader()
		{
			// url request 생성
			_req = new URLRequest();
		}
		
		private function createLoader(): void
		{
			_loader = new URLStream();
			_loader.addEventListener( Event.COMPLETE, loadCompleteListener );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, loadFailListener );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, loadFailListener );
		}
		
		public function set url($url:String):void
		{
			_req.url = $url;
		}
		
		public function get url():String
		{
			return _req.url;
		}
		
		public function load($charset:String="utf-8"):void
		{
			if( _loader == null ) createLoader();
			_charset = $charset;
			_loader.load( _req );
		}
		
		private function loadComplete(): void
		{
			if( _loader.connected && _loader.bytesAvailable ){
				try
				{
					_xml = XML( _loader.readMultiByte( _loader.bytesAvailable, _charset ) );
				}
				catch(e:TypeError)
				{
					trace(e.message);
					return;
				}
			}
		}
		
		private function loadCompleteListener(e:Event):void
		{
			_loaded = true;
			loadComplete();
			
			// 스트림 닫기
			if( _loader.connected ){
				_loader.close();
			}
			
			// 디스패치 이벤트
			dispatchEvent(e );
		}
		
		private function loadFailListener(e:Event): void
		{
			// 로드 실패
			dispatchEvent( e );
		}
		
	}
}