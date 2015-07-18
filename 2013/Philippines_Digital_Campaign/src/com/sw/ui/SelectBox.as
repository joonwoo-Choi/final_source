package com.sw.ui
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	* 셀렉트 박스 클래스
	* new SelectBox(구현 무비클립,리스트클래스,{클릭함수(mc),})<br>
 	* selbox = new SelectBox(con.selbox,SelSubClip,
	* 								{	ary:["aaa","bbb"],<br>
	* 									overCol:0xFFFFFF,outCol:0xDDDDDD,<br>
	*									click:onClickSel});
	*/ 
	public class SelectBox extends Object
	{
		private var scope_mc:MovieClip;
		private var sub_mc:MovieClip;
		
		private var CListSub:Class;
		
		private var listAry:Array;
		private var subAry:Array;
		
		private var clickFnc:Function;
		
		private var overCol:uint;
		private var outCol:uint;
		
		private var data:Object;
		
		/**	현제 선택한 메뉴 위치	*/
		public var cPos:int;
		
		/**
		 * 생성자 함수<br>
		 * new SelectBox(구현 무비클립,리스트클래스,{클릭함수,})
		 * */
		public function SelectBox($scope_mc:MovieClip,$listClass:Class,$dataObj:Object)
		{
			fN_init($scope_mc,$listClass,$dataObj);
			fN_setLayout();		
			fN_addEvent();
		}
		/**
		 * ************************************************************************
		 * 데이터 내용 초기화
		 * *************************************************************************/
		public function fN_init($scope_mc:MovieClip,$listClass:Class,$dataObj:Object):void
		{
			scope_mc = $scope_mc;
			sub_mc = scope_mc.sub;
			CListSub = $listClass;
			
			//데이터 오브젝트 적용
			overCol = $dataObj.overCol ? ($dataObj.overCol): 0xFFFFFF;
			outCol = $dataObj.outCol ? ($dataObj.outCol): 0xDDDDDD;
			listAry = $dataObj.ary ? ($dataObj.ary):([""]);
			
			data = $dataObj;
			subAry = [];
			scope_mc.txt.text = listAry[0];
		}
		/**************************************************************************
		 * 						위치 셋팅
		 * ***********************************************************************/
		private function fN_setLayout():void
		{
			fN_setList();
		}
		/**	셀렉스 박스 선택 내용 지정	*/
		public function setSelText($pos:int):void
		{	
			cPos = $pos;
			scope_mc.txt.text = listAry[$pos]
		}
		/**
		 * 셀렉트 박스 서브 텍스트 내용 변환
		 * */
		public function setListText($ary:Array):void
		{
			/*
			if($ary.length != listAry.length) 
			{	
				trace("error: SelectBox, 기존 리스트 내용과 갯수가 다릅니다.");	//return;	
			}
			*/
			var i:int;
			
			for(i = 0; i<listAry.length; i++)
			{	//기존 내용 초기화
				sub_mc.removeChild(subAry[i]);
			}
			subAry = [];
			listAry = [];
			for(i = 0; i<$ary.length; i++)
			{
				listAry[i] = $ary[i];
				//subAry[i].txt.text = $ary[i];
			}
			//새로운 메뉴 셋팅
			fN_setList();
		}
		/**
		 * 서브 리스트 생성
		 */
		private function fN_setList():void
		{
			for(var i:Number =0; i<listAry.length; i++)
			{
				var mc:MovieClip = new CListSub();
				subAry.push(mc);
				sub_mc.addChild(mc);
				
				mc.idx = i;
				mc.y = (i*mc.height) + sub_mc.bg.height;
				mc.txt.text = listAry[i];	
				mc.txt.textColor = outCol;
				fN_setListBtn(mc);
			}
			
			sub_mc.plane.height = sub_mc.height;
			sub_mc.bPlane.y = sub_mc.plane.height-Math.round(sub_mc.bPlane.height/2);
		}
		
		/**
		 * 이벤트 모음
		 */ 
		private function fN_addEvent():void
		{
			fN_btn();
		}
		/**
		 * 셀렉스 박스 전체 버튼화
		 * */
		private function fN_btn():void
		{
			scope_mc.plane.buttonMode = true;
			scope_mc.plane.alpha = 0;
			scope_mc.addChild(scope_mc.plane);
			scope_mc.plane.addEventListener(MouseEvent.MOUSE_OVER,fN_onPlaneOver);
		}
		/**	서브 리스트 열기	*/
		public function fN_onPlaneOver(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			//mc.useHandCursor = false;
			TweenLite.to(scope_mc.Mask,0.5,{height:sub_mc.height,ease:Expo.easeOut});
			
			scope_mc.plane.addEventListener(Event.ENTER_FRAME,fN_onPlaneEnter);
			scope_mc.point.nextFrame();
		}
		/**	서브 리스트 닫기	*/
		public function onCloseSub():void
		{
			TweenLite.to(scope_mc.Mask,0.5,{height:10,ease:Expo.easeOut});
			scope_mc.point.prevFrame();
			scope_mc.plane.removeEventListener(Event.ENTER_FRAME,fN_onPlaneEnter);		
		}
		/**	마우스 오버 후 닫힐지 여부 체크	*/
		private function fN_onPlaneEnter(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			if(scope_mc.mouseX < 0 ||
				scope_mc.mouseX > scope_mc.width ||
				scope_mc.mouseY < 0 ||
				scope_mc.mouseY > scope_mc.height )
			{
				onCloseSub();
			}
		}
		/**	
		 * 서브 리스트 버튼화	
		 * */
		private function fN_setListBtn($mc:MovieClip):void
		{
			$mc.mouseChildren = false;
			$mc.buttonMode = true;
			$mc.addChild($mc.plane);
			$mc.addEventListener(MouseEvent.MOUSE_OVER,fN_onOverList);
			$mc.addEventListener(MouseEvent.MOUSE_OUT,fN_onOutList);
			$mc.addEventListener(MouseEvent.CLICK,fN_onClickList);
		}
		/**
		 * 서브 리스트 오버
		 * */
		private function fN_onOverList(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.txt.textColor = overCol;
			if(data.over != null) data.over(mc);
		}
		/**
		 * 서브 리스트 아웃
		 * */
		private function fN_onOutList(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.txt.textColor = outCol;
			
			if(data.out != null) data.out(mc);
		}
		/**
		 * 서브 리스트 클릭
		 * */
		private function fN_onClickList(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			cPos = mc.idx;
			scope_mc.txt.text = mc.txt.text;
			onCloseSub();
			if(data.click != null) data.click(mc);
		}
		/**	소멸자	*/
		public function destroy():void
		{
			
		}
	}	
}
