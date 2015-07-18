package orpheus.templete.moviePlayer
{
	
	
	import orpheus.templete.moviePlayer.ctrler.CtlerVideoSet;
	import orpheus.templete.moviePlayer.ctrler.CtrlerBtn;
	import orpheus.templete.moviePlayer.ctrler.CtrlerVideoSetFlashVars;
	import orpheus.templete.moviePlayer.ctrler.CtrlerVideoSetXml;
	import orpheus.util.Atracer;
	
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
	import flash.events.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
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
	import flash.ui.*;
	import flash.utils.*;
	import flash.xml.XMLDocument;

	public class MoviePlayer extends Sprite
	{
		public function MoviePlayer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,defaultSetting);
		}


		
		// Array that store the required navigations
		
		private var objsAll:Array=new Array("ply","sek","vol","txt","rez","ful","hdv","bri");		
		
		public var StageWidth:Number=0;
		public var StageHeight:Number=0;

		
		// set all required variable and set the vale from flashVars if available
		
		public var vidDisWid:Number=0;
		public var vidDisHig:Number=0;
		private var sekWid:Number=0;
		private var PATH = this;


		private var shadowDistance:Number=0;
		private var sprWid:Number=1;

		private var sekBtnYes:Boolean;

		
		private function defaultSetting(event:Event):void
		{
			stage.scaleMode= StageScaleMode.NO_SCALE;
			stage.align= StageAlign.TOP_LEFT;
			_model = ModelPlayer.getInstance();
			_model.parameter = loaderInfo.parameters;
			_control = new CtlerVideoSet;
			_controlFlashVars = new CtrlerVideoSetFlashVars;
			_controlFlashVars.videoValueSetting();
			
			xMouse=stage.mouseX;
			yMouse=stage.mouseY;
			
			video_mc= new VideoMc;
			localVideoMCControl = new LocalVideoMCControl(this);
			
			ctrlerBtn = new CtrlerBtn(this);

			addChild(video_mc);
			
			if (_model.dataPath=="") {
				Atracer.alert("_model.settingLI: ",_model.settingLI);
				_control["setting"+_model.settingLI]();
//				selectSkin(settingLI);
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
			//dataPath variable store the xml path
			
			
			// Setting all Player objects and movie clip
			
			 
			 
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
			Atracer.alert("loadXmlDatas");
			var xmlData:XMLDocument = new XMLDocument();
			xmlData.ignoreWhite = true;
			xmlData.parseXML(new XML(_model.xmlLoad.data).toXMLString());
			var datalist= xmlData.firstChild.attributes;
			var gallxml= xmlData.firstChild.childNodes;
			
			_controlXML = new CtrlerVideoSetXml;
			_controlXML.datalist = datalist;
			_controlXML.video_mc = video_mc;
			_controlXML.setting();

			for (var k=0; k<gallxml.length; k++) {
				if (String(gallxml[k].localName) == "videoTitle") {
					if (_model.validate(gallxml[k].firstChild,"s")) {
						 video_mc.tTxt.txt.htmlText=gallxml[k].firstChild;
						 _model.titleText= video_mc.tTxt.txt.text;
					}
				}
				if (String(gallxml[k].localName) == "videoDescription") {
					if (_model.validate(gallxml[k].firstChild,"s")) {
						 video_mc.tTxt.txt.htmlText=gallxml[k].firstChild;
						 _model.desText=  video_mc.tTxt.txt.text;
						
					}
				}
				 video_mc.tTxt.txt.text="";
			}
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
			if (event.fullScreen) {
				_model.fulScreen = true;
				_model.autoHide=true;
				 video_mc.btns.ful.ico.gotoAndStop(2);
				 video_mc.refMc.visible=false;
				StageWidth= video_mc.stgBg.width= video_mc.locVid.bg.width= video_mc.yTub.bg.width=stage.stageWidth;
				StageHeight= video_mc.stgBg.height= video_mc.locVid.bg.height= video_mc.yTub.bg.height=stage.stageHeight;
			} else {
				_model.fulScreen = false;
				if (_model.reflect && _model.startV) {
					 video_mc.refMc.visible=true;
				}
				_model.autoHide=_model.autoHideF;
				if (!_model.autoHideF) {
					 video_mc.vid.alp =  video_mc.vid.alpha*100;
					 video_mc.vid.trg = 100;
					 video_mc.vid.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
					 video_mc.vid.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
					
					 video_mc.btns.alp =  video_mc.btns.alpha*100;
					 video_mc.btns.trg = 100;
					 video_mc.btns.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
					 video_mc.btns.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
				}
				 video_mc.btns.ful.ico.gotoAndStop(1);
				
				StageWidth=_model.rStgW<100?stage.stageWidth:_model.rStgW;
				StageHeight=_model.rStgH<100?(_model.autoHide?stage.stageHeight:(stage.stageHeight-_model.vidHig-(_model.vidBr*2)-(_model.vidVMrg*2))):_model.rStgH;
				StageHeight=_model.reflect&& _model.rStgH<100?(StageHeight-_model.refDep-_model.refDis):StageHeight;
			}
			reLoadVidSkin();
		}
		
		// This function is used to init all the function to redraw the player
		
		private function reLoadVidSkin() {
			sekBtnYes=false;
			_model.rezStg=true;
			_model.btnSprTra=_model.validate(_model.btnSprCol,"s")?.25:0;
			 video_mc.stgBg.width= video_mc.locVid.bg.width= video_mc.yTub.bg.width= video_mc.thumbImg.bg.width=StageWidth;
			 video_mc.stgBg.height= video_mc.locVid.bg.height= video_mc.yTub.bg.height= video_mc.thumbImg.bg.height=StageHeight;
			
			//---------- player front image resize  
			 video_mc.thumbImg.scaleX= video_mc.thumbImg.scaleY= video_mc.thumbImg.img.scaleX= video_mc.thumbImg.img.scaleY=1;
			 video_mc.thumbImg.btn.x=Math.round( video_mc.thumbImg.bg.width/2);
			 video_mc.thumbImg.btn.y=Math.round( video_mc.thumbImg.bg.height/2);
			if ( video_mc.thumbImg.refMc.numChildren>0) {
				for (var k= video_mc.thumbImg.refMc.numChildren-1; k>-1; k--) {
					 video_mc.thumbImg.refMc.removeChild( video_mc.thumbImg.refMc.getChildAt(k));
				}
			}
			fitToArea( video_mc.thumbImg.img,StageWidth,StageHeight);
			if (_model.reflect && _model.refVidOnly) {
				reflection( video_mc.thumbImg,_model.refDis,_model.refDep,_model.refAlp);
				 video_mc.thumbImg.refMc.addChild(bmp2);
			}
			// start to create Description text 
			
			if (_model.desText!="") {
				txtformat( video_mc.desTxt, _model.desText,StageWidth);
			} else {
				for (k=0; k<_model.objs.length; k++) {
					if (_model.objs[k] == "txt") {
						_model.objs.splice(k, 1);
					}
				}
			}
			 video_mc.desTxt.trgY= video_mc.desTxt.y= video_mc.desTxt.y<0?-Math.round( video_mc.desTxt.height+5):0;
			
			// Remove the previous child if the player is redraw
			
			if ( video_mc.btnMsk.numChildren>0 ) {
				 video_mc.btnMsk.removeChild( video_mc.btnMsk.getChildAt(0));
				 video_mc.vid.bg.removeChild( video_mc.vid.bg.getChildAt(0));
				 video_mc.vid.sh1.removeChild( video_mc.vid.sh1.getChildAt(0));
				 video_mc.vid.sh2.removeChild( video_mc.vid.sh2.getChildAt(0));
				 video_mc.vid.sh3.removeChild( video_mc.vid.sh3.getChildAt(0));
				 video_mc.vid.msk.removeChild( video_mc.vid.msk.getChildAt(0));
				 video_mc.vid.br.removeChild( video_mc.vid.br.getChildAt(0));
				 video_mc.vid.brShd.removeChild( video_mc.vid.brShd.getChildAt(0));
				setVidBtn();
			}
			if (_model.vLoaded ||  video_mc.yTub.vFirLod) {
				if (_model.locVideo) {
					resiz( localVideoMCControl.vidDis, StageWidth, StageHeight, "undefined");
				} else {
					resiz( video_mc.yTub.player, StageWidth, StageHeight, "undefined");
				}
			}
			if (_model.reflect && _model.startV) {
				takeSnapeShot();
			}
		}
		

		
		private function loadLogo() {
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
			_model.fadSpd = 100;
			ctrlerBtn.disableButtons();
			loadLogo();
			video_mc.thumbImg.bg.width=StageWidth;
			video_mc.thumbImg.bg.height=StageHeight;
			video_mc.thumbImg.btn.x=Math.round(video_mc.thumbImg.bg.width/2);
			video_mc.thumbImg.btn.y=Math.round(video_mc.thumbImg.bg.height/2);
			applyColor(video_mc.thumbImg.bg, _model.bgColor,1);
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
				video_mc.thumbImg.img.x=Math.round((video_mc.thumbImg.bg.width-video_mc.thumbImg.img.width)/2);
				video_mc.thumbImg.img.y=Math.round((video_mc.thumbImg.bg.height-video_mc.thumbImg.img.height)/2);
				fitToArea(video_mc.thumbImg.img,StageWidth,StageHeight);
				thumbInt(true);
			}
			function ioErrorHandler(event:Event):void {
				thumbInt(false);
			}
			if (_model.thumbImgPath != "") {
				loader.load(new URLRequest(_model.thumbImgPath));
			} else {
				thumbInt(false);
			}
			// Set Title text 
			if (_model.titleText !="") {
				var textMc = _model.embedFont?video_mc.tTxt.txt:video_mc.tTxt.txtNonEmb;
				textMc.wordWrap = false;
				textMc.x=10;
				textMc.y=5;
				textMc.autoSize = TextFieldAutoSize.LEFT;
				textMc.htmlText=_model.titleText;
				if (Math.round(textMc.width+20)>StageWidth) {
					textMc.wordWrap = true;
					textMc.width=StageWidth-20;
				}
				applyColor(video_mc.tTxt.bg, _model.textBgColor,_model.textBgAlpha);
				video_mc.tTxt.bg.width=video_mc.tTxt.sh.width=Math.round(textMc.width+20);
				video_mc.tTxt.bg.height=video_mc.tTxt.sh.height=Math.round(video_mc.tTxt.y+textMc.height)+10;
				video_mc.tTxt.x=-35;
				video_mc.tTxt.y=_model.titleVspace;
			}
			video_mc.tTxt.alpha=0;
			
			// Activate the player navigations
			
			ctrlerBtn.fn(video_mc.thumbImg);
			video_mc.thumbImg.img.addChild(loader);
		}
		
		
		// Front image fade In and Reflection setting function 
		
		private function thumbInt(ev) {
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
				video_mc.thumbImg.btn.gotoAndStop(2);
			}
		}
		

		
		// setting player navigation. This is the main function to create a player
		
		private function setVidBtn() {
			
			video_mc.vid.btn.ply.x=video_mc.vid.btn.sha.x=video_mc.vid.btn.sek.x=video_mc.vid.btn.vol.x=video_mc.vid.btn.rez.x=video_mc.vid.btn.ful.x=video_mc.vid.btn.hdv.x=video_mc.vid.btn.bri.x=video_mc.vid.btn.txt.x=-245;
			video_mc.btns.ply.x=video_mc.btns.sha.x=video_mc.btns.sek.x=video_mc.btns.vol.x=video_mc.btns.rez.x=video_mc.btns.ful.x=video_mc.btns.hdv.x=video_mc.btns.bri.x=video_mc.btns.txt.x=-245;
			video_mc.vid.btn.s1.x=video_mc.vid.btn.s2.x=video_mc.vid.btn.s3.x=video_mc.vid.btn.s4.x=video_mc.vid.btn.s5.x=video_mc.vid.btn.s6.x=video_mc.vid.btn.s7.x=video_mc.vid.btn.s8.x=-245;
			
			_model.vidWid = _model.vidWidF;
			
			video_mc.logo.x=_model.logoXmargin>=0?_model.logoXmargin:StageWidth-video_mc.logo.width+_model.logoXmargin;
			video_mc.logo.y=_model.logoYmargin>=0?_model.logoYmargin:StageHeight-video_mc.logo.height+_model.logoYmargin;
			
			if (_model.fulScreen) {
				_model.vidFixSiz =(_model.vidWid+(_model.vidBr*2)+(_model.vidMrg*2)) >= StageWidth && _model.vidWid>0?false:_model.vidFixSizF;
			} else {
				_model.vidFixSiz =(_model.vidWid+(_model.vidBr*2)+(_model.vidMrg*2)) <= StageWidth && _model.vidWid>0?true:false;
			}
			
			for (f=0; f<objsAll.length; f++) {
				if (objsAll[f]!="sek" && objsAll[f]!="vol") {
					
					if (_model.icoSiz>.5) {
						video_mc.btns[objsAll[f]].setIco(true);
						video_mc.btns[objsAll[f]].ico.scaleX=video_mc.btns[objsAll[f]].ico.scaleY=_model.icoSiz;
					} else {
						video_mc.btns[objsAll[f]].setIco(false);
						video_mc.btns[objsAll[f]].ico.scaleX=video_mc.btns[objsAll[f]].ico.scaleY=_model.icoSiz*2;
					}
				}
			}
			
			
			video_mc.btnMsk.x=video_mc.btns.x=video_mc.vid.x=_model.vidMrg;
			var pos:Number=0;
			var noBtn:Number=_model.objs.length-1;
			var tem:Boolean=false;
			
			for (var f:Number=0; f<_model.objs.length; f++) {
				if (_model.objs[f]=="vol") {
					tem=true;
				}
				if (_model.objs[f]=="sek") {
					sekBtnYes=true;
				}
			}
			noBtn=tem?noBtn-1:noBtn;
			_model.volWid=tem?_model.volWid:0;
			
			
			if (_model.vidFixSiz) {
				sekWid = Math.round((_model.vidWid-(((_model.btnWid+sprWid)*noBtn)+sprWid+_model.volWid+(_model.vidBr+_model.vidMrg)*2)));
			} else {
				sekWid = Math.round(StageWidth-(((_model.btnWid+sprWid)*noBtn)+sprWid+_model.volWid+(_model.vidBr+_model.vidMrg)*2));
			}
			sekWid=sekWid<150?150:sekWid;
			sekWid=sekBtnYes?sekWid:50;
			
			for (f=0; f<_model.objs.length; f++) {
				
				applyColor(video_mc.vid.btn[_model.objs[f]], _model.btnOvrCol,0);
				applyColor(video_mc.vid.btn[_model.objs[f]].parent["s"+Number(f)], _model.btnSprCol,_model.btnSprTra);
				
				video_mc.vid.btn[_model.objs[f]].parent["s"+Number(f)].width=sprWid;
				pos=  f>0 ? pos+video_mc.vid.btn[_model.objs[f-1]].width+sprWid : pos;
				
				if (_model.objs[f]!="sek" && _model.objs[f]!="vol") {
					video_mc.vid.btn[_model.objs[f]].width=_model.btnWid;
					video_mc.vid.btn[_model.objs[f]].x=pos;
				}
				if (_model.objs[f]=="sek") {
					video_mc.vid.btn[_model.objs[f]].x=pos;
					video_mc.vid.btn[_model.objs[f]].width=sekWid;
					sekBtnYes = true;
				}
				if (_model.objs[f]=="vol") {
					video_mc.vid.btn[_model.objs[f]].x=pos;
					video_mc.vid.btn[_model.objs[f]].width=_model.volWid;
				}
				video_mc.vid.btn[_model.objs[f]].parent["s"+Number(f)].x=(video_mc.vid.btn[_model.objs[f]].x+video_mc.vid.btn[_model.objs[f]].width);
			}
			
			_model.vidWid=video_mc.vid.btn[_model.objs[_model.objs.length-1]].x+video_mc.vid.btn[_model.objs[_model.objs.length-1]].width;
			video_mc.vid.btn.height=_model.vidHig;
			
			// draw rounded rectangle for required player movieclip
			
			drawRoundedRectangle(video_mc.vid.bg,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			drawRoundedRectangle(video_mc.vid.sh1,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			drawRoundedRectangle(video_mc.vid.sh2,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			drawSkin2(video_mc.vid.sh3,_model.vidWid, _model.vidHig,_model.vidOvrLayCol,_model.vidBr,_model.vidCorRad);
			drawRoundedRectangle(video_mc.vid.msk,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			drawRoundedRectangle(video_mc.btnMsk,_model.vidWid, _model.vidHig,_model.vidCol,_model.vidBr,_model.vidCorRad);
			
			drawRoundedBorder(video_mc.vid.br,(_model.vidWid+_model.vidBr*2),(_model.vidHig+_model.vidBr*2),_model.vidBrCol,_model.vidBr,_model.vidCorRad);
			if (_model.vidBr>0) {
				drawRoundedBorder(video_mc.vid.brShd,(_model.vidWid+_model.vidBr*2),(_model.vidHig+_model.vidBr*2),_model.vidBrCol,_model.vidBr,_model.vidCorRad);
			} else {
				drawRoundedBorder(video_mc.vid.brShd,(_model.vidWid+_model.vidBr*2),(_model.vidHig+_model.vidBr*2),_model.vidBrCol,1,_model.vidCorRad);
			}
			
			video_mc.btns.mask = video_mc.btnMsk;
			
			video_mc.vid.s_.width=(_model.vidWid-30)>0?(_model.vidWid-30):10;
			video_mc.vid.s_.x=(_model.vidWid+(_model.vidBr*2)-video_mc.vid.s_.width)/2;
			video_mc.vid.s_.y=_model.vidHig+_model.vidBr-32;
			video_mc.vid.sh.width=(_model.vidWid-50)>0?(_model.vidWid-50):10;
			video_mc.vid.sh.x=(_model.vidWid+(_model.vidBr*2)-video_mc.vid.sh.width)/2;
			video_mc.vid.sh.y=_model.vidBr+7;
			video_mc.vid.sh1.x=video_mc.vid.sh2.x=video_mc.vid.sh3.x=video_mc.vid.bg.x=_model.vidBr;
			video_mc.vid.sh1.y=video_mc.vid.sh2.y=video_mc.vid.sh3.y=video_mc.vid.bg.y=_model.vidBr;
			
			video_mc.vid.msk.x=video_mc.vid.msk.y=video_mc.vid.btn.x=video_mc.vid.btn.y=_model.vidBr;
			
			// Choose player skin type
			
			if (_model.skinType == 0) {
				applyColor(video_mc.vid.s_, _model.vidOvrLayCol,(_model.vidOvrLayTra*.65));
				applyColor(video_mc.vid.sh, _model.vidOvrLayCol,(_model.vidOvrLayTra*.30));
				applyColor(video_mc.vid.sh1, _model.vidOvrLayCol,(_model.vidOvrLayTra*.4));
				applyColor(video_mc.vid.sh3, _model.vidCol,0);
				video_mc.vid.sh2.alpha=_model.vidOvrLayTra;
			} else {
				applyColor(video_mc.vid.s_, _model.vidOvrLayCol,0);
				applyColor(video_mc.vid.sh, _model.vidOvrLayCol,0);
				applyColor(video_mc.vid.sh1, _model.vidOvrLayCol,0);
				applyColor(video_mc.vid.sh3, _model.vidOvrLayCol,_model.vidOvrLayTra);
				video_mc.vid.sh2.alpha=0;
			}
			
			video_mc.vid.bg.alpha=_model.vidBgTra;
			video_mc.vid.br.alpha=_model.vidBrTra;
			
			// Seek button setting
			
			video_mc.btns.sek.btn.width =video_mc.btns.sek.ico.width= sekBtnYes?video_mc.vid.btn.sek.width:20;
			video_mc.btns.sek.btn.height = _model.vidHig;
			video_mc.btns.sek.x = video_mc.vid.btn.sek.x;
			video_mc.btns.sek.ico.height=_model.sekHig;
			video_mc.btns.sek.ico.x=0;
			video_mc.btns.sek.ico.y=18;
			
			video_mc.btns.vidSekMc.vidSek.width=50;
			video_mc.btns.vidSekMc.vidSek.width=_model.vidTimAlignB?video_mc.btns.sek.btn.width-20:video_mc.btns.sek.btn.width-80;
			video_mc.btns.vidSekMc.vidSek.height=video_mc.btns.sek.ico.height;
			video_mc.btns.vidSekMc.vidPos.alpha=0;
			video_mc.btns.vidSekMc.vidPos.bar.height=Math.round((_model.vidHig+_model.sekHig)/2);
			video_mc.btns.vidSekMc.vidPos.y=-Math.round((_model.vidHig-_model.sekHig)/2-3);
			video_mc.btns.vidSekMc.vidPos.txt.y=Math.round(video_mc.btns.vidSekMc.vidPos.bar.height-video_mc.btns.vidSekMc.vidPos.txt.height-_model.sekHig)/2;
			
			video_mc.btns.vidSekMc.x=_model.vidTimAlignB?video_mc.btns.sek.x+10:video_mc.btns.sek.x+40;
			video_mc.btns.vidSekMc.y=Math.round(_model.vidHig/2-_model.sekHig/2);
			video_mc.btns.vidSekMc.vidPos.txt.autoSize = TextFieldAutoSize.LEFT;
			video_mc.btns.vidSekMc.staTxt.autoSize = TextFieldAutoSize.LEFT;
			video_mc.btns.vidSekMc.endTxt.autoSize = TextFieldAutoSize.LEFT;
			video_mc.btns.vidSekMc.staTxt.x=_model.vidTimAlignB?-8:-35;
			video_mc.btns.vidSekMc.endTxt.x=_model.vidTimAlignB?Math.round(video_mc.btns.vidSekMc.vidSek.width-video_mc.btns.vidSekMc.endTxt.width+8):Math.round(video_mc.btns.vidSekMc.vidSek.width+4);
			video_mc.btns.vidSekMc.staTxt.y=video_mc.btns.vidSekMc.endTxt.y=_model.vidTimAlignB?Math.round(_model.vidHig/4+_model.sekHig/2-7):Math.round(-8+_model.sekHig/2);
			
			applyColor(video_mc.btns.vidSekMc.vidSek.sek, _model.vidSekBarCol,1);
			applyColor(video_mc.btns.vidSekMc.vidSek.lod, _model.icoCol,.2);
			applyColor(video_mc.btns.vidSekMc.vidSek.bg, _model.icoCol,.2);
			applyColor(video_mc.btns.vidSekMc.vidPos, _model.icoCol,0);
			applyColor(video_mc.btns.vidSekMc.staTxt, _model.icoCol,1);
			applyColor(video_mc.btns.vidSekMc.endTxt, _model.icoCol,1);
			applyColor(video_mc.btns.vidSekMc.vidPos, _model.icoCol,0);
			
			//Volume button setting
			
			video_mc.btns.vol.btn.width = video_mc.vid.btn.vol.width;
			video_mc.btns.vol.btn.height = _model.vidHig;
			video_mc.btns.vol.x = Math.round(video_mc.vid.btn.vol.x);
			if (_model.icoSiz>.5) {
				video_mc.btns.vol.setIco(true);
				video_mc.btns.vol.ico.scaleX=video_mc.btns.vol.ico.scaleY=_model.icoSiz;
			} else {
				video_mc.btns.vol.setIco(false);
				video_mc.btns.vol.ico.scaleX=video_mc.btns.vol.ico.scaleY=_model.icoSiz*2;
			}
			video_mc.btns.vol.ico.x=Math.round((video_mc.btns.vol.btn.width-(video_mc.btns.vol.ico.width))/2)-23;
			video_mc.btns.volMc.x=Math.round(video_mc.btns.vol.x+video_mc.btns.vol.ico.x+video_mc.btns.vol.ico.width+4);
			video_mc.btns.volMc.height=_model.sekHig>4?4:_model.sekHig;
			video_mc.btns.volMc.y=Math.round((_model.vidHig-video_mc.btns.volMc.height)/2);
			video_mc.btns.volMc.y=_model.sekHig>1?video_mc.btns.volMc.y-1:video_mc.btns.volMc.y;
			video_mc.btns.vol.ico.y=Math.round((_model.vidHig-video_mc.btns.vol.ico.height)/2);
			applyColor(video_mc.btns.volMc.volMc, _model.vidSekBarCol,1);
			applyColor(video_mc.btns.volMc.bg, _model.icoCol,.4);
			
			for (f=0; f<_model.objs.length; f++) {
				if (_model.objs[f]!="sek" && _model.objs[f]!="vol") {
					video_mc.btns[_model.objs[f]].x=video_mc.vid.btn[_model.objs[f]].x;
					video_mc.btns[_model.objs[f]].btn.width=_model.btnWid;
					video_mc.btns[_model.objs[f]].btn.height=_model.vidHig;
					video_mc.btns[_model.objs[f]].ico.x=Math.round((_model.btnWid-(video_mc.btns[_model.objs[f]].ico.width))/2);
					video_mc.btns[_model.objs[f]].ico.y=Math.round((_model.vidHig-(video_mc.btns[_model.objs[f]].ico.height))/2);
				}
				applyColor(video_mc.btns[_model.objs[f]].ico, _model.icoCol,.65);
			}
			
			video_mc.vid.x=_model.vidFixSiz?Math.round((StageWidth-video_mc.vid.br.width)/2):Math.round((sekBtnYes?video_mc.btnMsk.x:(StageWidth-video_mc.vid.br.width)/2));
			video_mc.vid.y=_model.autoHide?Math.round(StageHeight-_model.vidHig-_model.vidVMrg-_model.vidBr+_model.refDis):Math.round(StageHeight-_model.vidBr)+_model.vidVMrg;
			
			
			video_mc.btnMsk.x=video_mc.btns.x=video_mc.vid.x+_model.vidBr;
			video_mc.btnMsk.y=video_mc.btns.y=video_mc.vid.y+_model.vidBr;
			
			var filterArray:Array = new Array();
			var filter:DropShadowFilter = new DropShadowFilter(shadowDistance, 45, 0x000000, _model.shadowAlpha, 5, 5, 1, 3,false,true);
			filterArray.push(filter);
			video_mc.vid.brShd.filters = filterArray;
			
			video_mc.vid.alpha=video_mc.btns.alpha=_model.autoHideF?0:1;
			
			video_mc.stgBg.width=video_mc.locVid.bg.width=video_mc.yTub.bg.width=StageWidth;
			video_mc.stgBg.height=video_mc.locVid.bg.height=video_mc.yTub.bg.height=StageHeight;
			
			// set intial HD icon
			if (firLodVid) {
				if (_model.vidQulLoc == "hd720") {
					video_mc.btns.hdv.ico.gotoAndStop(2);
					if (_model.locVideo && !_model.validate(_model.pathArrHd[_model.curPathNum],"s")) {
						video_mc.btns.hdv.ico.gotoAndStop(1);
					}
				} else {
					video_mc.btns.hdv.ico.gotoAndStop(1);
				}
			}
			firLodVid = false;
		}
		private var firLodVid:Boolean=true;
		
		// function to draw a rounded rectangle  
		
		private function drawRoundedRectangle(mc,w,h,borderColor,borderSize,cornerRadius) {
			mc.shape = new Sprite();
			mc.shape.graphics.beginFill(borderColor);
			mc.shape.graphics.drawRoundRect(0, 0, w, h, cornerRadius);
			mc.shape.graphics.endFill();
			mc.addChild(mc.shape);
		}
		
		// function to draw a rounded border  
		
		private function drawRoundedBorder(mc,w,h,borderColor,borderSize,cornerRadius) {
			mc.shape = new Sprite();
			mc.shape.graphics.beginFill(borderColor);
			mc.shape.graphics.drawRoundRect(borderSize, borderSize,w-borderSize*2, h-borderSize*2, cornerRadius);
			mc.shape.graphics.drawRoundRect(0, 0, w, h, cornerRadius);
			mc.shape.graphics.endFill();
			mc.addChild(mc.shape);
		}
		
		// draw skin type two
		
		private function drawSkin2(mc,w,h,borderColor,borderSize,cornerRadius) {
			var matr:Matrix = new Matrix();
			matr.createGradientBox(100, 100, 0, 0, 0);
			matr.rotate((Math.PI/180)*90);
			mc.shape = new Sprite();
			mc.shape.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, 100], [0x00, 0xFF], matr, SpreadMethod.PAD);
			mc.shape.graphics.drawRoundRect(0, 0, w, h, cornerRadius);
			mc.shape.graphics.endFill();
			mc.addChild(mc.shape);
		}
		
		// Seek bar coding
		
		private var sekPosVal:Number=0;

		

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
		
		private var sDr:Number=-1;
		private function sekEntFrm(ev) {
			if (_model.sekDrg) {
				TmrAutoHide.stop();
				if (_model.vidEnd) {
					_model.vidEnd=false;
					video_mc.btns.ply.ico.gotoAndStop(1);
				}
				sekPosVal=(Math.round(video_mc.btns.vidSekMc.vidSek.mouseX<0||video_mc.btns.vidSekMc.vidSek.mouseX>100?(video_mc.btns.vidSekMc.vidSek.mouseX<0?0:100):video_mc.btns.vidSekMc.vidSek.mouseX))/100;
				if (sDr != sekPosVal && _model.vLoaded) {
					sDr = sekPosVal;
					if (_model.locVideo) {
						localVideoMCControl.NS.seek(Math.floor(sekPosVal*_model.vidTotDur));
					} else {
						video_mc.yTub.player.seekTo(Math.floor(sekPosVal*_model.vidTotDur));
					}
				}
				ctrlerBtn.sekScrPos();
			} else {
				sDr =-1;
				TmrAutoHide.start();
				
				if (video_mc.btns.vidSekMc.vidSek.sek.scaleX>sekPosVal-.05 && video_mc.btns.vidSekMc.vidSek.sek.scaleX<sekPosVal+.05) {
					video_mc.btns.vidSekMc.removeEventListener( Event.ENTER_FRAME, sekEntFrm );
					video_mc.btns.vidSekMc.vidSek.sek.scaleX=sekPosVal;
				}
			}
			_model.spd +=(2-_model.spd)/2;
			video_mc.btns.vidSekMc.vidSek.sek.scaleX+=(sekPosVal-video_mc.btns.vidSekMc.vidSek.sek.scaleX)/_model.spd;
			
		}
		// Seek bar Mouse down function
		
		public function sekScr(event:MouseEvent) {
			trace("sekScr");
			if (_model.vLoaded) {
				trace("aaa%%%%%%%%%%%%%%%");
				if (video_mc.thumbImg.alpha>0) {
					ctrlerBtn.thumbFadeOut();
					ctrlerBtn.titleTxtFadIn(false);
				}
				trace("aaa############");
				_model.spd=200;
				trace("_model: ",_model);
				trace(_model.locVideo);
				if (_model.locVideo) {
					trace("localVideoMCControl: ",localVideoMCControl)
					trace("localVideoMCControl.NS: ",localVideoMCControl.NS);
					
					localVideoMCControl.NS.pause();
				} else {
					video_mc.yTub.player.pauseVideo();
				}
				video_mc.btns.vidSekMc.addEventListener( Event.ENTER_FRAME, sekEntFrm );
				stage.addEventListener(MouseEvent.MOUSE_UP, sekScrStp);
				
				video_mc.btns.vidSekMc.vidPos.alp = video_mc.btns.vidSekMc.vidPos.alpha*100;
				video_mc.btns.vidSekMc.vidPos.trg =100;
				video_mc.btns.vidSekMc.vidPos.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
				video_mc.btns.vidSekMc.vidPos.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
				
				_model.sekDrg=true;
				event.target.ico.alpha=1;
				
				video_mc.vid.btn[(String(event.target.name))].alp = video_mc.vid.btn[(String(event.target.name))].alpha*100;
				video_mc.vid.btn[(String(event.target.name))].trg = _model.btnOvrTra*100;
				video_mc.vid.btn[String(event.target.name)].removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
				video_mc.vid.btn[String(event.target.name)].addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
			}
		}		

		// Apply movieclip Color using the below function
		
		private function applyColor(obj, col, tra) {
			var newColorTransform:ColorTransform = obj.transform.colorTransform;
			newColorTransform.color = col;
			
			obj.transform.colorTransform = newColorTransform;
			obj.alpha=tra;
		}
		
		// Resize the object using below function
		
		private var W:Number;
		private var H:Number;
		private var rw:Number;
		private var rh:Number;
		private var curNum:Number=0;
		private var objW:Number;
		private var objH:Number;

		
		// The fitToArea is only use to resize the player cover image
		
		private function fitToArea(obj,wid,hig) {
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
			
			stage.removeEventListener( Event.ENTER_FRAME, rezEntFrm );
			var vW:Number=0;
			var vH:Number=0;
			var vX:Number=0;
			var vY:Number=0;
			
			_model.userRezMod=ResizeType!="undefined"?ResizeType:_model.userRezMod;
			W = vidDisWid;
			H = vidDisHig;
			rw = W/wid;
			rh = H/hig;
			
			if (_model.userRezMod == "none") {
				if (StageWidth>=vidDisWid && StageHeight>=vidDisHig) {
					vW=vidDisWid;
					vH=vidDisHig;
					vX=(StageWidth-vidDisWid)/2;
					vY=(StageHeight-vidDisHig)/2;
					video_mc.btns.rez.ico.gotoAndStop(1);
				} else {
					_model.userRezMod = "fittoarea";
				}
			}
			if (_model.userRezMod == "fittoarea") {
				if (rw<rh) {
					objW = W/rh;
					objH = H/rh;
				} else {
					objW = W/rw;
					objH = H/rw;
				}
				video_mc.btns.rez.ico.gotoAndStop(4);
				vW=objW;
				vH=objH;
				vX=(StageWidth-objW)/2;
				vY=(StageHeight-objH)/2;
			}
			if (Math.round(wid) != Math.round(W) || Math.round(hig) != Math.round(H) || _model.rezStg ) {
				if (!_model.rezStg) {
					rSpd=40;
					rObj=obj;
					rObjW=vW;
					rObjH=vH;
					rObjX=vX;
					rObjY=vY;
					YrObjW=_model.locVideo?localVideoMCControl.vidDis.width:video_mc.yTub.player.width;
					YrObjH=_model.locVideo?localVideoMCControl.vidDis.height:video_mc.yTub.player.height;
					stage.addEventListener( Event.ENTER_FRAME, rezEntFrm );
				} else {
					if (_model.locVideo) {
						obj.width= vW;
						obj.height= vH;
					} else {
						video_mc.yTub.player.setSize(vW,vH);
					}
					obj.x= vX;
					obj.y= vY;
				}
			} else {
				obj.x= vX;
				obj.y= vY;
				video_mc.btns.rez.ico.gotoAndStop(4);
			}
			_model.rezStg = false;
		}
		
		// Video resize Animation
		
		private var rObj:*;
		private var rObjW :Number=0;
		private var rObjH :Number=0;
		private var YrObjW :Number=0;
		private var YrObjH :Number=0;
		
		private var rObjX :Number=0;
		private var rObjY :Number=0;
		private var rSpd:Number=0;
		
		public function rezEntFrm(ev) {
			rSpd+=(2-rSpd)/3;
			if (rObj.width<rObjW+5 && rObj.width>rObjW-5 && rObj.height<rObjH+5 && rObj.height>rObjH-5 && rObj.x<rObjX+5 && rObj.x>rObjX-5 && rObj.y<rObjY+5 && rObj.y>rObjY-5) {
				if (_model.locVideo) {
					rObj.width=rObjW;
					rObj.height=rObjH;
				} else {
					video_mc.yTub.player.setSize(rObjW,rObjH);
				}
				rObj.x=rObjX;
				rObj.y=rObjY;
				if (_model.reflect && !_model.fulScreen && _model.locVideo) {
					takeSnapeShot();
				}
				stage.removeEventListener( Event.ENTER_FRAME, rezEntFrm );
			} else {
				YrObjW+=Math.round((rObjW-Math.round(YrObjW))/rSpd);
				YrObjH+=Math.round((rObjH-Math.round(YrObjH))/rSpd);
				if (_model.locVideo) {
					rObj.width=YrObjW;
					rObj.height=YrObjH;
				} else {
					video_mc.yTub.player.setSize(YrObjW,YrObjH);
				}
				rObj.x+=Math.round((rObjX-Math.round(rObj.x))/rSpd);
				rObj.y+=Math.round((rObjY-Math.round(rObj.y))/rSpd);
			}
			if (_model.reflect && !_model.fulScreen && _model.locVideo) {
				takeSnapeShot();
			}
		}
		
		// set Timer for autoHide and seek bar update
		
		public var TmrAutoHide:Timer;

		private var xMouse:Number;
		private var yMouse:Number;

		private var autAlp:Number=0;
		
		private var byteLod:Number=0;
		private var byteTot:Number=0;
		
		private function autoHideFn(e:TimerEvent):void {
			if (_model.vLoaded) {
				if (_model.locVideo) {
					byteLod=localVideoMCControl.NS.bytesLoaded;
					byteTot=localVideoMCControl.NS.bytesTotal;
					_model.vidCurDur = localVideoMCControl.NS.time;
				} else {
					byteLod=video_mc.yTub.player.getVideoBytesLoaded();
					byteTot=video_mc.yTub.player.getVideoBytesTotal();
					_model.vidCurDur=video_mc.yTub.player.getCurrentTime();
					
				}
				if ((byteLod!=byteTot || video_mc.btns.vidSekMc.vidSek.lod.scaleX!=1)) {
					video_mc.btns.vidSekMc.vidSek.lod.scaleX = (byteLod/byteTot);
				}
				if (_model.vidCurDur>_model.vidTotDur) {
					video_mc.btns.vidSekMc.staTxt.text=ctrlerBtn.fTime(_model.vidTotDur);
				} else {
					video_mc.btns.vidSekMc.staTxt.text=ctrlerBtn.fTime(_model.vidCurDur);
				}
				video_mc.btns.vidSekMc.vidSek.sek.scaleX=sekPosVal=_model.startV?(_model.vidCurDur/_model.vidTotDur)>1?1:(_model.vidCurDur/_model.vidTotDur):0;
			}
			if (_model.autoHide) {
				if (video_mc.stgBg.hitTestPoint(stage.mouseX, stage.mouseY, true) && ((xMouse !=stage.mouseX || yMouse !=stage.mouseY) || video_mc.btns.hitTestPoint(stage.mouseX, stage.mouseY, true))) {
					xMouse =stage.mouseX;
					yMouse =stage.mouseY;
					_model.hideDelayTim=0;
					if (video_mc.vid.alpha!=1) {
						video_mc.vid.alp = video_mc.vid.alpha*100;
						video_mc.vid.trg = 100;
						video_mc.vid.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
						video_mc.vid.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
						
						video_mc.btns.alp = video_mc.btns.alpha*100;
						video_mc.btns.trg = 100;
						video_mc.btns.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
						video_mc.btns.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
					}
				}
				if (_model.hideDelayTim==4) {
					if (video_mc.vid.alpha!=0) {
						video_mc.vid.alp = video_mc.vid.alpha*100;
						video_mc.vid.trg = 0;
						video_mc.vid.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
						video_mc.vid.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
						
						video_mc.btns.alp = video_mc.btns.alpha*100;
						video_mc.btns.trg = 0;
						video_mc.btns.removeEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
						video_mc.btns.addEventListener( Event.ENTER_FRAME, ctrlerBtn.fade );
					}
				}
				_model.hideDelayTim=_model.hideDelayTim<3?_model.hideDelayTim+1:4;
			}
		}
		

		
		// Set Description Text
		private function txtformat(txtMc, txt,w) {
			var textMc:*;
			video_mc.desTxt.bg.height=video_mc.desTxt.sh.height=0;
			textMc=_model.embedFont?txtMc.txt:txtMc.txtNonEmb;
			var myFmt:TextFormat = new TextFormat();
			myFmt.leftMargin = 5;
			myFmt.rightMargin = 5;
			textMc.y=4;
			textMc.width = w;
			textMc.wordWrap = true;
			textMc.autoSize = TextFieldAutoSize.LEFT;
			textMc.htmlText = txt;
			textMc.setTextFormat(myFmt);
			video_mc.desTxt.bg.width=video_mc.desTxt.sh.width=w;
			video_mc.desTxt.bg.height=video_mc.desTxt.sh.height=Math.round(video_mc.desTxt.height+5);
			video_mc.txtMsk.width=video_mc.desTxt.bg.width;
			video_mc.txtMsk.height=video_mc.desTxt.bg.height+5;
		}
		
		// Reflection function
		
		private var bmp2:*;
		public function reflection(mc,refDis,depth,alp) {
			var bmp = snapShot(mc,0,StageHeight-depth,StageWidth,depth);
			video_mc.refMc.addChild(bmp);
			// flip horizontal
			bmp.rotation = 180;
			var matrix:Matrix = bmp.transform.matrix;
			matrix.a=-1*matrix.a;
			matrix.tx=bmp.x-bmp.width;
			bmp.transform.matrix=matrix;
			
			// draw gradient mask
			var rect:Shape=new Shape();
			video_mc.refMc.addChild(rect);
			var mat:Matrix;
			var colors:Array;
			var alphas:Array;
			var ratios:Array;
			mat=new Matrix();
			colors=[0x0,0x0];
			alphas=[1,0];
			ratios = [0x00, 0xFF];
			mat.createGradientBox(StageWidth,depth,(90 * Math.PI / 180));
			rect.graphics.lineStyle();
			rect.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
			rect.graphics.drawRect(0,0,StageWidth,depth);
			rect.graphics.endFill();
			rect.alpha=alp;
			
			//set Mask
			bmp.x=rect.x=0;
			bmp.y=(StageHeight+depth+refDis);
			rect.y=StageHeight;
			bmp.cacheAsBitmap=rect.cacheAsBitmap=true;
			bmp.mask=rect;
			
			bmp2 = snapShot(video_mc.refMc,0,StageHeight,StageWidth,depth);
			video_mc.refMc.addChild(bmp2);
			bmp2.y=StageHeight;
			
			video_mc.refMc.removeChild(rect);
			video_mc.refMc.removeChild(bmp);
		}
		
		private function snapShot(mc,xP,yP,w,h) {
			var m : Matrix = new Matrix ( );
			m.translate( xP ,-yP);
			var bmpData:BitmapData=new BitmapData(w,h,true,0x00000000);
			bmpData.draw(mc,m,null,null,null,true);
			var bmp:Bitmap=new Bitmap(bmpData);
			return bmp;
			
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
		private var _controlXML:CtrlerVideoSetXml;
		public var ctrlerBtn:CtrlerBtn;

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