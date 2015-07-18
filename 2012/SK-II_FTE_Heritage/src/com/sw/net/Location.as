package com.sw.net
{
	import flash.display.Sprite;
	import flash.system.Capabilities;

	/**
	 * 플레이어 환경 정의 클래스<br>
	 * $local 	:: 플래쉬 플레이어로 플레이중일때 반환할 문자열<br>
	 * $web		::	웹상에서 볼때 반환할 문자열<br>
	 * <p>ex : Location.setURL("local","web");
	 * */
	public class Location
	{	
		/**	생성자	*/
		public function Location()
		{	
		}
		
		/**
		 * 플레이어 상황에 따라 문자열 반환
		 * @param $local 	:: 플래쉬 플레이어로 플레이중일때 반환할 문자열
		 * @param $html		::	로컬의 html상으로  볼때 반환할 문자열
		 * @param $web		::	웹상에서 볼때 반환할 문자열
		 * @return ::
		 */		
		static public function setURL($local:String= "",$html:String= "",$web:String= "none" ):String
		{
			if($web == "none") $web = $html;
			/*
			if( new RegExp("file://").test( loaderInfo.url  ) ) 
			{
				return $web;
			}
			else
				*/
			if( Capabilities.playerType == "StandAlone" ||
				 Capabilities.playerType == "External")
			{
				return $local;
			}
			else 
			{
				return $html;
			}
		}
		
		/**	
		 * 소멸자	
		 * */
		public function destroy():void
		{		}
	}//class
}//package