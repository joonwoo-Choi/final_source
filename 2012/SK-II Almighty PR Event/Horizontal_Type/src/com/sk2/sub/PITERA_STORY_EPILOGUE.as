package com.sk2.sub
{
	
	import com.greensock.TweenMax;
	import com.sk2.net.EPILOGUE_LIST;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.BtnAlpha;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.net.list.Write;
	import com.sw.utils.SetText;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.text.TextField;
	
//	import org.ascollada.namespaces.collada;

	/**
	 * SK2		::		후기 리스트
	 * */
	public class PITERA_STORY_EPILOGUE extends BaseSub
	{
		private var pop_mc:MovieClip;
		
		private var write:Write;
		private var list:EPILOGUE_LIST;
		private var writeTxt:String;
		
		private var base_write:String;
		
		/**	생성자	*/
		public function PITERA_STORY_EPILOGUE($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			scope_mc.bg_img.visible = false;
			DataProvider.stage.removeEventListener(KeyboardEvent.KEY_UP,onKey);
			list.destroy();
		}
		override protected function playRipple():void
		{
			if(bRipple == true) return;
			scope_mc.list_mc.alpha = 0;
			super.playRipple();
		}
		/**	물결 움직임 주기 전 셋팅	*/
		override public function setRipple():void
		{
			base_write = "100자 이내로 입력해 주세요.";
			
			pop_mc = scope_mc.pop_mc;
			pop_mc.visible = false;
			
//			list = new EPILOGUE_LIST(scope_mc,DataProvider.dataURL+"/Xml/EpilogueList.aspx",{listClick:viewPop,playRipple:playRipple});
//			write = new Write(DataProvider.dataURL+"/Event/EpilogueEvent.ashx",onWrite);
			
			DataProvider.stage.addEventListener(KeyboardEvent.KEY_UP,onKey);
		}
		/**
		 * 초기화
		 * */
		override public function init():void
		{
			list.loadList();
			TweenMax.to(scope_mc.bg_img,1,{alpha:1});
			setBtn();
		}
		/**	버튼셋팅	*/
		private function setBtn():void
		{
			for(var i:int = 1; i<=3; i++)
			{
				var btn:MovieClip = scope_mc["btn"+i];
				btn.idx = i;
				setBaseBtn(btn,onClickBtn);
			}	
		}
		private function onClickBtn($mc:MovieClip):void
		{
			switch($mc.idx)
			{
			case 1:	//글쓰기
				viewPop("write");	
			break;
			case 2:	//내가 등록한 글 리스트
				if(DataProvider.callBack.login == false) 
				{
					DataProvider.callBack.state = DataProvider.callBack.MY;
					DataProvider.callLogin();
				}
				else loadMyList();
			break;
			case 3:	//검색
				list.owner = "N";
				list.setNo(1);
				list.loadList();
			break;
			}
		}
		/**	자신이 등록한 내용 가져오기	*/
		public function loadMyList():void
		{
			list.resetData();
			list.setMy("Y");
			list.loadList();
		}
		/**	팝업 보여지기	*/
		private function viewPop($pos:String,$data:Object = null):void
		{
			if($data == null) $data = new Object();
			
			Button.setUI(pop_mc.btnX,{click:onClickPop});
			pop_mc.gotoAndStop(0);
			pop_mc.gotoAndStop($pos);
			switch($pos)
			{
			case "write":		//글쓰기
				var txt:TextField = pop_mc.txt;
				txt.addEventListener(FocusEvent.FOCUS_IN,onFocus);
				txt.text = base_write;
				txt.maxChars = 100;
				setBaseBtn(pop_mc.btn,onClickPop);
			break;
			case "complete":	//등록완료
				setBaseBtn(pop_mc.btn1,onClickPop);
				setBaseBtn(pop_mc.btn2,onClickPop);
				setBaseBtn(pop_mc.btn3,onClickPop);
			break;
			case "view":		//글내용 보기
				pop_mc.txt.text = $data.txt_body;	
				pop_mc.txt_id.text = $data.txt_id+" 님의 EPILOGUE";
				SetText.space(pop_mc.txt_id,{letter:-1});
			break;
			}
			pop_mc.alpha = 0;
			viewBlurObj(pop_mc);
		}
		private function onFocus(e:FocusEvent):void
		{
			if(pop_mc.txt.text == base_write) pop_mc.txt.text = "";
		}
		private function onClickPop($mc:MovieClip):void
		{
			switch($mc.name)
			{
				case "btnX":	//닫기
					viewBlurObj(pop_mc,null,pop_mc,0);
				break;
				case "btn":		//글쓰기
					sendWrite();
				break;
				case "btn1":	//트위터 
					FncOut.call("piteraMenu.scrapToTwitter");
				break;
				case "btn2":	//페이스북
					FncOut.call("piteraMenu.scrapToFacebook",writeTxt);
				break;
				case "btn3":	//PRODUCT 보기
					DataProvider.loader.navi.clickMenu(2,0);
				break;
			}
		}
		/**	글쓰기	*/
		public function sendWrite():void
		{
			writeTxt = pop_mc.txt.text;
			if(writeTxt == base_write) writeTxt = "";
			write.send({epilogue:writeTxt});	
		}
		/**
		 * 글쓰기 데이터 리턴
		 * */
		private function onWrite($result:String):void
		{
			switch($result)
			{
			case "-2":	//로그인 필요
				DataProvider.callBack.state = DataProvider.callBack.WRITE;
				DataProvider.callLogin("evt2Write");
			break;
			case "-3":	//후기 내용 없음
//				DataProvider.popup.viewPop("alert",{txt:"내용을 입력해 주세요."});
			break;
			case "-4":	//입력내용 초과
//				DataProvider.popup.viewPop("alert",{txt:"너무 많은 글을 입력하였습니다."});
			break;
			case "-9":	//시스템 오류
//				DataProvider.popup.viewPop("alert",{txt:"시스템 오류."});
			break;
			case "1":	//완료
				viewPop("complete");
				list.resetData();
				list.loadList();
			break;
			}
		}
		
		/**
		 * 키보드 눌렀을 때
		 * */
		private function onKey(e:KeyboardEvent):void
		{
			if(e.keyCode != 13) return;
			var txt:TextField = scope_mc.txt_search as TextField;
		}
	}//class
}//package