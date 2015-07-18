package com.adqua.net 
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	/**
	 * 폰트로더 
	 * */
	public class FONTLoader
	{
		//private var loader:Loader;
		private var _fontClass:String;
		private var _format:TextFormat;
		
		private var url:String;
		/**	완료 후 수행 함수	*/
		private var fnc_finish:Function;
		
		private var loader:SWFLoader;
		
		/**
		 * 생성자
		 * @param $url	:: 폰트 swf위치
		 * @param $data	:: 로드완료후 수행 내용 등등... 데이터(fontName,fnc_finish)
		 * 
		 */
		public function FONTLoader($url:String,$data:Object = null) 
		{
			if($data == null) $data = new Object();
			_fontClass = ($data.fontName != null) ? $data.fontName : $url.substr( $url.lastIndexOf("/") + 1 ).substr( 0, -4 );
			fnc_finish = $data.finish;
			url = $url;
			var obj:Object = new Object();
			obj.onComplete = onComplete;
			
			//loader = new Loader();
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader = new SWFLoader(url,obj);
		}
		/**	로더 반환	*/
		//public function getLoader():Loader
		public function getLoader():SWFLoader
		{	return loader;	}
		/**	폰트 로드	*/
		public function load():void
		{	
			//loader.load(new URLRequest(url));	
			loader.load();
		}
		
		/**	
		 * 로드 완료	http://cafe.naver.com/javachobostudy.cafe?iframe_url=%2FMyCafeIntro.nhn%3Fclubid%3D10286641
		 * */
		//private function onComplete(e:Event):void 
		private function onComplete(e:LoaderEvent):void 
		{
			//var fontClass:Class = $evt.target.applicationDomain.getDefinition( _fontClass ) as Class;
			//var fontClass:Class = MovieClip(loader.rawContent).applicationDomain.getDefinition( _fontClass ) as Class;
			var fontClass:Class = loader.getClass(_fontClass);
//			trace("fontClass:____________" + fontClass);
//			Font.registerFont( fontClass );
			//Font.registerFont((e.target.applicationDomain.getDefinition(_fontClass) as Class));
			
			var emFontArr:Array = Font.enumerateFonts( false ).reverse();
			_format = new TextFormat();
//			_format.font = String( emFontArr[0].fontName );
			
			//dispatchEvent( new FONTLoaderEvent( FONTLoaderEvent.COMPLETE, { format:_format } ) );
			var embededfonts:Array = Font.enumerateFonts( false );
			for each( var embededfont:Font in embededfonts )
			{
				trace(  "fontName="+embededfont.fontName+                    
					",fontType="+embededfont.fontType+
					",fontStyle="+embededfont.fontStyle+
					",hasGlyphs = "+embededfont.hasGlyphs( "안녕하세요01aaa" ) );
			}
			
			if(fnc_finish != null) fnc_finish();
			//destroy();
		}
		
		/**	소멸자	*/
		public function destroy():void
		{
			loader.unload();
			loader.dispose();
			loader = null;
		}
	}//class
}//package