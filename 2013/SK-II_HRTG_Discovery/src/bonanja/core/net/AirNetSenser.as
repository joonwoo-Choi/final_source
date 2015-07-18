
/*
인터넷 연결 상태 감지하기
*/


package bonanja.core.net
{
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	

	public class AirNetSenser extends Sprite
	{
		private var _netLoader  :URLLoader;
		private var _netRequest :URLRequest;
		
		private var _netURL     :String;
		private var _callback   :Function;
		
		private var _netStatus  :Boolean;
		
		//생성자
		public function AirNetSenser( $netURL:String, $callback:Function )
		{
			this._netURL    = $netURL;
			this._callback  = $callback;
			this._netStatus = false
			//this.netStatusInit( $netURL );
		}
		
		//준비하기
		public function ready() :void
		{
			if( !this._netStatus ){
				NativeApplication.nativeApplication.addEventListener( Event.NETWORK_CHANGE, this.onNetworkChange )
			
				this._netRequest        = new URLRequest();
				this._netRequest.url    = this._netURL
				this._netRequest.method = URLRequestMethod.HEAD
		
				this._netLoader = new URLLoader();
				this._netLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS,  this.onHttpStatus );
				this._netLoader.addEventListener( IOErrorEvent.IO_ERROR,        this.onIoError    );
				this._netStatus = true;
			}
			return;
		}	
		

		//핑확인
		public function ping() :Boolean
		{
			if( this._netStatus ){
				trace(">> NetStatus === 핑 확인 ")
				this._netLoader.load( this._netRequest );
			}
			return this._netStatus;
		}
		
		
		//소멸자
		public function destroy() :void
		{
			NativeApplication.nativeApplication.removeEventListener( Event.NETWORK_CHANGE, this.onNetworkChange )
			this._netLoader.removeEventListener( HTTPStatusEvent.HTTP_STATUS,  this.onHttpStatus );
			this._netLoader.removeEventListener( IOErrorEvent.IO_ERROR,        this.onIoError    );
			this._netLoader  = null;
			this._netRequest = null;
			this._callback   = null;
			this._netStatus  = false;
			return
		}
		

		private function onNetworkChange( e:Event ) :void
		{
			this.ping();
			return;
		}
		
		
		private function onHttpStatus( e:HTTPStatusEvent ) :void
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
			return
		}
		
		
		private function onIoError( e:IOErrorEvent ) :void
		{
			var obj:Object  = new Object();
				obj.type    = "Error";//현재 상태
			this._callback( obj );
			return;
		}
	}
}