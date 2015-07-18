package com.sw.net.list
{
	import com.sw.display.BaseClass;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.System;

	/**
	 *			리스트 데이터 받아오는 클래스
	 */
	public class BaseList extends BaseClass
	{
		//private var loader:URLLoader;
		private var loader:URLStream;
		private var request:URLRequest;	
		
		/**	현제 페이지 위치	*/
		protected var pageNo:int;
		/**	페이지 총 갯수	*/
		protected var pageCnt:int;
		/**	한 페이지당 리스트 갯수	*/
		protected var pageSize:int;
		/**	총 게시물 갯수	*/
		protected var listTotal:int;
		
		/**	xml 페이지 총 갯수 텝명	*/
		protected var xml_pageCnt:String;
		/**	xml 리스트 총 갯수 텝명	*/
		protected var xml_listTotal:String;
		
		/**	로드 완료후 수행할 함수 	*/	
		protected var cbk_onLoad:Function;
		
		/**	페이지 버튼 클래스	*/
		protected var page:Page;
		/**	xml데이터		*/
		private var xml:XML;
		
		/**
		 * 생성자
		 * @param $url		:: 데이터 보낼 주소
		 * @param $data		:: 실을 내용,콜백 함수
		 */
		public function BaseList($scope:Object,$url:String,$data:Object)
		{
			super($scope,$data);
			request = new URLRequest($url);
			pageSize = (data.size) ? (data.size) : (20);
			xml_pageCnt = (data.pageCnt != null) ?  (data.pageCnt) : ("pageCnt");
			xml_listTotal = (data.total != null) ?  (data.total) : ("listTotal");
			cbk_onLoad = (data.onLoad != null) ? (data.onLoad) : (null);
		}
		/**	페이지 위치 반환	*/
		public function getNo():int
		{	return pageNo;	}
		/**	총페이지 반환	*/
		public function getPage():int
		{	return pageCnt;	}
		
		/**	소멸자		*/
		override public function destroy():void
		{
			super.destroy();
			loader.removeEventListener(Event.COMPLETE,onLoad);
		}
		
		/**	데이터 로드 정보 초기화	*/
		public function resetData():void
		{	pageNo = 1;		}
		
		/**	변수 내용 초기화	*/
		protected function init($bLoad:Boolean = true):void
		{
			resetData();
			
			//loader = new URLLoader();
			loader = new URLStream();
			loader.addEventListener(Event.COMPLETE,onLoad);			
		}
		/**
		 * 외부에서 로드 요청
		 * */
		public function loadData($obj:Object = null,$method:String = ""):void
		{
			init();
			load($obj,$method);
		}
		/**
		 * 데이터 로드 <br>
		 * ex					::	load({search:"aaa"});			
		 * @param $listVar		::	같이 실어서 보낼 내용
		 */
		protected function load($obj:Object = null,$method:String = ""):void
		{
			if($method == "") $method = URLRequestMethod.POST;
			
			var listVar:URLVariables = new URLVariables();
			listVar.ran = Math.round(Math.random()*10000);
			listVar.pageNo = pageNo;
			listVar.pageSize = pageSize;
			
			if($obj != null)
			{	for(var txt:String in $obj) listVar[txt] = $obj[txt];	}
			
			request.data = listVar;
			request.method = $method;
			
			loader.load(request);
		}
		/**
		 * 데이터 받아오고 난후
		 * */
		private function onLoad(e:Event):void
		{	
			//받아온 xml내용 저장
			if(data.testTrace == true) trace(XML(URLLoader(e.currentTarget).data));
			
			//xml = new XML(URLLoader(e.currentTarget).data);
			//xml = XML(loader.re
			var encode:String = "utf-8";
			if(System.useCodePage == true) encode = "euc-kr"; 
			xml = XML(loader.readMultiByte(loader.bytesAvailable,encode));
			
			pageCnt = int(xml[xml_pageCnt].toString());
			listTotal = int(xml[xml_listTotal].toString());
			
			if(listTotal == 0)
			{
				resetData();
				onNoneList();
				return;
			}
			//trace(pageCnt);
			//trace(listTotal);
			
			if(page != null) page.setPage(pageNo,pageCnt);
			//로드 완료후 수행할 함수
			if(cbk_onLoad != null) cbk_onLoad(xml);
			
			//페이지 버튼 내용 적용
			//if(numClass != null) numPage = new NumPage(data.listLimit,data.numClass,data.numData);
		}
		/**	리스트 내용이 없을때 수행할 함수	*/
		protected function onNoneList():void
		{
			trace("리스트 내용이 없습니다.");
		}
		
		/**	받아온 xml반환	*/
		public function getXML():XML
		{	return xml;	}
	}//class
}//package