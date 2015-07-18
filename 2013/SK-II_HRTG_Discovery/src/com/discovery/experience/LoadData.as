package com.discovery.experience
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class LoadData
	{
		private var _urlLdr:URLLoader;
		private var _onComplete:Function;
		
		public function LoadData()
		{
		}
		
		protected function onLoadComplete(event:Event):void
		{
			disposeUrlLoader();
			
			if(_onComplete != null)
			{
				_onComplete.apply(null, [event]);
			}
		}		
		
		private function disposeUrlLoader():void
		{
			_urlLdr.removeEventListener(Event.COMPLETE, onLoadComplete);
			_urlLdr = null;
		}
		
		public function load(url:String, vari:URLVariables, onComplete:Function):void
		{
			var req:URLRequest = new URLRequest(url);
			req.data = vari;
			req.method =URLRequestMethod.POST;
			
			_onComplete = onComplete;
			if(_urlLdr == null)
			{
				_urlLdr = new URLLoader();
				_urlLdr.load(req);
				_urlLdr.addEventListener(Event.COMPLETE, onLoadComplete);
			}
		}
		
		public function close():void
		{
			if(_urlLdr == null) return;
			trace("URL LOADER CLOSE!!!");
			
			try{
				_urlLdr.close();
			}catch(e:Error)
			{
				trace("이미 닫았음...");
			}
			
			disposeUrlLoader();
		}
	}
}