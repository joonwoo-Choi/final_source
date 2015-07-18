package
{
	import bonanja.core.net.NetSenser;
	
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	[SWF(width="1080", height="1920", frameRate="30", backgroundColor="#ffffff")]
	
	public class Index_Season2 extends Sprite
	{
		
		private var $main:AssetKioskIndex_Season2;
		
		private var $loadCheck:Boolean = false;
		
		private var $loadCompleteCheck:Boolean = false;
		
		private var $sensor:NetSenser;
		
		private var $loadTimer:Timer;
		
		private var $txt:TextField;
		
		private var $ldr:SWFLoader
		
		public function Index_Season2()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetKioskIndex_Season2();
			this.addChild($main);
			
			$main.popup.visible = false;
			
			var tf:TextFormat = new TextFormat();
			tf.italic = true;
			tf.color = 0x545454;
			tf.size = 50;
			$txt = new TextField;
			$txt.defaultTextFormat = tf;
			$txt.autoSize = TextFieldAutoSize.LEFT;
			$main.txt.addChild($txt);
			$txt.text = "연결 중 입니다."
			$txt.x = this.stage.stageWidth/2 - $txt.width/2;
			$txt.y = this.stage.stageHeight/2 - $txt.height/2;
			
			/**	인터넷 접속상태 체크	*/
			$sensor = new NetSenser("http://www.daum.net", receiveStatus);
			
			$loadTimer = new Timer(6000);
			$loadTimer.addEventListener(TimerEvent.TIMER, loadCheck);
			$loadTimer.start();
			
			/**	팝업 닫기 버튼	*/
			$main.popup.btn.addEventListener(MouseEvent.CLICK, popupClose);
			/**	인터넷 접속상태 체크없이 로드 시작	*/
			$main.stage.addEventListener(KeyboardEvent.KEY_DOWN, startLoadContent);
			
//			kioskLoad();
			
			/**	풀 스크린 모드	*/
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		private function loadCheck(e:TimerEvent):void
		{
			$sensor.ping();
		}
		
		private function receiveStatus(obj:Object):void
		{
			switch (obj.status)
			{
				case "online" :
//					$loadTimer.stop();
//					$loadTimer.removeEventListener(TimerEvent.TIMER, loadCheck);
//					$loadTimer = null;
//					
//					kioskLoad();
					/**	로드 된 컨텐츠가 없다면 로드	*/
					if($loadCheck == false)
					{
						kioskLoad();
					}
					if($main.popup.alpha != 0) TweenLite.to($main.popup, 0.5, {autoAlpha:0});
					break;
				case "offline" :
				case "Error" :
					netErrorPopup();
					/**	로드 중 에러 발생시 다시 로드	*/
					if($main.content.numChildren >= 1 && $loadCompleteCheck == false)
					{
						$ldr.cancel();
						for (var i:int = 0; i < $main.content.numChildren; i++) 
						{	$main.content.removeChildAt(i);	}
						$loadCheck = false;
					}
					break;
			}
		}
		
		/**	인터넷 접속 불량 시 팝업	*/
		private function netErrorPopup():void
		{
			TweenLite.to($main.popup, 0.5, {autoAlpha:1});
		}
		/**	팝업 닫기	*/
		private function popupClose(e:MouseEvent):void
		{
			TweenLite.to($main.popup, 0.5, {autoAlpha:0});
		}
		/**	인터넷 접속상태 체크없이 로드 시작	*/
		private function startLoadContent(e:KeyboardEvent):void
		{
			if(e.keyCode == 32 && $loadCheck == false)
			{
				/**	센서 오류시 제거 후 다시 적용	*/
				$sensor.destroy();
				$sensor = null;
				$sensor = new NetSenser("http://www.daum.net", receiveStatus);
				
				kioskLoad();
			}
		}
		
		private function kioskLoad():void
		{
			$loadCheck = true;
//			$sensor.destroy();
			
			/**	테스트 경로	*/
//			var path:String = "http://test.crm.piterahouse.com/CRM/swf/FTE_Kiosk_Season2.swf";
			/**	실 서버 경로	*/
			var path:String = "http://crm.piterahouse.com/CRM/swf/FTE_Kiosk_Season2.swf";
			$ldr = new SWFLoader(path, {container:$main.content, onProgress:loadProgress, onComplete:loadComplete, onError:loadError});
			var urlVars:URLVariables = new URLVariables;
			urlVars.rand = Math.random() * 10000;
			$ldr.request.data = urlVars;
			$ldr.load();
			trace("로드 시작__!!!");
		}
		
		private function loadProgress(e:LoaderEvent):void
		{
			var loadPercent:Number = e.target.bytesLoaded / e.target.bytesTotal;
			$txt.text = String(Math.round(loadPercent * 100)) + " %";
			$txt.x = this.stage.stageWidth/2 - $txt.width/2;
			$txt.y = this.stage.stageHeight/2 - $txt.height/2;
			
			trace("로딩중!!___: " + loadPercent);
		}
		
		private function loadError(e:LoaderEvent):void
		{
			trace("로드 에러_____!!!! " + e);
		}
		
		private function loadComplete(e:LoaderEvent):void
		{
			$loadCompleteCheck = true;
			$main.txt.removeChild($txt);
			trace($main.content.numChildren);
			trace(e.target.content.loaderInfo.applicationDomain);
		}
	}
}