package orpheus.templete.moviePlayer
{
	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.xml.XMLDocument;
	
	import orpheus.templete.moviePlayer.ctrler.CtlerVideoSet;
	import orpheus.templete.moviePlayer.ctrler.CtrlerBtn;
	import orpheus.templete.moviePlayer.ctrler.CtrlerSeekBar;
	import orpheus.templete.moviePlayer.ctrler.CtrlerVideoSetFlashVars;
	import orpheus.templete.moviePlayer.ctrler.CtrlerVideoSetXml;
	import orpheus.templete.moviePlayer.ctrler.CtrlerXMLData;
	import orpheus.templete.moviePlayer.playerSet.AutoHideSet;
	import orpheus.templete.moviePlayer.playerSet.BtnSet;
	import orpheus.templete.moviePlayer.playerSet.FullScreenSet;
	import orpheus.templete.moviePlayer.playerSet.LoadThumbImg;
	import orpheus.templete.moviePlayer.playerSet.ReflectionSet;
	import orpheus.templete.moviePlayer.playerSet.ReloadSkin;
	import orpheus.templete.moviePlayer.playerSet.ResizeSet;
	import orpheus.templete.moviePlayer.playerSet.SeekScr;
	import orpheus.templete.moviePlayer.playerSet.TFormat;

	public class MoviePlayer extends Sprite
	{
		public function MoviePlayer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,defaultSetting);
		}


		
		// Array that store the required navigations
		
		public var objsAll:Array=new Array("ply","sek","vol","txt","rez","ful","hdv","bri");		
		
		public var StageWidth:Number=0;
		public var StageHeight:Number=0;

		
		// set all required variable and set the vale from flashVars if available
		
		public var vidDisWid:Number=0;
		public var vidDisHig:Number=0;
		public var sekWid:Number=0;
		private var PATH = this;
		public var sprWid:Number=1;

		public var sekBtnYes:Boolean;

		public var sekPosVal:Number=0;		
		private function defaultSetting(event:Event):void
		{
			stage.scaleMode= StageScaleMode.NO_SCALE;
			stage.align= StageAlign.TOP_LEFT;
			
			_model = ModelPlayer.getInstance();
			_model.parameter = loaderInfo.parameters;
			
			_control = new CtlerVideoSet;
			_controlFlashVars = new CtrlerVideoSetFlashVars;
			_controlFlashVars.videoValueSetting();
			
			_resizeSet = new ResizeSet(this);
			_reflection = new ReflectionSet(this);
			_autoHide = new AutoHideSet(this);
			_seekBarCtrler = new CtrlerSeekBar(this);
			_seekScr = new SeekScr(this);
			_tformat = new TFormat(this);
			xMouse=stage.mouseX;
			yMouse=stage.mouseY;
			
			video_mc= new VideoMc;
			localVideoMCControl = new LocalVideoMCControl(this);
			
			ctrlerBtn = new CtrlerBtn(this);

			addChild(video_mc);
			
			if (_model.dataPath=="") {
				_control["setting"+_model.settingLI]();
			}
			
			if (_model.validate(loaderInfo.parameters.playerNavigations,"s")) {
				_model.objs=[];
				_model.objs=String(loaderInfo.parameters.playerNavigations).split(",");
			}	
			
			 video_mc.yTub.vidQul=_model.validate(loaderInfo.parameters.videoDefaultQuality,"s")?String(loaderInfo.parameters.videoDefaultQuality):"";
			 
			_model.vidQulLoc=  video_mc.yTub.vidQul;
			_model.vidSource=(_model.vidQulLoc=="hd720")?_model.pathArrHd[0]:_model.pathArr[0];			 
			_model.locVideo=(_model.vidSource.substring(_model.vidSource.length-3,_model.vidSource.length-4)!=".")?false:true;
			 
			 alpha = 0;
			 video_mc.thumbImg.alpha= video_mc.tTxt.alpha=0;
			 video_mc.vid.alpha= video_mc.btns.alpha= video_mc.desTxt.alpha=1;
			 
			 ExternalInterface.addCallback("loadVideo", chkNewVideo);
			 
			 TmrAutoHide = new Timer(300);
			 TmrAutoHide.addEventListener(TimerEvent.TIMER, autoHideFn);
			 TmrAutoHide.start();
			 
			 video_mc.stgBg.buttonMode=true;
			 video_mc.stgBg.mouseChildren=false;
			 video_mc.stgBg.addEventListener(MouseEvent.CLICK,  ctrlerBtn.Click);
			 
			 for (var g:Number=0; g<_model.objs.length; g++) {
				 ctrlerBtn.fn(video_mc.btns[_model.objs[g]]);
			 }
			 trace("aaaa");
			 addEventListener(Event.ENTER_FRAME, EnterFrame);
			 _model.xmlLoad.addEventListener(Event.COMPLETE, loadXmlDatas);
		}
		

		// Check this movieClip whether it load completely in html file by just check the stage size value
		
		private function EnterFrame(ev:Event) {
			if (Number(stage.stageWidth)>0) {
				
				removeEventListener(Event.ENTER_FRAME,EnterFrame);
				
				_model.rStgW=_model.validate(loaderInfo.parameters.videoWidth,"n")?Number(loaderInfo.parameters.videoWidth):_model.rStgW;
				
				if (_model.dataPath!="") {
					_model.xmlLoad.load(_model.url);
				} else {
					initAll();
					stage.addEventListener( Event.RESIZE, resizeHandler );
					stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenRedraw);
				}
			}
		}
		
		
		// load XML file
		
		private function loadXmlDatas(event:Event):void {
			_xmlCtrler = new CtrlerXMLData(this);
			_xmlCtrler.loadXmlDatas(event);
			initAll();
			stage.addEventListener( Event.RESIZE, resizeHandler );
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenRedraw);
		}
		
		//  init All function is used to load or redraw the player if the stage is resize
		
		private function initAll() {
			StageWidth=_model.rStgW<100?stage.stageWidth:_model.rStgW;
			StageHeight=_model.rStgH<100?(_model.autoHide?stage.stageHeight:(stage.stageHeight-_model.vidHig-(_model.vidBr*2)-(_model.vidVMrg*2))):_model.rStgH;
			StageHeight=_model.reflect && _model.rStgH<100?(StageHeight-_model.refDep-_model.refDis):StageHeight;
			
			if (_model.desText!="") {
				txtformat( video_mc.desTxt, _model.desText,StageWidth);
			} else {
				for (var k=0; k<_model.objs.length; k++) {
					if (_model.objs[k] == "txt") {
						_model.objs.splice(k, 1);
					}
				}
			}
			 video_mc.desTxt.mask= video_mc.txtMsk;
			 video_mc.desTxt.y=-Math.round( video_mc.desTxt.height+5);
			
			applyColor( video_mc.desTxt.bg, _model.textBgColor,_model.textBgAlpha);
			applyColor( video_mc.stgBg, _model.bgColor,1);
			applyColor( video_mc.stgBg, _model.bgColor,1);
			applyColor( video_mc.locVid.bg, _model.bgColor,1);
			applyColor( video_mc.yTub.bg, _model.bgColor,1);
			
			if (_model.locVideo) {
				 video_mc.yTub.visible=false;
				 video_mc.locVid.visible=true;
			} else {
				 video_mc.locVid.visible=false;
				 video_mc.yTub.visible=true;
			}
			setVidBtn();
			
			loadThumbImg();
			
			if (!_model.autoPlayVideo) {
				 video_mc.btns.ply.ico.gotoAndStop(2);
				 video_mc.thumbImg.btn.gotoAndStop(2);
			}
			if (_model.autoPlayVideo) {
				ctrlerBtn.loadNewVideo(_model.vidSource);
			}
			this.alpha=1;
		}
		
		// resizeHandler function is an event function for stage resize 
		
		private function resizeHandler(e:Event):void {
			StageWidth=_model.rStgW<100?stage.stageWidth:_model.rStgW;
			StageHeight=_model.rStgH<100?(_model.autoHide?stage.stageHeight:(stage.stageHeight-_model.vidHig-(_model.vidBr*2)-(_model.vidVMrg*2))):_model.rStgH;
			StageHeight=_model.reflect && _model.rStgH<100?(StageHeight-_model.refDep-_model.refDis):StageHeight;
			reLoadVidSkin();
		}
		
		// fullScreenRedraw function is an event function for stage resize 
		
		private function fullScreenRedraw(event:FullScreenEvent):void {
			_fullCtrl = new FullScreenSet(this);
			_fullCtrl.fullScreenRedraw(event);
		}
		
		// This function is used to init all the function to redraw the player
		
		public function reLoadVidSkin() {
			_reloadSkin = new ReloadSkin(this);
			_reloadSkin.reLoadVidSkin();
		}
		

		
		public function loadLogo() {
			var loader:Loader = new Loader();
			configureListeners(loader.contentLoaderInfo);
			
			function configureListeners(dispatcher:IEventDispatcher) {
				dispatcher.addEventListener(Event.INIT, onLoaderInit);
			}
			function onLoaderInit(event:Event):void {
				video_mc.logo.x=_model.logoXmargin>=0?_model.logoXmargin:StageWidth-video_mc.logo.width+_model.logoXmargin;
				video_mc.logo.y=_model.logoYmargin>=0?_model.logoYmargin:StageHeight-video_mc.logo.height+_model.logoYmargin;
				video_mc.logo.alp = 0;
				video_mc.logo.trg = 100;
				video_mc.logo.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
				video_mc.logo.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
			}
			if (_model.logoPath != "") {
				loader.load(new URLRequest(_model.logoPath));
				video_mc.logo.addChild(loader);
			}
		}
		
		// Load and resize the player front image
		
		private function loadThumbImg() {
			_loadThumbImg = new LoadThumbImg(this);
			_loadThumbImg.loadThumbImg();
		}
		
		
		// Front image fade In and Reflection setting function 
		
		public function thumbInt(ev) {
			if (!_model.autoPlayVideo && video_mc.thumbImg.alpha==0) {
				thumbFadeIn();
			}
			if (video_mc.thumbImg.refMc.numChildren>0) {
				video_mc.thumbImg.refMc.removeChild(video_mc.thumbImg.refMc.getChildAt(0));
			}
			if (_model.reflect) {
				if (_model.refVidOnly) {
					if (ev) {
						reflection(video_mc.thumbImg,_model.refDis,_model.refDep,_model.refAlp);
					} else {
						reflection(video_mc.locVid,_model.refDis,_model.refDep,_model.refAlp);
					}
					video_mc.thumbImg.refMc.addChild(bmp2);
				} else {
					PATH.removeEventListener(Event.ENTER_FRAME, RefEnterFrame);
					PATH.addEventListener(Event.ENTER_FRAME, RefEnterFrame);
					reflection(PATH,_model.refDis,_model.refDep,_model.refAlp);
				}
			}
		}
		
		// Front image fade in function
		
		private function thumbFadeIn() {
			video_mc.thumbImg.visible=true;
			video_mc.thumbImg.alp =video_mc.thumbImg.alpha*100;
			video_mc.thumbImg.trg = 100;
			video_mc.thumbImg.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
			video_mc.thumbImg.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
		}
		

		// Load new video function
		
		import flash.external.ExternalInterface;
		
		
		private function chkNewVideo(path) {
			for (var j=0; j<_model.pathArr.length; j++) {
				if (_model.pathArr[j] == path || _model.pathArrHd[j]==path) {
					if (_model.pathArr[j] == path) {
						video_mc.btns.hdv.ico.gotoAndStop(1);
					} else {
						video_mc.btns.hdv.ico.gotoAndStop(2);
					}
					_model.curPathNum = j;
					j=_model.pathArr.length;
				} else {
					_model.curPathNum =0;
				}
			}
			ctrlerBtn.loadNewVideo(path);
		}
		
		private var tt:Number=0;
		private function delaySec(e) {
			tt++;
			if (tt>10) {
				stage.removeEventListener( Event.ENTER_FRAME, delaySec );
				ctrlerBtn.loadNewVideo(_model.pathArr[_model.curPathNum]);
			}
			
		}
		
		// Next video play
		public function playNext() {
			tt=0;
			if (_model.curPathNum<_model.pathArr.length-1) {
				_model.vidEnd = true;
				_model.curPathNum++;
				stage.removeEventListener( Event.ENTER_FRAME, delaySec );
				stage.addEventListener( Event.ENTER_FRAME, delaySec );
			} else {
				_model.vidEnd = false;
				video_mc.btns.ply.ico.gotoAndStop(2);
				thumbFadeIn();
				video_mc.thumbImg.btn.gotoAndStop(3);
			}
		}
		

		
		// setting player navigation. This is the main function to create a player
		
		public function setVidBtn() { 
			_btnSet = new BtnSet(this);
			_btnSet.setVidBtn();
		}
		// function to draw a rounded rectangle  
		
		public function drawRoundedRectangle(mc,w,h,borderColor,borderSize,cornerRadius) {
			mc.shape = new Sprite();
			mc.shape.graphics.beginFill(borderColor);
			mc.shape.graphics.drawRoundRect(0, 0, w, h, cornerRadius);
			mc.shape.graphics.endFill();
			mc.addChild(mc.shape);
		}
		
		// Set the volume of the video of local / youtube
		
		public function volTraFn(intr:Number) {
			if (_model.locVideo) {
				var sndTra= new SoundTransform(intr);
				localVideoMCControl.NS.soundTransform= sndTra;
			} else {
				if (_model.vLoaded) {
					video_mc.yTub.player.setVolume(intr*100);
				}
			}
		}
		
		// seek bar stop if the use stop drag
		public function sekScrStp(event:MouseEvent) {
			if (_model.vLoaded) {
				_model.sekDrg = false;
				if (video_mc.btns.ply.ico.currentFrame == 1) {
					if (_model.locVideo) {
						localVideoMCControl.NS.resume();
					} else {
						video_mc.yTub.player.playVideo();
					}
				}
				if (video_mc.btns.sek.hitTestPoint(stage.mouseX, stage.mouseY, true) == false) {
					video_mc.btns.vidSekMc.vidPos.alp = video_mc.btns.vidSekMc.vidPos*100;
					video_mc.btns.vidSekMc.vidPos.trg =0;
					video_mc.btns.vidSekMc.vidPos.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
					video_mc.btns.vidSekMc.vidPos.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, ctrlerBtn.sekOvrMov);
				}
				stage.removeEventListener(MouseEvent.MOUSE_UP, sekScrStp);
			}
		}
		
		// set the seek bar position 

		public function sekEntFrm(ev:Event) {
			_seekBarCtrler.sekEntFrm(ev);
		}
		
		// Seek bar Mouse down function
		
		public function sekScr(event:MouseEvent) {
			_seekScr.sekScr(event);
		}		

		// Apply movieclip Color using the below function
		
		public function applyColor(obj, col, tra) {
			var newColorTransform:ColorTransform = obj.transform.colorTransform;
			newColorTransform.color = col;
			
			obj.transform.colorTransform = newColorTransform;
			obj.alpha=tra;
		}
		
		// The fitToArea is only use to resize the player cover image
		
		public function fitToArea(obj,wid,hig) {
			obj.scaleX=obj.scaleY=1;
			var xp:Number =video_mc.thumbImg.refMc.y;
			video_mc.thumbImg.refMc.y=-video_mc.thumbImg.refMc.height;
			var W:Number=obj.width;
			var H:Number=obj.height;
			var rw:Number = W/wid;
			var rh:Number = H/hig;
			
			if (rw<rh) {
				obj.width = Math.floor(W/rh);
				obj.height = Math.floor(H/rh);
			} else {
				obj.width = Math.floor(W/rw);
				obj.height = Math.floor(H/rw);
			}
			obj.x=Math.floor((wid-obj.width)/2);
			obj.y=Math.floor((hig-obj.height)/2);
			video_mc.thumbImg.refMc.y=0;
		}
		
		// Resize the video function
		
		public function resiz(obj, wid, hig, ResizeType) {
			_resizeSet.resiz(obj, wid, hig, ResizeType);
		}
		
		public function rezEntFrm(ev) {
			_resizeSet.rezEntFrm(ev);
		}
		
		// set Timer for autoHide and seek bar update
		
		public var TmrAutoHide:Timer;

		public var xMouse:Number;
		public var yMouse:Number;

		private var autAlp:Number=0;
		
		private function autoHideFn(e:TimerEvent):void {
			_autoHide.autoHideFn(e);
		}
		

		
		// Set Description Text
		public function txtformat(txtMc, txt,w) {
			_tformat.txtformat(txtMc,txt,w);
		}
		
		// Reflection function
		
		public var bmp2:*;
		public function reflection(mc,refDis,depth,alp) {
			_reflection.reflection(mc,refDis,depth,alp);
		}
		
		// Take snap shot
		
		public function takeSnapeShot() {
			for (var k=video_mc.refMc.numChildren-1; k>-1; k--) {
				video_mc.refMc.removeChildAt(k);
			}
			if (_model.refVidOnly) {
				reflection(video_mc.locVid,_model.refDis,_model.refDep,_model.refAlp);
			} else {
				reflection(this,_model.refDis,_model.refDep,_model.refAlp);
			}
		}
		
		// Enter frame for reflect
		
		public function RefEnterFrame(ev) {
			if (!_model.fulScreen && _model.reflect && _model.locVideo) {
				if (!_model.refVidOnly || (video_mc.btns.ply.ico.currentFrame==1 || _model.sekDrg)) {
					takeSnapeShot();
				} else {
					if (!_model.refVidOnly) {
						takeSnapeShot();
					}
				}
			}
		}

		
		// set the all buttons listner 
		
		
		public var video_mc:VideoMc;


		
		// pause Video

		private var _model:ModelPlayer;
		private var _control:CtlerVideoSet;
		public var localVideoMCControl:LocalVideoMCControl;
		private var _controlFlashVars:CtrlerVideoSetFlashVars;

		public var ctrlerBtn:CtrlerBtn;
		private var _fullCtrl:FullScreenSet;
		private var _reloadSkin:ReloadSkin;
		private var _loadThumbImg:LoadThumbImg;
		private var _btnSet:BtnSet;
		private var _autoHide:AutoHideSet;
		private var _resizeSet:ResizeSet;
		private var _reflection:ReflectionSet;
		private var _seekBarCtrler:CtrlerSeekBar;
		private var _xmlCtrler:CtrlerXMLData;
		private var _seekScr:SeekScr;
		private var _tformat:TFormat;

		private function unloadVideo() {
			if (_model.locVideo) {
				if (localVideoMCControl.NS != null) {
					localVideoMCControl.NS.pause();
					localVideoMCControl.NS.close();
				}
			} else {
				if (video_mc.yTub.player != null) {
					video_mc.yTub.player.pauseVideo();
					video_mc.yTub.player.destroy();
				}
			}
		}
		
	}
}