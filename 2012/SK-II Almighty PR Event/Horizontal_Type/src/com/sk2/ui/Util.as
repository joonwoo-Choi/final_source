package com.sk2.ui
{
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.utils.McData;
	import com.sw.utils.SetText;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * SK2	::	상단,하단 메뉴 클래스
	 * */
	public class Util
	{
		private var scope_mc:MovieClip;
		private var top_mc:MovieClip;
		
		/**	생성자	*/
		public function Util($scope_mc:MovieClip)
		{
			scope_mc = $scope_mc;
			init();
		}
		/**	소멸자	*/
		public function destroy():void
		{}
		/**
		 * 초기화
		 * */
		private function init():void
		{
//			top_mc = scope_mc.top_mc;
			
//			Button.setUI(scope_mc.logo_mc,{click:onClickLogo});
//			setTop();
//			setFooter();
//			setLogin(DataProvider.callBack.login);
		}
		/**
		 * 상단 메뉴 셋팅
		 * */
		private function setTop():void
		{
			var topName:Array = ["HOME","LOGIN","JOIN US","CLOSE"];
			for(var  i:int = 0; i<topName.length; i++)
			{
				var btn:MovieClip = top_mc["btn"+(i+1)];
				McData.save(btn);
				btn.idx = (i+1);
				
				//var txt:TextField = btn.txt;
				var txt:TextField = new TextField();
				btn.addChild(txt);
				btn.addChild(btn.plane_mc);
				btn.txt = txt;
				txt.thickness = 200;
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.textColor = 0x8B0106;
				txt.text = topName[i];
				SetText.space(txt,{size:10,font:"CreMyungjo"});
				
				txt.selectable =false;
				txt.mouseEnabled = false;
				txt.mouseWheelEnabled = false;
				
				btn.plane_mc.width = 10;
				btn.plane_mc.width = btn.width;	
				Button.setUI(btn,{click:onClickTop});
			}
		}
		/**	하단 메뉴 셋팅	*/
		private function setFooter():void
		{
			for(var i:int = 1; i<=2; i++)
			{
				var btn:MovieClip = scope_mc["footer_btn"+i];
				btn.idx = i;
				Button.setUI(btn,{click:onClickFooter});
			}
		}
		
		/**	로고 클릭	*/
		private function onClickLogo($mc:MovieClip):void
		{
			//trace("로고 클릭");
			DataProvider.loader.navi.clickMenu(0,0);
		}
		
		/**	상단 메뉴 클릭	*/
		private function onClickTop($mc:MovieClip):void
		{
			switch($mc.idx)
			{
			case 1:	//HOME
				//trace("HOME");
				DataProvider.loader.navi.clickMenu(0,0);
			break;
			case 2:	//LOGIN
				if($mc.txt.text == "LOGIN")
				{
					trace("LOGIN");
					//DataProvider.track.check2("501");
					DataProvider.callLogin();
				}
				else if($mc.txt.text == "LOGOUT")
				{
					trace("LOGOUT");
					FncOut.call("piteraMenu.Logout");
					setLogin(false);
				}
			break;
			case 3:	//JOIN US
				if($mc.txt.text == "JOIN US")
				{
					trace("JOIN US");
					DataProvider.track.check2("502");
					FncOut.link("http://www.sk2.co.kr/comuser/join/join_step01.asp","_blank");
				}
				else if($mc.txt.text == "MY PAGE")
				{
					trace("MY PAGE");
				}
			break;
			case 4:	//CLOSE
				trace("CLOSE");
				FncOut.call("piteraMenu.closeWindow");
			break;
			}
		}
		public function setLogin($bool:Boolean):void
		{
			DataProvider.callBack.login = $bool;
			top_mc.btn2.txt.text = "LOGOUT";
			//top_mc.btn3.txt.text = "MY PAGE";
			top_mc.btn3.txt.text = "JOIN US";
			
			top_mc.btn1.x = top_mc.btn1.dx-15;
			top_mc.btn2.x = top_mc.btn2.dx-15;
			top_mc.btn3.x = top_mc.btn3.dx-10;
			
			if($bool == false)
			{
				top_mc.btn2.txt.text = "LOGIN";
				top_mc.btn3.txt.text = "JOIN US";
				
				top_mc.btn1.x = top_mc.btn1.dx;
				top_mc.btn2.x = top_mc.btn2.dx;
				top_mc.btn3.x = top_mc.btn3.dx;
			}
			SetText.space(top_mc.btn2.txt,{size:10,font:"CreMyungjo"});
			SetText.space(top_mc.btn3.txt,{size:10,font:"CreMyungjo"});
		}
		/**	하단 메뉴 클릭	*/
		private function onClickFooter($mc:MovieClip):void
		{
			switch($mc.idx)
			{
			case 1:
				trace("Twitter");
				FncOut.link("http://twitter.com/sk2_kor","_blank");
				DataProvider.track.check2("503");
			break;
			case 2:
				trace("Mobile");
				FncOut.link("http://m.purepitera.co.kr","_blank");
				DataProvider.track.check2("504");
			break;
			}
		}
	}//class
}//package