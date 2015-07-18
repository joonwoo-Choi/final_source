package com.sk2.sub
{
	import com.greensock.TweenMax;
	import com.sk2.net.EVT2_LIST;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.ui.ImgView;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * SK2	:: 후기등록 이벤트
	 * */
	public class PITERA_STORY_EVENT2 extends PITERA_STORY_EVENT1
	{
		private var list:EVT2_LIST;
		private var info_imgView:ImgView;
		
		/**	생성자	*/
		public function PITERA_STORY_EVENT2($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			if(list != null) list.destroy();
		}
		/**
		 * 물결 움직임 주고난 후 초기화
		 * */
		override public function init():void
		{
			super.init();
			scope_mc.btn_align.idx = 4;
			Button.setUI(scope_mc.btn_align,{click:onClickBtn});
			list.loadList();
			
			TweenMax.delayedCall(0.8,viewPop,["info"]);
		}
		/**	물결 움직임 주기 전 셋팅	*/
		override public function setRipple():void
		{
			list = new EVT2_LIST(scope_mc,DataProvider.dataURL+"/Xml/PostList.aspx",{listClick:viewPop,playRipple:playRipple});
		}
		public function loadList($state:String = "first"):void
		{	
			if($state == "fist")
			{	//최근에 올린 글 로드
				MovieClip(scope_mc.btn_align).prevFrame();
				onClickBtn(scope_mc.btn_align);
			}
			if($state == "list")
			{	//현제 리스트 내용 로드
				list.bMotion = false;
				list.loadList();
			}
		}	
		/**	글쓰기 클릭	*/
		public function clickWrite():void
		{
			onClickBtn(scope_mc.btn1);
		}
		override protected function onClickBtn($mc:MovieClip):void
		{
			switch($mc.idx)
			{
				case 1:	//글쓰기
					if(DataProvider.callBack.login == false) 
					{
						DataProvider.callBack.state = DataProvider.callBack.EVT2_WRITE;
						DataProvider.callLogin("evt1_write");
					}
					else 
					{
						DataProvider.callBack.state = DataProvider.callBack.EVT2_LIST;
						//FncOut.call("alert","글쓰기");
						FncOut.call("piteraMenu.postWrite");
					}
					break;
				case 2:	//이벤트안내팝업
					viewPop("info");
					break;
				case 3:	//검색
					list.setNo(1);
					list.loadList();
					break;
				case 4: //최근,동감 순으로 보기
					list.resetData();
					if($mc.currentFrame == 1)
					{
						$mc.nextFrame();
						list.rmd = "bn";
					}
					else 
					{
						$mc.prevFrame();
						list.rmd = "";
					}
					list.loadList();
					break;
			}
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
				case "complete":	//등록완료
					setBaseBtn(pop_mc.btn1,onClickPop);
					setBaseBtn(pop_mc.btn2,onClickPop);
					setBaseBtn(pop_mc.btn3,onClickPop);
				break;
				case "info":
					if(info_imgView != null) info_imgView.destroy();
					
					info_imgView = new ImgView(	pop_mc.imgView_mc,[],
						{	scroll:pop_mc.imgView_mc.scroll_mc,
							mask:pop_mc.imgView_mc.mask_mc,
							img:pop_mc.imgView_mc.img_mc,speed:0.1});
					info_imgView.doingScroll();
					setBaseBtn(pop_mc.imgView_mc.img_mc.btn_write,onClickPop);
				break;
			}
			
			pop_mc.alpha = 0;
			pop_mc.plane_mc.alpha = 0.3;
			viewBlurObj(pop_mc);
		}
		/**
		 * 팝업 버튼
		 * */
		private function onClickPop($mc:MovieClip):void
		{
			switch($mc.name)
			{
				case "btnX":		//닫기
					viewBlurObj(pop_mc,null,pop_mc,0);
					break;
				case "btn":			//글쓰기
					sendWrite();
					break;
				case "btn_write":	//안내 창에서 글쓰기
					viewBlurObj(pop_mc,onClickBtn,scope_mc.btn1,0);
				break;
				/*
				case "btn1":	//롯데닷컴
					FncOut.link("http://www.hmall.com/front/shSectR.do?SectID=541930","_blank");
					break;
				case "btn2":	//에이치몰
					FncOut.link("http://www.lotte.com/planshop/viewPlanShopDetail.lotte?spdp_no=1745151","_blank");
					break;
				case "btn3":	//신세계몰
					FncOut.call("alert","신세계몰");
					break;
				*/
			}
		}
		
	}//class
}//package