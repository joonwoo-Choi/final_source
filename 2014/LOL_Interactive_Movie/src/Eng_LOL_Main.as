package
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.StringUtil;
	import com.lol.events.LolEvent;
	import com.lol.main.Main;
	import com.lol.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="1048", height="590", frameRate="30", backgroundColor="0x888888")]
	
	public class Eng_LOL_Main extends Sprite
	{
		
		private var _main:AssetMain_Eng;
		private var _model:Model = Model.getInstance();
		private var _LolMain:Main;
		
		public function Eng_LOL_Main()
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
			
			_main = new AssetMain_Eng();
			this.addChild(_main);
			
			_LolMain = new Main(_main);
		}
	}
}