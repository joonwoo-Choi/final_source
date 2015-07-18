package util
{
	import com.adqua.net.Debug;
	import com.adqua.system.SecurityUtil;
	import com.cj.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import loading.ViewLoading;
	
	import pEvent.PEventCommon;

	public class SWFContent extends AbstractMain
	{
		private var $loader:Loader;
		private var $loading:MCLoading;
		private var $viewLoading:ViewLoading;
		private var $popBg:PopBg;
		public function SWFContent()
		{
			super();
			_model.addEventListener(PEventCommon.SWF_CONTENT_LOAD,swfLoad);
			_model.addEventListener(PEventCommon.REMOVE_INTERACTION,removePrevContent);
		}
		
		protected function swfLoad(event:Event):void
		{
			if(ArrayUtil.matchArray(_model.numActiveVideo,[2,2,1]) && numChildren>0){
				return;
			}
			if(ArrayUtil.matchArray(_model.numActiveVideo,[2,2,2]) && numChildren>0){
				return;
			}
			if(ArrayUtil.matchArray(_model.numActiveVideo,[2,2,3]) && numChildren>0){
				return;
			}
			if(ArrayUtil.matchArray(_model.numActiveVideo,[2,2,4]) && numChildren>0){
				return;
			}
			if(ArrayUtil.matchArray(_model.numActiveVideo,[3,3]) && numChildren>0){
				return;
			}
			trace("_model.numActiveVideo===============: ",_model.numActiveVideo);
			trace("numChildrenppppppppppppppppppppppppp: ",numChildren);
			
			if(ArrayUtil.matchArray(_model.numActiveVideo,[4,0,1]) && numChildren>0){
				return;
			}
			if(ArrayUtil.matchArray(_model.numActiveVideo,[4,0,_model.mall+1]) && numChildren>0){
				return;
			}
			trace("플래시를 로드한다...");
			
//			if(numChildren==0){
				
				removePrevContent(null);
				var swfUrl:String;
				
				if(_model.numNext.length==1)
				{
					swfUrl = _model.xmlData.list[int(_model.numNext[0])].@swf;
				}
				else if(_model.numNext.length==2)
				{
					swfUrl = _model.xmlData.list[int(_model.numNext[0])].list[int(_model.numNext[1])].@swf;
				}
				else if(_model.numNext.length==3)
				{
					swfUrl = _model.xmlData.list[int(_model.numNext[0])].list[int(_model.numNext[1])].list[int(_model.numNext[2])].@swf;
				}	
				
				$loader = new Loader;
//				$loader.load(new URLRequest(swfUrl));
//				$loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completLoaded);
//				addChild($loader);
				
			
				if(swfUrl ==_model.urlDefaultWeb + "Day2_3.swf"){
					
					_controler.makeLoading();
					
					if(SecurityUtil.isWeb()){
						$loader.load(new URLRequest(swfUrl));
					}else{
						$loader.load(new URLRequest(swfUrl));
					}
					$loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completLoaded);
					$loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
				}else{
					
					$loader.load(new URLRequest(swfUrl));
					addChild($loader);
					trace("swf컨텐츠 swfUrl : ", swfUrl)
				}
//			}
		}
		protected function onProgress(event:ProgressEvent):void
		{
			var per:Number = int((event.bytesLoaded/event.bytesTotal)*100);
			_controler.progress(per);
			trace("per : : ", per)
		}
		protected function completLoaded(event:Event):void
		{
//			Debug.alert("로드완료: "+$loader.alpha+" : "+this.alpha);
			trace("completLoaded++++++++++++++++++++++++++");
			addChild($loader);
			_controler.loadComplete();
		}
		
		private function removePrevContent(event:PEventCommon):void
		{
			var num:int = numChildren;
			for (var i:int = 0; i < num; i++) 
			{
				var mc:Loader = getChildAt(0) as Loader;
				removeChild(mc);
				mc.unloadAndStop();
				mc = null;
			}
			
		}
		
		
	}
}