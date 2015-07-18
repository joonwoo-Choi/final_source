package
{
	
	import com.adqua.display.Resize;
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.pokemon.model.Model;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;

	[SWF(width="1000", height="730", frameRate="30", backgroundColor="0xffffff")]
	
	public class Pokemon_Index extends Sprite
	{
		
		private var $main:AssetIndex;
		
		public function Pokemon_Index()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetIndex();
			this.addChild($main);
			
			/**	로그인 검사	*/
			if(root.loaderInfo.parameters.flagLogin)
			{
				if(root.loaderInfo.parameters.flagLogin == "y")
				{
					Model.getInstance().isLogin = true;
				}
			}
			
			/**	기본 경로 설정	*/
			var mainUrl:String;
			if(SecurityUtil.isWeb())
			{		mainUrl = SecurityUtil.getPath(this) + "Pokemon_Main.swf";		}
			else
			{		mainUrl = "Pokemon_Main.swf";		};
			
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest(mainUrl));
			ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, mainLoadProgress);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, mainLoadComplete);
			$main.mainCon.addChild(ldr);
		}
		
		private function mainLoadProgress(e:ProgressEvent):void
		{
			var loadPercent:Number = e.target.bytesLoaded / e.target.bytesTotal;
			$main.loader.txtCon.txt.text = String(Math.round(loadPercent * 100));
			$main.loader.txtCon.txt.autoSize = TextFieldAutoSize.RIGHT;
			
			$main.loader.progressBar.bar.x = loadPercent * 352 - 352;
			
			$main.loader.x = int($main.stage.stageWidth/2 - $main.loader.width/2);
//			$main.loader.progressBar.bar.x = loadPercent * $main.loader.progressBar.bar.width - $main.loader.progressBar.bar.width;
			
			trace("로딩중!!___: " + $main.loader.progressBar.bar.x);
		}
		
		private function mainLoadComplete(e:Event):void
		{
			TweenLite.to($main.loader, 0.5, {autoAlpha:0, onComplete:removeLoader});
		}
		
		private function removeLoader():void
		{
			$main.removeChild($main.loader);
		}
	}
}