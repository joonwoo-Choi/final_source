package com.bh.util
{
	
	import com.adobe.serialization.json.JSON;
	import com.bh.events.BhEvent;
	import com.bh.model.Model;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	[Event(name="encoding_start" , type="flash.events.Event")]
	
	public class NodeSocket extends Sprite
	{
		
		public static const ENCODING_START:String = "encoding_start";
		
		private var _socket:Socket;
		
		private var _serverUrl:String;
		private var _port:int;
		
		private var _firstChk:Boolean = true;
		private var _model:Model = Model.getInstance();
		
		public function NodeSocket(url:String, port:int)
		{
			this._serverUrl = url;
			this._port = port;
		}
		
		public function connect():void
		{
			cleanUpSocket();
			
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT, onSocketConnect);
			_socket.addEventListener(Event.CLOSE, onSocketDisconnect);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			_socket.connect(this._serverUrl, this._port);
			
			/**	최초 접속시	*/
			if(_firstChk)
			{
				trace("최초 접속");
				writeMessage("{ \"name\":\"handshake\", \"data\":\"WEB\" }");
			}
		}
		
		private function onSocketConnect(e:Event):void
		{
			
		}
		
		public function changeUrl(url:String, port:int):void
		{
			this._serverUrl = url;
			this._port = port;
		}
		
		public function sendMakeMovie(fromName:String, toName:String, imgUrl:String, msgArr:Array):void
		{
			/**	영상 제작 서버로 전송	*/
			if(fromName == "" || toName == "" || msgArr.length == 0) return;
			var jsonObj:Object = {"name":"makeMovie", "from":fromName, "to":toName, "image":imgUrl, "messageText":msgArr };
			_socket.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jsonObj));
			_socket.flush();
			trace("영상 제작 전송___>", com.adobe.serialization.json.JSON.encode(jsonObj));
		}
		
		private function onSocketDisconnect(e:Event):void
		{
			trace("소켓_____>>     종료");
			disconnectSocket();
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			trace("소켓_____>>     보안 에러");
			disconnectSocket();
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace("소켓_____>>     IO 에러     ", e.text);
			disconnectSocket();
		}
		
		private function onSocketData(e:ProgressEvent):void
		{
			var message:String = _socket.readUTFBytes(_socket.bytesAvailable);
			trace("소켓 데이터\n" + message + "\n처음이냐___>  " + _firstChk);
			
			/**	이미지 저장 경로 및 텍스트 정보	*/
			if(_firstChk == false)
			{
				var jsonData:Object = com.adobe.serialization.json.JSON.decode(message);
				if(jsonData.name != "makeImages") return;
				dispatchEvent(new BhEvent(ENCODING_START,jsonData));
			}
			
			if(_firstChk) _firstChk = false;
		}
		
		private function writeMessage(message:String):void
		{
			_socket.writeUTFBytes(message);
			_socket.flush();
		}
		
		private function disconnectSocket():void
		{
			cleanUpSocket();
		}
		
		private function cleanUpSocket():void
		{
			if(_socket != null)
			{
				trace("소켓_____>>     초기화");
				if(_socket.connected)
					_socket.close();
				
				_socket = null;
			}
		}
	}
}