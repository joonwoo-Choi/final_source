package microsite.InviteFriends
{
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.sw.buttons.Button;
	import com.sw.display.AlignBitmap;
	import com.sw.net.FncOut;
	import com.sw.net.list.BaseList;
	import com.sw.ui.ImgView;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.text.TextFieldAutoSize;
	
	/**		
	 *	SK2_Hersheys :: Q&A 친구 초대 리스트
	 */
	public class SiteFriendInviteList extends BaseList
	{
		private var $xml:XML;
		/**	그래픽	*/
		private var container:MovieClip;
		/**	친구 총 수	*/
		private var cnt:int;
		/**	사용자 데이터	*/
		private var userData:Object;
		/**	스크롤 기능	*/
		private var imgView:ImgView;
		/**	리스트 내용	*/
		private var mcList:MovieClip;
		/**	선택 갯수	*/
		private var selectCnt:int;
		/**	선택 최대 갯수	*/
		private var selectMax:int;
		/**	글로벌	*/
		private var $global:Global;
		/**	로드 Boolean	*/
		private var $loadIs:Boolean = true;
		
		/**	생성자	*/
		public function SiteFriendInviteList($scope:Object,$obj:Object)
		{
			$global = Global.getIns();
			selectCnt = 0;
			selectMax = 5;
			container = $scope as MovieClip;
			mcList = container.mcList;
			userData = new Object();
			
			container.mcLoadingFriend.visible = false;
			//var url:String = "";
			
			var url:String
			if(SecurityUtil.isWeb()){
				url = Global.getIns().dataURL+"/Process/FBFriendList.ashx";
			}else{
				url = "xml/friendsList.xml";
			}

			trace("url11111: ",url);
			super($scope, url, $obj);
			
			if(ExternalInterface.available)ExternalInterface.addCallback("microFlashCB",microFlashCB);
			init();
//			if(!SecurityUtil.isWeb())load();
			
//			$global.addEventListener( GlobalEvent.CENTER_BUTTON ,listLoad );
		}
		
		protected function listLoad(e:Event):void
		{
			if( $global.centerBtnNum == 1 && $loadIs == true ) 
			{
				microFlashCB("aaaaaaaaaaaaa");
//				load();
//				$loadIs = false;
			}
		}
		
		private function microFlashCB(fbAtoken:String):void
		{
			Global.getIns().accessToken = fbAtoken;
			$global.dispatchEvent( new Event( GlobalEvent.CENTER_BUTTON ));
//			$global.dispatchEvent( new Event( GlobalEvent.FACEBOOK_POPUP ));
			if( $global.centerBtnNum == 1 && $loadIs == true ) 
			{
				container.mcLoadingFriend.visible = true;
				container.mcLoadingFriend.play();
				
				load();
				$loadIs = false;
			}
			trace( "fbAtoken: ",fbAtoken );
//			if( ExternalInterface.available ) ExternalInterface.call( "alert" , "토큰값: "+fbAtoken );
		}
		
		/** 친구 초대 최대 갯수 반환	*/
		public function getMax():int
		{	return selectMax;	}
		
		/**	초기화	*/
		override protected function init($bLoad:Boolean=true):void
		{
			super.init($bLoad);
			
			var obj:Object = new Object();
			obj.mask = container.mcMask;
			obj.img = mcList;
			obj.scroll = container.mcScroll;
			obj.speed = 0.3;
			trace("obj: ",obj);
			
			imgView = new ImgView(container,[],obj);
			
			imgView.doingScroll();
		}
		/**	외부에서 로드 요청	*/
		override public function loadData($obj:Object = null,$method:String = ""):void
		{
			load($obj,$method);
		}
		/**	사용자 데이터 반환	*/
		public function getUserData():Object
		{	return userData;	}
		/**	친구 데이터 정렬	*/
		override protected function onNoneList():void
		{
			$xml = getXML();
			
			//			trace(xml);
			if($xml.Result != "OK")
			{
				trace("facebook 로그인 되어 있지 않음.");
				if(ExternalInterface.available) ExternalInterface.call( "fbLogin" );
				return;
			}
			
			cnt = $xml.FriendsList.FriendData.length();
			
			userData.uName = $xml.User.Name.toString();
			userData.uId = $xml.User.Id.toString();
			//			trace(cnt);
			for(var i:int =0; i<cnt; i++)
			{
				var cXML:XML = $xml.FriendsList.FriendData[i];
				trace(cXML);
				var list:listClip = new listClip;
//				var thumbClass:Class = data.thumb as Class;
//				var list:MovieClip = new thumbClass();
				
				list.listIdx = i;
				
				list.uName = cXML.Name.toString();
				list.idx = int(cXML.Id.toString());
				list.uId = cXML.Id.toString();
				list.name = "list"+i;
				trace(list);
				var file:String = cXML.ProfileImageUrl.toString();
				
				list.txt.autoSize = TextFieldAutoSize.LEFT;
				list.txt.text = cXML.Name.toString()+ "님";
				
				list.mcOver.alpha = 0;
				
				var loader:ImageLoader = new ImageLoader(file,{onComplete:onLoadThumb,name:list.name,auditSize:false});
				loader.load();
				mcList.addChild(list);
				
				if(i < 6)
				{	//상단 6개만 등장 모션
					list.alpha = 0;
					TweenMax.to(list,1,{delay:i*0.1,alpha:1});
				}
				
				Button.setUI(list,{click:onClickList});
			}
			
			sortList();
		}
		
		/**	친구 리스트 썸네일 이미지 적용	*/
		private function onLoadThumb(e:LoaderEvent):void
		{
			var loader:ImageLoader = e.target as ImageLoader;
			var bit:Bitmap = loader.rawContent as Bitmap;
			var list:MovieClip = mcList.getChildByName(loader.name) as MovieClip;
			
			bit = AlignBitmap.go(bit,list.mcThumb.width,list.mcThumb.height);
			bit.alpha = 0;
			list.mcThumb.addChild(bit);
			
			TweenMax.to(bit,1,{alpha:1});
			
			loader.dispose();
			loader.unload();
			loader = null;
			
			container.mcLoadingFriend.visible = false;
			container.mcLoadingFriend.gotoAndStop(1);
		}
		/**	리스트 정렬	 
		 * @param type :: total, select, search
		 * @param searchStr :: 검색 텍스트
		 */
		public function sortList(type:String="total",searchStr:String=""):void
		{
			var num:int = -1;
			for(var i:int =0; i<cnt; i++)
			{
				var list:MovieClip = mcList.getChildByName("list"+i) as MovieClip;
				
				if(type == "total")
				{	//전체 리스트
					viewList(list,i);
				}
				if(type == "select")
				{	//선택된 리스트
					if(list.select == true)
					{
						num++;
						viewList(list,num);
					}
					else hideList(list);
				}
				if(type == "search")
				{	//검색 리스트
					var str:String = list.uName as String;
					if(str.lastIndexOf(searchStr) != -1)
					{
						num++;
						viewList(list,num);
					}
					else hideList(list);
				}
			}
			
			imgView.doingScroll();
			
			TweenMax.to(container.mcScroll.dot_mc,0.7,{y:0,ease:Expo.easeOut});
			TweenMax.to(mcList,0.7,{y:0,ease:Expo.easeOut});
		}
		/**	선택된 친구 리스트 mc 배열로 반환	*/
		public function getSelectFriend():Array
		{
			var ary:Array = [];
			for(var i:int =0; i<cnt; i++)
			{
				var list:MovieClip = mcList.getChildByName("list"+i) as MovieClip;
				if(list.select == true) ary.push(list);
			}
			return ary;
		}
		/**	보이는 리스트 위치 적용	*/
		public function viewList(list:MovieClip,num:int):void
		{
			list.x = (num%3)*list.mcArea.width//172;
			list.y = (Math.floor(num/3)*(list.mcArea.height-5))+11//42)+11;
			list.visible = true;
		}
		/**	안보이는 리스트 적용	*/
		public function hideList(list:MovieClip):void
		{
			list.visible = false;
			list.x = 0;
			list.y = 0;
			
		}
		/**	리스트 클릭	*/
		private function onClickList(mc:MovieClip):void
		{
			if(mc.select != true)
			{
				//선택할수 있는 친구 모두를 선택
				if(selectCnt == selectMax)
				{
					FncOut.call("alert","5명의 친구를 모두 선택 하였습니다.");
					return;
				}
				selectCnt++;
				mc.select = true;
				mc.mcOver.alpha = 1;
				mc.txt.textColor = 0xBA2641;
			}
			else
			{
				selectCnt--;
				mc.select = false;
				mc.mcOver.alpha = 0;
				mc.txt.textColor = 0xffffff;
			}
			data.change(selectCnt);
		}
	}//class
}//package