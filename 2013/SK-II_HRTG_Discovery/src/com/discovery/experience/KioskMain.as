package com.discovery.experience
{
	
	import com.adqua.util.ButtonUtil;
	import com.discovery.events.DiscoveryEvent;
	import com.discovery.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFieldAutoSize;
	
	public class KioskMain
	{
		
		private var $con:MovieClip;
		
		private var $loadData:LoadData;
		
		private var $listUpdate:ListUpdate;
		
		private var $downY:Number;
		
		private var $dataListUrl:String = "http://www.piterahouse.com/event/discovery/KeywordList.ashx";
//		private var $dataListUrl:String = "http://www.piterahouse.com/Event/discovery/WallSmartFinderList.ashx";
//		private var $dataListUrl:String = "http://www.piterahouse.com/Event/discovery/SmartFinderList.ashx";
		
		private var $listPage:XML;
		/**	리스트 전체 수	*/
		private var $totalLength:int;
		/**	한페이지 리스트 수	*/
		private var $pageLength:int;
		/**	리스트 배열	*/
		private var $listArr:Array;
		/**	리스트 사이즈	*/
		private var $scaleArr:Array = [0.12, 0.15, 0.17, 0.25, 0.33, 0.41, 0.51, 0.61, 0.72, 1, 0.72, 0.61, 0.51, 0.41, 0.33, 0.25, 0.17, 0.15, 0.13, 0.12, 0.1, ];
		
		private var $centerPoint:Point = new Point(-964, 0);
		
		/**	위치	*/
		private var $pointLength:int = 20;
		private var $pointArr:Array;
		
		private var $isRotation:Boolean = false;
		
		private var $scrollDirection:String = "down";
		
		private var $wheelDirection:String = "down";
		
		private var $dataObj:Object;
		
		private var $viewContent:ViewContent;
		
		private var $isContentOpen:Boolean = false;
		
		private var $quickContentShow:Boolean = false;
		
		private var $guideShowChk:Boolean = true;
		
		private var $listClick:Boolean = true;
		
		private var $pageChange:Boolean = true;
		
		private var $listChange:Boolean = false;
		
		private var _viewListScrollBtn:Boolean;
		
		private var _firstNum:int;
		private var _lastNum:int;
		
		public function KioskMain(con:MovieClip, type:String)
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			$con = con;
			$con.alpha = 0;
			$con.visible = false;
			$con.listCon.plane.mouseEnabled = false;
			$con.listCon.plane.mouseChildren = false;
			$con.loader.visible = false;
			$con.loader.loader.gotoAndStop(1);
			$viewContent = new ViewContent($con, type);
			
			$con.guide.alpha = 0;
			$con.guide.visible = false;
			
			// 가이드 2프레임으로...
			$con.guide.circle.gotoAndStop(2);
			
			// 스크롤 버튼은 기본적으로 안보임...
			$con.kioskScrollCon.visible = false;
			$con.kioskScrollCon.alpha = 0;
			
			$loadData = new LoadData();
			
			$listUpdate = new ListUpdate();
			
			$con.addEventListener(DiscoveryEvent.SHOW_LIST, showList);
			$con.addEventListener(DiscoveryEvent.HIDE_LIST, hideList);
			$con.addEventListener(DiscoveryEvent.CLOSE_CONTENT, closeContent);
			$con.addEventListener(DiscoveryEvent.CHANGE_CONTENT, changeContent);
			
			if($con.root.parent is Stage)
			{
//				$con.dispatchEvent(new DiscoveryEvent(DiscoveryEvent.SHOW_LIST, {barcodeNo:"SK0082", missionNum:1, searchAge:1, searchSkinCare:1, searchUseYN:1, searchBrand:1}));
				$con.dispatchEvent(new DiscoveryEvent(DiscoveryEvent.SHOW_LIST, {barcodeNo:"SK1091", missionNum:2, searchKey:-1}));
//				$con.dispatchEvent(new DiscoveryEvent(DiscoveryEvent.SHOW_LIST, {barcodeNo:"SK0082", missionNum:1}));
				
				$con.stage.addEventListener(Event.RESIZE, resizeHandler);
			}
			resizeHandler();
			
//			$con.kioskScrollCon.scroll.buttonMode = true;
			$con.kioskScrollCon.scroll.mouseChildren = false;
			$con.kioskScrollCon.scroll.addEventListener(MouseEvent.MOUSE_DOWN, scrollDownHandler);
		}
		
		/**	리스트 보이기	*/
		protected function showList(e:DiscoveryEvent):void
		{
			$listChange = false;
			$pageChange = true;
			$isContentOpen = false;
			
			$wheelDirection = "down";
			$scrollDirection = "down"
			$dataObj = e.value;
			$viewContent.positionSetting($dataObj);
//			$con.kioskContentCon.title.title.gotoAndStop(int($dataObj.missionNum));
			
			TweenLite.to($con, 1, {autoAlpha:1});
			
			$con.listCon.stage.addEventListener(MouseEvent.MOUSE_DOWN, listDownHandler);
			userDataLoad();
		}
		/**	상세보기 닫기	*/
		protected function closeContent(e:Event):void
		{
			$isRotation = true;
			$listChange = true;
			$isContentOpen = false;
			if(_viewListScrollBtn)
			{
				TweenLite.to($con.kioskScrollCon, 0.5, {autoAlpha:1});
			}
			makePointArray("pointKioskDefault");
			for (var i:int = 0; i < $listArr.length; i++) 
			{
				contenViewClose(i, false);
			}
		}
		/**	상세보기 팝업 리스트 변경	*/
		protected function changeContent(e:DiscoveryEvent):void
		{
			if($isRotation == true || $listArr.length == 1) return;
			$isRotation = true;
			if(e.value.direction == "up")
			{
				$wheelDirection = "up";
			}
			else if(e.value.direction == "down")
			{
				$wheelDirection = "down";
			}
			rotationList(1);
		}
		
		private function contentsChange():void
		{
			for (var i:int = 0; i < $listArr.length; i++) 
			{
				if($pointArr[i].ro == 0)
				{
					if($wheelDirection == "up") $viewContent.contentSetting($listArr[i].xml, $listArr[i], $listArr.length);
					else if($wheelDirection == "down") $viewContent.contentSetting($listArr[i].xml, $listArr[i], $listArr.length);
				}
			}
		}
		
		/**	리스트 로드	*/
		private function userDataLoad():void
		{
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.pageNo = 1;
			vari.pageSize = 20;
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
				$dataListUrl = "http://www.piterahouse.com/event/discovery/WallKeywordList.ashx";
			}
			else
			{
				vari.searchKey = $dataObj.searchKey;
				$dataListUrl = "http://www.piterahouse.com/event/discovery/KeywordList.ashx";
			}
			
			$loadData.load($dataListUrl, vari, listXmlLoadComplete);
		}
		/**	리스트 로드 완료	*/
		private function listXmlLoadComplete(e:Event):void
		{
			if($listArr != null) removeAllList();
			var bool:Boolean;
			try
			{
				$listPage = XML(e.target.data);
			}catch(er:Error)
			{
				trace(er.message);
				bool = true;
			}
			if(bool) return;
			trace("총 데이타 갯수 : "+$listPage.dataCount);
			
			var dataCnt:int = $listPage.dataCount; 
			if(dataCnt > 0)
			{
				// 데이터가 있을경우에만...
				// 인터랙티브 월에서는 쇼리스트 할때마다 가이드 나오게.... ////////////////////////////////////////
				if($guideShowChk == true)
				{
					TweenMax.to($con.guide, 0.4, {autoAlpha:1});
					
					$guideShowChk = false;
					
					var delay:Number = 4.5;
					$con.guide.guideMask.scaleX = $con.guide.guideMask.scaleY = 0;
					TweenLite.to($con.guide.guideMask, 1, {scaleX:1, scaleY:1, ease:Expo.easeOut});
					TweenLite.delayedCall(delay, function():void
					{		
						TweenLite.to($con.guide.guideMask, 1, {scaleX:0, scaleY:0, ease:Expo.easeOut});		
					});
					TweenLite.to($con.guide, 0.75, {delay:delay, autoAlpha:0});
				}
				//////////////////////////////////////////////////////////////////////////////////////////////////////////
			}else{
				TweenMax.to($con.guide, 0.4, {autoAlpha:0});
			}
			
			if(dataCnt > 20)
			{
				// 데이터 갯수가 한페이가 이상일대 스크롤 버튼 보임
				TweenLite.to($con.kioskScrollCon, 0.5, {autoAlpha:1});
				_viewListScrollBtn = true;
			}
			else
			{
				// 아닐시 버튼 감춤
				TweenLite.to($con.kioskScrollCon, 0.5, {autoAlpha:0});
				_viewListScrollBtn = false;
			}
			settingList();
		}
		/**	페이지 리스트 셋팅	*/
		private function settingList():void
		{
			$totalLength = $listPage.dataCount;
			$pageLength = $listPage.dataList.EventData.length();
			$dataObj.pageNo = $listPage.pageNo;
			$dataObj.pageCount = $listPage.pageCount;
			
			makePointArray("pointKioskDefault");
			
			makeListArray();
		}
		
		/**	포인트 배열 만들기	*/
		private function makePointArray(pointName:String):void
		{
			$pointArr = [];
			var j:int;
			for (j = 0; j < $pointLength; j++) 
			{
				var point:MovieClip = $con.listCon.getChildByName(pointName + j) as MovieClip;
				$pointArr.push(point);
				point.scale = $scaleArr[j];
				var radians:Number = Math.atan2(point.y - $centerPoint.y, point.x - $centerPoint.x);
				point.ro = Math.round(radians*180/Math.PI);
			}
			/**	한페이지 리스트 수가 20개보다 적다면 적은 수만큼 포인트 제거	*/
			var shortNum:int;
			if($pageLength < 20)
			{
				shortNum = 20 - $pageLength;
				var k:int;
				for (k = 0; k < shortNum; k++) 
				{
					if(k%2 == 1) $pointArr.shift();
					else $pointArr.pop();
				}
			}
		}
		
		/**	리스트 배열 만들기	*/
		private function makeListArray(isScroll:Boolean = false, vector:Vector.<XML> = null):void
		{
			$listArr = [];
			var i:int;
			var xml:XML;
			var mcList:MovieClip;
			if(isScroll == false)
			{
				for (i = 0; i < $pageLength; i++) 
				{
					xml = $listPage.dataList.EventData[i];
					
					mcList = makeList(xml);
					$listArr.push(mcList);
				}
			}
			else
			{
				for (i = 0; i < $pageLength; i++) 
				{
					xml = vector[i];
					
					mcList = makeList(xml);
					$listArr.push(mcList);
				}
			}
			_firstNum = $listArr[0].listnum;
			_lastNum = $listArr[$listArr.length-1].listnum;
			
			pageChange();
		}
		
		private function pageChange():void
		{
			for (var j:int = 0; j < $listArr.length; j++) 
			{
				var mc:Object = {x:0};
				var listDegree:Number;
				var pointDegree:Number;
				$listArr[j].scaleX = $listArr[j].scaleY = 0.1;
				$listArr[j].txtCon.alpha = 0;
				if($scrollDirection == "down")
				{
					$listArr[j].rotation = $pointArr[0].ro;
					listDegree = Math.atan2($pointArr[0].y - $centerPoint.y, $pointArr[0].x - $centerPoint.x);
					pointDegree = Math.atan2($pointArr[j].y - $centerPoint.y, $pointArr[j].x - $centerPoint.x);
				}
				else if($scrollDirection == "up")
				{
					$listArr[j].rotation = $pointArr[$pointArr.length - 1].ro;
					listDegree = Math.atan2($pointArr[$pointArr.length-1].y - $centerPoint.y, $pointArr[$pointArr.length-1].x - $centerPoint.x);
					pointDegree = Math.atan2($pointArr[j].y - $centerPoint.y, $pointArr[j].x - $centerPoint.x);
				}
				TweenLite.to($listArr[j], 0.75, {alpha:$pointArr[j].alpha, rotation:$pointArr[j].ro, onComplete:rotationComplete});
				TweenLite.to(mc, 0.75, {x:100, onUpdate:listShow, onUpdateParams:[$listArr[j], j, mc, listDegree, pointDegree], onCompleteParams:[j], onComplete:showTxt});
			}
			
			if($con.loader.visible == true)
			{
				TweenLite.to($con.loader, 0.5, {autoAlpha:0});
				$con.loader.loader.gotoAndStop(1);
			}
		}
		
		/**	리스트 만들기	*/
		private function makeList(xml:XML):MovieClip
		{
			var mcList:kioskListClip = new kioskListClip;
			mcList.xml = xml;
			mcList.idx = int(xml.idx);
			mcList.listnum = xml.listnum;
			mcList.alpha = 0;
//			//trace(mcList.xml);
			
			// 임베드 폰트 셋팅
			var model:Model = Model.getInstance();
			model.setTextformat(mcList.txtCon.title);
			model.setTextformat(mcList.txtCon.userName);
			model.setTextformat(mcList.txtCon.ageTxt);
			model.setTextformat(mcList.txtCon.uNameTxt);
			mcList.txtCon.ageTxt.text = "세";
			mcList.txtCon.uNameTxt.text = "이름 :";
			
			if($dataObj.searchKey == -1 || $dataObj.searchKey == undefined || $dataObj.searchKey == null)
			{
				for (var j:int = xml.Contents.list.length(); j > 0; j--) 
				{
					if(xml.Contents.list[j-1].missionNum != "")
					{
						mcList.txtCon.title.text = String(xml.Contents.list[j-1].Contents);
						if(mcList.txtCon.title.text.length >= 38) mcList.txtCon.title.text = String(xml.Contents.list[j-1].Contents).slice(0, 35) + "...";
						break;
					}
				}
			}
			else
			{
				mcList.txtCon.title.text = String(xml.Contents.list[0].Contents);
				if(mcList.txtCon.title.text.length >= 38) mcList.txtCon.title.text = String(xml.Contents.list[0].Contents).slice(0, 35) + "...";
			}
			var uname:String = String(xml.Name);
			mcList.txtCon.userName.text =  uname.slice(0,1) + "*" + uname.slice(2,uname.length);
			
			mcList.txtCon.userAge.text = xml.Age;
			mcList.txtCon.title.autoSize = TextFieldAutoSize.LEFT;
			mcList.txtCon.userName.autoSize = TextFieldAutoSize.LEFT;
			mcList.txtCon.userAge.autoSize = TextFieldAutoSize.LEFT;
			mcList.txtCon.uNameTxt.autoSize = TextFieldAutoSize.LEFT;
			
			mcList.txtCon.userAge.x = int(mcList.txtCon.userName.x + mcList.txtCon.userName.width+2);
			mcList.txtCon.ageTxt.x = int(mcList.txtCon.userAge.x + mcList.txtCon.userAge.width-3);
			
			var minWidth:int = mcList.txtCon.x + mcList.txtCon.ageTxt.x + mcList.txtCon.ageTxt.width + 2;
			mcList.plane.width = Math.max(minWidth, (mcList.txtCon.x + mcList.txtCon.title.textWidth));
			
			if(String(xml.UserImageUrl) != "")
			{
				var ldr:Loader = new Loader;
				ldr.load(new URLRequest(String(xml.UserImageUrl)));
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
				mcList.imgCon.pImg.alpha = 0;
				mcList.imgCon.img.addChild(ldr);
			}
			else
			{
				mcList.imgCon.pImg.alpha = 1;
			}
			$con.listCon.addChild(mcList);
//			//trace("페이지 셋팅 인덱스 값: " + mcList.idx);
			
			ButtonUtil.makeButton(mcList, contentView);
			return mcList;
		}
		
		/**	리스트 이미지 로드 완료	*/
		private function imgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			
			bmp.width = bmp.height = 130;
			bmp.scaleX = bmp.scaleY = Math.max(bmp.scaleX, bmp.scaleY);
			bmp.x = int(130/2 - bmp.width/2);
			bmp.y = int(130/2 - bmp.height/2);
		}
		/**	등장 모션	*/
		private function listShow(target:MovieClip, targetNum:int, mc:Object, listDegree:Number, pointDegree:Number):void
		{
			var moveDegree:Number;
			if($scrollDirection == "down")
			{
				if($pointArr[targetNum].ro <= 0) moveDegree = Math.abs(Math.abs(listDegree) - Math.abs(pointDegree))*(mc.x/100);
				else moveDegree = Math.abs(Math.abs(listDegree) + Math.abs(pointDegree))*(mc.x/100);
				target.x = $centerPoint.x + Math.cos(listDegree+moveDegree)*902;
				target.y = $centerPoint.y + Math.sin(listDegree+moveDegree)*902;
			}
			else if($scrollDirection == "up")
			{
				if($pointArr[targetNum].ro <= 0) moveDegree = Math.abs(Math.abs(listDegree) + Math.abs(pointDegree))*(mc.x/100);
				else moveDegree = Math.abs(Math.abs(listDegree) - Math.abs(pointDegree))*(mc.x/100);
				target.x = $centerPoint.x + Math.cos(listDegree-moveDegree)*902;
				target.y = $centerPoint.y + Math.sin(listDegree-moveDegree)*902;
			}
		}
		/**	리스트 텍스트 보이기	*/
		private function showTxt(num:int):void
		{
			TweenLite.to($listArr[num], 1, {scaleX:$pointArr[num].scale, scaleY:$pointArr[num].scale, ease:Expo.easeOut});
			TweenLite.to($listArr[num].txtCon, 0.75, {delay:.75, alpha:1, ease:Cubic.easeOut});
			$listChange = true;
		}
		
		protected function hideList(e:DiscoveryEvent):void
		{
			//trace("hide list!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			$guideShowChk = true;
			
			$con.listCon.stage.removeEventListener(MouseEvent.MOUSE_DOWN, listDownHandler);
			TweenLite.to($con, 0.75, {autoAlpha:0});
			removeAllList();
		}
		/**	리스트 전체 제거	*/
		private function removeAllList():void
		{
			if($listArr.length == 0) return;
			for (var i:int = 0; i < $listArr.length; i++) 
			{
				TweenLite.killTweensOf($listArr[i]);
				TweenLite.killTweensOf($listArr[i].txtCon);
				var mc:MovieClip = new MovieClip;
				var listDegree:Number = Math.atan2($pointArr[i].y - $centerPoint.y, $pointArr[i].x - $centerPoint.x);;
				var pointDegree:Number;
				if($scrollDirection =="down")
				{
					pointDegree = Math.atan2($pointArr[$pointArr.length-1].y - $centerPoint.y, $pointArr[$pointArr.length-1].x - $centerPoint.x);
					TweenLite.to($listArr[i], 0.75, {alpha:0, rotation:$pointArr[$pointArr.length-1].ro, scaleX:$pointArr[$pointArr.length-1].scale, scaleY:$pointArr[$pointArr.length-1].scale});
				}
				else if($scrollDirection == "up")
				{
					pointDegree = Math.atan2($pointArr[0].y - $centerPoint.y, $pointArr[0].x - $centerPoint.x);
					TweenLite.to($listArr[i], 0.75, {alpha:0, rotation:$pointArr[0].ro, scaleX:$pointArr[$pointArr.length-1].scale, scaleY:$pointArr[$pointArr.length-1].scale});
				}
				TweenLite.to(mc, 0.75, {x:100, onUpdate:listRemove, onUpdateParams:[$listArr[i], i, mc, listDegree, pointDegree, $pointArr[i].ro], onCompleteParams:[$listArr[i]], onComplete:removeList});
			}
			$listArr = [];
		}
		/**	제거 모션	*/
		private function listRemove(target:MovieClip, targetNum:int, mc:MovieClip, listDegree:Number, pointDegree:Number, targetPointDegree:Number):void
		{
			var moveDegree:Number;
			if($scrollDirection == "down")
			{
				if(targetPointDegree <= 0) moveDegree = Math.abs(Math.abs(listDegree) + Math.abs(pointDegree))*(mc.x/100);
				else moveDegree = Math.abs(Math.abs(listDegree) - Math.abs(pointDegree))*(mc.x/100);
				target.x = $centerPoint.x + Math.cos(listDegree+moveDegree)*902;
				target.y = $centerPoint.y + Math.sin(listDegree+moveDegree)*902;
			}
			else if($scrollDirection == "up")
			{
				if(targetPointDegree <= 0) moveDegree = Math.abs(Math.abs(listDegree) - Math.abs(pointDegree))*(mc.x/100);
				else moveDegree = Math.abs(Math.abs(listDegree) + Math.abs(pointDegree))*(mc.x/100);
				target.x = $centerPoint.x + Math.cos(listDegree-moveDegree)*902;
				target.y = $centerPoint.y + Math.sin(listDegree-moveDegree)*902;
			}
		}
		
		/**	리스트 이벤트 핸들러	*/
		private function contentView(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.CLICK :
					if($isRotation == true || $listClick == false || $isContentOpen == true) return;
					$quickContentShow = true;
					if(e.target.rotation == 0)
					{
						$isRotation = true;
						$listChange = false;
						if(_viewListScrollBtn)
						{
							TweenLite.to($con.kioskScrollCon, 0.5, {autoAlpha:0});
						}
						makePointArray("pointKioskContent");
						for (var i:int = 0; i < $listArr.length; i++) 
						{	contenViewClose(i, true);		}
						$isContentOpen = true;
						$viewContent.contentSetting(e.target.xml, MovieClip(e.target), $listArr.length);
						$con.dispatchEvent(new DiscoveryEvent(DiscoveryEvent.VIEW_CONTENT, {}));
					}
					else
					{
						searchSortingTarget(e.target.idx);
					}
					break;
			}
		}
		/**	컨텐츠 팝업 보이기 & 숨기기 등장 모션	*/
		private function contenViewClose(num:int, contentView:Boolean):void
		{
			var mc:MovieClip = new MovieClip;
			var listDegree:Number = Math.atan2($listArr[num].y - $centerPoint.y, $listArr[num].x - $centerPoint.x);
			var pointDegree:Number = Math.atan2($pointArr[num].y - $centerPoint.y, $pointArr[num].x - $centerPoint.x);
			TweenLite.to($listArr[num], 1, {alpha:$pointArr[num].alpha, rotation:$pointArr[num].ro, scaleX:$pointArr[num].scale, scaleY:$pointArr[num].scale, onComplete:rotationComplete, ease:Expo.easeOut});
			TweenLite.to(mc, 1, {x:100, onUpdate:contentViewMoveList, onUpdateParams:[$listArr[num], num, mc, listDegree, pointDegree, contentView], ease:Expo.easeOut});
			
			if(num >= $listArr.length-1) TweenLite.delayedCall( 1, function():void{	rotationComplete()	});
		}
		/**	리스트 이동	*/
		private function contentViewMoveList(target:MovieClip, targetNum:int, mc:MovieClip, listDegree:Number, pointDegree:Number, contentView:Boolean):void
		{
			var moveDegree:Number;
			if(contentView == true)  moveDegree = Math.abs(Math.abs(listDegree) - Math.abs(pointDegree))*(mc.x/100);
			else moveDegree = -1 * Math.abs(Math.abs(listDegree) - Math.abs(pointDegree))*(mc.x/100);
			if($pointArr[targetNum].ro <= 0)
			{
				target.x = $centerPoint.x + Math.cos(listDegree-moveDegree)*902;
				target.y = $centerPoint.y + Math.sin(listDegree-moveDegree)*902;
			}
			else
			{
				target.x = $centerPoint.x + Math.cos(listDegree+moveDegree)*902;
				target.y = $centerPoint.y + Math.sin(listDegree+moveDegree)*902;
			}
		}
		
		private function searchSortingTarget(idx:int):void
		{
			var selectedNo:int;
			var targetNo:int;
			var moveCnt:int;
			
			for (var j:int = 0; j < $listArr.length; j++) 
			{
				if(idx == $listArr[j].idx) selectedNo = j;
				if($listArr[j].rotation == 0) targetNo = j;
			}
			
			if(selectedNo < targetNo) $wheelDirection = "down";
			else $wheelDirection = "up";
			moveCnt = Math.abs(targetNo - selectedNo);
			
			if(moveCnt == 0)
			{
				$listArr[selectedNo].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else
			{
				for (var i:int = 0; i < moveCnt; i++) 
				{
					rotationList();
				}
			}
//			if(moveCnt == 0) $listArr[selectedNo].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
//			else listLoadCheck(moveCnt + 1);
			$isRotation = true;
		}
		
		private function sortingQuickList(target:MovieClip, mc:Object):void
		{
			target.x = $centerPoint.x + Math.cos(mc.moveDegree)*902;
			target.y = $centerPoint.y + Math.sin(mc.moveDegree)*902;
		}
		
		private var $btnDownY:int;
		/**	스크롤 버튼 다운 핸들러	*/
		private function scrollDownHandler(e:MouseEvent):void
		{
			$listChange = false;
			$con.kioskScrollCon.scroll.gotoAndStop(2);
			$btnDownY = $con.kioskScrollCon.mouseY;
			$con.stage.addEventListener(MouseEvent.MOUSE_MOVE, startDragHandler);
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
		}
		private function startDragHandler(e:MouseEvent):void
		{
			$con.kioskScrollCon.scroll.y = int($con.kioskScrollCon.scrollBG.height/2) + $con.kioskScrollCon.mouseY - $btnDownY;
			if($con.kioskScrollCon.scroll.y <= $con.kioskScrollCon.scrollBG.height*0.43)
			{
				$con.kioskScrollCon.scroll.y = $con.kioskScrollCon.scrollBG.height*0.43
//				stopDragHandler();
//				if($isRotation == true || $totalLength <= $pageLength) return;
//				$wheelDirection = "up";
//				$scrollDirection = "up";
//				$pageChange = true;
//				$isRotation = true;
//				listLoadCheck(21);
			}
			else if($con.kioskScrollCon.scroll.y >= $con.kioskScrollCon.scrollBG.height*0.57)
			{
				$con.kioskScrollCon.scroll.y = $con.kioskScrollCon.scrollBG.height*0.57
//				stopDragHandler();
//				if($isRotation == true || $totalLength <= $pageLength) return;
//				$wheelDirection = "down";
//				$scrollDirection = "down";
//				$pageChange = true;
//				$isRotation = true;
//				listLoadCheck(21);
			}
		}
		
		private function stopDragHandler(e:MouseEvent = null):void
		{
			$listChange = true;
			$con.kioskScrollCon.scroll.gotoAndStop(1);
			$con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, startDragHandler);
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragHandler);
			TweenLite.to($con.kioskScrollCon.scroll, 0.5, {y:$con.kioskScrollCon.scrollBG.height/2, ease:Cubic.easeOut});
			
			if($con.kioskScrollCon.scroll.y <= $con.kioskScrollCon.scrollBG.height*0.45)
			{
				if($isRotation == true || $totalLength <= $pageLength) return;
				$wheelDirection = "up";
				$scrollDirection = "up";
				$pageChange = true;
				$isRotation = true;
				listLoadCheck(21);
			}
			else if($con.kioskScrollCon.scroll.y >= $con.kioskScrollCon.scrollBG.height*0.55)
			{
				if($isRotation == true || $totalLength <= $pageLength) return;
				$wheelDirection = "down";
				$scrollDirection = "down";
				$pageChange = true;
				$isRotation = true;
				listLoadCheck(21);
			}
		}
		
		/**	리스트 이동 핸들러	*/
		private function listDownHandler(e:MouseEvent):void
		{
			if($isRotation == true || $listChange == false) return;
			$downY = $con.listCon.mouseY;
			$con.stage.addEventListener(MouseEvent.MOUSE_MOVE, listDragHandler);
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, listDragStopHandler);
		}
		/**	마우스 이동 체크	*/
		private function listDragHandler(e:MouseEvent):void
		{
			var num:int = $downY - $con.listCon.mouseY;
			if(num <= -10) 
			{
				$listClick = false;
				$wheelDirection = "down";
				removeMouseMoveHandler();
				rotationList();
			}
			else if(num >= 10) 
			{
				$listClick = false;
				$wheelDirection = "up";
				removeMouseMoveHandler();
				rotationList();
			}
		}
		private function rotationList(rotationTime:Number = 0.25):void
		{
			var mc:Object = new Object;
			var listDegree:Number;
			var pointDegree:Number;
			if($wheelDirection == "up")
			{
				listDegree = Math.atan2($listArr[0].y - $centerPoint.y, $listArr[0].x - $centerPoint.x);
				pointDegree = Math.atan2(($pointArr[0].y-20) - $centerPoint.y, ($pointArr[0].x-20) - $centerPoint.x);
				TweenLite.to($listArr[0], rotationTime, {alpha:0, rotation:$pointArr[0].ro, scaleX:$pointArr[0].scale, scaleY:$pointArr[0].scale, onCompleteParams:[$listArr[0]], onComplete:removeList});
				if(mc.moveDegree == undefined) mc.moveDegree = listDegree;
				TweenLite.to(mc, rotationTime, {moveDegree:pointDegree, onUpdate:sortingQuickList, onUpdateParams:[$listArr[0], mc], onComplete:rotationComplete});
				
				$listArr.push($listArr[0]);
				$listArr.shift();
				$listArr[$listArr.length-1].x = $pointArr[$listArr.length-1].x-20;
				$listArr[$listArr.length-1].y = $pointArr[$listArr.length-1].y+20;
				$listArr[$listArr.length-1].scaleX = $listArr[$listArr.length-1].scaleY = $pointArr[$listArr.length-1].scale;
				$listArr[$listArr.length-1].rotation = $pointArr[$listArr.length-1].ro;
			}
			else if($wheelDirection == "down")
			{
				listDegree = Math.atan2($listArr[$listArr.length - 1].y - $centerPoint.y, $listArr[$listArr.length - 1].x - $centerPoint.x);
				pointDegree = Math.atan2(($pointArr[$pointArr.length - 1].y+20) - $centerPoint.y, ($pointArr[$pointArr.length - 1].x-20) - $centerPoint.x);
				TweenLite.to($listArr[$listArr.length - 1], rotationTime, {alpha:0, rotation:$pointArr[$pointArr.length - 1].ro, scaleX:$pointArr[$pointArr.length - 1].scale, scaleY:$pointArr[$pointArr.length - 1].scale, onCompleteParams:[$listArr[$listArr.length - 1]], onComplete:removeList});
				if(mc.moveDegree == undefined) mc.moveDegree = listDegree;
				TweenLite.to(mc, rotationTime, {moveDegree:pointDegree, onUpdate:sortingQuickList, onUpdateParams:[$listArr[$listArr.length - 1], mc], onComplete:rotationComplete});
				
				$listArr.unshift($listArr[$listArr.length - 1]);
				$listArr.pop();
				$listArr[0].x = $pointArr[0].x-20;
				$listArr[0].y = $pointArr[0].y-20;
				$listArr[0].scaleX = $listArr[0].scaleY = $pointArr[0].scale;
				$listArr[0].rotation = $pointArr[0].ro;
			}
			allListUpdateComplete(rotationTime);
		}
		/**	리스트 클릭 가능	*/
		private function listDragStopHandler(e:MouseEvent):void
		{
			removeMouseMoveHandler();
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, listDragStopHandler);
			TweenLite.delayedCall(.5, function():void{		$listClick = true;		});
		}
		/**	마우스 무브 이벤트 제거	*/
		private function removeMouseMoveHandler():void
		{
			$con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, listDragHandler);
		}
		
		private var _isOnLodingData:Boolean;
		
		/**	리스트 로드 유무 체크 후 리스트 업데이트	*/
		private function listLoadCheck(psize:int=2):void
		{
			if(_isOnLodingData) return;
			if($listArr.length == 1) return;
			
			TweenLite.to($con.loader, 0.5, {autoAlpha:1});
			$con.loader.loader.gotoAndPlay(1);
			
			var listRotationTime:Number;
			if($isContentOpen == true) listRotationTime = 1;
			else listRotationTime = 0.5;
			
			if($totalLength > $pageLength)
			{
				_isOnLodingData = true;
				$listUpdate.update("kiosk", $listPage, $listArr, psize, $dataListUrl, $dataObj, $wheelDirection, listUpdate, listPageUpdate, allListUpdateComplete, listRotationTime, _firstNum, _lastNum);
			}
			else
			{
				for (var i:int = 0; i < psize - 1; i++) 
				{
					listUpdate();
				}
				
				allListUpdateComplete(listRotationTime);
			}
		}
		
		private function listPageUpdate(isScroll:Boolean, pushXMLGroup:Vector.<XML>):void
		{
			_isOnLodingData = false;
			if($listArr != null) removeAllList();
			if($wheelDirection == "down") pushXMLGroup.reverse();
			makeListArray(isScroll, pushXMLGroup);
		}
		
		private function listUpdate(pushNewXml:XML = null, listRotationTime:Number=1):void
		{
			_isOnLodingData = false;
			if(pushNewXml) trace("생성된 리스트 : "+pushNewXml.listnum);
			
			var mcList:MovieClip;
			var rotationXml:XML;
			
			var mc:MovieClip = new MovieClip;
			var listDegree:Number;
			var pointDegree:Number;
			if($wheelDirection == "up")
			{
				listDegree = Math.atan2($listArr[0].y - $centerPoint.y, $listArr[0].x - $centerPoint.x);
				pointDegree = Math.atan2(($pointArr[0].y-20) - $centerPoint.y, ($pointArr[0].x-20) - $centerPoint.x);
				TweenLite.to($listArr[0], listRotationTime, {alpha:0, rotation:$pointArr[0].ro, scaleX:$pointArr[0].scale, scaleY:$pointArr[0].scale, onCompleteParams:[$listArr[0]], onComplete:removeList});
				if(mc.moveDegree == undefined) mc.moveDegree = listDegree;
				TweenLite.to(mc, listRotationTime, {moveDegree:pointDegree, onUpdate:sortingQuickList, onUpdateParams:[$listArr[0], mc], onComplete:rotationComplete});
				
				rotationXml = $listArr[0].xml;
				$listArr.shift();
				if($totalLength > $pageLength) mcList = makeList(pushNewXml);
				else mcList = makeList(rotationXml);
				$listArr.push(mcList);
				$listArr[$listArr.length-1].x = $pointArr[$listArr.length-1].x-20;
				$listArr[$listArr.length-1].y = $pointArr[$listArr.length-1].y+20;
				$listArr[$listArr.length-1].scaleX = $listArr[$listArr.length-1].scaleY = $pointArr[$listArr.length-1].scale;
				$listArr[$listArr.length-1].rotation = $pointArr[$listArr.length-1].ro;
			}
			else if($wheelDirection == "down")
			{
				listDegree = Math.atan2($listArr[$listArr.length - 1].y - $centerPoint.y, $listArr[$listArr.length - 1].x - $centerPoint.x);
				pointDegree = Math.atan2(($pointArr[$pointArr.length - 1].y+20) - $centerPoint.y, ($pointArr[$pointArr.length - 1].x-20) - $centerPoint.x);
				TweenLite.to($listArr[$listArr.length - 1], listRotationTime, {alpha:0, rotation:$pointArr[$pointArr.length - 1].ro, scaleX:$pointArr[$pointArr.length - 1].scale, scaleY:$pointArr[$pointArr.length - 1].scale, onCompleteParams:[$listArr[$listArr.length - 1]], onComplete:removeList});
				if(mc.moveDegree == undefined) mc.moveDegree = listDegree;
				TweenLite.to(mc, listRotationTime, {moveDegree:pointDegree, onUpdate:sortingQuickList, onUpdateParams:[$listArr[$listArr.length - 1], mc], onComplete:rotationComplete});
				
				rotationXml = $listArr[$listArr.length-1].xml;
				$listArr.pop();
				if($totalLength > $pageLength) mcList = makeList(pushNewXml);
				else mcList = makeList(rotationXml);
				$listArr.unshift(mcList);
				$listArr[0].x = $pointArr[0].x-20;
				$listArr[0].y = $pointArr[0].y-20;
				$listArr[0].scaleX = $listArr[0].scaleY = $pointArr[0].scale;
				$listArr[0].rotation = $pointArr[0].ro;
			}
		}
		
		private function allListUpdateComplete(listRotationTime:Number=1):void
		{
			for (var i2:int = 0; i2 < $listArr.length; i2++) 
			{
				var mc2:MovieClip = new MovieClip;
				var listDegree2:Number = Math.atan2($listArr[i2].y - $centerPoint.y, $listArr[i2].x - $centerPoint.x);
				var pointDegree2:Number = Math.atan2($pointArr[i2].y - $centerPoint.y, $pointArr[i2].x - $centerPoint.x);
				
				TweenLite.to($listArr[i2], listRotationTime, {alpha:$pointArr[i2].alpha, rotation:$pointArr[i2].ro, scaleX:$pointArr[i2].scale, scaleY:$pointArr[i2].scale, onComplete:rotationComplete});
				if(mc2.moveDegree == undefined) mc2.moveDegree = listDegree2;
				
				TweenLite.to(mc2, listRotationTime, {moveDegree:pointDegree2, onUpdate:sortingQuickList, onUpdateParams:[$listArr[i2], mc2], onCompleteParams:[i2], onComplete:showContentPopupChk});
			}
			
			if($isContentOpen == true) contentsChange();
		}
		
		private function showContentPopupChk(num:int):void
		{
			if(num == $listArr.length-1 && $quickContentShow == true)
			{
				for (var i:int = 0; i < $listArr.length; i++) 
				{
					if($listArr[i].rotation ==0)
					{
						$quickContentShow = false;
						$listArr[i].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
				}
			}
		}
		
		/**	리스트 이동 가능	*/
		private function rotationComplete():void
		{	$isRotation = false;		}
		
		/**	리스트 제거	*/
		private function removeList(target:MovieClip):void
		{
			ButtonUtil.removeButton(target, contentView);
			var cnt:int = target.imgCon.img.numChildren;
			while(cnt > 0)
			{
				var ldr:Loader = target.imgCon.img.getChildAt(0) as Loader;
				var bmp:Bitmap = ldr.content as Bitmap;
				target.imgCon.img.removeChild(ldr);
				if(ldr.content != null) bmp.bitmapData.dispose();
				ldr.unloadAndStop();
				cnt--;
			}
			$con.listCon.removeChild(target);
			target = null;
			
			//trace("리스트 컨테이너 자식 수: " + $con.listCon.numChildren);
		}
		
		/**	리사이즈	*/
		private function resizeHandler(e:Event = null):void
		{
			resize($con.stage.stageWidth, $con.stage.stageHeight);
		}
		
		public function resize(sw:Number, sh:Number):void
		{
			$con.guide.plane.width = sw;
			$con.guide.plane.height = sh;
			
			$con.x = int(sw/2);
			$con.y = int(sh/2);
			
			$con.loader.bg.width = sw;
			$con.loader.bg.height = sh;
		}
	}
}
