package orpheus.templete.moviePlayer.playerSet
{
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	
	public class LoadThumbImg extends AbsrtractMCCtrler
	{
		public function LoadThumbImg(mc:MoviePlayer)
		{
			super(mc);
		}
		public function loadThumbImg() {
			_model.fadSpd = 100;
			_con.ctrlerBtn.disableButtons();
			_con.loadLogo();
			_con.video_mc.thumbImg.bg.width=_con.StageWidth;
			_con.video_mc.thumbImg.bg.height=_con.StageHeight;
			_con.video_mc.thumbImg.btn.x=Math.round(_con.video_mc.thumbImg.bg.width/2);
			_con.video_mc.thumbImg.btn.y=Math.round(_con.video_mc.thumbImg.bg.height/2);
			_con.applyColor(_con.video_mc.thumbImg.bg, _model.bgColor,1);
			var loader:Loader = new Loader();
			configureListeners(loader.contentLoaderInfo);
			
			function configureListeners(dispatcher:IEventDispatcher) {
				dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				dispatcher.addEventListener(Event.INIT, onLoaderInit);
			}
			// Load int function for image
			
			function onLoaderInit(event:Event):void {
				var thBmp:Bitmap = new Bitmap();
				thBmp=Bitmap(event.target.content);
				thBmp.smoothing=true;
				var filterArray:Array = new Array();
				var filter:BitmapFilter = new BlurFilter(10,10,BitmapFilterQuality.HIGH);
				filterArray.push(filter);
				_con.video_mc.thumbImg.img.x=Math.round((_con.video_mc.thumbImg.bg.width-_con.video_mc.thumbImg.img.width)/2);
				_con.video_mc.thumbImg.img.y=Math.round((_con.video_mc.thumbImg.bg.height-_con.video_mc.thumbImg.img.height)/2);
				_con.fitToArea(_con.video_mc.thumbImg.img,_con.StageWidth,_con.StageHeight);
				_con.thumbInt(true);
			}
			function ioErrorHandler(event:Event):void {
				_con.thumbInt(false);
			}
			if (_model.thumbImgPath != "") {
				loader.load(new URLRequest(_model.thumbImgPath));
			} else {
				_con.thumbInt(false);
			}
			// Set Title text 
			if (_model.titleText !="") {
				var textMc = _model.embedFont?_con.video_mc.tTxt.txt:_con.video_mc.tTxt.txtNonEmb;
				textMc.wordWrap = false;
				textMc.x=10;
				textMc.y=5;
				textMc.autoSize = TextFieldAutoSize.LEFT;
				textMc.htmlText=_model.titleText;
				if (Math.round(textMc.width+20)>_con.StageWidth) {
					textMc.wordWrap = true;
					textMc.width=_con.StageWidth-20;
				}
				_con.applyColor(_con.video_mc.tTxt.bg, _model.textBgColor,_model.textBgAlpha);
				_con.video_mc.tTxt.bg.width=_con.video_mc.tTxt.sh.width=Math.round(textMc.width+20);
				_con.video_mc.tTxt.bg.height=_con.video_mc.tTxt.sh.height=Math.round(_con.video_mc.tTxt.y+textMc.height)+10;
				_con.video_mc.tTxt.x=-35;
				_con.video_mc.tTxt.y=_model.titleVspace;
			}
			_con.video_mc.tTxt.alpha=0;
			
			// Activate the player navigations
			
			_con.ctrlerBtn.fn(_con.video_mc.thumbImg);
			_con.video_mc.thumbImg.img.addChild(loader);
		}		
	}
}