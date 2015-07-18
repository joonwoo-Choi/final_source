package
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.pokemon.event.PokemonEvent;
	import com.pokemon.main.Banner;
	import com.pokemon.main.Main;
	import com.pokemon.main.Notice;
	import com.pokemon.model.Model;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	
	[SWF(width="1180", height="730", frameRate="30", backgroundColor="0xffffff")]
	
	public class Pokemon_Main extends Sprite
	{
		
		private var $main:AssetMain;
		
		private var $model:Model;
		
		private var $mainControl:Main;
		
		private var $banner:Banner;
		
		private var $notice:Notice;
		
		public function Pokemon_Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetMain();
			this.addChild($main);
			
			$mainControl = new Main($main.mainCon);
			$banner = new Banner($main.banner);
			$notice = new Notice($main.notice);
			
			$model = Model.getInstance();
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = "";		}
			else
			{		$model.defaulfPath = "http://samlipgf.adqua.co.kr";		};
			
			var xmlPath:String;
			/**	XML 경로	*/
			if(SecurityUtil.isWeb())
			{		xmlPath = $model.defaulfPath + "/pokemon/xml/mainList.ashx";		}
			else
			{		xmlPath = "http://samlipgf.adqua.co.kr/pokemon/xml/mainList.ashx";		};
			
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			
			var req:URLRequest = new URLRequest(xmlPath);
			req.data = vari;
			req.method =URLRequestMethod.POST;
			
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(req);
			urlLdr.addEventListener(Event.COMPLETE, xmlLoadComplete);
			
			/**	기본 경로 설정	*/
			var gnbUrl:String;
			if(SecurityUtil.isWeb())
			{		gnbUrl = SecurityUtil.getPath(this) + "Pokemon_GNB.swf";		}
			else
			{		gnbUrl = "Pokemon_GNB.swf";		};
			var ldr:Loader = new Loader();
			ldr.load(new URLRequest(gnbUrl));
			$main.gnbCon.addChild(ldr);
			
			/**	로고	*/
			$main.logo.buttonMode = true;
			$main.logo.addEventListener(MouseEvent.CLICK, logoHandler);
			
			/**	로컬 테스트용 XML	*/
//			System.useCodePage = true;
//			var urlLdr:URLLoader = new URLLoader();
//			urlLdr.load(new URLRequest("xml/pokemon.xml"));
//			urlLdr.addEventListener(Event.COMPLETE, xmlLoadComplete);
			
			stageResize();
			$main.stage.addEventListener(Event.RESIZE, stageResize);
		}
		
		protected function xmlLoadComplete(e:Event):void
		{
			$model.pokemonXml = new XML(e.target.data);
			
			$model.dispatchEvent(new PokemonEvent(PokemonEvent.POKEMON_XML_LOADED));
			
			ButtonUtil.makeButton($main.footer.btn, footerBtnHandler);
			trace($model.pokemonXml);
		}
		
		private function logoHandler(e:MouseEvent):void
		{
			JavaScriptUtil.call("home");
		}
		
		private function footerBtnHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to($main.footer.txt, 0.5, {tint:0xfe9203});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to($main.footer.txt, 0.5, {tint:null});
					break;
				case MouseEvent.CLICK :
					JavaScriptUtil.call("indi");
					break;
			}
		}
		
		private function stageResize(e:Event = null):void
		{
			$main.footer.bg.width = $main.stage.stageWidth;
			$main.bg.width = $main.stage.stageWidth;
		}
	}
}