package microsite.Main
{
	
	import adqua.event.XMLLoaderEvent;
	import adqua.movieclip.TestButton;
	import adqua.net.XMLLoader;
	import adqua.util.NetUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.AlignMode;
	import com.greensock.layout.AutoFitArea;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.display.ContentDisplay;
	import com.lumpens.utils.ButtonUtil;
	import com.sw.display.BaseIndex;
	import com.sw.utils.book.Book;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import microsite.Main.special.SpecialCon;
	
	import orpheus.event.LoadVarsEvent;
	import orpheus.net.LoadVars;
	import orpheus.system.SecurityUtil;
	import orpheus.templete.countDown.PiteraCount;
	
	import util.LoadingMC;
	
	[SWF(width="1280",height="800", backgroundColor = "#000000" ,frameRate="30")]
	
	public class SK_II_Heritage extends Sprite
	{
		private var $mainLoader:Loader;
		private var $progress:LoadingMC;
		
		public function SK_II_Heritage()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		protected function onAdd(e:Event):void
		{
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			stage.addEventListener(Event.RESIZE,onResize);
			
			$progress = new LoadingMC;
			addChild($progress);
			
			$mainLoader = new Loader();
			
			var urlRequest:URLRequest = new URLRequest(SecurityUtil.getPath(root)+"PurepiteraMain.swf");
			if(SecurityUtil.isWeb())urlRequest.data = NetUtil.objectToURLVariables(root.loaderInfo.parameters);			
			$mainLoader.load(urlRequest);
			$mainLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			$mainLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaded);
		}
		
		protected function onResize(event:Event):void
		{
			
		}
		
		protected function onProgress(e:ProgressEvent):void
		{
			var loaded:Number = e.target.bytesLoaded;
			var total:Number = e.target.bytesTotal;
			var percent:Number = Math.round( loaded / total * 100 );
			
			$progress.arcAngle(percent);			
		}
		
		protected function onLoaded(event:Event):void
		{
			removeChild($progress);
			addChild($mainLoader);
		}
	}
}