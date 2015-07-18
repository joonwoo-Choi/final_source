package contents.guerilla
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.sw.buttons.Button;
	import com.sw.display.AlignBitmap;
	import com.sw.display.Remove;
	import com.sw.net.FncOut;
	import com.sw.net.Location;
	import com.sw.net.list.BaseList;
	
	import event.MovieEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.CallBack;
	
	/**		
	 *	SK2_Hersheys :: 발렌타인데이 >> 게릴라 이벤트 >> 친구초대 하기 >> 친구 리스트
	 */
	public class GuerillaSeason1List extends BaseList
	{
		private var viewMc:MovieClip;
		private var btnMc:MovieClip;
		private var setPage:Function;
		
		/**	사용자 정보	*/
		public var userData:Object;
		/**	친구 정보	*/
		public var selFriend:Array;
		/**	선택한 친구 수	*/
		private var selCnt:int;
		
		/**	썸네일 이미지 로더	*/
		private var loader:LoaderMax;
		/**	친구 리스트 xml	*/
		private var xml:XML;
		
		/**	친구 리스트 슬라이드 차이	*/
		private var slideGap:int;
		
		/**	생성자	*/
		public function GuerillaSeason1List($scope:Object, $url:String, $data:Object)
		{
			super($scope, $url, $data);
			viewMc = $scope as MovieClip;
			btnMc = $data.btnMc as MovieClip;
			setPage = $data.setPage as Function;
			
			init();
			initObject();
			setBtn();
		}
		/**	초기화	*/
		override protected function init($bLoad:Boolean=true):void
		{
			super.init($bLoad);
			
			selFriend = [];
			
			for(var i:int = 1; i<=5; i++)
			{
				var sel:MovieClip = btnMc["btnImgSel"+i] as MovieClip;
				if(sel == null) continue;
				
				Button.setUI(sel,{over:onOverSel,out:onOutSel,click:onClickSel});
			}
		}
		
		public function initObject():void
		{
			selCnt = 0;
			pageNo = 1;
			
			for(var i:int = 1; i<=5; i++)
			{
				var sel:MovieClip = btnMc["btnImgSel"+i] as MovieClip;
				sel.userName = "";
				sel.userId = "";
				Remove.child(sel.view.imgMc);
			}
			
			viewMc.btnScroll.dotMc.x = 0;
			viewMc.btnScroll.barMc.x = 0;
			viewMc.listMc.x = viewMc.maskMc.x;
			
			btnMc.btnScroll.dotMc.x = 0;
			btnMc.btnScroll.barMc.x = 0;
			btnMc.listMc.x = btnMc.maskMc.x;
			
			initLoader();
		}
		/**	버튼 셋팅	*/
		private function setBtn():void
		{
			//선택 완료 버튼
			MovieClip(btnMc.btn1).addEventListener(MouseEvent.CLICK,onClickComplete);
			var dotMc:MovieClip = btnMc.btnScroll.dotMc as MovieClip;
			dotMc.buttonMode = true;
			
			dotMc.addEventListener(MouseEvent.MOUSE_DOWN,onDownDot);
			dotMc.addEventListener(MouseEvent.MOUSE_UP,onUpDot);
		}
		private function onDownDot(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			slideGap =  btnMc.btnScroll.mouseX - mc.x;
				
			btnMc.addEventListener(Event.ENTER_FRAME,onEnterDot);
			btnMc.stage.addEventListener(MouseEvent.MOUSE_UP,onUpDot);
		}
		private function onUpDot(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			btnMc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUpDot);
			btnMc.removeEventListener(Event.ENTER_FRAME,onEnterDot);
		}
		private function onEnterDot(e:Event):void
		{
			var dotMc:MovieClip = btnMc.btnScroll.dotMc as MovieClip;
			var bgMc:MovieClip = btnMc.btnScroll.bgMc as MovieClip;
			var barMc:MovieClip = btnMc.btnScroll.barMc as MovieClip;
			
			dotMc.x = btnMc.btnScroll.mouseX - slideGap;
			
			if(dotMc.x < 0) dotMc.x = 0;
			if(dotMc.x > bgMc.width) dotMc.x = bgMc.width;
			
			var pos:int = -((dotMc.x/bgMc.width)*(btnMc.listMc.width-btnMc.maskMc.width))+btnMc.maskMc.x;
			btnMc.listMc.x -= (btnMc.listMc.x - pos)*0.4;
			viewMc.listMc.x -= (viewMc.listMc.x - pos)*0.4;
			
			barMc.x = 
			viewMc.btnScroll.barMc.x = 
			viewMc.btnScroll.dotMc.x = dotMc.x;
			
		}
		/**	리스트 로드	*/
		public function loadList():void
		{
			if(xml != null) return;
			
			load();
		}
		/**	데이터 로드 완료	*/
		override protected function onNoneList():void
		{
			xml = getXML();
			
//			trace(xml);
			
			if(xml.Result.toString() != "OK") 
			{
				Global.getIns().callbackSate = CallBack.FRIEND_FB;
				FncOut.call("fbLoginChk");
				setPage(-1);
				return;
			}
			listTotal = xml.FriendsList.FriendData.length();
			pageCnt = Math.ceil(listTotal/7);
			setUser();
			
//			FncOut.call("alert",pageCnt);
//			testShowBtn();
			setList();
		}
		/**	본인 데이터 저장	*/
		private function setUser():void
		{
			userData = new Object();
			userData.userId = xml.User.Id.toString();
			userData.userName = xml.User.Name.toString();
		}
		/**	리스트 내용 셋팅	*/
		private function setList():void
		{
			initLoader();
			
			if(xml.Result.toString() != "OK") return;
			
			loader = new LoaderMax({auditSize:false,maxConnections:7});
			var start:int = ((pageNo-1)*7)-1;
			
			for(var i:int = 0; i< listTotal; i++)
			{
				var viewList:J25KeyImgMcClip = createList(viewMc.listMc,i,true);	
				var btnList:J25KeyImgMcClip = createList(btnMc.listMc,i,false);	
				
				btnList.alpha = 0;
				btnList.view = viewList;
				Button.setUI(btnList,{over:onOverThumb,out:onOutThumb,click:onClickThumb});
			}
			
			loader.load();
			
			if(listTotal <= 7) 
			{
				btnMc.btnScroll.dotMc.visible = false;
				viewMc.btnScroll.dotMc.visible = false;
			}
		}
		private function createList(listMc:MovieClip,num:int,view:Boolean):J25KeyImgMcClip
		{
			var list:J25KeyImgMcClip = new J25KeyImgMcClip();
			list.name = "list"+num;
			var listXml:XML = xml.FriendsList.FriendData[num] as XML;
			
			list.x = num*50;
			list.overMc.scaleX =
			list.overMc.scaleY = 1.2;
			list.overMc.alpha = 1;
			
			listMc.addChild(list);
			
			if(view == false)
			{
				list.userName = listXml.Name.toString();
				list.userId = listXml.Id.toString();
				
				return list;
			}
			
			var imgLoader:ImageLoader = new ImageLoader(listXml.ProfileImageUrl.toString(),{onComplete:onLoadThumb,name:list.name});
			loader.append(imgLoader);
			
			return list;
		}
		/**	썸네일 로드 완료	*/
		private function onLoadThumb(e:LoaderEvent):void
		{
			var imgLoader:ImageLoader = e.target as ImageLoader;
			var listMc:MovieClip = viewMc.listMc as MovieClip;
			var list:MovieClip = listMc.getChildByName(imgLoader.name) as MovieClip;
			
			var bit:Bitmap = imgLoader.rawContent as Bitmap;
			bit = AlignBitmap.go(bit,list.planeMc.width,list.planeMc.height);
			
			bit.alpha = 0;
			list.imgMc.addChild(bit);
			TweenMax.to(bit,1,{alpha:1});
		}
		
		/**	로더 초기화	*/
		private function initLoader():void
		{
			if(xml == null)
			{
				Remove.child(viewMc.listMc);
				Remove.child(btnMc.listMc);
			}
			
			if(loader == null) return;
			loader.dispose();
			loader.unload();
			loader = null;
		}
		
		/**	테스트용 버튼 위치 보여지기	*/
		private function testShowBtn():void
		{
			btnMc.btnPage1.alpha = 1;
			btnMc.btnPage2.alpha = 1;
			btnMc.btnPage1.planeMc.alpha = 0.5;
			btnMc.btnPage2.planeMc.alpha = 0.5;		
		}
		/**	선택 리스트 오버	*/
		private function onOverSel(mc:MovieClip):void
		{
			if(mc.userName == "") return;
			TweenMax.to(mc.view.imgX,0.4,{alpha:1});
		}
		/**	선택 리스트 아웃	*/
		private function onOutSel(mc:MovieClip):void
		{
			TweenMax.to(mc.view.imgX,0.4,{alpha:0});
		}
		/**	선택 리스트 클릭	*/
		private function onClickSel(mc:MovieClip):void
		{
			if(mc.userName == "") return;	
			mc.userName = "";
			mc.userId = "";
			Remove.child(mc.view.imgMc);
			
			selCnt--;
		}
		/**	썸네일 리스트 오버	*/
		private function onOverThumb(mc:MovieClip):void
		{
			if(mc.userName == "") return;
			
			TweenMax.to(mc.view.overMc,0.4,{scaleX:1,scaleY:1,ease:Expo.easeOut});
		}
		/**	썸네일 리스트 아웃	*/
		private function onOutThumb(mc:MovieClip):void
		{
			TweenMax.to(mc.view.overMc,0.4,{scaleX:1.2,scaleY:1.2,ease:Expo.easeOut});
		}
		/**	썸네일 리스트 클릭	*/
		private function onClickThumb(mc:MovieClip):void
		{
			if(mc.userName == "") return;
			
			if(selCnt >= 5)
			{	//갯수 제한
				FncOut.call("alert","이미 친구 5명을 선택 하였습니다.");
				return;
			}
			var i:int;
			var sel:MovieClip;
			
			for(i = 1; i<=5; i++)
			{	//중복 제거
				sel = btnMc["btnImgSel"+i] as MovieClip;
				if(sel.userName == mc.userName) return;
			}
			for(i = 1; i<=5; i++)
			{	//선택 내용 적용
				sel = btnMc["btnImgSel"+i] as MovieClip;
				
				if(sel.userName != "") continue;
				
				var bitData:BitmapData = new BitmapData(mc.view.planeMc.width,mc.view.planeMc.height,false);
				bitData.draw(mc.view.imgMc);
				var bit:Bitmap = new Bitmap(bitData);
//				bit.alpha = 0;
				Remove.child(sel.view.imgMc);
				
				sel.view.imgMc.addChild(bit);
//				TweenMax.to(bit,1,{alpha:1});
				
				sel.userName = mc.userName;
				sel.userId = mc.userId;
				
				selCnt++;
				break;
			}
		}
		
		/**	선택 완료	*/
		private function onClickComplete(e:MouseEvent):void
		{
			selFriend = [];
			for(var i:int = 1; i<=5; i++)
			{
				var sel:MovieClip = btnMc["btnImgSel"+i] as MovieClip;
				
				if(sel.userName == "") continue;
				selFriend.push(sel);
			}
			if(selFriend.length == 0) 
			{
				FncOut.call("alert","친구를 선택해 주세요.");
				
				if(Location.setURL("local","") != "local") return;
			}
			
			setPage(1);
		}
		/**	페이지 이동 버튼	*/
		private function onClickPage(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
//			trace(mc.idx);
			
			if(mc.idx == 1)	pageNo--;
			if(mc.idx == 2) pageNo++;
			if(pageNo < 1) pageNo = 1;
			if(pageNo > pageCnt) pageNo = pageCnt;
			
			setList();
		}
	}//class
}//package