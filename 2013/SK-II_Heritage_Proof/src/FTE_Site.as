package 
{
	
	import com.adqua.system.SecurityUtil;
	import com.proof.microsite.Site_Main;
	import com.proof.microsite.flvPlayer.BackgroundFlvPlayer;
	import com.proof.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[SWF(width="1659", height="877", frameRate="30", backgroundColor="0x999999")]
	
	public class FTE_Site extends Sprite
	{
		
		private var $main:AssetSiteMain;
		
		private var $model:Model;
		
		private var $siteMain:Site_Main;
		
		private var $flvPlayer:BackgroundFlvPlayer;
		
		public function FTE_Site()
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
			
			$main = new AssetSiteMain();
			this.addChild($main);
			
			$model = Model.getInstance();
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = SecurityUtil.getPath(this);		}
			else
			{		$model.defaulfPath = "";		};
			
			$siteMain = new Site_Main($main);
//			$flvPlayer = new MainFlvPlayer($main.movCon);
		}
	}
}