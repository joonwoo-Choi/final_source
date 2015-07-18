package net
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.system.System;

	/**		
	 *	SK2_Hersheys :: 시계, 날씨 데이터 로더
	 */
	public class LoaderClockWeather
	{
		private var loader:URLLoader;
		private var _fnc:Function;
		private var url:String;
		private var request:URLRequest;
		
		/**	생성자	*/
		public function LoaderClockWeather(fnc:Function)
		{
//			http://hertest.purepitera.co.kr/Process/GetWeather.ashx?rtype=weather
//			rtype으로
//			weather / time /both
			
			_fnc = fnc;
			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR,loadData);
			loader.addEventListener(Event.COMPLETE,onLoadComplete);
		}
		private function loadData(e:Event = null):void
		{
			trace("날씨,시계데이터 로드");
			System.useCodePage = false;
			loader.load(request);
		}
		/**	데이터 로드	*/
		public function load(str:String):void
		{
			url = Global.getIns().dataURL+"Process/GetWeather.ashx";
			request = new URLRequest(url+"?rtype="+str+"&ran="+Math.round(Math.random()*10000));
			Security.allowDomain("*");
			loadData();
		}
		/**	로드 완료된 데이터 반환	*/
		private function onLoadComplete(e:Event):void
		{
			_fnc(loader.data as String);
			//trace(loader.data);
		}
		
	}//class
}//package