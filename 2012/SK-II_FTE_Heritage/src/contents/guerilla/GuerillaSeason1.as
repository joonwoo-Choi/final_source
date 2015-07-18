package contents.guerilla
{
	import com.ddoeng.as3.Base;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.net.Location;
	import com.sw.net.list.Write;
	
	import event.MovieEvent;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import net.CallBack;
	import net.HersheysFncOut;

	/**		
	 *	SK2_Hersheys :: 발렌타인 데이 게릴라 이벤트
	 */
	public class GuerillaSeason1 extends BaseGuerilla
	{
		/**	페이지 현제 위치	*/
		private var cPos:int;
		/**	친구 리스트	*/
		private var list:GuerillaSeason1List;
		
		private var viewTxt:TextField;
		private var btnTxt:TextField;
		
		/**	기본 문장	*/
		private var baseTxt:String;
		/**	보내고자 하는 메세지	*/
		private var message:String;
		
		
		/**	생성자	*/
		public function GuerillaSeason1($btnMc:MovieClip,$viewMc:MovieClip)
		{
			super($btnMc,$viewMc);
			
			init();
			setMenu();
			
			var url:String = Global.getIns().dataURL+"/Process/FBFriendList.ashx";
			list = new GuerillaSeason1List(viewMc.img2,url,{btnMc:btnMc.img2,setPage:setPage});
			
			setMessageText();
			
			Global.getIns().addEventListener(CallBack.FRIEND_FB,onCallbackFB);
			Global.getIns().addEventListener(CallBack.FRIEND,onCallbackLogin);
		}
		
		/**	개인정보 입력 완료 콜백	*/
		private function onCallbackLogin(e:MovieEvent):void
		{
			var url:String = Global.getIns().dataURL+"/Process/FriendsInvite.ashx";
			
			for(var i:int = 0; i<list.selFriend.length; i++)
			{	//친구 데이터 보내기
				var feedSend:Write = new Write(url,onWrite);
				var friend:MovieClip = list.selFriend[i] as MovieClip;
				feedSend.send({friendsID:friend.userId,friendsName:friend.userName,message:message,sender:1});
			
				//FncOut.call("alert",list.selFriend.length);
			}
			
			//본인 데이터 보내기
			var userFeedSend:Write = new Write(url,onWrite);
			userFeedSend.send({friendsID:list.userData.userId,friendsName:list.userData.userName,message:message,sender:2});
			
			setPage(1);
		}
		private function onWrite(result:String):void
		{
			trace(result);
		}
		/**	페이스북 로그인 콜백	*/
		public function onCallbackFB(e:MovieEvent):void
		{
			setPage(1);
			list.loadList();
		}
		
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
			
//			gapX = -35;
//			gapY = -75;
			
//			btnMc.scaleX = 0.77
//			btnMc.scaleY = 1.2;
			
			btnMc.scaleX = 0.77;
			btnMc.scaleY = 0.8;
			btnMc.rotation = -20;
			
			cPos = 1;
		}
		
		/**	메뉴 구성	*/
		private function setMenu():void
		{
			btnMc.shadowMc.visible = false;
			btnMc.lineMc.visible = false;
			for(var j:int = 1; j<=4; j++)
			{
				var img:MovieClip = btnMc["img"+j] as MovieClip;
				for(var i:int =0; i<img.numChildren; i++)
				{
					var obj:Object = img.getChildAt(i);
					
					if(obj is MovieClip == false) obj.visible = false;
					else 
					{
						if(obj.name.substr(0,3) != "btn") continue;
						//obj.alpha = 0.5;
						var viewObj:MovieClip = viewMc[obj.parent.name][obj.name] as MovieClip;
						obj.view = viewObj;
						
						obj.alpha = 0;
						obj.y -= 10;
						obj.height += 20;
//						trace(obj.name);
						
						if(j == 1)
						{	//처음 페이스북 로그인 여부 체크 버튼 위치
							obj.y += 50;
							obj.view.y = obj.y;
							obj.view.x += 2;
						}
						if(obj.name.substr(0,6) == "btnImg")
						{	//친구 리스트 오버 표현
							obj.overMc.visible = false;
						}
						
					}
				}
			}
			
			//첫페이지 (페이스북 로그인)
			setButton(btnMc.img1.btn1,onClickFBLogin);
			setButton(btnMc.img1.btn2,onClickSkip);
			
			//두번째 페이지 (친구 선택)
			setButton(btnMc.img2.btn1);
			setButton(btnMc.img2.btn2,onClickCancel);
//			setButton(btnMc.img2.btnPage1);
//			setButton(btnMc.img2.btnPage2);
			
			//세번째 페이지 (멘트 입력)
			setButton(btnMc.img3.btn1,onClickSend);
			setButton(btnMc.img3.btn2,onClickBack);
			
			//네번째 페이지 (완료)
			setButton(btnMc.img4.btn,onClickComplete);
			
			setPage(0);
			
		}

		/**	페이지 이동 구성	*/
		private function setPage(dir:int = 0):void
		{
			cPos += dir;
			if(cPos > 4) cPos = 4;
			if(cPos < 1) cPos = 1;
			
//			trace(cPos);
			
			for(var i:int = 1; i<=4; i++)	
			{
				var view:MovieClip = viewMc["img"+i] as MovieClip;
				var btn:MovieClip = btnMc["img"+i] as MovieClip;
				
				btn.visible = false;
				var alpha:int = 0;
				if(i == cPos)
				{
					btn.visible = true;
					alpha = 1;
				}
				TweenMax.to(view,1,{alpha:alpha});
			}
			if(cPos == 3 && dir != 0)
			{
				viewTxt.text = baseTxt;
				btnTxt.text = baseTxt;	
			}
		}
		/**	페이스북 로그인	*/
		private function onClickFBLogin(mc:MovieClip):void
		{
			Global.getIns().callbackSate = CallBack.FRIEND_FB;
			FncOut.call("fbLoginChk");
			
			if(Location.setURL("local","") == "local")
			{	//로컬 상에서 테스트 할시에는 로그인 완료로 체크
				Global.getIns().dispatchEvent(new MovieEvent(CallBack.FRIEND_FB));
			}
			btnMc.img1.visible = false;
			TweenMax.delayedCall(1,setPage);
		}
		
		/**	페이스북 로그인 취소 버튼	*/
		private function onClickSkip(mc:MovieClip):void
		{
			Global.getIns().stopMovie();
			Global.getIns().viewPop("loginPop");
		}
		
		/**	이벤트 참여 취소	*/
		private function onClickCancel(mc:MovieClip):void
		{
			//Global.getIns().nextMovie();
			Global.getIns().stopMovie();
			Global.getIns().viewPop("cancelPop");
		}
		
		/**	코멘트 글 내용 적용 내용 	*/
		private function setMessageText():void
		{
			viewTxt = viewMc.img3.btnTxt.txt;
			btnTxt = btnMc.img3.btnTxt.txt;
			
			baseTxt = "14일의 놀라운 변화를 체험해봐!";
			viewTxt.text = baseTxt;
			btnTxt.text = baseTxt;
			
			var tf:TextFormat = new TextFormat();
			tf.size = 15;
			viewTxt.defaultTextFormat = tf;
			btnTxt.defaultTextFormat = tf;
			
			btnMc.img3.btnTxt.alpha = 0;
			
			btnMc.img3.btnTxt.planeMc.alpha = 0;
			btnMc.img3.btnTxt.y += 8.2;
			btnMc.img3.btnTxt.x += 10.2;
			btnMc.img3.btnTxt.txt.width -= 20;
			
			btnTxt.cacheAsBitmap = true;
			btnTxt.maxChars = 70;
			
			btnTxt.addEventListener(FocusEvent.FOCUS_IN,onFocusTxt);
			btnTxt.addEventListener(FocusEvent.FOCUS_OUT,onFocusOutTxt);
			
		}
		
		/**	코멘트 내용 포커스	*/
		private function onFocusTxt(e:Event):void
		{
			viewMc.addEventListener(Event.ENTER_FRAME,onEntenrTxt);
			
			if(btnTxt.text == baseTxt) btnTxt.text = "";
		}
		/**	코멘트 내용 포커스 아웃	*/
		private function onFocusOutTxt(e:Event):void
		{
			viewMc.removeEventListener(Event.ENTER_FRAME,onEntenrTxt);
		}
		/**	텍스트 내용 적용	*/
		private function onEntenrTxt(e:Event):void
		{
			viewTxt.text = btnTxt.text;
			viewTxt.scrollH = btnTxt.scrollH;
			viewTxt.scrollV = btnTxt.scrollV;
		}
		/**	친구 다시 선택	*/
		private function onClickBack(mc:MovieClip):void
		{
			setPage(-1);
			list.initObject();
			list.loadList();
		}
		/**	친구 데이이터 보내기 */
		private function onClickSend(mc:MovieClip):void
		{
			viewMc.removeEventListener(Event.ENTER_FRAME,onEntenrTxt);
			
			if(viewTxt.text == baseTxt || viewTxt.text == "")
			{
				FncOut.call("alert","친구들에서 보낼 메세지를 입력해 주세요.");
				return;
			}
			message = viewTxt.text;
			
			Global.getIns().callbackSate = CallBack.FRIEND;
			FncOut.call("guerillaValidation");
			btnMc.img3.visible = false;
			TweenMax.delayedCall(1,setPage);
		}
		
		/**	이벤트 참여 완료	*/
		private function onClickComplete(mc:MovieClip):void
		{
			Global.getIns().nextMovie();
			
			destroy();
		}
		
		/**	소멸자	*/
		override public function destroy(e:Event = null):void
		{
			super.destroy();
			
			if(list != null)
			{
				list.destroy();
				list = null;
			}
			
			Global.getIns().removeEventListener(CallBack.FRIEND_FB,onCallbackFB);
			Global.getIns().removeEventListener(CallBack.FRIEND,onCallbackLogin);
		}
		
	}//class
}//package