package
{
	
	import com.adqua.control.MotionController;
	import com.adqua.display.Resize;
	import com.adqua.net.Debug;
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.proof.event.ModelEvent;
	import com.proof.microsite.flvPlayer.BackgroundFlvPlayer;
	import com.proof.model.Model;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	
	[SWF(width="1659", height="877", frameRate="30", backgroundColor="0x999999")]
	
	public class FTE_Back_Mov_random extends Sprite
	{
		
		private var $main:AssetBackMov;
		
		private var $model:Model;
		/**	리사이즈	*/
		private var $resize:Resize;
		
		private var $flvPlayer:BackgroundFlvPlayer;
		
		private var $sp:Sprite;
		
		private var $dot:dot;
		
		public function FTE_Back_Mov_random()
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
			
			$main = new AssetBackMov();
			this.addChild($main);
			
			$model = Model.getInstance();
			
			$resize = new Resize();
			
			$flvPlayer = new BackgroundFlvPlayer($main.mov);
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = SecurityUtil.getPath(this);		}
			else
			{		$model.defaulfPath = "";		};
			
			/**	파라미터 검사	*/
			if(root.loaderInfo.parameters.menuNum)
			{		$model.menuNum = root.loaderInfo.parameters.menuNum;		}
			
			$model.menuNum = 0;
			
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(new URLRequest($model.defaulfPath + "xml/back_mov_list.xml"));
			urlLdr.addEventListener(Event.COMPLETE, backMovListLoadComplete);
			
			$sp = new Sprite();
			$main.dot.addChild($sp);
			$dot = new dot();
			
			blindCheck();
			resizeHandler();
			$main.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			/**	메뉴 변경 콜백 함수	*/
			if(ExternalInterface.available) ExternalInterface.addCallback("menuChange", menuTypeCheck);
			/**	망점 보이기 or 숨기기	*/
			if(ExternalInterface.available) ExternalInterface.addCallback("dotVisible", dotVisible);
		}
		/**	영상 리스트 로드 완료	*/
		private function backMovListLoadComplete(e:Event):void
		{
			$model.backMovList = new XML(e.target.data);
			trace("영상 리스트 XML 로드 완료_____!!");
			
			$model.dispatchEvent(new ModelEvent(ModelEvent.PLAY_LIST_LOADED));
		}
		/**	메뉴 변경 콜백 실행	*/
		private function menuTypeCheck(menuNum:int):void
		{
			$model.menuNum = menuNum;
			blindCheck();
			$model.dispatchEvent(new ModelEvent(ModelEvent.MENU_CHANGE));
		}
		/**	망점 보이기 or 숨기기	*/
		private function dotVisible(isShow:String):void
		{
			if(isShow == "show")
			{		TweenLite.to($main.dot, 0.5, {alpha:1});		}
			else
			{		TweenLite.to($main.dot, 0.5, {alpha:0});		}
		}
		/**	블라인드 체크	*/
		private function blindCheck():void
		{
			if($model.menuNum == 0)
			{		TweenLite.to($main.blind, 0.5, {alpha:0});		}
			else
			{		TweenLite.to($main.blind, 0.5, {alpha:0.35});		}
		}
		
		private function resizeHandler(e:Event = null):void
		{
			$sp.graphics.clear();
			$sp.graphics.beginBitmapFill($dot);
			$sp.graphics.drawRect(0, 0, $main.stage.stageWidth, $main.stage.stageHeight);
			$sp.graphics.endFill();
			
			$main.blind.width = $main.stage.stageWidth;
			$main.blind.height = $main.stage.stageHeight;
		}
	}
}