package
{
	import bonanja.core.net.NetSenser;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	[SWF(width="1080", height="1920", frameRate="30", backgroundColor="#ffffff")]
	
	public class Index_Season2_20130422 extends Sprite
	{
		
		private var $chk:Boolean = true;
		
		private var $sensor:NetSenser;
		
		private var $loadTimer:Timer;
		
		private var $txt:TextField;
		
		public function Index_Season2_20130422()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			var tf:TextFormat = new TextFormat();
			tf.italic = true;
			tf.color = 0x545454;
			tf.size = 50;
			$txt = new TextField;
			$txt.defaultTextFormat = tf;
			$txt.autoSize = TextFieldAutoSize.LEFT;
			this.addChild($txt);
			$txt.text = "연결 중 입니다."
			$txt.x = this.stage.stageWidth/2 - $txt.width/2;
			$txt.y = this.stage.stageHeight/2 - $txt.height/2;
			
			/**	인터넷 접속 상태 체크	*/
			$sensor = new NetSenser("http://www.daum.net/", receiveStatus);
			
			$loadTimer = new Timer(100);
			$loadTimer.addEventListener(TimerEvent.TIMER, loadCheck);
			$loadTimer.start();
			
			/**	풀 스크린 모드	*/
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		protected function loadCheck(e:TimerEvent):void
		{
			$sensor.ping();
		}
		
		private function receiveStatus(obj:Object):void
		{
			switch (obj.status)
			{
				case "online" :
					$loadTimer.stop();
					$loadTimer.removeEventListener(TimerEvent.TIMER, loadCheck);
					$loadTimer = null;
					
					kioskLoad();
					break;
				case "offline" :
				case "Error" :
					break;
			}
		}
		
		private function kioskLoad():void
		{
			$sensor.destroy();
			
			/**	테스트 경로	*/
//			var path:String = "http://test.crm.piterahouse.com/CRM/swf/FTE_Kiosk_Season2.swf";
			/**	실 서버 경로	*/
			var path:String = "http://crm.piterahouse.com/CRM/swf/FTE_Kiosk_Season2.swf";
			var loader:SWFLoader = new SWFLoader(path, {container:this, onProgress:loadProgress, onComplet:loadComplete});
			var urlVars:URLVariables = new URLVariables;
			urlVars.rand = Math.random() * 10000;
			loader.request.data = urlVars;
			loader.load();
		}
		
		private function loadProgress(e:LoaderEvent):void
		{
			var loadPercent:Number = e.target.bytesLoaded / e.target.bytesTotal;
			$txt.text = String(Math.round(loadPercent * 100)) + " %";
			$txt.x = this.stage.stageWidth/2 - $txt.width/2;
			$txt.y = this.stage.stageHeight/2 - $txt.height/2;
			
			trace("로딩중!!___: " + loadPercent);
		}
		
		private function loadComplete(e:LoaderEvent):void
		{
			trace("load");
		}
	}
}