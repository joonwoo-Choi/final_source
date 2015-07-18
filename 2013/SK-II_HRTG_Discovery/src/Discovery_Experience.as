package
{
	
	import com.discovery.experience.KioskMain;
	import com.discovery.experience.SiteMain;
	import com.discovery.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="1920", height="1080", frameRate="30", backgroundColor="#eeeeee")]
	
	public class Discovery_Experience extends Sprite
	{
		public function get container():Sprite
		{
			if($main == null) return null;
			return $main.container;
		}
		
		public function get main():Object
		{
			if(_type == "kiosk"){
				return $kioskSetting;
			}else{
				return $siteSetting;
			}
		}
		
		private var $main:AssetExperience;
		
		private var $siteSetting:SiteMain;
		
		private var $kioskSetting:KioskMain;
		
		private var _type:String;
		
		public function Discovery_Experience()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			//stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			Model.getInstance().initFont();
			
			$main = new AssetExperience();
			this.addChild($main);
			
			this.mouseEnabled = false;
			$main.mouseEnabled = false;
			$main.container.mouseEnabled = false;
			$main.container.listCon.mouseEnabled = false;
			
			var params:Object = root.loaderInfo.parameters;
			_type = params.type;
//			if(_type == null){
//				_type = "kiosk";
//			}
			
			if(_type == "kiosk")
			{
				$kioskSetting = new KioskMain($main.container, "kiosk");
			}
			else
			{
				$siteSetting = new SiteMain($main.container, "site");
			}
			trace("리스트 타입 : ",params.type);
//			$kioskSetting = new KioskMain($main.container, "kiosk");
		}
	}
}