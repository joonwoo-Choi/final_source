package
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.smirnoff.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.setTimeout;
	
	[SWF(width="132", height="132", frameRate="30", backgroundColor="#eeeeee")]
	
	public class RankListPlayer extends Sprite
	{
		
		private var _main:AssetListPlayer;
		private var _model:Model = Model.getInstance();
		private var _snd:Sound;
		private var _sndCh:SoundChannel;
		private var _position:Number;
		private var _imgUrl:String;
		private var _sndUrl:String;
		
		private var _selected:Boolean = false;
		private var _firstChk:Boolean = true;
		private var _cdUrl:String;
		
		public function RankListPlayer()
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
			
			_main = new AssetListPlayer();
			this.addChild(_main);
			
			_model.defaultPath = SecurityUtil.getPath(this);
			if(root.loaderInfo.parameters.cdNum != null || root.loaderInfo.parameters.cdNum != undefined)
			{
				_cdUrl = _model.defaultPath + "img/listPlayer/cd" + String(int(root.loaderInfo.parameters.cdNum) - 1) + ".png";
			}
			else
			{
				_cdUrl = _model.defaultPath + "img/listPlayer/cd1.png"
			}
				
			if(root.loaderInfo.parameters.img != null || root.loaderInfo.parameters.img != undefined)
			{
				_imgUrl = root.loaderInfo.parameters.img;
				_sndUrl = root.loaderInfo.parameters.snd;
			}
			else
			{
				_imgUrl = _model.defaultPath + "img/uImg.jpg";
				_sndUrl = _model.defaultPath + "snd/cd_01/01_original.mp3";
			}
			
			cdImgLoad();
			initSnd();
			loadImg(_imgUrl);
			loadSnd(_sndUrl);
			makeBtn();
			
			if(ExternalInterface.available) ExternalInterface.addCallback("resetMusic", resetMusic);
		}
		
		private function cdImgLoad():void
		{
			var ldr:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			if(SecurityUtil.isWeb())
			{
				context.checkPolicyFile = true;
				context.securityDomain = SecurityDomain.currentDomain;
				context.applicationDomain = ApplicationDomain.currentDomain;
			}
			ldr.load(new URLRequest(_cdUrl), context);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, cdImgLoadComplete);
			_main.cd.addChild(ldr);
		}
		
		private function cdImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
		}
		
		private function resetMusic():void
		{
			if(_selected == true && _firstChk == true)
			{
				_firstChk = false;
//				loadSnd(_sndUrl);
//				sndToggle();
			}
			else if(_selected == true && _firstChk == false)
			{
				initSnd();
				_firstChk = true;
				_selected = false;
			}
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
			ldr.load(new URLRequest(url),context);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, userImgLoadComplete);
			_main.img.addChild(ldr);
		}
		
		private function userImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
			
			bmp.width = 60;
			bmp.height = 60;
			bmp.scaleX = bmp.scaleY = Math.max(bmp.scaleX, bmp.scaleY);
			bmp.x = int(60/2 - bmp.width/2);
			bmp.y = int(60/2 - bmp.height/2);
		}
		
		private function loadSnd(url:String):void
		{
			_snd = new Sound();
			_sndCh = new SoundChannel();
			_snd.load(new URLRequest(url));
		}
		
		private function makeBtn():void
		{
			ButtonUtil.makeButton(_main.btnToggle, btnToggleHandler);
		}
		
		private function btnToggleHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					sndToggle();
					break;
			}
		}
		
		private function sndToggle():void
		{
			if(_snd == null && _sndCh == null) loadSnd(_sndUrl);
			
			if(_selected == false && _firstChk == true)
			{
				_selected = true;
				JavaScriptUtil.call("stopMusic");
//				return;
			}
			
			if(_main.btnToggle.currentFrame == 1)
			{
				_main.btnToggle.gotoAndStop(2);
				_sndCh = _snd.play(_position);
				_sndCh.addEventListener(Event.SOUND_COMPLETE, endMusic);
				_main.addEventListener(Event.ENTER_FRAME, sndPlayProgress);
			}
			else
			{
				_main.btnToggle.gotoAndStop(1);
				_position = _sndCh.position;
				_sndCh.stop();
				_sndCh.removeEventListener(Event.SOUND_COMPLETE, endMusic);
				_main.removeEventListener(Event.ENTER_FRAME, sndPlayProgress);
			}
		}
		
		protected function endMusic(event:Event):void
		{
			_firstChk = true;
			_selected = false;
			initSnd();
		}
		
		private function sndPlayProgress(e:Event):void
		{
//			_main.playBar.seekBar.seekMask.scaleX = _sndCh.position / _snd.length;
		}
		
		private function initSnd(e:Event = null):void
		{
			_main.btnToggle.gotoAndStop(1);
			_position = 0;
			if(_snd != null && _sndCh != null)
			{
				_main.removeEventListener(Event.ENTER_FRAME, sndPlayProgress);
				_sndCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
				_sndCh.stop();
				if(_snd.isBuffering == true) _snd.close();
				_snd = null;
				_sndCh = null;
			}
		}
	}
}