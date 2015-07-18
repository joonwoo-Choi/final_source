package contents.qnaevent.step
{
	import contents.qnaevent.QnAGlobal;
	import contents.qnaevent.step.friendinvite.FriendInviteMain;
	
	import flash.display.MovieClip;
	
	import net.HersheysFncOut;
	
	/**		
	 * SK2_Hersheys :: Q&A 친구 추천
	 */
	public class QnAFriend extends BaseQnAStep
	{
		/**	그래픽	*/
		private var container:QnAFriendClip;
		/**	메인 스크립트 내용	*/
		private var inviteMain:FriendInviteMain;
		
		/**	생성자	*/
		public function QnAFriend(mc:MovieClip=null)
		{
			container = new QnAFriendClip();
			
			inviteMain = new FriendInviteMain(container,QnAFriendListClip);
			super(container);
			if(QnAGlobal.getIns().bFacebook == false) HersheysFncOut.qnaLoginFB();
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			inviteMain.destroy();
			inviteMain = null;
		}
	}//class
}//package