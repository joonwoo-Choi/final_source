package facebook.lunching
{
	import adqua.system.SecurityUtil;
	
	import com.sw.display.BaseIndex;
	
	import facebook.InviteFriends.FB_FriendInvite;
	
	import flash.events.Event;

	[SWF(width="700",height="461",frameRate="30")]	
	public class FB_Lunching extends BaseIndex
	{
		private var $rootUrl:String;
		private var $container:Asset_FB_FriendInvite;
		private var $inviteMain:FriendInviteMain;
		public function FB_Lunching()
		{
			super();
		}
		override protected function onAdd(e:Event):void
		{
			//ContextMenu.setMenu(this);
			super.onAdd(e);
			trace("Global.getIns(): ",Global.getIns());
			Global.getIns().urlType = "facebook";
			$rootUrl = root.loaderInfo.url;
			if(SecurityUtil.isWeb()){
				trace("$rootUrl.indexOf(test): ",$rootUrl.indexOf("test"));
				if($rootUrl.indexOf("test")==-1){
					Global.getIns().dataURL="http://www.purepitera.co.kr"
				}else{
					Global.getIns().dataURL="http://hertest.purepitera.co.kr"
				}
				trace("Global.getIns().dataURL: ",Global.getIns().dataURL);
			}else{
				Global.getIns().dataURL="http://hertest.purepitera.co.kr";
			}
			$container = new Asset_FB_FriendInvite();
			$container.mcBg.mcLunching.alpha=1;
			$container.y = -134;
			addChild($container);
			
			$inviteMain = new FriendInviteMain($container, Asset_FB_FriendInvite,"F");
			init();
			
		}		
		/**	소멸자	*/
		override public function destroy(e:Event=null):void
		{
			super.destroy(e);
			$inviteMain.destroy();
			$inviteMain = null;
		}			
	}
}