package
{
	
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.proof.event.ModelEvent;
	import com.proof.microsite.flvPlayer.TVCFlvPlayer;
	import com.proof.model.Model;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	[SWF(width="360", height="203", frameRate="30", backgroundColor="0xffffff")]
	
	public class FTE_TVCPlayer extends Sprite
	{
		
		private var $main:AssetSiteFlvPlayerSeason2;
		
		private var $model:Model;
		
		private var $subFlvPlayer:TVCFlvPlayer;
		
		public function FTE_TVCPlayer()
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
			var movNum:int;
			if(root.loaderInfo.parameters.movNum)
			{		movNum = int(root.loaderInfo.parameters.movNum);	}
			else
			{		movNum = 0;		}
			
			/**	기본 경로 설정	*/
			var defaultPath:String;
			if(SecurityUtil.isWeb())
			{		defaultPath = SecurityUtil.getPath(this);		}
			else
			{		defaultPath = "";		};
			
			var imgPath:String = defaultPath + "thumb/TVC_" + movNum + ".jpg";
			var movPath:String = defaultPath + "flv/TVC_" + movNum + ".flv";
			
			$main = new AssetSiteFlvPlayerSeason2();
			this.addChild($main);
			
			$subFlvPlayer = new TVCFlvPlayer($main);
			
			/**	섬네일 로드	*/
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest(imgPath));
			$main.thumb.addChild(ldr);
			
			$model.videoPath = movPath;
			
			makeStarBtn();
		}
		
		protected function resetFlvPlayer(w:Event):void
		{
			TweenLite.to($main.btnPlay, 1, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to($main.thumb, 1, {alpha:1, ease:Cubic.easeOut});
			
			makeStarBtn();
		}
		
		private function makeStarBtn():void
		{
			$main.btnPlay.buttonMode = true;
			$main.btnPlay.addEventListener(MouseEvent.CLICK, videoStart);
		}
		
		protected function videoStart(e:MouseEvent):void
		{
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