package com.sw.net.list
{
	import com.sw.buttons.Button;
	import com.sw.display.BaseClass;
	import com.sw.display.Remove;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 리스트에서 페이지 셋팅 클래스
	 * */
	public class Page extends BaseClass
	{
		/**	현제페이지 번호*/
		private var pageNo:int;
		/**	총 페이지	*/
		private var pageCnt:int
		/**	페이지 제한 갯수	*/
		private var pageLimit:int;
		
		/**	복사 될 번호 clip	*/
		private var numClass:Class;
		/**	리스트 상위 obj	*/
		private var list_mc:Sprite;
		/**	리스트 선터 정렬 plane_mc	*/
		private var plane_mc:MovieClip;
		
		/**	현제 페이지	*/
		public var cPage:MovieClip;
		/**	num 버튼 배열	*/
		private var numAry:Array;
		/**	페이지 이동 버튼 배열	*/
		private var btnAry:Array;
		
		/**	현제 페이지 표현	*/
		private var fnc_current:Function;
		/**	페이지 클릭시	*/
		private var fnc_click:Function;
		
		private var startNum:int;
		/**
		 * 생성자<br>
		 * ex : (scope,NumClip,{limit:10,current:currentNum,click:onClickNum})<br>
		 * click 함수 인자 값은 페이지 번호
		 * @param $scope	::	페이지 버튼,graphic 내용을 가지고 있는 display
		 * @param $numClass	::	추가할 listClip
		 * @param $data		::	추가 데이터
		 */
		public function Page($scope:DisplayObjectContainer,$numClass:Class,$data:Object=null)
		{
			super($scope,$data);
			numClass = $numClass;
			init();
		}
		/**	소멸자	*/
		override public function destroy():void
		{}
		/**
		 * 초기화
		 * */
		private function init():void
		{
			plane_mc = scope.plane_mc;
			if(plane_mc == null){	trace("에러 : NumPage, plane_mc가 없습니다.");		return;	}
			btnAry = [""];
			for(var i:int = 1; i<=4; i++)
			{	
				btnAry[i] = null;
				if(scope["page_btn"+i] != null)
					btnAry[i] = scope["page_btn"+i];
			}
			pageLimit = (data.limit != null) ? (data.limit) : (10);
			fnc_current = (data.current != null) ? (data.current) : (null);
			fnc_click = (data.click != null) ? (data.click) : (null);
			
			list_mc = new Sprite();
			scope.addChild(list_mc);
			
		}
		/**	페이지 카운팅 수치 셋팅	*/
		public function setLimitPage($num:int):void
		{
			pageLimit = $num;
		}
		/**
		 * 번호 생성
		 * @param $pageNo		::	현제 페이지
		 * @param $pageCnt		::	총 페이지 수
		 */
		public function setPage($pageNo:int,$pageCnt:int):void
		{
			pageNo = $pageNo;
			pageCnt = $pageCnt;
			
			if(pageCnt ==0) return;
			
			Remove.child(list_mc);
			var num:int = pageNo%pageLimit;
			if(num == 0) num = pageLimit;
			startNum = pageNo-(num)+1;
			numAry = [];
			var i:int;
			for(i = 0; i< pageLimit; i++)
			{
				if((i+startNum) > pageCnt) break;
				
				var list:MovieClip = new numClass();
				numAry.push(list);
				list_mc.addChild(list);
				list.idx = i+startNum;
				if(list.txt != null) list.txt.text = i+startNum;
				if(data.setNum != null) data.setNum(list);
				
				if(pageNo == list.idx && fnc_current != null) 
				{
					cPage = list;
					fnc_current(list);
				}
				list.x = list.plane_mc.width*i;
				Button.setUI(list,{over:data.over,out:data.out,click:onClickNum});
			}
			list_mc.x = Math.round((plane_mc.width - list_mc.width)/2);
			
			//페이지 이동 버튼 
			var posAry:Array = [];
			posAry[1] = posAry[3] = MovieClip(numAry[0]).x+list_mc.x;
			posAry[2] = posAry[4] = MovieClip(numAry[i-1]).x+MovieClip(numAry[i-1]).width+list_mc.x;
			
			for(i = 1; i<btnAry.length; i++)
			{
				var btn:MovieClip = btnAry[i];
				if(btn == null) continue;
				
				btn.idx = -i;
				btn.alpha = 1;
				Button.setUI(btn,{click:onClickNum,override:true});
				
				btn.x = posAry[i];
				if(i == 3 && btnAry[1] != null) btn.x = btn.x - btnAry[1].width;
				if(i == 4 && btnAry[2] != null) btn.x = btn.x - btnAry[2].width;
			}
			scope.alpha = 1;
			scope.visible = true;
			
		}
		/**	페이지 클릭	*/
		public function onClickNum($mc:MovieClip):void
		{
			var num:int;
			num = $mc.idx;
			if(num < 0)
			{	//페이지 이동 버튼 클릭
				switch(num)
				{
				case -1 :		//한페이지 이전
					num = pageNo-1;
					break;
				case -2 :		//한페이지 이후
					num = pageNo+1;
					break;
				case -3 :		//limit페이지 이전
					num = startNum-pageLimit;
					break;
				case -4 :		//limit 페이지 이후
					num = startNum+pageLimit;
					break;
				}
			}
			if(num < 1) num = 1;
			if(num > pageCnt) num = pageCnt;
			if(fnc_click != null) fnc_click(num);	//페이지 클릭
		}
		
	}//class
}//package