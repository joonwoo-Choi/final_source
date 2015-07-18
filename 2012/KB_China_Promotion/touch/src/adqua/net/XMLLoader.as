/*
사용법 
var data:URLVariables = new URLVariables();
data.id = "p2ri";

var xmlLoader : XMLLoader = new XMLLoader("xmlName.xml", [data], [EncodeType.EUC_KR], [EncodeType.GET]);

또는,

var xLoader:XMLLoader = new XMLLoader();
xLoader.data = data;
xLoader.sendEncodeType = EncodeType.GET //기본값 : EncodeType.POST
xLoader.encodeType = EncodeType.EUC_KR;
xLoader.load("test.xml");
xLoader.addEventListener(XMLLoaderEvent.XML_ERROR, errorHandler);
xLoader.addEventListener(XMLLoaderEvent.XML_PROGRESS, progressHandler);
xLoader.addEventListener(XMLLoaderEvent.XML_COMPLETE, complateHander);

function complateHander(e:XMLLoaderEvent):void
{
trace(e.xml);
}

function errorHandler(e:XMLLoaderEvent):void
{
trace(e);
}

function progressHandler(e:XMLLoaderEvent):void
{
trace(e.bytesLoaded , e.bytesTotal);
}

 */

package adqua.net
{
	import adqua.event.XMLLoaderEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.System;


	public class XMLLoader extends EventDispatcher
	{
		private var urlStream:URLStream = new URLStream();
		private var urlRequest:URLRequest = new URLRequest();
		private var _data:URLVariables = null;
		private var enCode:String;
		private var _method:String;

		//로드 완료 된 xml 데이터
		private var _xml:XML;
		
		public function XMLLoader(url:String = null, vars:URLVariables = null, _encode:String = null, method:String = null)
		{
			super();
			if (url) load(url, vars, _encode, method);
		}

		public function load( url:String, vars:URLVariables = null, _encode:String = null, method:String = null):void
		{
			if (_encode != null) enCode = _encode;
			if (enCode == null) enCode = System.useCodePage ? EncodeType.EUC_KR : EncodeType.UTF_8;
			
			if (method != null) _method = method;
			if (_method == null) _method = URLRequestMethod.POST;
			
			if (vars != null) _data = vars;
			if (_data) this.urlRequest.data = _data;
			
			this.urlRequest.url = url;
			this.urlRequest.method = _method;
			
			this.urlStream.addEventListener(Event.COMPLETE, onComplete);
			this.urlStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			this.urlStream.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this.urlStream.load(this.urlRequest);
		}

		private function onProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(new XMLLoaderEvent(e, XMLLoaderEvent.XML_PROGRESS));
		}

		private function onError( e:IOErrorEvent ):void
		{
			trace("파일을 찾을 수 없습니다");
			this.dispatchEvent(new XMLLoaderEvent("Not find File", XMLLoaderEvent.XML_ERROR));
		}

		private function onComplete( e:Event ):void
		{
			var str:String = urlStream.readMultiByte(urlStream.bytesAvailable, enCode);
			str = str.charAt(0) == "<" ? str : str.substr(str.indexOf("<?"));

			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			
			_xml = new XML(str);
			
			this.dispatchEvent(new XMLLoaderEvent(xml, XMLLoaderEvent.XML_COMPLETE));				
		}

		public function get data():URLVariables
		{
			return _data;
		}

		public function set data(vars:URLVariables):void
		{
			_data = vars;
		}

		public function get xml():XML
		{
			return _xml;
		}

		public function get encodeType():String
		{
			return enCode;
		}

		public function set encodeType(_enCode:String):void
		{
			enCode = _enCode;
		}
		
		public function get method():String
		{
			return _method;
		}
		
		public function set method(method:String):void
		{
			_method = method;
		}
	} // class
}// package
