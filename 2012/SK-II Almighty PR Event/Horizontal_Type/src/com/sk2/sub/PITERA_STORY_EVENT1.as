package com.sk2.sub
{
	import com.greensock.TweenMax;
	import com.sk2.net.EPILOGUE_LIST;
	import com.sk2.net.EVT1_LIST;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.BtnAlpha;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.net.list.Write;
	import com.sw.utils.SetFont;
	import com.sw.utils.SetText;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.text.TextField;
	
	/**
	 * SK2 :: 이벤트 신청하기
	 * */
	public class PITERA_STORY_EVENT1 extends BaseSub
	{
		protected var pop_mc:MovieClip;
		
		protected var write:Write;
		private var list:EVT1_LIST;
		private var writeTxt1:String;
		private var writeTxt2:String;
		
		private var base_write1:String;
		private var base_write2:String;
		
		/**	생성자	*/
		public function PITERA_STORY_EVENT1($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
			
			pop_mc = scope_mc.pop_mc;
			pop_mc.visible = false;	
			
			DataProvider.stage.addEventListener(KeyboardEvent.KEY_UP,onKey);
			scope_mc.stage.addEventListener(Event.RESIZE,onResize);
			
			onResize();
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			pop_mc.plane_mc.visible = false;
			scope_mc.stage.removeEventListener(Event.RESIZE,onResize);
			DataProvider.stage.removeEventListener(KeyboardEvent.KEY_UP,onKey);
			if(list != null) list.destroy();
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
			base_write1 = "200자 내로 본인의 피부 고민을 정성스럽게 작성해 주세요.";
			base_write2 = "200자 내로 피테라 에센스로 변하고 싶은 피부를            정성스럽게 작성해 주세요.";
			
			
//			list = new EVT1_LIST(scope_mc,DataProvider.dataURL+"/Xml/SampleRequestList.aspx",{listClick:viewPop,playRipple:playRipple});
//			write = new Write(DataProvider.dataURL+"/Event2/SampleRequest.ashx",onWrite);
			
			
		}
		/**
		 * 물결 움직임 주고난 후 초기화
		 * */
		override public function init():void
		{
			if(list != null)list.loadList();
			setBtn();
			TweenMax.delayedCall(0.8,viewPop,["info"]);
		}
		/**	버튼셋팅	*/
		protected function setBtn():void
		{
			for(var i:int = 1; i<=3; i++)
			{
				var btn:MovieClip = scope_mc["btn"+i];
				btn.idx = i;
				setBaseBtn(btn,onClickBtn);
			}	
		}
		protected function onClickBtn($mc:MovieClip):void
		{
			switch($mc.idx)
			{
				case 1:	//글쓰기
					viewPop("write");	
					break;
				case 2:	//이벤트안내팝업
					viewPop("info");
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
			
			if($pos != "view") 
			{	
				while(pop_mc.getChildByName("txt_id") != null)
					pop_mc.removeChild(pop_mc.getChildByName("txt_id"));
			}
			switch($pos)
			{
				case "write":		//글쓰기
					var txt:TextField = pop_mc.txt1;
					txt.addEventListener(FocusEvent.FOCUS_IN,onFocus);
					txt.text = base_write1;
					txt.maxChars = 200;
					
					txt = pop_mc.txt2;
					txt.addEventListener(FocusEvent.FOCUS_IN,onFocus);
					txt.text = base_write2;
					txt.maxChars = 200;
					
					setBaseBtn(pop_mc.btn,onClickPop);
					break;
				case "complete":	//등록완료
					setBaseBtn(pop_mc.btn1,onClickPop);
					setBaseBtn(pop_mc.btn2,onClickPop);
					setBaseBtn(pop_mc.btn3,onClickPop);
					break;
				case "view":		//글내용 보기
					pop_mc.txt1.text = $data.ans1;
					pop_mc.txt2.text = $data.ans2;
					var id:String = $data.txt_id as String;
					pop_mc.txt_id.text = id.substr(0,id.length-3);
					TextField(pop_mc.txt1).selectable = false;
					TextField(pop_mc.txt2).selectable = false;
					SetFont.getIns().go(pop_mc.txt_id,{font:"SD SeokPil L (P)",letter:1,size:30});
					//SetText.space(pop_mc.txt_id,{letter:-1});
					break;
				case "info":		//안내
					setBaseBtn(pop_mc.btn4,onClickPop);
					break;
			}
			pop_mc.alpha = 0;
			pop_mc.plane_mc.alpha = 0.3;
			viewBlurObj(pop_mc,finishPop,"view");
		}
		private function finishPop($dir:String = "hide"):void
		{
			/*
			if($dir == "hide")
				viewBlurObj(pop_mc,null,pop_mc,0);
			if($dir == "view")
				TweenMax.to(pop_mc.plane_mc,0.5,{alpha:0.3});
			*/
		}
		private function onFocus(e:FocusEvent):void
		{
			var txt:TextField = e.currentTarget as TextField;
			
			if(pop_mc.txt1.text == base_write1 && txt.name == "txt1") pop_mc.txt1.text = "";
			if(pop_mc.txt2.text == base_write2 && txt.name == "txt2") pop_mc.txt2.text = "";
		}
		private function onClickPop($mc:MovieClip):void
		{
			switch($mc.name)
			{
				case "btnX":	//닫기
					//TweenMax.to(pop_mc.plane_mc,0.5,{alpha:0,onComplete:finishPop});
					viewBlurObj(pop_mc,null,pop_mc,0);
					break;
				case "btn":		//글쓰기
					sendWrite();
					break;
				case "btn2":	//롯데닷컴
					//"http://www.lotte.com/goods/viewGoodsDetail.lotte?goods_no=10913628"
					FncOut.call("piteraMenu.linkLotte");
					//FncOut.link("http://www.lotte.com/goods/viewGoodsDetail.lotte?goods_no=10913628","_blank");
					break;
				case "btn1":	//에이치몰
					FncOut.call("piteraMenu.linkHyundai");
					//FncOut.link("http://www.hmall.com/front/shSectR.do?SectID=541930","_blank");
					break;
				case "btn3":	//신세계몰
					FncOut.call("piteraMenu.linkShinsegae");
					//FncOut.link("http://mall.shinsegae.com/item/item.do?method=viewItemDetail&item_id=14181091","_blank");
					break;
				case "btn4":	//샘플 신청
					//FncOut.link("http://www.naver.com","_blank");
					//viewPop("write");
					viewBlurObj(pop_mc,viewPop,"write",0);
					break;
			}
		}
		/**	글쓰기	*/
		public function sendWrite():void
		{
			writeTxt1 = pop_mc.txt1.text;
			writeTxt2 = pop_mc.txt2.text;
			
			if(	writeTxt1 == base_write1 ||
				writeTxt2 == base_write2 ||
				writeTxt1 == "" || 	writeTxt2 == "")
			{
//				DataProvider.popup.viewPop("alert",{txt:"내용을 입력해 주세요."});
				return;
			}
			write.send({q1:writeTxt1,q2:writeTxt2});
		}
		/**
		 * 글쓰기 데이터 리턴
		 * */
		private function onWrite($result:String):void
		{
			switch($result)
			{
				case "-2":	//로그인 필요
					DataProvider.callBack.state = DataProvider.callBack.EVT1_WRITE;
					DataProvider.callLogin("evt1_write");
					break;
				case "-3":	//고민내용 전달 실패
//					DataProvider.popup.viewPop("alert",{txt:"고민내용 전달 실패."});
					break;
				case "-4":	//입력내용 초과
//					DataProvider.popup.viewPop("alert",{txt:"너무 많은 글을 입력하였습니다."});
					break;
				case "-9":	//시스템 오류
//					DataProvider.popup.viewPop("alert",{txt:"시스템 오류."});
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
		/**
		 * 화면 리사이즈
		 * */
		private function onResize(e:Event=null):void
		{
			//trace("이벤트1 화면 리사이즈");
			var sw:Number = DataProvider.resize.sw;
			var sh:Number = DataProvider.resize.sh;
			
			pop_mc.plane_mc.width = sw;
			pop_mc.plane_mc.height = sh;
			
			pop_mc.plane_mc.x = (sw-scope_mc.plane_mc.width)/-2;
			pop_mc.plane_mc.y = (sh-scope_mc.plane_mc.height)/-2;
		}
	}//class
}//package