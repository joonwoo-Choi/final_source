package microsite.Main.special
{
	import adqua.movieclip.TestButton;
	import adqua.net.Debug;
	
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lumpens.utils.JavaScriptUtil;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import microsite.Main.MainModel;
	
	import orpheus.system.SecurityUtil;
	
	public class SpecialCon extends Sprite
	{
		public function SpecialCon()
		{
			super();
			$model = MainModel.getInstance();
			TweenPlugin.activate([AutoAlphaPlugin]);
			$model.addEventListener(GlobalEvent.SPECIAL_BTN_CLICK,showMyself);
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			visible = false;
			alpha = 0;
		}
		
		protected function showMyself(event:Event):void
		{
			for (var i:int = 0; i < $imgNum; i++) 
			{
				var imgCon:Sprite =$imgCoverBank[i];
				if(i==$model.activeSpecialNum){
					imgCon.visible = true;	
					$activeImgCon = imgCon;
				}else{
					imgCon.visible = false;				
				}
			}
			if($model.activeSpecialNum>3){
				$flvPlayerCon.visible = true;
			}else{
				$flvPlayerCon.visible = false;
			}
			TweenLite.to(this,.5,{autoAlpha:1});
			resizeContent($activeImgCon);
		}
		
		protected function onAdded(event:Event):void
		{
			makeBg();
			imgConSetting();	
			flvPlayerSetting();
			stage.addEventListener(Event.RESIZE,onResize);
			onResize();
		}
		
		private function flvPlayerSetting():void
		{
			$flvPlayerCon = new FlvPlayerSpecial(this);
			$flvPlayerCon.visible = false;
			addChild($flvPlayerCon);
			resizeContent($flvPlayerCon);
		}
		
		protected function onResize(event:Event=null):void
		{
			$bg.width = stage.stageWidth;
			$bg.height = stage.stageHeight;
			if($activeImgCon)resizeContent($activeImgCon);
			if($flvPlayerCon)resizeContent($flvPlayerCon);
		}
		
		private function resizeContent(con:Sprite):void
		{
			var targetW:int = (stage.stageWidth >=1280)?stage.stageWidth:1280;
			var targetH:int = (stage.stageHeight >=768)?stage.stageHeight:768;
			if(con){
				con.x = (targetW-(con.width-40))/2;
				con.y = (targetH-con.height)/2;
			}
		}
		
		private function makeBg():void
		{
			trace("makeBg");
			$bg = TestButton.btn(stage.stageWidth,stage.stageHeight,0x000000);
			$bg.alpha = .4;
			addChild($bg);
		}
		private var $imgNum:int = 4;
		private var $imgLoader:ImageLoader;
		private var $imgCoverBank:Array = [];
		private var $bg:Sprite;
		private var $model:MainModel;
		private var $downloadURL:URLRequest;
		private var $file:FileReference;
		private var $activeImgCon:Sprite;
		private var $flvPlayerCon:FlvPlayerSpecial;
		private function imgConSetting():void
		{
			for (var i:int = 0; i < $imgNum; i++) 
			{
				var imgCover:Sprite = new Sprite();
				imgCover.visible = false;
				addChild(imgCover);
				var url:String=SecurityUtil.getPath(root)+"img/special"+i+".png";
				
				$imgLoader = new ImageLoader(url, 
					{container:imgCover, 
						smoothing:true,
						onComplete:imgSetting,
						alpha:1
					});
				$imgCoverBank.push(imgCover);
				$imgLoader.vars = {myNum:i};
				$imgLoader.load();
			}
		}
		
		private function imgSetting(evt:LoaderEvent):void
		{
			var imgLoader:ImageLoader = ImageLoader(evt.target);
			var imgCover:Sprite = $imgCoverBank[int(imgLoader.vars.myNum)];
			
			var mcBtnClose:MCBtnClose = new MCBtnClose;
			mcBtnClose.buttonMode = true;
			mcBtnClose.addEventListener(MouseEvent.CLICK,onCloseClick);
			mcBtnClose.x = ContentDisplay(imgLoader.content).width;
			imgCover.addChild(mcBtnClose);
			
			var mcBtnDown:MCBtnDown = new MCBtnDown;
			mcBtnDown.myNum = int(imgLoader.vars.myNum);
			mcBtnDown.buttonMode = true;
			mcBtnDown.addEventListener(MouseEvent.CLICK,onDownClick);
			mcBtnDown.addEventListener(MouseEvent.ROLL_OVER,onOver);
			mcBtnDown.addEventListener(MouseEvent.ROLL_OUT,onOut);
			mcBtnDown.x = mcBtnClose.x;
			mcBtnDown.y = mcBtnClose.height;
			imgCover.addChild(mcBtnDown);
			
			resizeContent(imgCover);
		}
		
		protected function onOver(evt:MouseEvent):void
		{
			var btn:MCBtnDown = evt.currentTarget as MCBtnDown
			TweenLite.to(btn.over,.5,{alpha:1});
		}
		
		protected function onOut(evt:MouseEvent):void
		{
			var btn:MCBtnDown = evt.currentTarget as MCBtnDown
			TweenLite.to(btn.over,.5,{alpha:0});
			
		}
//		private var $fileName:Array =["specialCut0.jpg",];
		protected function onDownClick(evt:MouseEvent):void
		{
			JavaScriptUtil.call( "gTracking" , "printad_imgdown" );
			JavaScriptUtil.call( "realTracking" , 30 );
			var btn:MovieClip = evt.currentTarget as MovieClip;
			$downloadURL = new URLRequest();
			$downloadURL.url = SecurityUtil.getPath(root)+"img/sp_cut_0"+(int(btn.myNum)+1)+".jpg";
			$file = new FileReference();
			configureListeners($file);
			$file.download($downloadURL, "sp_cut_0"+(int(btn.myNum)+1)+".jpg");
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CANCEL, cancelHandler);
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(Event.SELECT, selectHandler);
		}
		
		private function cancelHandler(event:Event):void {
			trace("cancelHandler: " + event);
		}
		
		private function completeHandler(event:Event):void {
			trace("completeHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var file:FileReference = FileReference(event.target);
			trace("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function selectHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			trace("selectHandler: name=" + file.name + " URL=" + $downloadURL.url);
		}
		
		public function onCloseClick(event:MouseEvent=null):void
		{
			TweenLite.to(this,.5,{autoAlpha:0});
		}
	}
}