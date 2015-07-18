package com.discovery.experience
{
	import flash.events.Event;
	import flash.net.URLVariables;
	
	public class ListUpdate
	{
		private var $type:String;
		
		private var $listPage:XML;
		
		private var $listArr:Array;
		
		private var $loadData:LoadData;
		
		private var $dataListUrl:String;
		
		private var $wheelDirection:String;
		
		private var $dataObj:Object;
		
		private var $singleListFN:Function;
		
		private var $pageListFN:Function;
		
		private var $pSize:int;
		
		private var $pushXMLGroup:Vector.<XML>;
		
		private var _firstNum:int;
		private var _lastNum:int;
		
		private var _allLIstUpdateCompleteFN:Function;
		private var _listRotTime:Number;
		
		
		public function ListUpdate()
		{
			$loadData = new LoadData();
		}
		
		public function close():void
		{
			$loadData.close();
		}
		
		public function update(type:String, listPage:XML, listArr:Array, psize:int, dataListUrl:String, dataObj:Object, wheelDirection:String, 
							   					singleListFN:Function, pageListFN:Function, allListUpdateComplete:Function, listRotationTime:Number,
												firstNum:int, lastNum:int):void
		{
			$type = type;
			$listPage = listPage;
			$listArr = listArr;
			$pSize = psize;
			$dataListUrl = dataListUrl;
			$dataObj = dataObj;
			$wheelDirection = wheelDirection;
			$singleListFN = singleListFN;
			$pageListFN = pageListFN;
			_firstNum = firstNum;
			_lastNum = lastNum;
			
			_allLIstUpdateCompleteFN = allListUpdateComplete;
			_listRotTime = listRotationTime;
			
			var vari:URLVariables = makeVari(psize);
//			var vari:URLVariables = new URLVariables();
//			vari.rand = Math.round(Math.random()*10000);
//			vari.pageSize = psize;
//			vari.missionNum = $dataObj.missionNum;
//			
//			if($type == "site")
//			{
//				if($dataObj.idx == -1){
//					vari.searchAge = $dataObj.searchAge;
//					vari.searchSkinCare = $dataObj.searchSkinCare;
//					vari.searchUseYN	= $dataObj.searchUseYN;
//					vari.searchBrand = $dataObj.searchBrand;
//				}
//			}
//			else if($type == "kiosk")
//			{
//				vari.barcodeNo	 = $dataObj.barcodeNo;
//				if($dataObj.searchAge != undefined){
//					vari.searchAge	= $dataObj.searchAge;
//				}
//				if($dataObj.searchSkinCare != undefined){
//					vari.searchSkinCare	= $dataObj.searchSkinCare;
//				}
//				if($dataObj.searchUseYN != undefined){
//					vari.searchUseYN	= $dataObj.searchUseYN;
//				}
//				if($dataObj.searchBrand != undefined){
//					vari.searchBrand = $dataObj.searchBrand;
//				}
//			}
			
			var i:int;
			if($wheelDirection == "up") {
				for (i = 0; i < $listArr.length; i++) 
				{
					if(_lastNum == $listArr[i].listnum)
					{
						vari.nlist = $listArr[i].idx;
						vari.listnum = $listArr[i].listnum;
						trace("nlist", vari.nlist , vari.listnum, i, $listArr[i].listnum);
					}
				}
//				vari.nlist = $listArr[$listArr.length-1].idx;
//				vari.listnum = $listArr[$listArr.length-1].listnum;
//				trace("nlist", vari.nlist , vari.listnum);
			}
			else if($wheelDirection == "down") {
				for (i = 0; i < $listArr.length; i++) 
				{
					if(_firstNum == $listArr[i].listnum)
					{
						vari.plist = $listArr[i].idx;
						vari.listnum = $listArr[i].listnum;
						trace("plist", vari.plist , vari.listnum, i);
					}
				}
//				vari.plist = $listArr[0].idx;
//				vari.listnum = $listArr[0].listnum;
//				trace("plist", vari.plist , vari.listnum);
			}
			$loadData.load($dataListUrl, vari, listInfoComplete);
		}
		
		private function listInfoComplete(e:Event):void
		{
			var xml:XML = XML(e.target.data);
			var list:XMLList = xml.dataList.EventData;
			var len:int = list.length();
			trace("load 1. -> ", "가져올 갯수:", $pSize, " 가져온 갯수:",len);
			
			$pushXMLGroup = new Vector.<XML>();
			var pushXml:XML;
			var i:int;
			if($pSize == len && $pSize != $listArr.length+1)
			{
				i = 1;
				for (; i < len; i++) 
				{
					pushXml = XML(list[i]);
					$singleListFN(pushXml, _listRotTime);
				}
				
				_allLIstUpdateCompleteFN(_listRotTime);
			}
			else if(len <= $pSize)
			{
				i = 1;
				for (; i < len; i++) 
				{
					pushXml = XML(list[i]);
					$pushXMLGroup.push(pushXml);
				}
				
				var gap:int = $pSize - len;
				var vari:URLVariables = makeVari(gap);
//				var vari:URLVariables = new URLVariables();
				if($wheelDirection == "up") {
					// 첫페이지 가져오기
					vari.listnum = $listPage.dataList.EventData[0].listnum;
					vari.nlist = $listPage.dataList.EventData[0].idx;
				}
				else if($wheelDirection == "down") 
				{
					//  마지막 가져오기
					var lastPage:int = Math.ceil($listPage.dataCount/gap);
					vari.pageNo = lastPage;
				}
//				vari.rand = Math.round(Math.random()*10000);
//				vari.pageSize = gap;
//				vari.missionNum = $dataObj.missionNum;
//				if($type == "site")
//				{
//					if($dataObj.idx == -1){
//						vari.searchAge = $dataObj.searchAge;
//						vari.searchSkinCare = $dataObj.searchSkinCare;
//						vari.searchUseYN	= $dataObj.searchUseYN;
//						vari.searchBrand = $dataObj.searchBrand;
//					}
//				}
//				else if($type == "kiosk")
//				{
//					vari.barcodeNo	 = $dataObj.barcodeNo;
//					if($dataObj.searchAge != undefined){
//						vari.searchAge	= $dataObj.searchAge;
//					}
//					if($dataObj.searchSkinCare != undefined){
//						vari.searchSkinCare	= $dataObj.searchSkinCare;
//					}
//					if($dataObj.searchUseYN != undefined){
//						vari.searchUseYN	= $dataObj.searchUseYN;
//					}
//					if($dataObj.searchBrand != undefined){
//						vari.searchBrand = $dataObj.searchBrand;
//					}
//				}
				trace(gap , $pSize , len);
				$loadData.load($dataListUrl, vari, listinfoReloadComplete);
			}
		}
		
		private function listinfoReloadComplete(e:Event):void
		{
			var xml:XML = XML(e.target.data);
			var list:XMLList = xml.dataList.EventData;
			var len:int = list.length();
			trace("load 2. -> ", "가져올 갯수:", xml.pageSize, " 가져온 갯수:",len);
			
			var pushXml:XML;
			var cnt:int = len-1;
			for (var i:int = 0; i < len; i++) 
			{
				if($wheelDirection == "up") {
					pushXml =list[i];
				}
				else if($wheelDirection == "down") 
				{
					pushXml =list[cnt];
				}
//				trace(pushXml);
				$pushXMLGroup.push(pushXml);
				
				cnt--;
			}
			
			var psize:int = xml.pageSize;
			var gap:int = psize - len;
			if(gap == 0){
				createUpdateList();
			}else{
				var vari:URLVariables = makeVari(gap+1);
//				var vari:URLVariables = new URLVariables();
//				vari.rand = Math.round(Math.random()*10000);
//				vari.missionNum = $dataObj.missionNum;
//				vari.pageSize = gap+1;
//				
//				if($type == "site")
//				{
//					vari.plist = $pushXMLGroup[len-1].idx;
//					vari.listnum = $pushXMLGroup[len-1].listnum;
//					if($dataObj.idx == -1){
//						vari.searchAge = $dataObj.searchAge;
//						vari.searchSkinCare = $dataObj.searchSkinCare;
//						vari.searchUseYN	= $dataObj.searchUseYN;
//						vari.searchBrand = $dataObj.searchBrand;
//					}
//				}
//				else if($type == "kiosk")
//				{
//					vari.barcodeNo	 = $dataObj.barcodeNo;
//					if($dataObj.searchAge != undefined){
//						vari.searchAge	= $dataObj.searchAge;
//					}
//					if($dataObj.searchSkinCare != undefined){
//						vari.searchSkinCare	= $dataObj.searchSkinCare;
//					}
//					if($dataObj.searchUseYN != undefined){
//						vari.searchUseYN	= $dataObj.searchUseYN;
//					}
//					if($dataObj.searchBrand != undefined){
//						vari.searchBrand = $dataObj.searchBrand;
//					}
//				}
				
				vari.plist = list[0].idx;
				vari.listnum = list[0].listnum;
				trace(  "plist : ", vari.plist);
				
				$loadData.load($dataListUrl, vari, listinfoReloadComplete2);
			}
		}
		
		private function listinfoReloadComplete2(e:Event):void
		{
			var xml:XML = XML(e.target.data);
			var list:XMLList = xml.dataList.EventData;
			var len:int = list.length();
			
			var pushXml:XML;
			for (var i:int = 1; i < len; i++) 
			{
				pushXml =list[i];
				trace(pushXml.listnum , pushXml.idx);
				if($wheelDirection == "up") {
					$pushXMLGroup.unshift(pushXml);
				}
				else if($wheelDirection == "down") 
				{
					$pushXMLGroup.push(pushXml);
				}
			}
			
			createUpdateList();
		}
		
		private function createUpdateList():void
		{
			trace("-------------------------------------------------");
			var len:int = $pushXMLGroup.length;
			if(len >= 20)
			{
				$pageListFN(true, $pushXMLGroup);
				trace("@@@@@@@@@@@@@@@@@@           " + len);
			}
			else
			{
				for (var i:int = 0; i < len; i++) 
				{
					$singleListFN($pushXMLGroup[i], _listRotTime);
				}
				
				_allLIstUpdateCompleteFN(_listRotTime);
			}
			trace("-------------------------------------------------");
		}
		
		/**	UrlVari 생성	*/
		private function makeVari(pSize:int):URLVariables
		{
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.pageSize = pSize;
			
			if($type == "site")
			{
				if(int($dataObj.searchKey) == -1 || $dataObj.searchKey == undefined || $dataObj.searchKey == null)
				{
					vari.missionNum = $dataObj.missionNum;
					vari.searchAge = $dataObj.searchAge;
					vari.searchSkinCare = $dataObj.searchSkinCare;
					vari.searchUseYN	= $dataObj.searchUseYN;
					vari.searchBrand = $dataObj.searchBrand;
				}else{
					vari.searchKey = $dataObj.searchKey;
				}
			}
			else if($type == "kiosk")
			{
				if(int($dataObj.searchKey) == -1 || $dataObj.searchKey == undefined || $dataObj.searchKey == null)
				{
					vari.missionNum = $dataObj.missionNum;
					vari.barcodeNo	 = $dataObj.barcodeNo;
					if($dataObj.searchAge != undefined){
						vari.searchAge	= $dataObj.searchAge;
					}
					if($dataObj.searchSkinCare != undefined){
						vari.searchSkinCare	= $dataObj.searchSkinCare;
					}
					if($dataObj.searchUseYN != undefined){
						vari.searchUseYN	= $dataObj.searchUseYN;
					}
					if($dataObj.searchBrand != undefined){
						vari.searchBrand = $dataObj.searchBrand;
					}
				}
				else
				{
					vari.searchKey = $dataObj.searchKey;
				}
			}
			return vari;
		}
	}
}