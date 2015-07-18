package
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.StringUtil;
	import com.hm.culturebox.Main;
	import com.hm.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="1280", height="1363", frameRate="30", backgroundColor="0x888888")]
	
	public class HM_CultureBox extends Sprite
	{
		
		private var _assetMain:AssetMain;
		
		private var _main:Main;
		
		private var _model:Model = Model.getInstance();
		
		public function HM_CultureBox()
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
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{
				_model.commonPath = SecurityUtil.getPath(this);
				if(StringUtil.ereg(SecurityUtil.getPath(this), "test", "g")) _model.dataUrl = "http://test.culture.cjhello.com/";
				else _model.dataUrl = "http://culture.cjhello.com/";
			}
			else
			{
				_model.commonPath = "";
			};
			
			_assetMain = new AssetMain();
			this.addChild(_assetMain);
			
			_main = new Main(_assetMain);
		}
	}
}