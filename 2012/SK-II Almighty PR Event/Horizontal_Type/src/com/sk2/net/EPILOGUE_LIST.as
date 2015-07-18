package com.sk2.net
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.sk2.clips.NumClip;
	import com.sk2.clips.SelSubClip;
	import com.sk2.sub.BaseSub;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.display.SetBitmap;
	import com.sw.net.list.BaseList;
	import com.sw.net.list.Page;
	import com.sw.ui.ImgView;
	import com.sw.ui.SelectBox;
	import com.sw.utils.SetText;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequestMethod;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import flashx.textLayout.elements.SubParagraphGroupElement;
	
	/**
	 * SK2	::	후기 리스트 클래스
	 * */
	public class EPILOGUE_LIST extends BaseList
	{
		protected var search_txt:TextField;
		protected var list_mc:MovieClip;
		protected var selbox:SelectBox;
		public var owner:String ;
		private var list_view:ImgView;
		protected var base_search:String;
		
		/**	생성자	
		 * @param $scope	::	최상위 mc
		 * @param $url		::	로드 요청 url
		 * @param $data		::	함수
		 * 
		 */
		public function EPILOGUE_LIST($scope:Object,$url:String,$data:Object)
		{
			super($scope,$url,$data);
			init();
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			search_txt.removeEventListener(FocusEvent.FOCUS_IN,onFocusSearch);
		}
		/**	변수 내용 초기화 */
		override public function resetData():void
		{
			super.resetData();
			selbox.setSelText(0);
			search_txt.text = base_search;
			owner = "N";
		}
		public function setNo($num:int = 1):void
		{	pageNo = $num;	}
		/**
		 * 초기화
		 * */
		override protected function init($bLoad:Boolean = true):void
		{
			base_search = "입력하세요";
			
			list_mc = scope.list_mc;
			search_txt = scope.txt_search;
			
			selbox = new SelectBox(scope.selbox,SelSubClip,
									{	ary:["아이디","내용"],
										over:onOverSel,
										out:onOutSel,
										click:onClickSel,
										overCol:0x514335,
										outCol:0x514335});
			super.init();
			xml_listTotal = "recordCount";
			xml_pageCnt = "pageCount";
			pageSize = 6;
			cbk_onLoad = onLoad;
			
			page = new Page(scope.page_mc,NumClip,{over:onOverPage,out:onOutPage,current:setCNum,click:onClickNum});
			search_txt.addEventListener(FocusEvent.FOCUS_IN,onFocusSearch);
			
			if($bLoad == true) loadList();
		}
		/**	셀렉트 박스 클릭하였을때	*/
		protected function onClickSel($mc:MovieClip):void{}
		/**	
		 * 자신이 등록한 내용 가져오는지 셋팅	
		 * @param $type	::	String ("Y","N") 
		 */
		public function setMy($type:String):void
		{
			owner = $type;
		}
		/**	검색 텍스트 내용 포커스시	*/
		private function onFocusSearch(e:FocusEvent):void
		{	search_txt.text = "";	}	
			
		/**	리스트 내용 불러오기	*/
		public function loadList():void
		{
			var schType:String = "uid";
			if(selbox.cPos == 1) schType = "post";
			var schString:String = search_txt.text;
			if(base_search == schString) schString = "";
			load({owner:owner,schType:schType,schString:schString},URLRequestMethod.GET);
		}
		/**	리스트 내용이 없을때	*/
		override protected function onNoneList():void
		{
//			DataProvider.popup.viewPop("alert",{txt:"검색 결과가 없습니다."});
			
			if(pageNo == 1 && (search_txt.text == "" || search_txt.text == base_search)) return;
			loadList();
		}
		/**
		 * 데이터 내용 불러오고 난 후
		 * */
		protected function onLoad($xml:XML):void
		{
			scope.list_mc.alpha = 0;
			
			//trace($xml);
			if(scope.txt_cnt != null)
				scope.txt_cnt.text = String(listTotal);
			
			//trace(pageCnt)
			var listCnt:int = $xml.dataList.EventData.length();
			var i:int; 
			for(i =0; i<pageSize; i++)
			{
				var cXml:XML = $xml.dataList.EventData[i];
				
				var list:MovieClip = list_mc["list"+(i+1)];
				
				if(i >= listCnt) 
				{	list.visible = false;	continue;	}
				
				//번호 적용
				var num:int = (listTotal-((pageNo-1)*pageSize))-i;		//번호 거꾸로 체크
				//var num:int = ((pageNo-1)*pageSize)+(i+1);
				
				list.txt_idx.text = SetText.plus0(num);
				if(list.txt_idx.text.length < 3) list.txt_idx.text = "0"+list.txt_idx.text;
				//아이디 적용
				list.txt_id.text = String(cXml.uid.toString()).toLocaleUpperCase();
				//본문 텍스트 적용
				list.txt_body = cXml.postscript.toString();
				list.over_mc.alpha = 0;
				//list.buttonMode = false;
				Button.setUI(list,{click:onClickList});
				list.visible = true;
				/*
				var over_mc:MovieClip = list.over_mc;
				var over_txt:TextField = over_mc.txt;
				over_txt.text = cXml.postscript.toString();
				over_txt.autoSize = TextFieldAutoSize.LEFT;
				if(over_txt.height > over_mc.plane_mc.height) 
				{
					over_txt.autoSize = TextFieldAutoSize.NONE;
					over_txt.height = over_mc.plane_mc.height;
				}
				over_txt.y = Math.round((over_mc.plane_mc.height-over_txt.height)/2)+over_mc.plane_mc.y;
				*/
				TweenMax.killChildTweensOf(list);
				
				//등장 모션
				TweenMax.to(list,0,{delay:0,alpha:0});
				if(list.bg != null)
					DataProvider.baseSub.moveBubble(list.bg,{speed:1-(i*0.05),delay:i*0.05});
				TweenMax.to(list,1-(i*0.05),{delay:i*0.05,alpha:1});
				
				//Button.setUI(list,{over:onOverList,out:onOutList});
				
			}
			var endList:MovieClip = list_mc["list"+listCnt];
			list_mc.x = Math.round((scope.list_bg.width-(endList.width+endList.x))/2)+scope.list_bg.x;
			
			list_mc.alpha = 1;
			data.playRipple();
		}
		/**	리스트 마우스 오버	*/
		private function onOverList($mc:MovieClip):void
		{
			$mc.txt_idx.textColor = 0xffffff;
			$mc.txt.textColor = 0xffffff;
			$mc.txt_id.textColor = 0xdbd3ad;
			TweenMax.to($mc.over_mc,0.5,{alpha:1});
		}
		/**	리스트 마우스 아웃	*/
		private function onOutList($mc:MovieClip):void
		{
			$mc.txt_idx.textColor = 0x8B0106;
			$mc.txt.textColor = 0x8B0106;
			$mc.txt_id.textColor = 0x6E6D5A;
			TweenMax.to($mc.over_mc,0.5,{alpha:0});
		}
		/**	리스트 클릭	*/
		private function onClickList($mc:MovieClip):void
		{
			data.listClick("view",{txt_body:$mc.txt_body,txt_id:$mc.txt_id.text});
			
		}
		/**
		 * 페이지 내용
		 * */
		/**	페이지 오버 */
		private function onOverPage($num:NumClip):void
		{
			page.cPage.txt.textColor = 0x6E6D5A;
			$num.txt.textColor = 0x8B0106;
		}
		/**	페이지 아웃*/
		private function onOutPage($num:NumClip):void
		{
			$num.txt.textColor = 0x6E6D5A;
			page.cPage.txt.textColor = 0x8B0106;
		}
		/**	현제 보고 있는 페이지 표시	*/
		private function setCNum($num:NumClip):void
		{
			DataProvider.baseSub.moveBubble($num.bubble_mc);
			$num.txt.textColor = 0x8B0106;
		}
		/**	페이지 관련 버튼 클릭	*/
		private function onClickNum($pageNo:int):void
		{
			pageNo = $pageNo;
			loadList();
		}
		/**
		 * 검색 관련 내용
		 * */
		private function onOverSel($mc:MovieClip):void
		{	$mc.plane.alpha = 0.05;	}	
		private function onOutSel($mc:MovieClip):void
		{	$mc.plane.alpha = 0;	}
	}//class
}//package

