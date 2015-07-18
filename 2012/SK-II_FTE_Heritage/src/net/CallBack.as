package net
{
	import com.sw.net.FncOut;
	import com.sw.net.Location;
	
	import event.MovieEvent;
	
	import flash.external.ExternalInterface;

	/**		
	 *	SK2_Hershys :: 콜백 함수
	 */
	public class CallBack
	{
		/**	코멘트 콜백 내용	*/
		static public const COMMENT:String = "CallbackComment";
		/**	친구 초대 페이스북 콜백 	*/
		static public const FRIEND_FB:String = "CallbackFriendFacebook";
		/**	친구 초대 콜백 	*/
		static public const FRIEND:String = "CallbackFriend";
		/**	투표하기 콜백 	*/
		static public const VOTE:String = "CallbackVote";
		/**	벨소리 받기 콜백	*/
		static public const BELL:String = "CallbackBell";
		/**	다이어트 게릴라 이벤트 글 입력	*/
		static public const EVENT4_COMMENT:String = "CallbackEventComment";
		
		/**	Q&A 페이스북 비로그인 참여	*/
		static public const QNA_LOGIN:String = "qnaLogin";
		/**	Q&A 페이스북 로그인 참여	*/
		static public const QNA_FACEBOOK:String = "qnaFacebookLogin";
		
		/**	생성자	*/
		public function CallBack()
		{
			init();
		}
		
		/**	초기화	*/
		private function init():void
		{
			if(Location.setURL("local","web") == "local") return;
			
			ExternalInterface.addCallback("loginCallback",loginCallback);
			ExternalInterface.addCallback("loginFbCallback",loginCallbackFb);
		}
		
		private function loginCallbackFb():void
		{
			// TODO Auto Generated method stub
			trace("loginCallBackFBBBBBBBBBBBB================");
			Global.getIns().fbLoginChk = "loginFB";
			Global.getIns().dispatchEvent(new MovieEvent(Global.getIns().callbackSate));
		}
		/**	로그인 콜백	*/
		public function loginCallback():void
		{
			trace("loginCallBack..........................................");
			//FncOut.call("alert","flash:loginCallback");
			Global.getIns().dispatchEvent(new MovieEvent(Global.getIns().callbackSate));
		}
	}//class
}//package