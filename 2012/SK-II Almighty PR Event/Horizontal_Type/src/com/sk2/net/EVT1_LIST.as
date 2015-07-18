package com.sk2.net
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.sk2.clips.ClearClip;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.BtnEnter;
	import com.sw.buttons.Button;
	import com.sw.display.Remove;
	import com.sw.utils.McData;
	import com.sw.utils.SetFont;
	import com.sw.utils.SetText;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * SK2 :: 신청 하기 데이터 연동
	 * */
	public class EVT1_LIST extends EPILOGUE_LIST
	{
		/**	검색 내용 셀렉트 박스	*/
		private var selbox_mc:MovieClip;
		/**	마지막 리스트 내용	*/
		private var endList:MovieClip;
		/**	마우스 올리고 있는 리스트	*/
		private var overList:MovieClip;
		
		/**	생성자	*/
		public function EVT1_LIST($scope:Object, $url:String, $data:Object)
		{
			super($scope, $url, $data);
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			MovieClip(scope).removeEventListener(Event.ENTER_FRAME,onEnter);
		}
		
		/**
		 * 초기화
		 * */
		override protected function init($bLoad:Boolean = true):void
		{
			super.init(false);
			
			cbk_onLoad = onLoad;
			pageSize = 10;
			selbox_mc = scope.selbox;
			selbox_mc.txt.text = "아이디";
			//selbox.setListText(["이름","전화번호","매장명"]);
			selbox_mc.mouseChildren = false;
			selbox_mc.mouseEnabled = false;
			//MovieClip(scope).mouseChildren = true;
			
			DataProvider.baseSub.setBaseBtn(scope.btn3,onClickSearch);
			page.setLimitPage(5);	//페이지 내용 컷트 수
			
			//1페이지 다음,이전 버튼
			var i:int;
			for(i =1; i<=2; i++)
			{
				var btn:MovieClip = scope["point"+i];
				if(btn == null) continue;
				btn.idx = i*-1;
				var be:BtnEnter = new BtnEnter(btn,{click:page.onClickNum});
				//Button.setUI(btn,{click:page.onClickNum});
			}
			if($bLoad == true) loadList();
			MovieClip(scope).addEventListener(Event.ENTER_FRAME,onEnter);
			
			for(i =1; i<=10; i++)
			{	
				if(scope.list_mc["list"+i] == null) continue;
				McData.save(scope.list_mc["list"+i]);
			}
		}
		/**	
		 * 	로드한 데이터가 없을때 수행	
		 * */
		override protected function onNoneList():void
		{	
			if(scope.visible == false) return;
			super.onNoneList();
			data.playRipple();
		}
		
		/**	리스트 내용 로드	*/
		override public function loadList():void
		{
			var txt:String = search_txt.text;
			if(txt == base_search) txt = "";
			load({schString:txt},URLRequestMethod.GET);
		}
		protected function onClickSearch($mc:MovieClip):void
		{
			pageNo = 1;
			loadList();
		}
		/**	로드 완료 후 수행 함수	*/
		override protected function onLoad($xml:XML):void
		{
			scope.list_mc.alpha = 0;
			//trace($xml);
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
				var txt_idx:TextField = list.txt_idx as TextField;
				
				txt_idx.text = SetText.plus0(num);
				if(txt_idx.text.length < 3) txt_idx.text = "0"+txt_idx.text;
				txt_idx = SetFont.getIns().go(txt_idx,{font:"YDIYSin"});
				
				//list.txt_idx.text = "aa";
				//txt_idx = SetFont.getIns().go(list.txt_idx,{font:"YDIYSin"});
				//trace();
				//아이디 적용
				list.over_mc.txt_id.text = list.txt_id.text = String(cXml.uid.toString()).toLocaleUpperCase()+" 님의";
				SetFont.getIns().go(list.txt_id,{font:"YDIYSin"});
				SetFont.getIns().go(list.over_mc.txt_id,{font:"SD SeokPil L (P)",size:20});
				//글 내용 적용
				list.ans1 = String(cXml.ans1.toString());
				list.ans2 = String(cXml.ans2.toString());
				
				//본문 텍스트 적용
				list.over_mc.txt_body.text = String(list.ans1);
				if(String(list.ans1).length > 30 )
					list.over_mc.txt_body.text = String(list.ans1).substr(0,30)+"...";
				list.over_mc.alpha = 0;
				SetFont.getIns().go(list.over_mc.txt_body,{font:"SD SeokPil L (P)",leading:0,size:20});
				
				list.addChild(list.over_mc);
				list.addChild(list.plane_mc);
				
				list.over_mc.mask = list.plane_mc;
				list.out_mc.alpha = 1;
				list.plane_mc.width = list.out_mc.width;
				list.numOver = 183;
				
				list.over_mc.visible = false;
				list.rotation = 20;
				list.x = list.dx+30;
				list.over_mc.scaleX = 0.4;
				list.mouseChildren = false;
				
				Button.setUI(list,{over:onOverList,out:onOutList,click:onClickList});
				list.visible = true;
				TweenMax.killChildTweensOf(list);
				
				//등장 모션
				TweenMax.to(list,0,{delay:0,alpha:0});
				TweenMax.to(list,1-(i*0.05),{delay:i*0.05,rotation:0,x:list.dx,alpha:1,ease:Back.easeOut});
			}
			
			endList = list_mc["list"+listCnt];
			//list_mc.x = Math.round((scope.list_bg.width-(endList.plane_mc.width+endList.x))/2)+scope.list_bg.x;
			list_mc.alpha = 1;
			
			data.playRipple();
		}
		/**	리스트 마우스 오버	*/
		private function onOverList($mc:MovieClip):void
		{
			if(overList != null)
			{
				TweenMax.to(overList.plane_mc,0.5,{width:$mc.out_mc.width});
				TweenMax.to(overList.over_mc,0.5,{alpha:0,ease:Expo.easeOut,scaleX:0.4,onComplete:finishList,onCompleteParams:[$mc]});
				TweenMax.to(overList.out_mc,0.5,{alpha:1,ease:Expo.easeOut});
			}
			
			TweenMax.to($mc.plane_mc,0.5,{width:$mc.numOver});
			//$mc.plane_mc.visible = true;
			$mc.over_mc.visible = true;
			TweenMax.to($mc.over_mc,0.5,{alpha:1,scaleX:1,ease:Expo.easeOut});
			TweenMax.to($mc.out_mc,0.5,{alpha:0,ease:Expo.easeOut});
			overList = $mc;
		}
		/**	리스트 마우스 아웃	*/
		private function onOutList($mc:MovieClip):void
		{	
			/*
			TweenMax.to($mc.plane_mc,0.5,{width:$mc.out_mc.width});
			TweenMax.to($mc.over_mc,0.5,{alpha:0,ease:Expo.easeOut,scaleX:0.4,onComplete:finishList,onCompleteParams:[$mc]});
			TweenMax.to($mc.out_mc,0.5,{alpha:1,ease:Expo.easeOut});
			*/
		}
		/**	리스트 아웃 모션 끝나고 난후	*/
		private function finishList($mc:MovieClip):void
		{
			if($mc.over_mc.alpha == 0) $mc.over_mc.visible = false;
			if($mc.y != $mc.dy) $mc.y = $mc.dy;
		}
		/**	리스트 클릭	*/
		private function onClickList($mc:MovieClip):void
		{
			TweenMax.to($mc,1,{y:$mc.dy-20,onComplete:finishList,onCompleteParams:[$mc]})
			data.listClick("view",{ans1:$mc.ans1,ans2:$mc.ans2,txt_id:$mc.txt_id.text});
		}
		
		/**
		 * 매순간 마다 리스트 내용 제정렬
		 * */
		private function onEnter(e:Event):void
		{
			if(endList == null) return;
			var dirX:int;
			dirX = Math.round((scope.list_bg.width-(endList.plane_mc.width+endList.x))/2)+scope.list_bg.x;
			dirX += 30; 
			list_mc.x -= (list_mc.x - dirX)*0.3;
			for(var i:int = 2; i<=10;i++)
			{
				var list:MovieClip = scope.list_mc["list"+i];
				var beList:MovieClip = scope.list_mc["list"+(i-1)];
				dirX = beList.plane_mc.width+ beList.x;
				list.x = dirX;
			}
		}
		
	}//class
}//pacakge