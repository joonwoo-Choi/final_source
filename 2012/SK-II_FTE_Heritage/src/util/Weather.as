package util
{
	import com.greensock.loading.XMLLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	
	import net.LoaderClockWeather;
	
	use namespace xmlns;	
	
	/**
	 *	SK2_Hershy :: 서울 날씨 (싱글톤)
	 */
	public class Weather
	{
		/**	인스턴스	*/
		static private var ins:Weather = new Weather();
		/**	데이터 로더	*/
		private var loader:LoaderClockWeather;
		
		/**	날씨 데이터	*/
		private var _txt:String;
		/**	날씨 데이터 반환 받을 함수	*/
		private var fncAry:Array;
		
		/**	생성자	*/
		public function Weather()
		{
			if(ins != null) throw new Error("Weather는 싱글톤 입니다.");
			init();
		}
		/**	인스턴스 반환	*/
		static public function getIns():Weather
		{	return ins;	}
		
		/**	초기화	*/
		private function init():void
		{
			_txt = "";
			fncAry = [];
			
			if(loader == null)
			{
				loader = new LoaderClockWeather(onLoad);
				loader.load("weather");
			}
		}
		
		/**
		 * 날씨 문자열로 반환
		 * @param fnc	:: 날씨 넘겨 받을 함수 (인자값으로 String을 받아야함)
		 */		
		public function getTxt(fnc:Function):void
		{
			if(_txt != "") fnc(_txt);
			else fncAry.push(fnc);
		}
		
		/**	데이터 로드 완료	*/
		private function onLoad(str:String):void
		{
			_txt = str;
			_txt = _txt.substr(_txt.lastIndexOf("/")+1);
			
			for(var i:int = 0; i<fncAry.length; i++)
			{
				fncAry[i](_txt);
			}
			fncAry = [];
			
			//txt.appendText(xml.body.data[0].wfKor.toString());
			//_txt = xml.body.data[0].wfKor.toString();
			
			/*
			for(var i:int = 0; i<xml.children().children().length(); i++)
			{
				if(xml.children().children()[i].toString() == "서울")
				{
					txt.appendText(xml.children().children()[i].@desc.toString());
					break;
				}	
			}
			*/
		}
		
	}//class
}//package