package minimap
{
	import com.adqua.event.XMLLoaderEvent;
	import com.adqua.net.XMLLoader;
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import pEvent.PEventCommon;
	
	public class ViewSpot extends AbstractMCView
	{
		private var $xmlLoader:XMLLoader;
		private var frameNum:int;
		public function ViewSpot(con:MovieClip)
		{
			super(con);
			setting();
		}
		
		override protected function onRemoved(event:Event):void
		{
			super.onRemoved(event);
		}
		
		override public function setting():void
		{
			_model.addEventListener(PEventCommon.SPOT_MAIN, xmlLoaded);
			ButtonUtil.makeButton(_mcView["closeBtn"]["btn"], closeBtnHandler);
		}
		
		public function removeEvent(e:Event = null):void
		{
			_model.removeEventListener(PEventCommon.SPOT_MAIN, xmlLoaded);
			ButtonUtil.removeButton(_mcView["closeBtn"]["btn"], closeBtnHandler);
			
			removePrev();
		}
		
		protected function xmlLoaded(evt:PEventCommon):void
		{
			mainSetting(null)
		}
		
		private function mainSetting(evt:Event):void
		{
			removePrev();
			trace("여기 _model.routeNum : ", _model.routeNum)
			var mainNum:int = _model.galleryPhotXMLData.bimg.length();
//			frameNum = _model.galleryPhotXMLData.page[_model.pageNum].list[_model.listNum].@frameNum;
			frameNum = _model.galleryPhotXMLData.bimg[_model.routeNum].@frameNum;
			
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
		
		private function imgShow(evt:LoaderEvent):void
		{
			TweenLite.to(evt.target.content, .5,{alpha:1});
			trace("에일리 스팟 팝업 자식 수: " + PopSpot(_mcView).loadCon.numChildren);
		}
		
		private function removePrev():void
		{
			var num:int = PopSpot(_mcView).loadCon.numChildren - 1;
			while (num >=0)
			{
				var mc:DisplayObject = PopSpot(_mcView).loadCon.getChildAt(num);
				PopSpot(_mcView).loadCon.removeChild(mc);
				num --;
				trace("에일리 스팟 팝업 자식 수: " + PopSpot(_mcView).loadCon.numChildren);
			}
			
		}
		
		
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
					
					_model.dispatchEvent(new PEventCommon(PEventCommon.ROUTE_MENU_SHOW));
					TweenMax.to(PopSpot(_mcView),.5,{autoAlpha:0, onComplete:removePrev});
					break;
			}
		}
	}
}