package
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.bh.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	[SWF(width="1280", height="720", frameRate="30", backgroundColor="0xffffff")]
	
	public class BH_Index extends Sprite
	{
		private var _assetIndex:AssetIndex;
		private var _model:Model;
		
		private var _mainLdr:Loader;
		private var _commonPath:String;
		private var _loadComplete:Boolean = false;
		private var _mainStart:Boolean = false;
		
		private var _idx:int;
		
		public function BH_Index()
		{
			Security.allowDomain('*');
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
			
			_model = Model.getInstance();
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb()) _commonPath = SecurityUtil.getPath(this);
			else _commonPath = "";
			_model.commonPath = _commonPath;
			
			var flashParams:Object = LoaderInfo(root.loaderInfo).parameters;
			if(flashParams.idx || flashParams.idx == ""){
				_idx = int(flashParams.idx);
//				JavaScriptUtil.alert("파라미터 받음 " + _idx);
			}
			
//			_idx = 2;
			initSetting();
			initEventListener();
		}
		
		private function initSetting():void
		{
			_assetIndex = new AssetIndex();
			this.addChild(_assetIndex);
			
//			_assetIndex.loaderCon.alpha = 0;
//			_assetIndex.loaderCon.visible = false;
			_assetIndex.loaderCon.loader.loaderMask.width = 0;
			
			_assetIndex.logo.buttonMode = true;
			_assetIndex.logo.addEventListener(MouseEvent.CLICK, basicStore);
			
			_mainLdr = new Loader();
			_mainLdr.visible = true;
			_assetIndex.mainCon.addChild(_mainLdr);
			_mainLdr.load(new URLRequest(_commonPath + "BH_Main.swf"));
//			_mainLdr.load(new URLRequest(_commonPath + "BH_Main_v14.swf"));
			_mainLdr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, mainLoadProgress);
			_mainLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, mainLoadComplete);
		}
		
		private function basicStore(e:MouseEvent):void
		{
			JavaScriptUtil.call("basichome");
		}
		
		private function initEventListener():void
		{
			resizeHandler();
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		
		private function mainLoadProgress(e:ProgressEvent):void
		{
			trace("메인로드 중 ===> " + int(100*(e.bytesLoaded/e.bytesTotal)) + "%");
			_assetIndex.loaderCon.loader.loaderMask.width = int((e.bytesLoaded/e.bytesTotal)*176);
		}
		
		private function mainLoadComplete(e:Event):void
		{
			_mainLdr.visible = true;
			_loadComplete = true;
			e.target.removeEventListener(ProgressEvent.PROGRESS, mainLoadProgress);
			e.target.removeEventListener(Event.COMPLETE, mainLoadComplete);
			
			TweenLite.to(_assetIndex.loaderCon, 0.75, {autoAlpha:0, onComplete:play});
			trace("메인로드 완료___!");
		}
		private function play():void
		{
			if(_idx > 0) _mainLdr.content["scrapMoviePlay"](_idx);
			else _mainLdr.content["mainContentStart"]();
		}
		
		private function resizeHandler(e:Event = null):void
		{
			_assetIndex.loaderCon.loader.x = int(stage.stageWidth/2 - _assetIndex.loaderCon.loader.width/2);
			_assetIndex.loaderCon.loader.y = int(stage.stageHeight/2 - _assetIndex.loaderCon.loader.height/2);
			_assetIndex.loaderCon.plane.width = stage.stageWidth;
			_assetIndex.loaderCon.plane.height = stage.stageHeight;
		}
	}
}