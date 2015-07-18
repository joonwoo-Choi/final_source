package
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.adqua.util.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.smirnoff.events.SmirnoffEvents;
	import com.smirnoff.model.Model;
	import com.smirnoff.page.Notice;
	import com.smirnoff.page.Page_0;
	import com.smirnoff.page.Page_1;
	import com.smirnoff.page.Page_2;
	import com.smirnoff.page.Page_3;
	import com.smirnoff.page.Page_4;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[SWF(width="810", height="1116", frameRate="30", backgroundColor="#eeeeee")]
	
	public class Smirnoff_FB extends Sprite
	{
		
		private var _main:AssetMain;
		private var _model:Model;
		
		private var _notice:Notice;
		private var _page0:Page_0;
		private var _page1:Page_1;
		private var _page2:Page_2;
		private var _page3:Page_3;
		private var _page4:Page_4;
		
		public function Smirnoff_FB()
		{
			TweenPlugin.activate([ColorTransformPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			_main = new AssetMain();
			this.addChild(_main);
			
			_model = Model.getInstance();
			_model.defaultPath = SecurityUtil.getPath(this);
			_model.addEventListener(SmirnoffEvents.PAGE_CHANGED, footerColorChange);
			
//			_model.dataUrl = "http://www.smirnoffdistrict.com/";
//			_model.outputSndUrl = "http://www.smirnoffdistrict.com/uploads/mp3/";
			
			if(SecurityUtil.isWeb())
			{
				if(StringUtil.ereg(SecurityUtil.getPath(this), "test", "g"))
				{
					_model.dataUrl = "http://test.smirnoffdistrict.com/";
					_model.outputSndUrl = "http://test.smirnoffdistrict.com/uploads/mp3/";
				}
				else
				{
					_model.dataUrl = "http://www.smirnoffdistrict.com/";
					_model.outputSndUrl = "http://www.smirnoffdistrict.com/uploads/mp3/";
				}
			}
			
//			_main.page0.visible = false;
			_main.page1.visible = false;
			_main.page2.visible = false;
			_main.page3.visible = false;
			_main.page4.visible = false;
			
			fontLoad();
			sndListLoad();
			makeGlobalBtn();
		}
		
		protected function footerColorChange(e:SmirnoffEvents):void
		{
			if(int(e.value.pageNo) == 4) _main.footer.gotoAndStop(2);
			else _main.footer.gotoAndStop(1);
		}		
		
		private var _fontLdr:Loader;
		
		private function fontLoad():void
		{
			_fontLdr = new Loader();
			_fontLdr.load(new URLRequest(_model.defaultPath + "Nanum_Gothic.swf"));
			_fontLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, fontLoadComplete);
		}
		
		private function fontLoadComplete(e:Event):void
		{
			_fontLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE, fontLoadComplete);
			var N_Gothic:Class = _fontLdr.contentLoaderInfo.applicationDomain.getDefinition( "Nanum_Gothic" )  as  Class;
			Font.registerFont(N_Gothic);
			
			var allFonts:Array = Font.enumerateFonts();
			var cnt:uint = allFonts.length;
			for(var i:uint=0; i<cnt; i++){
				trace("load.swf Font List : " , allFonts[i].fontName)
			}
			var tFormat:TextFormat = new TextFormat("NanumGothic");
			_main.page3.titleTxt.txt.maxChars = 10;
			_main.page3.titleTxt.txt.embedFonts = true;
			_main.page3.titleTxt.txt.defaultTextFormat = tFormat;
			
			_main.page4.txt1.maxChars = 10;
			_main.page4.txt1.uName.embedFonts = true;
			_main.page4.txt1.uName.defaultTextFormat = tFormat;
			_main.page4.txt2.maxChars = 10;
			_main.page4.txt2.uTitle.embedFonts = true;
			_main.page4.txt2.uTitle.defaultTextFormat = tFormat;
		}
		
		private function sndListLoad():void
		{
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(new URLRequest(_model.defaultPath + "xml/sndList.xml"));
			urlLdr.addEventListener(Event.COMPLETE, sndListLoadComplete);
		}
		
		private function sndListLoadComplete(e:Event):void
		{
			_model.sndList = XML(e.target.data);
			_model.openLength = int(_model.sndList.original.cd.length());
			trace(_model.sndList, _model.openLength);
			
			_notice = new Notice(_main);
			_page0 = new Page_0(_main.page0);
			_page1 = new Page_1(_main.page1);
			_page2 = new Page_2(_main.page2);
			_page3 = new Page_3(_main.page3);
			_page4 = new Page_4(_main.page4);
			
			_model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:0}));
		}
		
		private function makeGlobalBtn():void
		{
			ButtonUtil.makeButton(_main.btnLogo, logoHandler);
			ButtonUtil.makeButton(_main.btnRank, rankHandler);
			
			_main.btnSecurity.buttonMode = true;
			_main.btnSecurity.addEventListener(MouseEvent.CLICK, securityHandler);
			_main.btnDrink.buttonMode = true;
			_main.btnDrink.addEventListener(MouseEvent.CLICK, drinkHandler);
		}
		
		private function logoHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK : 
					if(_model.isLogoClick == false || _main.page0.visible == true) return;
					_model.isLogoClick = false;
					_model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.GO_MAIN, {}));
					break;
			}
		}
		
		private function rankHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK : 
					/**	트래킹	*/
					JavaScriptUtil.call("googleSender", "District", "rankingbtn");
					
					JavaScriptUtil.call("mix.remixRanking");
					break;
			}
		}
		
		private function securityHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("https://www.facebook.com/SmirnoffKorea/app_1376702779221155"), "_blank");
		}
		
		private function drinkHandler(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.drinkiq.com"), "_blank");
		}
	}
}