package com.sw.net.list
{
	import com.sw.net.FncOut;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * 데이터 보내고 결과값 받아 오는 클래스
	 * */
	public class Write
	{
		private var req:URLRequest;
		private var bTest:Boolean;
		
		protected var loader:URLLoader;
		protected var fnc:Function;
		protected var data:Object;
		
		/**	결과 내용 변수명 초기값 'result='	*/
		protected var resultTxt:String;
		
		/**	
		 * 생성자
		 * 	
		 * @param $url	::요청 경로
		 * @param $fnc	::완료후 반환 콜백 함수
		 * @param $data	::같이 실어서 넘길 데이터
		 */
		public function Write($url:String,$fnc:Function,$data:Object=null)
		{
			data = $data;
			if(data == null ) data = new Object();
			bTest = (data.test != null) ? (data.test) : (false);
			
			req = new URLRequest($url);
			fnc = $fnc;
			init();
		}

		/**
		 * 초기화
		 * */
		private function init():void
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,onLoad);
			
			resultTxt = "result=";
			if(data.resultTxt != null) resultTxt = data.resultTxt;
		}
		/**
		 * 데이터 보내기 <br>
		 * ex	:: send({txt:"aaa"},URLRequestMethod.POST)
		 * @param $data		:: 같이 실어 보낼 데이터 내용 (object)
		 * @param $method	:: 데이터 타입
		 */
		public function send($data:Object=null,$method:String = ""):void
		{
			if($method == "") $method = URLRequestMethod.POST;
			req.method = $method;
			var vari:URLVariables = new URLVariables();
			vari.ran = Math.round(Math.random()*10000);
			trace("Global.getIns().accessToken: ",Global.getIns().accessToken);
//			vari.fbAtoken = Global.getIns().accessToken;
//			vari.fbAtoken = "AAAEnhiBKwk8BAMXjj4lPp1WJZCHz2JPCAv95dDYJbXH6OjnbYg7GcloxnYJJJRbwPO7JksKfP5uWuCbW51PNQSib1OqprbziToacajGUAlBldjITL";
			if($data != null) 
			{
				for(var txt:String in $data) vari[txt] = $data[txt];
			}
			req.data = vari;
			loader.load(req);
		}
		
		/**	결과 내용 String으로 반환	*/
		public function getResultText():String
		{
			var txt:String = loader.data as String;
			return txt;
		}
		/**	로더 결과 data 내용 반환	*/
		public function getData():Object
		{	
			if(loader == null) return null;
			return loader.data;	
		}
		/**
		 * 데이터 받오고 난후
		 * */
		protected function onLoad(e:Event):void
		{
			var txt:String = loader.data as String;
			if(bTest == true) FncOut.call("alert",txt.substr(7));
			
			fnc(txt.substr(resultTxt.length));
		}
		
		/**	소멸자	*/
		public function destroy():void
		{
			loader.removeEventListener(Event.COMPLETE,onLoad);
			loader = null;
		}
		
	}//class
}//package