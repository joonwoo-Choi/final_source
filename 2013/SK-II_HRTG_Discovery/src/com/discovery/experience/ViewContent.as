package com.discovery.experience
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.discovery.events.DiscoveryEvent;
	import com.discovery.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFieldAutoSize;

	public class ViewContent
	{
		
		private var $con:MovieClip;
		
		private var $type:String;
		
		private var $missionNum:int;
		
		private var $dataObj:Object;
		
		private var $xmlData:XML;
		
		private var $xmlDataLdr:URLLoader;
		
		private var $btnArrowLength:int = 2;
		
		private var $weekBtnArr:Array;
		
		private var $weekBtnLength:int = 4;
		
		private var $contentsPopup:MovieClip;
		
		private var $isClose:Boolean = true;
		
		private var $activeNum:int;
		
		public function ViewContent(con:MovieClip, type:String)
		{
			TweenPlugin.activate([BlurFilterPlugin]);
			$con = con;
			$type = type;
			$xmlDataLdr = new URLLoader();
			$xmlDataLdr.addEventListener(Event.COMPLETE, detailXmlLoadComplete);
			
			if(type == "site")
			{
				$contentsPopup = $con.siteContentCon;
				$con.removeChild($con.kioskContentCon);
				$con.removeChild($con.kioskScrollCon);
				$con.kioskContentCon = null;
				$con.kioskScrollCon = null;
			}
			else if(type == "kiosk")
			{
				$contentsPopup = $con.kioskContentCon;
				$con.removeChild($con.siteContentCon);
				$con.removeChild($con.siteScrollCon);
				$con.siteContentCon = null;
				$con.siteScrollCon = null;
			}
			$contentsPopup.visible = false;
			
			$con.addEventListener(DiscoveryEvent.SHOW_LIST, showList);
			$con.addEventListener(DiscoveryEvent.VIEW_CONTENT, viewContent);
			$con.addEventListener(DiscoveryEvent.CLOSE_CONTENT, contentClose);
			$con.addEventListener(DiscoveryEvent.HIDE_LIST, contentClose);
			
			makeBtn();
		}
		
		protected function showList(e:DiscoveryEvent):void
		{
			if($contentsPopup.visible == true) contentClose();
		}
		
		/**	컨텐츠 팝업 보이기	*/
		protected function viewContent(e:DiscoveryEvent):void
		{
			$isClose = true;
			$con.listCon.mouseEnabled = false;
			$con.listCon.mouseChildren = false;
			TweenLite.to($con.listCon, 1, {x:-400, alpha:0.75, blurFilter:new BlurFilter(16,16), ease:Expo.easeOut});
			TweenLite.to($contentsPopup, 0.5, {delay:1, autoAlpha:1});
		}
		
		/**	컨텐츠 팝업 닫기	*/
		protected function contentClose(e:DiscoveryEvent = null):void
		{
			$con.listCon.mouseEnabled = true;
			$con.listCon.mouseChildren = true;
			removeImg($contentsPopup.reviewImg);
			removeImg($contentsPopup.imgCon.img);
			TweenLite.killTweensOf($con.listCon);
			TweenLite.killTweensOf($contentsPopup);
			TweenLite.to($con.listCon, 1, {x:0, alpha:1, blurFilter:new BlurFilter(0,0), onCompleteParams:[$con.listCon], onComplete:finishBlur, ease:Expo.easeOut});
			TweenLite.to($contentsPopup, 0.5, {autoAlpha:0});
		}
		/**	블러 종료	*/
		private function finishBlur(mc:MovieClip):void
		{	mc.filters = null;	}
		
		private function makeBtn():void
		{
			ButtonUtil.makeButton($contentsPopup.btnClose, contentCloseHandler);
			for (var i:int = 0; i < $btnArrowLength; i++) 
			{
				var btnArrow:MovieClip = $contentsPopup.getChildByName("btnArrow" + i) as MovieClip;
				btnArrow.no = i;
				ButtonUtil.makeButton(btnArrow, btnArrowHandler);
			}
			
			$weekBtnArr = [];
			for (var j:int = 0; j < $weekBtnLength; j++) 
			{
				var btnWeek:MovieClip = $contentsPopup.getChildByName("btnWeek" + j) as MovieClip;
				if(btnWeek == null) return;
				btnWeek.no = j;
				$weekBtnArr.push(btnWeek);
				ButtonUtil.makeButton(btnWeek, changeWeek);
			}
		}
		
		private function contentCloseHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					if($isClose == false) return;
					$con.dispatchEvent(new DiscoveryEvent(DiscoveryEvent.CLOSE_CONTENT, {}));
					break;
			}
		}
		
		private function btnArrowHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					$isClose = false;
					var changeDirection:String;
					if(e.target.no == 0) changeDirection = "up";
					else changeDirection = "down";
					$con.dispatchEvent(new DiscoveryEvent(DiscoveryEvent.CHANGE_CONTENT, {direction:changeDirection}));
					break;
			}
		}
		
		private function changeWeek(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK : 
					if($activeNum == target.no) return;
//					if($xmlData.Contents.list.length() == 1) 
//					{
//						trace("리스트 로드가 완료되지 않았음");
//						return;
//					}
					if($xmlData.Contents.list[target.no].Contents == null || $xmlData.Contents.list[target.no].Contents == "")
					{
						if($type == "site") JavaScriptUtil.alert("선택한 주차의 답변이 없습니다.");
						else if($type == "kiosk") $con.dispatchEvent(new DiscoveryEvent(DiscoveryEvent.SHOW_ALERT, {}));
						return;
					}
					else
					{
						$activeNum = target.no;
						activeWeekBtn(target.no); 
						$contentsPopup.reviewCon.review.text = $xmlData.Contents.list[target.no].Contents;
						TweenLite.to($contentsPopup.reviewMask, 0.5, {scaleX:0, ease:Expo.easeOut});
						TweenLite.to($contentsPopup.reviewImg, 0.5, {alpha:0, ease:Expo.easeOut, onComplete:reviewImgLoad});
					}
					break;
			}
		}
		
		private function activeWeekBtn(num:int):void
		{
//			if(int($dataObj.searchKey) == -1 || $dataObj.searchKey == undefined || $dataObj.searchKey == null) $contentsPopup.title.title.gotoAndStop(num+1);
//			else $contentsPopup.title.title.gotoAndStop(int($xmlData.Contents.list.missionNum));
			
			$contentsPopup.title.title.gotoAndStop(num+1);
			for (var i:int = 0; i < $weekBtnLength; i++) 
			{
				if(num == $weekBtnArr[i].no)
				{
					TweenLite.to($weekBtnArr[i].active, 0.5, {alpha:1});
				}
				else
				{
					TweenLite.to($weekBtnArr[i].active, 0.5, {alpha:0});
				}
			}
		}
		
		public function positionSetting(dataObj:Object):void
		{
			$contentsPopup.title.title.gotoAndStop(int(dataObj.missionNum));
			$missionNum = int(dataObj.missionNum);
			$dataObj = dataObj;
			
			var i:int;
			if(int($dataObj.searchKey) == -1 || $dataObj.searchKey == undefined || $dataObj.searchKey == null)
			{
				if($type == "site")
				{
					$contentsPopup.reviewMask.y = 230;
					$contentsPopup.reviewImg.y = 230;
					$contentsPopup.reviewCon.y = 230;
					$contentsPopup.title.y = 150;
					$contentsPopup.btnArrow0.y = 34;
					$contentsPopup.btnArrow1.y = 490;
					$contentsPopup.btnClose.y = 52;
				}
				else if($type == "kiosk")
				{
					$contentsPopup.reviewMask.y = 266;
					$contentsPopup.reviewImg.y = 266;
					$contentsPopup.reviewCon.y = 264;
					$contentsPopup.title.y = 175;
					$contentsPopup.btnArrow0.y = 14;
					$contentsPopup.btnArrow1.y = 520;
					$contentsPopup.btnClose.y = 71;
				}
				
				for (i = 0; i < $weekBtnLength; i++) 
				{	$weekBtnArr[i].visible = true;	}
			}
			else
			{
				if($type == "site")
				{
					$contentsPopup.reviewMask.y = 152;
					$contentsPopup.reviewImg.y = 152;
					$contentsPopup.reviewCon.y = 150;
					$contentsPopup.title.y = 73;
					$contentsPopup.btnArrow0.y = 11;
					$contentsPopup.btnArrow1.y = 443;
					$contentsPopup.btnClose.y = 72;
				}
				else if($type == "kiosk")
				{
					$contentsPopup.reviewMask.y = 162;
					$contentsPopup.reviewImg.y = 162;
					$contentsPopup.reviewCon.y = 160;
					$contentsPopup.title.y = 72;
					$contentsPopup.btnArrow0.y = 0;
					$contentsPopup.btnArrow1.y = 482;
					$contentsPopup.btnClose.y = 71;
				}
				
				for (i = 0; i < $weekBtnLength; i++) 
				{	$weekBtnArr[i].visible = false;	}
			}
		}
		
		public function contentSetting(xmlData:XML, target:MovieClip, listLength:int):void
		{
			$xmlData = xmlData;
			for (var j:int = $xmlData.Contents.list.length(); j > 0; j--) 
			{
				if($xmlData.Contents.list[j-1].missionNum != "")
				{
					$activeNum = $xmlData.Contents.list[j-1].missionNum-1;
					break;
				}
			}
			if(int($dataObj.searchKey) == -1)
			{
				activeWeekBtn($activeNum);
			}
			else
			{
				$contentsPopup.title.title.gotoAndStop($activeNum+1);
				$activeNum = 0;
			}
			trace($xmlData, target.idx, target, $activeNum);
			
			if($type == "kiosk" && int($dataObj.searchKey) != -1)
			{
				if($contentsPopup.title.title.currentFrame == 1) $contentsPopup.btnClose.x = 986;
				else $contentsPopup.btnClose.x = $contentsPopup.title.x + $contentsPopup.title.width + 50;
			}
			
			TweenLite.killTweensOf(target);
			TweenLite.to(target, 1, {alpha:0, rotation:0, ease:Expo.easeOut});
			
			TweenLite.killTweensOf($contentsPopup.reviewCon);
			TweenLite.killTweensOf($contentsPopup.txtCon);
			TweenLite.killTweensOf($contentsPopup.reviewMask);
			TweenLite.killTweensOf($contentsPopup.reviewImg);
			TweenLite.killTweensOf($contentsPopup.imgCon.imgMask);
			TweenLite.to($contentsPopup.reviewCon, 0.5, {alpha:0, ease:Expo.easeOut});
			TweenLite.to($contentsPopup.txtCon, 0.5, {alpha:0, ease:Expo.easeOut, onComplete:changeTxt});
			TweenLite.to($contentsPopup.reviewMask, 0.5, {scaleX:0, ease:Expo.easeOut});
			TweenLite.to($contentsPopup.reviewImg, 0.5, {alpha:0, ease:Expo.easeOut, onComplete:reviewImgLoad});
			TweenLite.to($contentsPopup.imgCon.imgMask, 0.5, {scaleX:0, scaleY:0, ease:Expo.easeOut, onComplete:userPictureLoad});
			var i:int;
			var btnArrow:MovieClip
			if(listLength == 1)
			{
				for (i = 0; i < $btnArrowLength; i++) 
				{
					btnArrow = $contentsPopup.getChildByName("btnArrow" + i) as MovieClip;
					btnArrow.visible = false;
				}
			}
			else
			{
				for (i = 0; i < $btnArrowLength; i++) 
				{
					btnArrow = $contentsPopup.getChildByName("btnArrow" + i) as MovieClip;
					btnArrow.visible = true;
				}
			}
		}
		private function detailXmlLoadComplete(e:Event):void
		{
			var xml:XML = XML(e.target.data);
			var dataXml:XML = XML(xml.dataList.EventData);
			$xmlData = dataXml;
			trace(dataXml);
		}
		/**	컨텐츠 텍스트 변경	*/
		private function changeTxt():void
		{
			// 임베드 폰트 셋팅
			var model:Model = Model.getInstance();
			model.setTextformat($contentsPopup.txtCon.testerName);
			model.setTextformat($contentsPopup.txtCon.skinTrouble);
			model.setTextformat($contentsPopup.txtCon.product);
			model.setTextformat($contentsPopup.txtCon.ageTxt);
			model.setTextformat($contentsPopup.txtCon.skinAgeTxt);
			model.setTextformat($contentsPopup.txtCon.totalSkinAgeTxt);
			model.setTextformat($contentsPopup.reviewCon.review);
			
			model.setTextformat($contentsPopup.txtCon.item0);
			model.setTextformat($contentsPopup.txtCon.item1);
			model.setTextformat($contentsPopup.txtCon.item2);
			model.setTextformat($contentsPopup.txtCon.item3);
			model.setTextformat($contentsPopup.txtCon.item4);
			model.setTextformat($contentsPopup.txtCon.item5);
			model.setTextformat($contentsPopup.txtCon.item6);
			model.setTextformat($contentsPopup.txtCon.item7);
			
			$contentsPopup.txtCon.ageTxt.text = "세";
			$contentsPopup.txtCon.skinAgeTxt.text = "세";
			$contentsPopup.txtCon.totalSkinAgeTxt.text = "세";
			
			var uname:String = String($xmlData.Name);
			$contentsPopup.txtCon.testerName.text =  uname.slice(0,1) + "*" + uname.slice(2,uname.length);
			$contentsPopup.txtCon.age.text = $xmlData.Age;
			$contentsPopup.txtCon.skinAge.text = $xmlData.SkinAge;
			$contentsPopup.txtCon.skinScore.text = $xmlData.SkinScore + "%";
			$contentsPopup.txtCon.skinTrouble.text = $xmlData.SkinTrouble;
			$contentsPopup.txtCon.product.text = $xmlData.Product;
			$contentsPopup.txtCon.skinImproveScore.text = $xmlData.TotalSkinScore + "%";
			$contentsPopup.txtCon.skinImproveAge.text = $xmlData.TotalSkinAge;
			
			$contentsPopup.txtCon.ageTxt.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.skinAgeTxt.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.testerName.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.age.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.skinAge.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.skinScore.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.skinTrouble.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.product.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.skinImproveScore.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.skinImproveAge.autoSize = TextFieldAutoSize.RIGHT;
			$contentsPopup.txtCon.totalSkinAgeTxt.autoSize = TextFieldAutoSize.RIGHT;
			
			$contentsPopup.txtCon.age.x = int($contentsPopup.txtCon.ageTxt.x - $contentsPopup.txtCon.age.width) + 3;
			$contentsPopup.txtCon.skinAge.x = int($contentsPopup.txtCon.skinAgeTxt.x - $contentsPopup.txtCon.skinAge.width) + 3;
			$contentsPopup.txtCon.skinImproveAge.x = int($contentsPopup.txtCon.totalSkinAgeTxt.x - $contentsPopup.txtCon.skinImproveAge.width) + 4;
			
			$contentsPopup.txtCon.item0.text = "이름:";
			$contentsPopup.txtCon.item1.text = "나이:";
			$contentsPopup.txtCon.item2.text = "매직링 피부나이:";
			$contentsPopup.txtCon.item3.text = "매직링 피부점수:";
			$contentsPopup.txtCon.item4.text = "개선이 필요한 피부요소:";
			$contentsPopup.txtCon.item5.text = "피테라 에센스 외 사용 브랜드:";
			$contentsPopup.txtCon.item6.text = "매직링 피부점수 개선도:";
			$contentsPopup.txtCon.item7.text = "매직링 피부나이 개선도:";
			$contentsPopup.txtCon.item0.autoSize = TextFieldAutoSize.LEFT;
			$contentsPopup.txtCon.item1.autoSize = TextFieldAutoSize.LEFT;
			$contentsPopup.txtCon.item2.autoSize = TextFieldAutoSize.LEFT;
			$contentsPopup.txtCon.item3.autoSize = TextFieldAutoSize.LEFT;
			$contentsPopup.txtCon.item4.autoSize = TextFieldAutoSize.LEFT;
			$contentsPopup.txtCon.item5.autoSize = TextFieldAutoSize.LEFT;
			$contentsPopup.txtCon.item6.autoSize = TextFieldAutoSize.LEFT;
			$contentsPopup.txtCon.item7.autoSize = TextFieldAutoSize.LEFT;
			$contentsPopup.txtCon.item0.x = int($contentsPopup.txtCon.testerName.x - $contentsPopup.txtCon.item0.width);
			$contentsPopup.txtCon.item1.x = int($contentsPopup.txtCon.age.x - $contentsPopup.txtCon.item1.width);
			$contentsPopup.txtCon.item2.x = int($contentsPopup.txtCon.skinAge.x - $contentsPopup.txtCon.item2.width);
			$contentsPopup.txtCon.item3.x = int($contentsPopup.txtCon.skinScore.x - $contentsPopup.txtCon.item3.width);
			$contentsPopup.txtCon.item4.x = int($contentsPopup.txtCon.skinTrouble.x - $contentsPopup.txtCon.item4.width);
			$contentsPopup.txtCon.item5.x = int($contentsPopup.txtCon.product.x - $contentsPopup.txtCon.item5.width);
			$contentsPopup.txtCon.item6.x = int($contentsPopup.txtCon.skinImproveScore.x - $contentsPopup.txtCon.item6.width);
			$contentsPopup.txtCon.item7.x = int($contentsPopup.txtCon.skinImproveAge.x - $contentsPopup.txtCon.item7.width);
			
			$contentsPopup.reviewCon.review.text = $xmlData.Contents.list[$activeNum].Contents;
//			$contentsPopup.reviewCon.review.autoSize = TextFieldAutoSize.LEFT;
			
			TweenLite.to($contentsPopup.reviewCon, 1, {alpha:1, ease:Expo.easeOut});
			TweenLite.to($contentsPopup.txtCon, 1, {alpha:1, ease:Expo.easeOut});
		}
		/**	리뷰 이미지 변경	*/
		private function reviewImgLoad():void
		{
			removeImg($contentsPopup.reviewImg);
			if(String($xmlData.Contents.list[$activeNum].ContentsImageUrl) != "")
			{
				var ldr:Loader = new Loader();
				ldr.load(new URLRequest(String($xmlData.Contents.list[$activeNum].ContentsImageUrl)));
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, reviewImgLoadComplete);
				$contentsPopup.reviewImg.addChild(ldr);
				$contentsPopup.reviewImg.pImg.alpha = 0;
			}
			else
			{
				$contentsPopup.reviewImg.pImg.alpha = 1;
				TweenLite.to($contentsPopup.reviewMask, 1, {scaleX:1, ease:Expo.easeOut});
				TweenLite.to($contentsPopup.reviewImg, 1, {alpha:1, ease:Expo.easeOut});
			}
		}
		/**	리뷰 이미지 로드 완료	*/
		private function reviewImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			
			bmp.width = 300;
			bmp.height = 200;
			bmp.scaleX = bmp.scaleY = Math.max(bmp.scaleX, bmp.scaleY);
			bmp.x = int(300/2 - bmp.width/2);
			bmp.y = int(200/2 - bmp.height/2);
//			trace(bmp.x, bmp.y, bmp.width, bmp.height, bmp.scaleX, bmp.scaleY);
			
			TweenLite.to($contentsPopup.reviewMask, 1, {scaleX:1, ease:Expo.easeOut});
			TweenLite.to($contentsPopup.reviewImg, 1, {alpha:1, ease:Expo.easeOut});
		}
		/**	테스터 사진 변경	*/
		private function userPictureLoad():void
		{
			removeImg($contentsPopup.imgCon.img);
			if(String($xmlData.UserImageUrl) != "")
			{
				var ldr:Loader = new Loader();
				ldr.load(new URLRequest(String($xmlData.UserImageUrl)));
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, userImgLoadComplete);
				$contentsPopup.imgCon.img.addChild(ldr);
				$contentsPopup.imgCon.pImg.alpha = 0;
			}
			else
			{
				$contentsPopup.imgCon.pImg.alpha = 1;
				TweenLite.to($contentsPopup.imgCon.imgMask, 1, {scaleX:1, scaleY:1, ease:Expo.easeOut});
			}
		}
		/**	유저 이미지 로드 완료 & 스무싱	*/
		private function userImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			
			bmp.width = bmp.height = 130;
			bmp.scaleX = bmp.scaleY = Math.max(bmp.scaleX, bmp.scaleY);
			bmp.x = int(130/2 - bmp.width/2);
			bmp.y = int(130/2 - bmp.height/2);
//			trace(bmp.x, bmp.y, bmp.width, bmp.height, bmp.scaleX, bmp.scaleY);
			
			TweenLite.to($contentsPopup.imgCon.imgMask, 1, {scaleX:1, scaleY:1, ease:Expo.easeOut, onComplete:closeTrue});
		}
		
		/**	컨텐츠 팝업 닫기 가능	*/
		private function closeTrue():void
		{
			$isClose = true;
		}
		
		/**	이미지 제거	*/
		private function removeImg(con:MovieClip):void
		{
			var cnt:int = con.numChildren;
			var targetNum:int
			if(con == $contentsPopup.imgCon.img)
			{
				if(cnt < 1) return;
				targetNum = 0;
			}
			else if(con == $contentsPopup.reviewImg)
			{
				if(cnt <= 2) return;
				targetNum = 2;
			}
			
			while(cnt > targetNum)
			{
				var ldr:Loader = con.getChildAt(con.numChildren-1) as Loader;
				var bmp:Bitmap = ldr.content as Bitmap;
				if(ldr.content != null) bmp.bitmapData.dispose();
				con.removeChild(ldr);
				ldr.unloadAndStop();
				cnt--;
				trace("이미지 컨테이너 자식 수" + con.numChildren);
			}
		}
	}
}