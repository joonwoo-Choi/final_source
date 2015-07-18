package orpheus.text {
	/**
	 * @author kdh.
	 */
	import flash.events.EventDispatcher;	
	import flash.events.ProgressEvent;		import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextFormat;

	import orpheus.events.EmbedFontEvent;
	import orpheus.system.SecurityUtil;	

	public class EmbedFont extends EventDispatcher 
	{
		private var _url : String;
		private var _fontClass : String;
		private var _format : TextFormat;
		private var _fontName : String;

		public function EmbedFont(stage : *, url : String) {
			fnInit(stage, url);
		}

		public function fnInit(stage : *, url : String) : void {
			_fontClass = url.substr(url.lastIndexOf("/") + 1).substr(0, -4);
			_url = SecurityUtil.getPath(stage) + url;
			trace('_url: ' + (_url));

			var request : URLRequest = new URLRequest(_url);
			var loader : Loader = new Loader();
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fnComplete);			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, fnProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fnIOErroe);
		}
		
		private function fnProgress(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}

		public function fnComplete(e : Event) : void {
			var font:Class = e.target["applicationDomain"].getDefinition(_fontClass) as Class;
			Font.registerFont(font);
			
			_format = new TextFormat();
			
			var tempArr:Array = Font.enumerateFonts(false).reverse();	
			_format.font = _fontName = String(tempArr[0].fontName);
			
			
			dispatchEvent(new EmbedFontEvent(_format, EmbedFontEvent.EMBED_COMPLETE));
		}

		private function fnIOErroe(e : IOErrorEvent) : void {
			trace("폰트 파일을 찾을 수 없습니다");
			dispatchEvent(new EmbedFontEvent("Not find File", EmbedFontEvent.EMBED_ERROR));
		}				public function get format():TextFormat
		{
			return _format;
		}
		
		public function get fontName():String
		{
			return _fontName;
		}
	}
}




