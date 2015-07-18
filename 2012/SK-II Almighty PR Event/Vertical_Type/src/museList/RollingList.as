package museList
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class RollingList extends Sprite
	{
		
		/**	컨테이너	*/
		private var $con:MovieClip;
		/**	모델	*/
		private var $model:Model;
		/**	리스트 XML	*/
		private var $xml:XML;
		/**	리스트 갯수	*/
		private var $listLength:int;
		/** 리스트 현재 번호	*/
		private var $listNum:int = 0;
		/** 리스트 마지막 번호	*/
		private var $maxNum:int;
		/**	이미지 배열	*/
		private var $imgArr:Array;
		/**	후기 로더	*/
		private var $ldr:Loader;
		
		public function RollingList(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			/**	페이지 롤링 타이머 이벤트	*/
			$model.addEventListener(ModelEvent.PAGE_ROLLING, rollingList);
			
			loadXML();
			makeBtn();
		}
		
		protected function rollingList(e:Event):void
		{
			listNumChange(1);
		}
		
		/**	XML 로드 시작	*/
		private function loadXML():void
		{
			var ldr:URLLoader = new URLLoader();
			ldr.load(new URLRequest("xml/museList.xml"));
			
			ldr.addEventListener(Event.COMPLETE, xmlLoadComplete);
		}
		
		/**	XML 로드 완료	*/
		private function xmlLoadComplete(e:Event):void
		{
			$xml = new XML(e.target.data);
			
			$listLength = $xml.list.length();
			$maxNum = $listLength - 1;
			
			trace($xml + "\n::::::::$listLength: " + $listLength + "\n::::::::$maxNum: " + $maxNum);
			
			/**	이미지 로드 시작	*/
			$imgArr = [];
			for (var i:int = 0; i < $listLength; i++) 
			{
				var ldr:Loader = new Loader();
				ldr.load(new URLRequest($xml.list[i].@url));
				
				/**	로더 컨테이너	*/
				var mcCon:MovieClip = new MovieClip;
				mcCon.addChild(ldr);
				mcCon.alpha = 0;
				mcCon.review = $xml.list[i].@review;
				$con.imgCon.addChild(mcCon);
				
				$imgArr[i] = mcCon;
				
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
			}
		}
		
		/**	이미지 로드 완료	*/
		private function imgLoadComplete(e:Event):void
		{
			/**	페이지 체인지	*/
			pageChange();
		}
		
		/**	버튼 만들기	*/
		private function makeBtn():void
		{
			for (var i:int = 0; i < 2; i++) 
			{
				var btns:MovieClip = $con.getChildByName("btn"+i) as MovieClip;
				btns.no = i;
				btns.buttonMode = true;
				btns.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			/**	하단 이벤트 참여 버튼*/
			$con.btn.buttonMode = true;
			$con.btn.addEventListener(MouseEvent.CLICK, popupJoinHandler);
			
			/**	후기 보기 버튼	*/
			$con.btnReview.buttonMode = true;
			$con.btnReview.addEventListener(MouseEvent.CLICK, reviewHandler);
		}
		
		/**	리뷰 페이지 로드	*/
		private function reviewHandler(e:MouseEvent):void
		{
			/**	리뷰 버튼 exposure 	*/
			TweenMax.to($con.btnReview, 0, {colorTransform:{exposure:1.7, brightness:1}});
			TweenMax.to($con.btnReview, .6, {colorTransform:{exposure:1, brightness:0}, autoAlpha: 1});
			
			/**	리스트 롤링 정지	*/
			$model.dispatchEvent(new Event(ModelEvent.TIMER_STOP));
			
			/**	리뷰 페이지 로드	*/
			$ldr = new Loader();
			$ldr.load(new URLRequest($xml.list[$listNum].@reviewURL));
			$ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, reviewLoadComplete);
			$ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			$ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
			trace("::::: 리뷰 보기 :::::");
		}
		
		protected function ioerror(e:IOErrorEvent):void
		{
			trace(e);
		}
		
		protected function progress(e:ProgressEvent):void
		{
			trace(e.bytesLoaded + "/" + e.bytesTotal);
		}
		
		/**	리뷰 페이지 보이기	*/
		private function reviewLoadComplete(e:Event):void
		{
			$con.reviewCon.imgCon.addChild($ldr);
			trace($ldr.content, $ldr.content.width, $ldr.content.height, $ldr.content.alpha, $ldr.content.visible, $ldr.content.x, $ldr.content.y);
			
			$model.dispatchEvent(new Event(ModelEvent.REVIEW_PAGE_VIEW));
			trace($con.alpha, $con.visible, $con.reviewCon.alpah, $con.reviewCon.visible, $ldr.alpha, $ldr.visible);
		}
		
		/**	참여하기 창 띄우기	*/
		private function popupJoinHandler(e:MouseEvent):void
		{
			/**	리스트 롤링 정지	*/
			$model.dispatchEvent(new Event(ModelEvent.TIMER_STOP));
			/**	팝업 페이지 참여하기 띄우기	*/
			$model.dispatchEvent(new Event(ModelEvent.EVT_ONE_VIEW));
			/**	리뷰 페이지 닫기	*/
			$model.dispatchEvent(new Event(ModelEvent.REVIEW_PAGE_CLOSE));
			/**	리스트 숨기기	*/
			TweenMax.to($con, 1.5, {autoAlpha:0, ease:Cubic.easeOut});
		}
		
		/**	버튼 이벤트 핸들러	*/
		private function clickHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			TweenMax.to(mc, 0, {colorTransform:{exposure:1.5, brightness:1}});
			TweenMax.to(mc, 0.75, {colorTransform:{exposure:1, brightness:0}});
			
			for (var u:int = 0; u < 2; u++) 
			{
				var btns:MovieClip = $con.getChildByName("btn"+u) as MovieClip;
				btns.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			/**	리스트 롤링 멈춤	*/
			$model.dispatchEvent(new Event(ModelEvent.TIMER_PAUSE));
			
			/**	리스트 번호 체인지	*/
			listNumChange(mc.no);
			
			/**	클릭해서 본 페이지 번호 저장	*/
			var j:int = 0;
			for (var i:int = 0; i < $model.viewLength; i++) 
			{
				if($model.viewArr[i] != $listNum)
				{
					while(j < 1)
					{
						$model.viewArr.push($listNum);
						j++;
						trace("$model.viewLength: "+$model.viewLength);
					}
				}
			}
			$model.viewLength++;
			
			/**	페이지 다 본 후 타이머 정지 & 참가 팝업창 띄우기	*/
			if($model.viewArr.length >= $listLength)
			{
				$model.dispatchEvent(new Event(ModelEvent.TIMER_STOP));
				$model.dispatchEvent(new Event(ModelEvent.EVT_ONE_VIEW));
				/**	리스트 숨기기	*/
				TweenMax.to($con, 1.5, {autoAlpha:0, ease:Cubic.easeOut});
			}
			
			trace("$model.viewArr: " + $model.viewArr);
		}
		
		private function listNumChange(num:int):void
		{
			/**	버튼에 따른 페이지 번호 변화	*/
			switch (num)
			{
				case 0 : $listNum--; break;
				case 1 : $listNum++; break;
			}
			
			/**	페이지 번호 순환 시키기	*/
			if($listNum < 0)
			{
				$listNum = $maxNum;
			}
			else if($listNum > $maxNum)
			{
				$listNum = 0;
			}
			
			/**	페이지 체인지	*/
			pageChange();
		}
		
		/**	페이지 체인지	*/
		private function pageChange():void
		{
			for (var i:int = 0; i < $listLength; i++) 
			{
				/**	이미지 체인지	*/
				if($listNum == i) 
				{
					TweenMax.to($imgArr[i], 0, {colorTransform:{exposure:1.4, brightness:1}});
					TweenLite.to($imgArr[i], 1.5, {colorTransform:{exposure:1, brightness:0}, alpha:1, ease:Cubic.easeOut, onComplete:tweenComplete});
					
					/**	리뷰버튼 보이기 & 숨기기	*/
					if($imgArr[i].review == "true")
					{
						TweenMax.to($con.btnReview, .5, {autoAlpha: 1});
					}
					else
					{
						TweenMax.to($con.btnReview, .5, {autoAlpha: 0});
					}
				}
				else
				{
					TweenLite.to($imgArr[i], 1.5, {alpha:0, ease:Cubic.easeOut});
				}
			}
			
			/**	하단 타이틀 체인지	*/
			if($xml.list[$listNum].@muse == "true")
			{
				TweenLite.to($con.title0, 1.5, {alpha:1, ease:Cubic.easeOut});
				TweenLite.to($con.title1, 1.5, {alpha:0, ease:Cubic.easeOut});
				trace(":::::::Muse_true");
			}
			else
			{
				TweenLite.to($con.title0, 1.5, {alpha:0, ease:Cubic.easeOut});
				TweenLite.to($con.title1, 1.5, {alpha:1, ease:Cubic.easeOut});
				trace(":::::::Muse_false");
			}
		}
		
		private function tweenComplete():void
		{
			for (var i:int = 0; i < 2; i++) 
			{
				var btns:MovieClip = $con.getChildByName("btn"+i) as MovieClip;
				btns.addEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
	}
}