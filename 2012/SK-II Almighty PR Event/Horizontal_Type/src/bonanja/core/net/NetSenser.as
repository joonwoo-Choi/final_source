
/*
인터넷 연결 상태 감지하기
*/


package bonanja.core.net
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	

	public class NetSenser extends Sprite
	{

		private var _netLoader  :URLLoader;
		private var _netRequest :URLRequest;
		private var _callback   :Function;
		
		
		//생성자
		public function NetSenser( $netURL:String, $callback:Function )
		{
			this._callback = $callback;
//			NativeApplication.nativeApplication.addEventListener( Event.NETWORK_CHANGE, this.onNetworkChange )
			this.netStatusInit( $netURL );
		}
		
		//핑확인
		public function ping():void
		{
			trace(">> NetStatus === 핑 확인 ")
			this._netLoader.load( this._netRequest );
			return;
		}
		
		
		//소멸자
		public function destroy():void{
//			NativeApplication.nativeApplication.removeEventListener( Event.NETWORK_CHANGE, this.onNetworkChange )
			this._netLoader.removeEventListener( HTTPStatusEvent.HTTP_STATUS,  this.onHttpStatus );
			this._netLoader.removeEventListener( IOErrorEvent.IO_ERROR,        this.onError      );
			this._netLoader  = null
			this._netRequest = null
			this._callback   = null
			return
		}
		

		//초기화
		private function netStatusInit( $netURL:String ):void
		{
			this._netRequest        = new URLRequest();
			this._netRequest.url    = $netURL;
			this._netRequest.method = URLRequestMethod.GET;
		
			this._netLoader = new URLLoader();
			this._netLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS,  this.onHttpStatus );
			this._netLoader.addEventListener( IOErrorEvent.IO_ERROR,        this.onError      );
			this._netLoader.load(new URLRequest($netURL));
			trace($netURL);
			return;
		}		
		

		/*private function onNetworkChange( e:Event ):void
		{
			this.ping();
			return;
		}*/
		
		
		private function onHttpStatus( e:HTTPStatusEvent ):void
		{
			var obj:Object = new Object();
				obj.type   = "HttpStatus";

			switch ( e.status ) {
				case 0 :
					//오프라인
					obj.status = "offline";
					break;
				default :
					//온라인
					obj.status = "online";
					break;
			}
			this._callback( obj );
			trace("연결 상태_____: " + obj.status);
			return
		}
		
		
		private function onError( e:IOErrorEvent ):void
		{
			trace("error");
			var obj:Object  = new Object();
				obj.type    = "Error";
				obj.status    = "Error";//현재 상태
			trace("연결 에러_____: " + obj.status)
			this._callback( obj );
			return;
		}
	}
}