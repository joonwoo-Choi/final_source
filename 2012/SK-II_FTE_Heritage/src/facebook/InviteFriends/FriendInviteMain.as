package facebook.InviteFriends
{
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lumpens.utils.JavaScriptUtil;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.net.list.Write;
	import com.sw.utils.SetText;
	
	import contents.qnaevent.QnAGlobal;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import net.CallBack;
	import net.HersheysFncOut;
	
	import util.BtnHersheys;
	
	/**		
	 *	SK2_Hersheys :: Q&A 친구 초대 메인 스크립트 내용
	 */
	public class FriendInviteMain
	{
		/**	그래픽	*/
		private var container:MovieClip;
		
		/**	리스트 내용	*/
		private var list:FriendInviteList;
		/**	검색 초기 글자 내용	*/
		private var baseSearch:String;
		/**	메세지 초기 글자 내용	*/
		private var baseMessage:String;
		/**	글 보내는 내용 클래스	*/
		private var arySend:Array;
		/** 페이지 번호 받아오기 **/
		private var $flashVars:Object;
		/** 페이지 번호 **/
		private var $pageNum:int;
		
		/** 보낸 친구 수	*/
		private var sendCnt:int;
		private var $type:String;
		private var $req:URLRequest;
		private var $loader:URLLoader;
		private var $testBtn:listClip;
		
		/**	생성자	*/
		public function FriendInviteMain(mc:MovieClip,thumbClass:Class,type:String="W")
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			$type = type;
			container = mc;
			list = new FriendInviteList(container.mcList,{change:changeSelect,thumb:thumbClass});
			
			init();	
			Global.getIns().addEventListener(CallBack.QNA_FACEBOOK,onLogin);
		}
		/**	페이스북 로그인 콜백	*/
		private function onLogin(e:Event):void
		{
			trace("onLogin");
			if(list.getSelectFriend().length != 0) 
			{
				onClickSend();
				return;
			}
			list.loadData();
			
			/**	페이지 번호 받아오기 */
			$flashVars = container.root.loaderInfo.parameters;
			if($flashVars["pageNum"]==undefined){
				$pageNum = 0;
			}else{
				$pageNum = container.root.loaderInfo.parameters.pageNum - 1;
			}
			
		}
		/**	초기화	*/
		private function init():void
		{
			container.loading.visible = false;
			baseSearch = "이름을 입력하세요.";
			baseMessage = "메세지를 입력하세요.";
			container.txtSearch.text = baseSearch;
			container.txtMessage.text = baseMessage;
			
			changeSelect(0);
			
			Button.setUI(container.btnTotal,{click:onClickSort});
			Button.setUI(container.btnSelect,{click:onClickSort});
			
			BtnHersheys.getIns().go(container.btnSend,onClickSend);
			
			container.txtMessage.addEventListener(FocusEvent.FOCUS_IN,onFocusMessage);
			container.txtSearch.addEventListener(FocusEvent.FOCUS_IN,onFocusSearch);
			container.txtSearch.addEventListener(Event.CHANGE,onChangeSearch);
		}
		private function onFocusSearch(e:Event):void
		{
			if(container.txtSearch.text == baseSearch) 
				container.txtSearch.text = "";
		}
		private function onFocusMessage(e:Event):void
		{
			if(container.txtMessage.text == baseMessage) 
				container.txtMessage.text = "";
		}
		/**	검색 글 내용 수정 될 때 마다 리스트 다시 정렬	*/
		private function onChangeSearch(e:Event):void
		{
			var str:String = container.txtSearch.text;
			str = SetText.change(str," ","");
			list.sortList("search",str);
//			setSortBtn("total");
		}
		
		/**	리스트 정렬 버튼	*/
		private function onClickSort(mc:MovieClip):void
		{
			if(mc.name == "btnTotal")
			{	//전체 리스트 보여지기
				list.sortList("total");
//				setSortBtn("total");
			}
			if(mc.name == "btnSelect")
			{	//선택된 리스트만 보여지기
				list.sortList("select");
//				setSortBtn("select");
			}
			
			if(container.txtSearch.text != baseSearch)
				container.txtSearch.text = "";
		}
		/**	카운트 갯수 변화	*/
		private function changeSelect(cnt:int):void
		{
			var btnTxt:TextField = container.btnSelect.txt as TextField;
			btnTxt.autoSize = TextFieldAutoSize.RIGHT;
			btnTxt.text = "선택됨("+cnt+")";
			
			var str:String = "";
			if(cnt == list.getMax()) str = "5명의 친구를 모두 선택 하였습니다.";
			else if(cnt == 0) str = list.getMax()+"명의 친구를 선택 할 수 있습니다.";
			else str = (list.getMax()-cnt)+"명의 친구를 더 선택 할 수 있습니다."
			
			container.txtAlert.text = str;
			
		}
		/**	초대장 보내기 버튼	*/
		private function onClickSend(mc:MovieClip = null):void
		{
			//trace("데이터 보내기");
			
			arySend = [];
			var obj:Object = new Object();
			var arySelect:Array = list.getSelectFriend();
			var cnt:int = arySelect.length;
			var send:Write
			
			var url:String = Global.getIns().dataURL+"/Process/FBTeaserFriendInvite.ashx";
			
			if(cnt == 0) 
			{
				FncOut.call("alert","친구를 선택해 주세요.");
				return;
			}
			else if( container.txtMessage.text == baseMessage || container.txtMessage.text == "" )
			{
				FncOut.call("alert","메세지를 입력해 주세요.");
				return;
			}
			else
			{
				var friendInfo:Array = [];
				for(var i:int = 0; i<cnt; i++)
				{
					friendInfo.push(arySelect[i].uId+"/"+arySelect[i].uName);
				}
				$req = new URLRequest(url);
				var vari:URLVariables = new URLVariables();
				vari.ran = Math.round(Math.random()*10000);
				vari.friends = String(friendInfo);
				trace("vari.friends: ",vari.friends);
				if(SecurityUtil.isWeb()){
					vari.fbAtoken = Global.getIns().accessToken;
				}else{
					vari.fbAtoken = "AAAEnhiBKwk8BAEQ3JBaSXFsIwhZAJXcDdBTLHKzHICcNh0bRGBzZA4z4F6SvzwtABkWhqVtvxoSCas4PSZAoZC2I9KgySEdfZAfdNaqzmmojy9z62S34W";
				}				
				vari.message=container.txtMessage.text;
				vari.regtype = "T";
				$req.data = vari;
				$req.method =URLRequestMethod.POST;
				$loader = new URLLoader();
				$loader.load($req);
				$loader.addEventListener(Event.COMPLETE,onLoad);
				container.loading.visible = true;
				container.loading.gotoAndPlay(2);
			}
		}
		
		protected function onLoad(e:Event):void
		{
			var txt:String = $loader.data as String;
			trace("txt: ",txt);
			onSend(txt);
		}
		
		/**	피드 날리기 결과 	*/
		private function onSend(result:String):void
		{
			trace(result);
			switch(result)
			{
				case "-1":	//페이스북 로그인 필요
					HersheysFncOut.qnaLoginFB();
					break;
				case "-2":
					FncOut.call("alert","전송할 정보가 없습니다.");
					break;
				case "-3":
					FncOut.call("alert","메세지 내용이 없습니다.");
					break;
				case "-6":
					FncOut.call("alert","오늘 전송 가능한 메시지수를 초과하였습니다.\r\n올바르지 않은 메시지 전송시 더 이상 이벤트 참여 불가능합니다.");
					break;
				case "-8":
					FncOut.call("alert","잠시 후 다시 이용해 주세요.");
					break;
			}
			
			if(result != "1" && result != "2") return;
			
			resetBtn();
			container.loading.visible = false;
			container.loading.gotoAndStop(1);
			FncOut.call("completeView");
			trace("nextMovie");
		}
		
		private function resetBtn(event:Event=null):void
		{
			var arySelect:Array = list.getSelectFriend();
			for (var i:int = 0; i < arySelect.length; i++) 
			{
				var list:MovieClip = arySelect[i];
				list.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			container.txtMessage.text = baseMessage;
			container.txtSearch.text = baseSearch;
		}
		
		private function hideMyself():void
		{
			container.dispatchEvent(new Event("hideInvite",true));
			QnAGlobal.getIns().moveStep(0);	
			// TODO Auto Generated method stub
		}
		
		/**	소멸자	*/
		public function destroy():void
		{
			Global.getIns().removeEventListener(CallBack.QNA_FACEBOOK,onLogin);
			container.txtMessage.removeEventListener(FocusEvent.FOCUS_IN,onFocusMessage);
			container.txtSearch.removeEventListener(FocusEvent.FOCUS_IN,onFocusSearch);
			container.txtSearch.removeEventListener(Event.CHANGE,onChangeSearch);
		}		
		
	}//class
}//package