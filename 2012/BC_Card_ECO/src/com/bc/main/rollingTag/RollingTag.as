package com.bc.main.rollingTag
{
	
	import com.bc.model.Model;
	import com.bc.model.ModelEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.utils.NetUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class RollingTag
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	상품 리스트 XML	*/
		private var $listXml:XML;
		/**	태그 이미지 수	*/
		private var $tagLength:int;
		/**	태그 배열	*/
		private var $tagArr:Array = [];
		/**	태그 롤링 타이머	*/
		private var $timer:Timer;
		/**	타이머 카운트	*/
		private var $timerCnt:int = 0;
		
		public function RollingTag(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.XML_LOADED, tagImgLoad);
		}
		
		private function tagImgLoad(e:Event):void
		{
			$listXml = $model.listXml;
			$tagLength = $listXml.tag.list.length();
			
			/**	태그 이미지 로드	*/
			for (var i:int = 0; i < $tagLength; i++) 
			{
				var tagLdr:Loader = new Loader();
				if(NetUtil.isBrowser())
				{
					tagLdr.load(new URLRequest($model.webUrl + $listXml.tag.list[i]));
				}
				else
				{
					tagLdr.load(new URLRequest($listXml.tag.list[i]));
				}
				$tagArr.push(tagLdr);
				tagLdr.alpha = 0;
				$con.img.addChild(tagLdr);
				
				tagLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, tagLoadComplete);
			}
			
			$timer = new Timer(4000);
			$timer.addEventListener(TimerEvent.TIMER, rollingTagHandler);
			$timer.start();
		}
		/**	태그 로드 완료	*/
		private function tagLoadComplete(e:Event):void
		{
			listRolling();
//			$model.dispatchEvent(new ModelEvent(ModelEvent.TAG_LOADED));
		}
		
		private function rollingTagHandler(e:TimerEvent):void
		{
			$timerCnt++;
			listRolling();
//			if($timerCnt == 1) TweenLite.to($con.img, 0.75, {alpha:1, ease:Cubic.easeOut});
		}
		
		private function listRolling():void
		{
			for (var i:int = 0; i < $tagLength; i++) 
			{
				if($timerCnt%$tagLength == i)
				{
					$tagArr[i].x = $con.maskMC.width;
					if($timerCnt >= 1) TweenLite.to($tagArr[i], 1, {alpha:1, x:0, ease:Cubic.easeOut});
				}
				else
				{
					TweenLite.to($tagArr[i], 1, {x:-$tagArr[i].width, ease:Cubic.easeOut});
				}
			}
		}
	}
}