package
{
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.proof.event.ModelEvent;
	import com.proof.microsite.flvPlayer.SubFlvPlayer;
	import com.proof.model.Model;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[SWF(width="670", height="377", frameRate="30", backgroundColor="0xffffff")]
	
	public class FTE_FlvPlayer extends Sprite
	{
		
		private var $main:AssetSiteFlvPlayer;
		
		private var $model:Model;
		
		private var $subFlvPlayer:SubFlvPlayer;
		
		private var $movNum:int;
		
		public function FTE_FlvPlayer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.VIDEO_STOP, resetFlvPlayer);
			
			/**	영상 번호 설정	*/
			if(root.loaderInfo.parameters.movNum)
			{		$movNum = root.loaderInfo.parameters.movNum;	}
			else
			{		$movNum = 1;		}
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = SecurityUtil.getPath(this);		}
			else
			{		$model.defaulfPath = "";		};
			
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(new URLRequest($model.defaulfPath + "xml/site_xml.xml"));
			urlLdr.addEventListener(Event.COMPLETE, xmlLoadComplete);
			
			$main = new AssetSiteFlvPlayer();
			this.addChild($main);
			
			$subFlvPlayer = new SubFlvPlayer($main);
		}
		
		protected function resetFlvPlayer(w:Event):void
		{
			TweenLite.to($main.btnPlay, 1, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to($main.thumb, 1, {alpha:1, ease:Cubic.easeOut});
			
			makeStarBtn();
		}
		/**	XML 로드 완료	*/
		protected function xmlLoadComplete(e:Event):void
		{
			$model.siteXml = new XML(e.target.data);
			trace($model.siteXml);
			/**	섬네일 로드	*/
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest($model.defaulfPath + $model.siteXml.flvPlayer.list[$movNum].@thumb));
			$main.thumb.addChild(ldr);
			
			$model.videoPath = $model.defaulfPath + $model.siteXml.flvPlayer.list[$movNum].@video;
			
			makeStarBtn();
		}
		
		private function makeStarBtn():void
		{
			$main.btnPlay.buttonMode = true;
			$main.btnPlay.addEventListener(MouseEvent.CLICK, videoStart);
		}
		
		protected function videoStart(e:MouseEvent):void
		{
//			$main.btnPlay.mouseChildren = false;
//			$main.btnPlay.mouseEnabled = false;
			$main.btnPlay.buttonMode = false;
			$main.btnPlay.removeEventListener(MouseEvent.CLICK, videoStart);
			
			TweenLite.to($main.btnPlay, 1, {alpha:0, ease:Cubic.easeOut});
			TweenLite.to($main.thumb, 1, {alpha:0, ease:Cubic.easeOut, onComplete:settingVideo});
		}
		
		private function settingVideo():void
		{
			$model.dispatchEvent(new ModelEvent(ModelEvent.VIDEO_SETTING));
		}
	}
}