package facebook.InviteFriends
{
	import adqua.system.SecurityUtil;
	
	import com.sw.display.BaseIndex;
	
	import facebook.InviteFriends.FriendInviteMain;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	[SWF(width="700",height="595",frameRate="30")]
	
	public class FB_FriendInvite extends BaseIndex
	{
		private var $container:Asset_FB_FriendInvite;
		private var $inviteMain:Object;
		private var $rootUrl:String;
		public function FB_FriendInvite()
		{
			super();
			trace("FacebookFriendAppVer!!!!");
			
		}
		override protected function onAdd(e:Event):void
		{
			//ContextMenu.setMenu(this);
			super.onAdd(e);
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