package minimap
{
	import com.adqua.event.XMLLoaderEvent;
	import com.adqua.net.XMLLoader;
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.NetUtil;
	import com.cj.utils.ArrayUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import pEvent.PEventCommon;

	[SWF(width="961",height="541",frameRate="30")]
	public class MiniMap extends AbstractMain
	{
		private var $miniMap:MiniCon;
		private var $menuMc:MovieClip;
		private var $popGallery:PopGallery;
		private var $ViewGallery:ViewGallery;
		private var $xmlLoader:XMLLoader;
		private var $popSpot:PopSpot;
		private var $ViewSpot:ViewSpot;
		
		public function MiniMap()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		override protected function onAdded(event:Event):void
		{
			Model.getInstance().prependURL = SecurityUtil.getPath(this);
			Model.getInstance().addEventListener(PEventCommon.REMOVE_POPUP_EVENT, removeEvent);
			
			//minimap
			$miniMap = new MiniCon;
			addChild($miniMap);
			$miniMap["hpCover"].mouseEnabled = false;
			$miniMap["hpCover"].mouseChildren = false;

			//사진갤러리
			$popGallery = new PopGallery;
			$miniMap["spotLoad"].addChild($popGallery);
			$popGallery.visible = false;
			$ViewGallery = new ViewGallery($popGallery);
			
			//스팟갤러리
			$popSpot = new PopSpot;
			$miniMap["spotLoad"].addChild($popSpot);
			$popSpot.visible = false;
			$ViewSpot = new ViewSpot($popSpot);
			
			//상단메뉴셋팅
			menuSetting();
			
			//상단메뉴 활성화
			menuMov(0);
			
			//지도루트 모션활성화
			routeMove(0);
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			//메뉴 on off
			_model.addEventListener(PEventCommon.ROUTE_MENU_SHOW,menuShow);
			_model.addEventListener(PEventCommon.ROUTE_MENU_HIDE,menuHide);
			
			super.onAdded(event);
		}
		/**	이벤트 제거	*/
		protected function removeEvent(e:Event):void
		{
			trace("루트 맵 팝업 이벤트 제거_____________________!!");
			Model.getInstance().removeEventListener(PEventCommon.REMOVE_POPUP_EVENT, removeEvent);
			_model.removeEventListener(PEventCommon.ROUTE_MENU_SHOW,menuShow);
			_model.removeEventListener(PEventCommon.ROUTE_MENU_HIDE,menuHide);
			
			for (var k:int = 0; k < 3; k++) 
			{
				$menuMc = $miniMap["menuCon"]["menu"+k];
				$menuMc.removeEventListener(MouseEvent.CLICK, menuClick);
				$menuMc = null;
			}
			$miniMap["menuCon"]["menu3"].removeEventListener(MouseEvent.CLICK, menuClick);
			
			$miniMap["menuCon"]["yellowGo"].removeEventListener(MouseEvent.ROLL_OVER, yellowOver);
			$miniMap["menuCon"]["yellowGo"].removeEventListener(MouseEvent.ROLL_OUT, yellowOut);
			$miniMap["menuCon"]["yellowGo"].removeEventListener(MouseEvent.CLICK, yellowClick);
			
			for (var i:int = 0; i < 4; i++) 
			{
				var routeAry:Array = [3,3,2,5]
				for (var j:int = 0; j < routeAry[i]; j++) 
				{
					var $routeBtn:MovieClip =  $miniMap["route"+i]["btn" + j];
					$routeBtn.removeEventListener(MouseEvent.CLICK, routeClick);
				}
			}
			
			if($xmlLoader != null)
			{
				$xmlLoader.removeEventListener(XMLLoaderEvent.XML_COMPLETE,xmlLoaded);
				$xmlLoader = null;
			}
			
			$ViewSpot.removeEvent();
			$ViewGallery.removeEvent();
			
			$miniMap.removeChildren(0, $miniMap.numChildren - 1);
			this.removeChild($miniMap);
			trace("$miniMap 자식 수: " + $miniMap.numChildren, "  &&   스테이지 자식 수: " + this.numChildren);
			
			$ViewSpot = null;
			$ViewGallery = null;
			$popGallery = null;
			$popSpot = null;
			$miniMap = null;
		}
		
		protected function menuShow(e:PEventCommon=null):void
		{
			$miniMap["menuCon"].visible = true;
		}
		
		protected function menuHide(e:PEventCommon=null):void
		{
			$miniMap["menuCon"].visible = false;
		}
		
		//상단메뉴셋팅
		private function menuSetting():void
		{
			for (var i:int = 0; i < 3; i++) 
			{
				$menuMc = $miniMap["menuCon"]["menu"+i];
				$menuMc.buttonMode = true;
				$menuMc.id = i;
				_model.menuNum = $menuMc.id;
				$menuMc["txtMc"].gotoAndStop(i+1);
				$menuMc["bg"].gotoAndStop(i+1);
				$menuMc.addEventListener(MouseEvent.CLICK, menuClick);
			}
			var $menuMc3:MovieClip = $miniMap["menuCon"]["menu3"];
			$menuMc3.buttonMode = true;
			$menuMc3.id = 3;
			$menuMc3.addEventListener(MouseEvent.CLICK, menuClick);
			
			$miniMap["menuCon"]["yellowGo"].buttonMode = true;
			$miniMap["menuCon"]["yellowGo"].addEventListener(MouseEvent.ROLL_OVER, yellowOver);
			$miniMap["menuCon"]["yellowGo"].addEventListener(MouseEvent.ROLL_OUT, yellowOut);
			$miniMap["menuCon"]["yellowGo"].addEventListener(MouseEvent.CLICK, yellowClick);
		}
		//전체 영상보기 클릭
		protected function yellowOver(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			TweenMax.to(curMc, 0.3,{frame:curMc.totalFrames-1, easing:Linear.easeNone});
		}
		
		protected function yellowOut(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			TweenMax.to(curMc, 0.3,{frame:1, easing:Linear.easeNone});
		}
		protected function yellowClick(evt:MouseEvent):void
		{
			if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map1_video");
			NetUtil.getURL("http://youtu.be/q-f0QRZFlAM","_blank");
			
		}
		
		//상단메뉴 클릭
		protected function menuClick(evt:MouseEvent):void
		{
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			var curId:int = curMc.id;
			menuMov(curId);
			routeMove(curId);
			trace("curId : ", curId);
			if(curId == 0){
				if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map1");
			}else if(curId == 1){
				if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map2");
			}else if(curId == 2){
				if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map3");
			}else if(curId == 3){
				if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map4");
			}
		}
		
		//상단메뉴 활성화
		private function menuMov($id:int):void
		{
			for (var i:int = 0; i < 4; i++) 
			{
				var $menu:MovieClip = $miniMap["menuCon"]["menu"+i];
				
				if(i == $id){
					TweenMax.to($menu, 0.3,{frame:$menu.totalFrames-1, easing:Linear.easeNone});
					
				}else{
					TweenMax.to($menu, 0.3,{frame:1, easing:Linear.easeNone});
				}
			}
		}
		
		//route 무비
		private function routeMove($id:int):void
		{
			/**	루트맵 스탬프 발도장 찍기	*/
			routMapStamp($id)
			
			_model.menuNum = $id;
			for (var i:int = 0; i < 4; i++) 
			{
				var $route:MovieClip = $miniMap["route"+i];
				
				if(i == $id){
					$route.visible = true;
					TweenMax.to($route,1.2,{frame:$route.totalFrames-1, easing:Linear.easeNone});
					
					var routeAry:Array = [3,3,2,5]
					for (var j:int = 0; j < routeAry[_model.menuNum]; j++) 
					{
						var $routeBtn:MovieClip =  $miniMap["route"+i]["btn" + j];
						$routeBtn.buttonMode = true;
						$routeBtn.id = j;
						
//						var $routeIcon:MovieClip =  $miniMap["route"+i]["num" + j]["mc"];
						if($id == 3) $route["num" + j]["mc"].gotoAndStop(j+1);
						
						$routeBtn.addEventListener(MouseEvent.ROLL_OVER, routeOver);
						$routeBtn.addEventListener(MouseEvent.ROLL_OUT, routeOut);
						$routeBtn.addEventListener(MouseEvent.CLICK, routeClick);
						trace("j : ", j)
					}
				}else{
					$route.visible = false;
					$route.gotoAndStop(1);
				}
			}
		}
		
		protected function routeOver(event:MouseEvent):void
		{
			var curMc:MovieClip = event.currentTarget as MovieClip;
			var curId:int = curMc.id
			TweenLite.to($miniMap["route"+_model.menuNum]["num"+curId],.2,{frame:$miniMap["route"+_model.menuNum]["num"+curId].totalFrames-1})
				trace("curId : :", curId)
		}
		protected function routeOut(event:MouseEvent):void
		{
			var curMc:MovieClip = event.currentTarget as MovieClip;
			var curId:int = curMc.id
			TweenLite.to($miniMap["route"+_model.menuNum]["num"+curId],.2,{frame:1})
		}
		
		//route 클릭
		protected function routeClick(evt:MouseEvent):void
		{
			menuHide();
			
			var curMc:MovieClip = evt.currentTarget as MovieClip;
			var curId:int = curMc.id;
			_model.routeNum = curId;
			
			$xmlLoader = new XMLLoader;
			$xmlLoader.addEventListener(XMLLoaderEvent.XML_COMPLETE,xmlLoaded);
			
			//route 갤러리
			if(_model.menuNum == 0){
				TweenMax.to($popGallery,.5, {autoAlpha:1});
				
				if(_model.routeNum == 0){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map1_barbaras");
					
					$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto0.xml");
					$popGallery.galleryMc.gotoAndStop(1)
					$popGallery.galleryMc.titleMc.gotoAndPlay(2);
				}else if(_model.routeNum == 1 ){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map1_rwm");
					
					$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto1.xml");
					$popGallery.galleryMc.gotoAndStop(2)
					$popGallery.galleryMc.titleMc.gotoAndPlay(2);
				}else if(_model.routeNum == 2 ){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map1_highstreet");
					
					$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto2.xml");
					$popGallery.galleryMc.gotoAndStop(3)
					$popGallery.galleryMc.titleMc.gotoAndPlay(2);
				}
				
			}else if(_model.menuNum == 1){
				TweenMax.to($popGallery,.5, {autoAlpha:1});
				
				if(_model.routeNum == 0){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map2_club");
					
					$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto3.xml");
					$popGallery.galleryMc.gotoAndStop(4)
					$popGallery.galleryMc.titleMc.gotoAndPlay(2);
				}else if(_model.routeNum == 1 ){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map3_chispa");
					
					$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto4.xml");
					$popGallery.galleryMc.gotoAndStop(5)
					$popGallery.galleryMc.titleMc.gotoAndPlay(2);
				}else if(_model.routeNum == 2 ){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map4_skydeck");
					
					$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto5.xml");
					$popGallery.galleryMc.gotoAndStop(6)
					$popGallery.galleryMc.titleMc.gotoAndPlay(2);
				}
				
			}else if(_model.menuNum == 2){
				TweenMax.to($popGallery,.5, {autoAlpha:1});
				
				if(_model.routeNum == 0){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map3_cultura");
					
					$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto6.xml");
					$popGallery.galleryMc.gotoAndStop(7)
					$popGallery.galleryMc.titleMc.gotoAndPlay(2);
				}else if(_model.routeNum == 1 ){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map3_macapagal");
					
					$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto7.xml");
					$popGallery.galleryMc.gotoAndStop(8)
					$popGallery.galleryMc.titleMc.gotoAndPlay(2);
				}
				
			//spot갤러리
			}else if(_model.menuNum == 3){
				
				TweenMax.to($popSpot, .5, {autoAlpha:1});
				$xmlLoader.load(_model.urlDefaultWeb+"xml/galleryPhoto8.xml");
//				
				trace("_model.routeNum : ,", _model.routeNum)
				
				if(_model.routeNum == 0){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map4_golf");
				}else if(_model.routeNum == 1){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map4_self");
				}else if(_model.routeNum == 2){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map4_sunset");
				}else if(_model.routeNum == 3){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map4_seafood");
				}else if(_model.routeNum == 4){
					if(ExternalInterface.available)ExternalInterface.call("googleTrace","W_map4_dance");
				}
			}
		}
		
		/**	루트맵 스탬프 찍기	*/
		private function routMapStamp(rounConNum:int):void
		{
			/**	날짜별 영상 번호 배열	*/
			var stamapConArr:Array = [];
			if(rounConNum == 0) stamapConArr = ["0", "1", "2"];
			else if(rounConNum == 1) stamapConArr = ["3", "4", "5"];
			else if(rounConNum == 2) stamapConArr = ["6", "7"];
			/**	본 영상 번호랑 같은 것만 배열로 생성	*/
			var routWatchedMovArr:Array = ArrayUtil.intersect(stamapConArr, _model.watchedMov);
			/**	발도장 보이기	*/
			if(rounConNum < 3 && routWatchedMovArr.length > 0)
			{
				var route:MovieClip = $miniMap["route"+rounConNum];
				var k:int;
				for (k = 0; k < routWatchedMovArr.length; k++) 
				{
					route["stamp" + routWatchedMovArr[k]].alpha = 1;
				}
			}
		}
		
		protected function xmlLoaded(evt:XMLLoaderEvent):void
		{
			Model.getInstance().galleryPhotXMLData = evt.xml;
			if(_model.menuNum == 3){
				_model.dispatchEvent(new PEventCommon(PEventCommon.SPOT_MAIN));
			}else{
				_model.dispatchEvent(new PEventCommon(PEventCommon.GALLERY_LOAD));
			}
		}
	}
}