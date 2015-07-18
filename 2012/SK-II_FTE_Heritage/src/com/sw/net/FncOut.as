package com.sw.net
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * //외부 함수 실행 클래스<br>
	 * FncOut.call("alert","aaa");
	 * //외부 링크
	 *	FncOut.link("www.naver.com","_blank");
	 * */
	public class FncOut
	{
		/** 	생성자		*/
		public function FncOut()
		{}
		/**	소멸자	*/
		public function destroy():void
		{		}
		/**
		 * 플레이어 상태 체크
		 * @return		::		true:웹,false:로컬
		 * 
		 */		
		static public function checkPlayer():Boolean
		{
			var state:String = Location.setURL("swf");
			if(state == "swf") return false;
			return true;
		}
		/**
		 * 외부 함수 호출
		 * */
		static public function call($fnc:String,$data1:Object=null,$data2:Object=null,$data3:Object=null,$data4:Object=null):void
		{
			trace("외부함수 : "+$fnc+"("+$data1+","+$data2+","+$data3+","+$data4+")");
			if(!FncOut.checkPlayer()) return;
			
			if($data4 != null)
				ExternalInterface.call($fnc,$data1,$data2,$data3,$data4);
			else if($data3 != null)
				ExternalInterface.call($fnc,$data1,$data2,$data3);
			else if($data2 != null)
				ExternalInterface.call($fnc,$data1,$data2);
			else if($data1 != null)
				ExternalInterface.call($fnc,$data1);
			else if($data1 == null)
				ExternalInterface.call($fnc);
			
		}
		/**	
		 * 외부 주소 링크 
		 * */
		static public function link($url:*, $target:String = "_self"):void
		{      
			trace($url,$target);
			if(!FncOut.checkPlayer()) return;
			var req:URLRequest = $url is String ? new URLRequest($url) : $url;    
	   
			var is_ie:Boolean = Boolean(ExternalInterface.call("function() {if(document.all) return 1; else return 0;}"));     
			if (is_ie) ExternalInterface.call("window.open", req.url, $target);
			else navigateToURL(req, $target);
		}
	}//class
}//package