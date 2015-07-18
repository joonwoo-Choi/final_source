package com.sk2.net
{
	import com.sk2.sub.PITERA_STORY_EPILOGUE;
	import com.sk2.sub.PITERA_STORY_EVENT;
	import com.sk2.sub.PITERA_STORY_EVENT1;
	import com.sk2.sub.PITERA_STORY_EVENT2;
	import com.sk2.sub.PITERA_STORY_TOUR;
	import com.sk2.utils.DataProvider;
	import com.sw.net.FncOut;
	import com.sw.net.Location;
	
	import flash.external.ExternalInterface;
	
	/**
	 * SK2  :	콜백 함수
	 * */
	public class CallBack
	{
		/**	콜백 부를 때 상태	*/
		public var state:String;
		
		/**	글쓰기	*/
		public const WRITE:String = "write";
		/**	이벤트1 참여	*/
		public const EVT1:String = "evt1";
		/**	트위터 글쓰기	*/
		public const TWIT:String = "twit";
		/**	수정	*/
		public const EDIT:String = "edit";
		/**	삭제	*/
		public const DEL:String = "del";
		/**	자신이 등록한 리스트		*/
		public const MY:String = "my";
		
		
		/**	신청하기 글쓰기	*/
		public const EVT1_WRITE:String = "evt1_write";
		/**	후기 글쓰기	*/
		public const EVT2_WRITE:String = "evt2_write";
		/**	후기 리스트 로드	*/
		public const EVT2_LIST:String = "evt2_list";
		
		/**	로그인 유무	*/
		public var login:Boolean;
		
		/**	생성자	*/
		public function CallBack()
		{
			init();
		}
		/**	소멸자	*/
		public function destroy():void
		{		}
		/**
		 * 초기화
		 * */
		private function init():void
		{
			login = false;
			state = "none"
			if(Location.setURL("swf") != "swf")
			{
				ExternalInterface.addCallback("loginCallback",loginCallback);
				ExternalInterface.addCallback("evt2Callback",evt2Callback);
			}
		}
		/**	로그인 콜백 호출	*/
		public function loginCallback():void
		{
			login = true;
			//FncOut.call("alert",state);
			switch(state)
			{
				case WRITE:		//이벤트2 글쓰기
					PITERA_STORY_EPILOGUE(DataProvider.loader.subObj).sendWrite();	
				break;
				case TWIT:
					
				break;
				case MY:		//이벤트2 자신이 등록한 글보기
					PITERA_STORY_EPILOGUE(DataProvider.loader.subObj).loadMyList();
				break;
				case EVT1:		//이벤트1 등록 완료
					PITERA_STORY_TOUR(DataProvider.loader.subObj).sendWrite();
					break;
				case EDIT:
				
				break;
				case DEL:
					
				break;
				case EVT1_WRITE:	//신청하기 글쓰기
					PITERA_STORY_EVENT1(DataProvider.loader.subObj).sendWrite();
				break;
				case EVT2_WRITE:	//후기 글쓰기
					PITERA_STORY_EVENT2(DataProvider.loader.subObj).clickWrite();
				break;
				case EVT2_LIST:		//후기 리스트 다시 로드
					PITERA_STORY_EVENT2(DataProvider.loader.subObj).loadList("first");
				break;
			}
			DataProvider.loader.navi.util.setLogin(true);
		}
		
		/**	후기등록 콜백 함수	*/
		public function evt2Callback():void
		{
			PITERA_STORY_EVENT2(DataProvider.loader.subObj).loadList("list");
		}
		
	}//class
}//package