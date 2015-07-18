package minimap
{
	import com.adqua.event.XMLLoaderEvent;
	import com.adqua.net.Debug;
	import com.adqua.net.XMLLoader;
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.NetUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import pEvent.PEventCommon;
	
	public class ViewGallery extends AbstractMCView
	{
		private var $xmlLoader:XMLLoader;
		private var $listCon:GalleryListCon;
		private var $listConCtrl:GalleryListConCtrl;
		private var frameNum:int = 0;
		
		public function ViewGallery(con:MovieClip)
		{
			TweenPlugin.activate([ColorTransformPlugin]);
			super(con);
			
			setting();
		}
		
		override protected function onRemoved(event:Event):void
		{
			super.onRemoved(event);
		}
		
		override public function setting():void
		{
			ButtonUtil.makeButton(_mcView["closeBtn"]["btn"], closeBtnHandler);
			_model.addEventListener(PEventCommon.GALLERY_LOAD, xmlLoaded);
		}
		
		public function removeEvent(e:Event = null):void
		{
			_model.removeEventListener(PEventCommon.GALLERY_LOAD, xmlLoaded);
			_model.removeEventListener(PEventCommon.GALLERY_MAIN, mainSetting);
			
			ButtonUtil.removeButton(_mcView["closeBtn"]["btn"], closeBtnHandler);
			
			for (var i:int = 0; i < 2; i++) 
			{
				var btns:MovieClip = _mcView.galleryMc.page.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btns, btnsHandler);
			}
			
			_model.pageNum = 0;
			_model.listNum = 0;
			
			if($listConCtrl != null) $listConCtrl.removeEvent();
			_mcView.removeChildren(0, _mcView.numChildren - 1);
			trace("_mcView 자식 수: " + _mcView.numChildren);
			
			$xmlLoader = null;
			$listConCtrl = null;
			$listCon = null;
		}
		
		protected function xmlLoaded(evt:PEventCommon):void
		{
			$listCon = new GalleryListCon;
			$listConCtrl = new GalleryListConCtrl($listCon);
			_mcView.addChild($listCon);
			
			$listCon.x = 736;
			$listCon.y = 460;
			
			mainSetting(null);
			_model.addEventListener(PEventCommon.GALLERY_MAIN, mainSetting);
		}
		
		private function mainSetting(evt:Event):void
		{
			trace("갤러리 팝업 오픈");
			for (var i:int = 0; i < 2; i++) 
			{
				var btns:MovieClip = _mcView.galleryMc.page.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, btnsHandler);
				trace("버튼 Y: " + btns.y);
			}
			
			removePrev();
			var mainNum:int = _model.galleryPhotXMLData.bimg.length();
			frameNum = _model.galleryPhotXMLData.page[_model.pageNum].list[_model.listNum].@frameNum;
				
			var mainMc:MovieClip = _mcView["loadCon"];
			var url:String = Model.getInstance().prependURL+_model.galleryPhotXMLData.bimg[frameNum];
			var thumbLoader:ImageLoader = new ImageLoader(url,{
				container:mainMc, 
				smoothing:true,
				width:mainMc.width, height:mainMc.height,
				onComplete:imgShow,
				alpha:0
			});	
			
			thumbLoader.load(); 
			trace("url : ", url)
		}
		
		private function btnsHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					
//					TweenLite.to(target, 0.5, {});
					TweenLite.to(target, 0.5, {frame:target.totalFrames-1,colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(target, 0.5, {frame:1,colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK :
					trace("버튼 번호: " + target.no);
					trace("여기??")
					
					if(_model.menuNum == 0){
						if(_model.routeNum == 0){
							//바바라스
							if(target.no == 0){
								NetUtil.getURL("https://maps.google.co.kr/maps?ie=UTF8&cid=12877213566382084173&q=Barbara%27S&iwloc=A&gl=KR&hl=ko","_blank");
							}else if(target.no == 1){
								NetUtil.getURL("http://bit.ly/10LiSEv","_blank");
							}
						}else if(_model.routeNum == 1){
							//RWM 호텔풀
							if(target.no == 0){
								NetUtil.getURL("https://maps.google.co.kr/maps?ie=UTF8&cid=4359221893150939472&q=%EB%A6%AC%EC%A1%B0%EC%B8%A0+%EC%9B%94%EB%93%9C+%EB%A7%88%EB%8B%90%EB%9D%BC&iwloc=A&gl=KR&hl=ko","_blank");
							}else if(target.no == 1){
								NetUtil.getURL("http://bit.ly/17ka5gF","_blank");
							}
						}else if(_model.routeNum == 2){
							//보니파시오 하이스트리트
							if(target.no == 0){
								NetUtil.getURL("https://maps.google.co.kr/maps?ie=UTF8&cid=16169461543096294469&q=%ED%83%80%EC%9E%84%EC%A1%B4+-+%EB%B3%B4%EB%8B%88%ED%8C%8C%EC%8B%9C%EC%98%A4+%ED%95%98%EC%9D%B4+%EC%8A%A4%ED%8A%B8%EB%A6%AC%ED%8A%B8&iwloc=A&gl=KR&hl=ko","_blank");
							}else if(target.no == 1){
								NetUtil.getURL("http://bit.ly/13zduTC","_blank");
							}
						}
					}else if(_model.menuNum == 1){
						if(_model.routeNum == 0){
							//클럽 골프
							if(target.no == 0){
								NetUtil.getURL("https://maps.google.co.kr/maps?ie=UTF8&cid=3313606031813836371&q=Club+Intramuros&iwloc=A&gl=KR&hl=ko","_blank");
							}else if(target.no == 1){
								NetUtil.getURL("http://bit.ly/12pkM0x","_blank");
							}
						}else if(_model.routeNum == 1){
							//치스파
							if(target.no == 0){
								NetUtil.getURL("https://maps.google.co.kr/maps?ie=UTF8&cid=3227800775163404118&q=CHI,+The+Spa+at+Edsa+Shangri-La,+Manila&iwloc=A&gl=KR&hl=ko","_blank");
							}else if(target.no == 1){
								NetUtil.getURL("http://bit.ly/17k9Ke1","_blank");
							}
						}else if(_model.routeNum == 2){
							//스카이덱 레스토랑
							if(target.no == 0){
								NetUtil.getURL("https://maps.google.co.kr/maps?ie=UTF8&cid=1927525393932516316&q=Sky+Deck+View+Bar,+The+Bayleaf+Intramuros&iwloc=A&gl=KR&hl=ko","_blank");
							}else if(target.no == 1){
								NetUtil.getURL("http://bit.ly/13hv7Iz","_blank");
							}
						}
					}else if(_model.menuNum == 2){
						if(_model.routeNum == 0){
							//쿨트라
							if(target.no == 0){
								NetUtil.getURL("https://maps.google.co.kr/maps?ie=UTF8&cid=16735945200470335387&q=SM+%EB%AA%B0+%EC%98%A4%EB%B8%8C+%EC%95%84%EC%8B%9C%EC%95%84&iwloc=A&gl=KR&hl=ko","_blank");
							}else if(target.no == 1){
								NetUtil.getURL("http://bit.ly/130aCi3","_blank");
							}
						}else if(_model.routeNum == 1){
							//마카파갈 씨사이드 마켓
							if(target.no == 0){
								NetUtil.getURL("https://maps.google.co.kr/maps?ie=UTF8&cid=9331554860435773691&q=Sea+Side&iwloc=A&gl=KR&hl=ko","_blank");
							}else if(target.no == 1){
								NetUtil.getURL("http://bit.ly/15uPdiT","_blank");
							}
						}
					}
					
					break;
			}
		}
		
		private function imgShow(evt:LoaderEvent):void
		{
			TweenLite.to(evt.target.content, .5,{alpha:1});
			
			
			if(_model.pageNum == 0){
				if(_model.listNum == 0){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(1)
				}else if(_model.listNum == 1){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(2)
				}else if(_model.listNum == 2){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(3)
				}
			}else if(_model.pageNum == 1){
				if(_model.listNum == 0){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(4)
				}else if(_model.listNum == 1){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(5)
				}else if(_model.listNum == 2){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(6)
				}
			}else if(_model.pageNum == 2){
				if(_model.listNum == 0){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(7)
				}else if(_model.listNum == 1){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(8)
				}else if(_model.listNum == 2){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(9)
				}
			}else if(_model.pageNum == 3){
				if(_model.listNum == 0){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(10)
				}else if(_model.listNum == 1){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(11)
				}else if(_model.listNum == 2){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(12)
				}
			}else if(_model.pageNum == 4){
				if(_model.listNum == 0){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(13)
				}else if(_model.listNum == 1){
					PopGallery(_mcView).galleryMc.titleMc.mc.gotoAndStop(14)
				}
			}
		}
		
		private function removePrev():void
		{
			var num:int = PopGallery(_mcView).loadCon.numChildren
			for (var i:int = 0; i < num; i++) 
			{
				if(PopGallery(_mcView).loadCon.numChildren>1){
					var mc:DisplayObject = PopGallery(_mcView).loadCon.getChildAt(0);
					PopGallery(_mcView).loadCon.removeChild(mc);
				}
			}
			trace("num : ", num)
		}
		
//		protected function closeClick(evt:Event):void
//		{
//			for (var i:int = 0; i < 2; i++) 
//			{
//				var btns:MovieClip = _mcView.galleryMc.page.getChildByName("btn" + i) as MovieClip;
//				ButtonUtil.removeButton(btns, btnsHandler);
//			}
//			_model.dispatchEvent(new PEventCommon(PEventCommon.ROUTE_MENU_SHOW));
//			TweenMax.to(PopGallery(_mcView),.5,{autoAlpha:0});
//			
//			_mcView.removeChild($listCon);
//			_model.pageNum = 0;
//			_model.listNum = 0;
//			trace("갤러리 팝업 닫기");
//		}
		
		
		/**	닫기 버튼 핸들러	*/
		private function closeBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(_mcView["closeBtn"]["btn"], 0.5, {rotation:90, ease:Expo.easeOut});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to(_mcView["closeBtn"]["btn"], 0.5, {rotation:0, ease:Expo.easeOut});
					break;
				case MouseEvent.CLICK :
					
					for (var i:int = 0; i < 2; i++) 
					{
						var btns:MovieClip = _mcView.galleryMc.page.getChildByName("btn" + i) as MovieClip;
						ButtonUtil.removeButton(btns, btnsHandler);
					}
					_model.dispatchEvent(new PEventCommon(PEventCommon.ROUTE_MENU_SHOW));
					TweenMax.to(PopGallery(_mcView),.5,{autoAlpha:0});
					
					if($listCon)_mcView.removeChild($listCon);
					_model.pageNum = 0;
					_model.listNum = 0;
					trace("갤러리 팝업 닫기");
					break;
			}
		}
		
		
	}
}