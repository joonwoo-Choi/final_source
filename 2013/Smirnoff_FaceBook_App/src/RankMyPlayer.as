package
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.smirnoff.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	[SWF(width="469", height="203", frameRate="30", backgroundColor="#eeeeee")]
	
	public class RankMyPlayer extends Sprite
	{
		
		private var _main:AssetMyPlayer;
		private var _model:Model = Model.getInstance();
		private var _snd:Sound;
		private var _sndCh:SoundChannel;
		private var _position:Number;
		private var _imgUrl:String;
		private var _sndUrl:String;
		private var _cdUrl:String;
		
		private var _selected:Boolean = false;
		private var _firstChk:Boolean = true;
		
		public function RankMyPlayer()
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
			
			_main = new AssetMyPlayer();
			this.addChild(_main);
			
			_model.defaultPath = SecurityUtil.getPath(this);
			if(root.loaderInfo.parameters.cdNum != null || root.loaderInfo.parameters.cdNum != undefined)
			{
				_cdUrl = _model.defaultPath + "img/myPlayer/cd" + String(int(root.loaderInfo.parameters.cdNum) - 1) + ".png";
			}
			else
			{
				_cdUrl = _model.defaultPath + "img/myPlayer/cd0.png"
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
			
			bmp.x = int(-bmp.width/2);
			bmp.y = int(-bmp.height/2);
		}
		
		private function resetMusic():void
		{
			if(_selected == true && _firstChk == true)
			{
				_firstChk = false;
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
			ldr.load(new URLRequest(url), context);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, userImgLoadComplete);
			_main.img.addChild(ldr);
//			_main.cd.img.addChild(ldr);
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
		
		private function loadSnd(url:String):void
		{
			_snd = new Sound();
			_sndCh = new SoundChannel();
			_snd.load(new URLRequest(url));
		}
		
		private function makeBtn():void
		{
			ButtonUtil.makeButton(_main.playBar.btnToggle, btnToggleHandler);
			
			_main.playBar.volCon.buttonMode = true;
			_main.playBar.volCon.addEventListener(MouseEvent.MOUSE_DOWN, volDown);
			
			_main.playBar.seekBar.buttonMode = true;
			_main.playBar.seekBar.addEventListener(MouseEvent.MOUSE_DOWN, seekBarDown);
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
			}
			
			if(_main.playBar.btnToggle.currentFrame == 1)
			{
				_main.playBar.btnToggle.gotoAndStop(2);
				_sndCh = _snd.play(_position);
				var volume:SoundTransform = new SoundTransform();
				volume.volume = _main.playBar.volCon.vol.scaleX;
				_sndCh.soundTransform = volume;
				_sndCh.addEventListener(Event.SOUND_COMPLETE, endMusic);
				_main.addEventListener(Event.ENTER_FRAME, sndPlayProgress);
			}
			else
			{
				_main.playBar.btnToggle.gotoAndStop(1);
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
		
		private function volDown(e:MouseEvent):void
		{
			_main.playBar.volCon.stage.addEventListener(MouseEvent.MOUSE_MOVE, soundDragHandler);
			_main.playBar.volCon.stage.addEventListener(MouseEvent.MOUSE_UP, soundMouseUpHandler);
			
			soundHandler();
		}
		
		private function soundDragHandler(e:MouseEvent):void
		{
			soundHandler();
		}
		
		private function soundMouseUpHandler(e:MouseEvent):void
		{
			_main.playBar.volCon.stage.removeEventListener(MouseEvent.MOUSE_MOVE, soundDragHandler);
			_main.playBar.volCon.stage.removeEventListener(MouseEvent.MOUSE_UP, soundMouseUpHandler);
		}
		
		private function soundHandler():void
		{
			_main.playBar.volCon.vol.width = _main.playBar.volCon.mouseX;
			var volume:SoundTransform = new SoundTransform();
			volume.volume = _main.playBar.volCon.vol.scaleX;
			if(volume.volume <= 0)
			{
				volume.volume = 0;
			}
			else if(volume.volume >= 1)
			{
				volume.volume = 1;
			}
			_sndCh.soundTransform = volume;
			trace(_sndCh.soundTransform.volume);
		}
		
		private function seekBarDown(e:MouseEvent):void
		{
			if(_snd == null || _sndCh == null) return;
			seekBarDragMove(_main.playBar.seekBar.mouseX);
			_main.playBar.seekBar.stage.addEventListener(MouseEvent.MOUSE_MOVE, seekBarMove);
			_main.playBar.seekBar.stage.addEventListener(MouseEvent.MOUSE_UP, seekBarMoveComplete);
			
			_sndCh.stop();
			_sndCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
			_main.removeEventListener(Event.ENTER_FRAME, sndPlayProgress);
		}
		
		private function seekBarMove(e:MouseEvent):void
		{
			seekBarDragMove(_main.playBar.seekBar.mouseX);
		}
		
		private function seekBarMoveComplete(e:MouseEvent):void
		{
			_main.playBar.seekBar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, seekBarMove);
			_main.playBar.seekBar.stage.removeEventListener(MouseEvent.MOUSE_UP, seekBarMoveComplete);
			
			if(_main.playBar.btnToggle.currentFrame == 2)
			{
				_sndCh = _snd.play(_position);
				var volume:SoundTransform = new SoundTransform();
				volume.volume = _main.playBar.volCon.vol.scaleX;
				_sndCh.soundTransform = volume;
				_sndCh.addEventListener(Event.SOUND_COMPLETE, initSnd);
				_main.addEventListener(Event.ENTER_FRAME, sndPlayProgress);
			}
			
			if(_main.playBar.seekBar.seekMask.scaleX == 1) initSnd();
		}
		
		private function seekBarDragMove(num:Number):void
		{
			var width:int = num - 6;
			if(num <= 0 ) width = 0;
			else if(num >= 156) width = 156;
			_main.playBar.seekBar.seekMask.width = width;
			var percent:Number = _main.playBar.seekBar.seekMask.scaleX;
			_main.playBar.seekBar.handle.x = int(16 + (140 * percent));
			_position = percent * _snd.length;
			trace(num, _main.playBar.seekBar.seekMask.width);
		}
		
		private function sndPlayProgress(e:Event):void
		{
			_main.playBar.seekBar.seekMask.scaleX = _sndCh.position / _snd.length;
			if(140 * _main.playBar.seekBar.seekMask.scaleX >= 0)
			{
				_main.playBar.seekBar.handle.x = 16 + (140 * _main.playBar.seekBar.seekMask.scaleX);
			}
			
			_main.cd.rotation = 720 * (_sndCh.position / _snd.length);
			trace(_main.cd.rotation);
		}
		
		private function initSnd(e:Event = null):void
		{
			_main.playBar.seekBar.handle.x = 16;
			_main.playBar.seekBar.seekMask.scaleX = 0;
			_main.playBar.btnToggle.gotoAndStop(1);
			_position = 0;
			if(_snd != null && _sndCh != null)
			{
				_main.removeEventListener(Event.ENTER_FRAME, sndPlayProgress);
				_sndCh.removeEventListener(Event.SOUND_COMPLETE, initSnd);
				var volume:SoundTransform = new SoundTransform();
				volume.volume = 1;
				_sndCh.soundTransform = volume;
				_main.playBar.volCon.vol.scaleX = 1
				_sndCh.stop();
				if(_snd.isBuffering == true) _snd.close();
				_snd = null;
				_sndCh = null;
				TweenLite.to(_main.cd, 2, {rotation:0, ease:Cubic.easeOut, onComplete:rotationComplete});
			}
		}
		
		private function rotationComplete():void
		{
			_main.cd.rotation = 0;
		}
	}
}