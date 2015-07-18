package
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.adqua.util.StringUtil;
	import com.smirnoff.control.SndControl;
	import com.smirnoff.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	[SWF(width="398", height="224", frameRate="30", backgroundColor="#eeeeee")]
	
	public class PopupPlayer extends Sprite
	{
		
		private var _main:AssetPopupPlayer;
		private var _xml:XML;
		private var _sndControl:SndControl;
		private var _model:Model = Model.getInstance();
		private var _imgUrl:String;
		private var _sndUrl:String;
		private var _snd:Sound;
		private var _sndCh:SoundChannel;
		private var _cdUrl:String;
		
		public function PopupPlayer()
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
			
			_main = new AssetPopupPlayer();
			this.addChild(_main);
//			_main.x = 251;
//			_main.y = 251;
			
			_model.defaultPath = SecurityUtil.getPath(this);
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
			
//			if(root.loaderInfo.parameters.cdNum != null || root.loaderInfo.parameters.cdNum != undefined)
//			{
//				_cdUrl = _model.defaultPath + "img/popupPlayer/cd" + String(root.loaderInfo.parameters.cdNum) + ".png";
//			}
//			else
//			{
//				_cdUrl = _model.defaultPath + "img/popupPlayer/cd0.png"
//			}
//			cdImgLoad();
			
			if(root.loaderInfo.parameters.d != null || root.loaderInfo.parameters.d != undefined)
			{
				var vari:URLVariables = new URLVariables();
				vari.rand = Math.round(Math.random()*10000);
				vari.d = String(root.loaderInfo.parameters.d);
				
				var req:URLRequest = new URLRequest(String(_model.dataUrl + "process/GetEvtData.ashx"));
				req.data = vari;
				req.method =URLRequestMethod.GET;
				
				var urlLdr:URLLoader = new URLLoader();
				urlLdr.load(req);
				urlLdr.addEventListener(Event.COMPLETE, userDataLoadComplete);
			}
			else
			{
				_imgUrl = _model.defaultPath + "img/uImg.jpg";
				_sndUrl = _model.defaultPath + "snd/cd_01/01_original.mp3";
				loadImg(_imgUrl);
				cdImgLoad(_model.defaultPath + "img/popupPlayer/cd1.png");
				sndLoad();
			}
		}
		
		private function userDataLoadComplete(e:Event):void
		{
			_xml = XML(e.target.data);
			trace(_xml);
			_imgUrl = String(_xml.ProfileImg);
			_sndUrl = String(_xml.MusicFile);
			loadImg(_imgUrl);
			cdImgLoad(_model.defaultPath + "img/popupPlayer/cd" + String(uint(_xml.CdNum) - 1) + ".png");
			sndLoad();
		}
		
		private function loadImg(url:String):void
		{
			var ldr:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			if(SecurityUtil.isWeb())
			{
				context.checkPolicyFile = true;
				context.securityDomain = SecurityDomain.currentDomain;
				context.applicationDomain = ApplicationDomain.currentDomain;
			}
			ldr.load(new URLRequest(url), context);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, userImgLoadComplete);
			_main.img.addChild(ldr);
		}
		
		private function userImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			
			bmp.width = 77;
			bmp.height = 77;
			bmp.scaleX = bmp.scaleY = Math.max(bmp.scaleX, bmp.scaleY);
			bmp.x = int(77/2 - bmp.width/2);
			bmp.y = int(77/2 - bmp.height/2);
		}
		
		private function cdImgLoad(cdUrl:String):void
		{
//			JavaScriptUtil.alert(cdUrl);
			var ldr:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			if(SecurityUtil.isWeb())
			{
				context.checkPolicyFile = true;
				context.securityDomain = SecurityDomain.currentDomain;
				context.applicationDomain = ApplicationDomain.currentDomain;
			}
			ldr.load(new URLRequest(cdUrl), context);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, cdImgLoadComplete);
			_main.cd.addChild(ldr);
		}
		
		private function cdImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			
			bmp.x = int(-bmp.width/2);
			bmp.y = int(-bmp.height/2);
		}
		
		private function loadSnd(url:String):void
		{
			_snd = new Sound();
			_sndCh = new SoundChannel();
			_snd.load(new URLRequest(url));
			_sndCh = _snd.play();
			_main.addEventListener(Event.ENTER_FRAME, sndPlayProgress);
		}
		
		private function sndLoad():void
		{
			_model.sndUrl = _sndUrl;
			_sndControl = new SndControl(_main.playBar);
			_sndControl.initSnd();
			_sndControl.loadSnd();
			_sndControl.sndToggle();
			_sndControl.selectedCD(_main.cd);
		}
		
		private function sndPlayProgress(e:Event):void
		{
			_main.cd.rotation = 720 * (_sndCh.position / _snd.length);
		}
	}
}