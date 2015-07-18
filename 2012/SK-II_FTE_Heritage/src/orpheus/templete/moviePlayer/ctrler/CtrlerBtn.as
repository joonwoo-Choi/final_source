package orpheus.templete.moviePlayer.ctrler
{
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.media.SoundTransform;

	public class CtrlerBtn extends Ctrler
	{
		public var video_mc:VideoMc;
		
		public function CtrlerBtn(moviePlayer:MoviePlayer)
		{
			_moviePlayer = moviePlayer;
			
			video_mc = moviePlayer.video_mc;
		}
		public function fn(mc) {
			mc.buttonMode=true;
			mc.mouseChildren=false;
			if (mc.name=="sek") {
				mc.addEventListener( MouseEvent.MOUSE_OVER, sekOvr);
			} else {
				mc.addEventListener(MouseEvent.MOUSE_OVER, mOver);
			}
			if (mc.name=="sek") {
				mc.addEventListener( MouseEvent.MOUSE_OUT, sekOut);
			} else {
				mc.addEventListener(MouseEvent.MOUSE_OUT,  mOut);
			}
			if (mc.name=="vol") {
				mc.addEventListener( MouseEvent.MOUSE_DOWN, volStrScr);
			}
			if (mc.name=="sek") {
				mc.addEventListener( MouseEvent.MOUSE_DOWN, _moviePlayer.sekScr);
			}
			if (mc.name!="sek") {
				mc.addEventListener(MouseEvent.MOUSE_DOWN,  mDown);
				mc.addEventListener(MouseEvent.MOUSE_UP,  mUp);
			}
			mc.addEventListener(MouseEvent.CLICK,  Click);
		}		
		// seek bar Roll over function
		
		private function sekOvr(event:MouseEvent) {
			if (_model.vLoaded) {
				sekScrPos();
				video_mc.stage.addEventListener( MouseEvent.MOUSE_MOVE, sekOvrMov);
				
				video_mc.btns.vidSekMc.vidPos.alp = video_mc.btns.vidSekMc.vidPos.alpha*100;
				video_mc.btns.vidSekMc.vidPos.trg = 100;
				video_mc.btns.vidSekMc.vidPos.removeEventListener( Event.ENTER_FRAME, fade );
				video_mc.btns.vidSekMc.vidPos.addEventListener( Event.ENTER_FRAME, fade );
				
				video_mc.vid.btn[(String(event.target.name))].alp = video_mc.vid.btn[(String(event.target.name))].alpha*100;
				video_mc.vid.btn[(String(event.target.name))].trg = _model.btnOvrTra*100;
				video_mc.vid.btn[String(event.target.name)].removeEventListener( Event.ENTER_FRAME, fade );
				video_mc.vid.btn[String(event.target.name)].addEventListener( Event.ENTER_FRAME, fade );
				
			}
		}		
		// set Timer position and value 
		
		public function sekScrPos() {
			var v:int =  ((video_mc.btns.vidSekMc.vidSek.mouseX<0||video_mc.btns.vidSekMc.vidSek.mouseX>100?(video_mc.btns.vidSekMc.vidSek.mouseX<0?0:100):video_mc.btns.vidSekMc.vidSek.mouseX))*video_mc.btns.vidSekMc.vidSek.scaleX;
			video_mc.btns.vidSekMc.vidPos.x=v>=video_mc.btns.vidSekMc.vidSek.width?video_mc.btns.vidSekMc.vidSek.width:Math.round(v);
			video_mc.btns.vidSekMc.vidPos.t = Math.round(video_mc.btns.vidSekMc.vidSek.mouseX<0||video_mc.btns.vidSekMc.vidSek.mouseX>100?(video_mc.btns.vidSekMc.vidSek.mouseX<0?0:100):video_mc.btns.vidSekMc.vidSek.mouseX);
			video_mc.btns.vidSekMc.vidPos.txt.x=Math.round(Number(video_mc.btns.vidSekMc.vidPos.t))>50?Math.round(-video_mc.btns.vidSekMc.vidPos.txt.width-3):3;
			video_mc.btns.vidSekMc.vidPos.txt.text=video_mc.locVid.objInfo||_model.vLoaded?fTime((video_mc.btns.vidSekMc.vidPos.t/100)*_model.vidTotDur):"";
		}		
		// Mouse over function for all Navigation
		
		private function mOver(event:MouseEvent) {
			if (event.target.name != "thumbImg" && video_mc.vid.btn[event.target.name].visible) {
				video_mc.vid.btn[(String(event.target.name))].alp = video_mc.vid.btn[(String(event.target.name))].alpha*100;
				video_mc.vid.btn[(String(event.target.name))].trg = _model.btnOvrTra*100;
				video_mc.vid.btn[String(event.target.name)].removeEventListener( Event.ENTER_FRAME, fade );
				video_mc.vid.btn[String(event.target.name)].addEventListener( Event.ENTER_FRAME, fade );
			}
			if (event.target.name == "thumbImg") {
				video_mc.thumbImg.btn.alp = video_mc.thumbImg.btn.alpha*100;
				video_mc.thumbImg.btn.trg = 0;
				video_mc.thumbImg.btn.removeEventListener( Event.ENTER_FRAME, fade );
				video_mc.thumbImg.btn.addEventListener( Event.ENTER_FRAME, fade );
			}
		}	
		// fade In/Out function
		
		private var _moviePlayer:MoviePlayer;
		public function fade(ev) {
			_model.hideDelayTim=0;
			_model.fadSpd +=(3-_model.fadSpd)/3;
			ev.target.alp +=(ev.target.trg - ev.target.alp )/Math.round(_model.fadSpd);
			ev.target.alpha=ev.target.alp/100;
			if (ev.target.alp<ev.target.trg+5 && ev.target.alp>ev.target.trg-5) {
				ev.target.alpha=ev.target.trg/100;
				if (ev.target.name == "thumbImg") {
					ev.target.visible=ev.target.trg==0?false:true;
					video_mc.thumbImg.img.visible=video_mc.thumbImg.refMc.visible=ev.target.trg==0?false:video_mc.thumbImg.img.visible;
					video_mc.thumbImg.bg.alpha=video_mc.thumbImg.img.visible?1:0;
					if (video_mc.tTxt.visible && !_model.autoPlayVideo) {
						titleTxtFadIn(true);
					} else {
						video_mc.tTxt.visible=false;
					}
				}
				ev.target.removeEventListener( Event.ENTER_FRAME, fade );
			}
		}	
		// Title text fade in function
		
		public function titleTxtFadIn(n) {
			if (_model.titleText !="") {
				_model.fadSpd = 100;
				video_mc.tTxt.sp=100;
				if (n) {
					video_mc.tTxt.visible=true;
					video_mc.tTxt.x= -55;
					video_mc.tTxt.trgX=0;
					
					video_mc.tTxt.trg = 100;
					video_mc.tTxt.alpha=0;
				} else {
					video_mc.tTxt.visible=false;
					video_mc.tTxt.trg = 0;
					video_mc.tTxt.trgX=-video_mc.tTxt.width/2;
				}
				video_mc.tTxt.alp = video_mc.tTxt.alpha*100;
				video_mc.tTxt.removeEventListener(Event.ENTER_FRAME, posnx);
				video_mc.tTxt.addEventListener(Event.ENTER_FRAME, posnx);
				video_mc.tTxt.removeEventListener( Event.ENTER_FRAME, fade );
				video_mc.tTxt.addEventListener( Event.ENTER_FRAME, fade );
			} else {
				video_mc.tTxt.visible=false;
			}
		}		
		// set x/y position function
		
		private function posnx(ev) {
			ev.target.sp +=(3-ev.target.sp)/4;
			ev.target.x +=(ev.target.trgX - ev.target.x )/Math.round(ev.target.sp);
			if (ev.target.x<ev.target.trgX+.5 && ev.target.x>ev.target.trgX-.5) {
				ev.target.x=ev.target.trgX;
				ev.target.removeEventListener( Event.ENTER_FRAME, posnx );
			}
		}		
		// Timer format
		
		public function fTime(t:int):String {
			var s:int = Math.round(t);
			var m:int = 0;
			if (s > 0) {
				while (s > 59) {
					m++;
					s -= 60;
				}
				var mm:String;
				mm = m<10?"0":"";
				var ss:String;
				ss = s<10?"0":"";
				return String(mm + m + ":" + ss + s);
			} else {
				return ("00:00");
			}
		}	
		
		// seek bar Roll Out function
		
		private function sekOut(event:MouseEvent) {
			if (_model.vLoaded) {
				if (!_model.sekDrg) {
					video_mc.btns.vidSekMc.vidPos.alp = video_mc.btns.vidSekMc.vidPos.alpha*100;
					video_mc.btns.vidSekMc.vidPos.trg = 0;
					video_mc.btns.vidSekMc.vidPos.removeEventListener( Event.ENTER_FRAME, fade );
					video_mc.btns.vidSekMc.vidPos.addEventListener( Event.ENTER_FRAME, fade );
				}
				video_mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, sekOvrMov);
				event.target.ico.alpha=.7;
				video_mc.vid.btn[(String(event.target.name))].alp = video_mc.vid.btn[(String(event.target.name))].alpha*100;
				video_mc.vid.btn[(String(event.target.name))].trg = 0;
				video_mc.vid.btn[String(event.target.name)].removeEventListener( Event.ENTER_FRAME, fade );
				video_mc.vid.btn[String(event.target.name)].addEventListener( Event.ENTER_FRAME, fade );
			}
		}	
		
		// seek bar Timer fade out, if the user mouse up outside the player
		
		public function sekOvrMov(event:MouseEvent) {
			if (video_mc.thumbImg.alpha>0 && _model.sekDrg) {
				thumbFadeOut();
			}
			sekScrPos();
		}
		// Front image fade Out function
		
		public function thumbFadeOut() {
			video_mc.thumbImg.alp =video_mc.thumbImg.alpha*100;
			video_mc.thumbImg.trg = 0;
			video_mc.thumbImg.removeEventListener( Event.ENTER_FRAME, fade );
			video_mc.thumbImg.addEventListener( Event.ENTER_FRAME, fade );
		}		
		
		
		
		// Mouse out function for all Navigation
		
		private function mOut(event:MouseEvent) {
			if (event.target.name != "thumbImg" && video_mc.vid.btn[event.target.name].visible) {
				event.target.ico.alpha=.7;
				video_mc.vid.btn[(String(event.target.name))].alp = video_mc.vid.btn[(String(event.target.name))].alpha*100;
				video_mc.vid.btn[(String(event.target.name))].trg = 0;
				video_mc.vid.btn[String(event.target.name)].removeEventListener( Event.ENTER_FRAME, fade );
				video_mc.vid.btn[String(event.target.name)].addEventListener( Event.ENTER_FRAME, fade );
			}
			if (event.target.name == "thumbImg") {
				video_mc.thumbImg.btn.alp = video_mc.thumbImg.btn.alpha*100;
				video_mc.thumbImg.btn.trg = 100;
				video_mc.thumbImg.btn.removeEventListener( Event.ENTER_FRAME, fade );
				video_mc.thumbImg.btn.addEventListener( Event.ENTER_FRAME, fade );
			}
		}		
		// Volume control for mouse down event
		
		private function volStrScr(event:MouseEvent) {
			_model.spd=100;
			if (video_mc.btns.volMc.volMc.mouseX<0) {
				_model.volDrg = false;
				_model.volval=(_model.volval==0)?_model.volPrePos:0;
			} else {
				_model.volDrg=true;
			}
			event.target.removeEventListener( Event.ENTER_FRAME, volStpSek );
			video_mc.btns.volMc.addEventListener( Event.ENTER_FRAME, volEv );
			video_mc.stage.addEventListener(MouseEvent.MOUSE_UP, volStpScr);
			
		}				
		// Volume control to stop the mouse drag event
		
		private function volStpSek(ev) {
			if (video_mc.btns.volMc.volMc.volMc.scaleX>_model.volval-.05 && video_mc.btns.volMc.volMc.volMc.scaleX<_model.volval+.05) {
				video_mc.btns.volMc.removeEventListener( Event.ENTER_FRAME, volEv );
				ev.target.removeEventListener( Event.ENTER_FRAME, volStpSek );
				video_mc.btns.volMc.volMc.volMc.scaleX=_model.volval;
				_moviePlayer.volTraFn(_model.volval);
			}
		}
		// Position the volume bar
		
		private function volEv(ev) {
			if (_model.volDrg) {
				_model.volval=(Math.round(video_mc.btns.volMc.volMc.mouseX<0||video_mc.btns.volMc.volMc.mouseX>100?(video_mc.btns.volMc.volMc.mouseX<0?0:100):video_mc.btns.volMc.volMc.mouseX))/100;
				_moviePlayer.volTraFn(_model.volval);
			}
			_model.spd +=(2-_model.spd)/2;
			video_mc.btns.volMc.volMc.volMc.scaleX+=(_model.volval-video_mc.btns.volMc.volMc.volMc.scaleX)/_model.spd;
		}	
		
		// Volume control for mouse up event
		
		private function volStpScr(event:MouseEvent) {
			_model.volDrg = false;
			video_mc.stage.removeEventListener(MouseEvent.MOUSE_UP, volStpScr);
			event.target.addEventListener( Event.ENTER_FRAME, volStpSek );
			_model.volPrePos = _model.volval>0?_model.volval:_model.volPrePos;
		}		
		
		
		// Mouse Down function for all Navigation
		
		private function mDown(event:MouseEvent) {
			if (event.target.name != "thumbImg" && video_mc.vid.btn[event.target.name].visible) {
				event.target.ico.alpha=1;
			}
		}
		
		// Mouse Up function for all Navigation
		
		function mUp(event:MouseEvent) {
			if (event.target.name != "thumbImg" && video_mc.vid.btn[event.target.name].visible) {
				event.target.ico.alpha=.7;
			}
			
		}
		
		// Button Click function for all Navigation
		
		public function Click(event:MouseEvent) {
			if (video_mc.vid.btn[event.target.name] || event.target.name == "stgBg") {
				
				// play/pause button coding
				
				if ((event.target.name == "ply" || event.target.name == "stgBg") ) {
					thumbFadeOut();
					titleTxtFadIn(false);
					if (!_model.autoPlayVideo) {
						video_mc.btns.ply.ico.gotoAndStop(1);
						enableButtons();
						loadNewVideo(_model.vidSource);
						video_mc.locVid.vidSta=undefined;
					} else {
						if (_model.vidCurDur>=_model.vidTotDur-.5) {
							video_mc.btns.ply.ico.gotoAndStop(1);
							if (_model.locVideo) {
								_moviePlayer.localVideoMCControl.NS.resume();
								_moviePlayer.localVideoMCControl.NS.seek(0);
							} else {
								video_mc.yTub.player.playVideo();
							}
						} else {
							if (video_mc.btns.ply.ico.currentFrame==1) {
								video_mc.btns.ply.ico.gotoAndStop(2);
								if (_model.locVideo) {
									_moviePlayer.localVideoMCControl.NS.pause();
								} else {
									video_mc.yTub.player.pauseVideo();
								}
							} else {
								video_mc.btns.ply.ico.gotoAndStop(1);
								if (_model.locVideo) {
									_moviePlayer.localVideoMCControl.NS.resume();
								} else {
									video_mc.yTub.player.playVideo();
								}
							}
						}
					}
					_model.autoPlayVideo=true;
				}
				// Brightness button coding
				
				if (event.target.name == "bri" && _model.vLoaded && video_mc.vid.btn[event.target.name].visible) {
					var myElements_array:Array=new Array();
					if (video_mc.btns.bri.ico.currentFrame==1) {
						video_mc.btns.bri.ico.gotoAndStop(2);
						myElements_array = [1.2, 0, 0, 0, 7,
							0, 1.2, 0, 0, 7,
							0, 0, 1.2, 0, 7,
							0, 0, 0, 1, 0];
						var myColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(myElements_array);
						if (_model.locVideo) {
							video_mc.locVid.filters = [myColorMatrix_filter];
						} else {
							video_mc.yTub.filters = [myColorMatrix_filter];
						}
					} else {
						video_mc.btns.bri.ico.gotoAndStop(1);
						if (_model.locVideo) {
							video_mc.locVid.filters = [];
						} else {
							video_mc.yTub.filters = [];
						}
					}
				}
				
				// Resize button coding
				
				if (event.target.name == "rez" && _model.vLoaded && video_mc.vid.btn[event.target.name].visible) {
					switch (_model.userRezMod ) {
						case "fittoarea" :
							if (_model.locVideo) {
								_moviePlayer.resiz(_moviePlayer.localVideoMCControl.vidDis, _moviePlayer.StageWidth, _moviePlayer.StageHeight, "none");
							} else {
								_moviePlayer.resiz(video_mc.yTub.player, _moviePlayer.StageWidth, _moviePlayer.StageHeight, "none");
							}
							break;
						case "none" :
							if (_model.locVideo) {
								_moviePlayer.resiz(_moviePlayer.localVideoMCControl.vidDis, _moviePlayer.StageWidth, _moviePlayer.StageHeight, "fittoarea");
							} else {
								_moviePlayer.resiz(video_mc.yTub.player, _moviePlayer.StageWidth, _moviePlayer.StageHeight, "fittoarea");
							}
							break;
					}
				}
				// HD button coding
				
				if (event.target.name == "hdv" && video_mc.vid.btn[event.target.name].visible) {
					if ( _model.vLoaded) {
						if (video_mc.btns.hdv.ico.currentFrame==2) {
							video_mc.btns.hdv.ico.gotoAndStop(1);
							if (_model.locVideo) {
								loadNewVideo(_model.pathArr[_model.curPathNum]);
							} else {
								video_mc.yTub.player.setPlaybackQuality(video_mc.yTub.vidQul);
							}
						} else {
							video_mc.btns.hdv.ico.gotoAndStop(2);
							if (_model.locVideo) {
								if (_model.validate(_model.pathArrHd[_model.curPathNum],"s")) {
									loadNewVideo(_model.pathArrHd[_model.curPathNum]);
								} else {
									video_mc.btns.hdv.ico.gotoAndStop(1);
								}
							} else {
								video_mc.yTub.player.setPlaybackQuality("hd720");
							}
						}
					}
				}
				// Full screen button coding
				
				if (event.target.name == "ful" && video_mc.vid.btn[event.target.name].visible) {
					if (video_mc.btns.ful.ico.currentFrame == 1) {
						video_mc.stage.displayState = StageDisplayState.FULL_SCREEN;
						video_mc.btns.ful.ico.gotoAndStop(2);
					} else {
						video_mc.stage.displayState = StageDisplayState.NORMAL;
						video_mc.btns.ful.ico.gotoAndStop(1);
					}
				}
				// Description Text coding
				
				if (event.target.name == "txt") {
					video_mc.desTxt.sp=50;
					video_mc.desTxt.trgY = video_mc.desTxt.y<0?0: -Math.round(video_mc.desTxt.height+4);
					video_mc.desTxt.removeEventListener( Event.ENTER_FRAME, posny );
					video_mc.desTxt.addEventListener( Event.ENTER_FRAME, posny );
				}
			}
			
			// Front image coding
			if (event.target.name == "thumbImg") {
				if (video_mc.thumbImg.visible) {
					if (_model.autoPlayVideo ) {
						_model.curPathNum=0;
						if (_model.pathArr.length > 1) {
							if (_model.locVideo) {
								if (video_mc.btns.hdv.ico.currentFrame==1) {
									loadNewVideo(_model.pathArr[_model.curPathNum]);
								} else {
									if (_model.validate(_model.pathArrHd[_model.curPathNum],"s")) {
										loadNewVideo(_model.pathArrHd[_model.curPathNum]);
									} else {
										video_mc.btns.hdv.ico.gotoAndStop(1);
										loadNewVideo(_model.pathArr[_model.curPathNum]);
									}
								}
							} else {
								loadNewVideo(_model.pathArr[_model.curPathNum]);
							}
						} else {
							loadNewVideo(_model.vidSource);
						}
					} else {
						video_mc.btns.ply.ico.gotoAndStop(1);
						loadNewVideo(_model.vidSource);
						video_mc.locVid.vidSta=undefined;
					}
					thumbFadeOut();
					titleTxtFadIn(false);
					_model.autoPlayVideo=true;
					video_mc.btns.ply.ico.gotoAndStop(1);
					
					enableButtons();
					
					video_mc.locVid.vidSta=undefined;
				}
			}
			if (_model.reflect && !_model.fulScreen && _model.locVideo && _model.startV) {
				_moviePlayer.takeSnapeShot();
			}
		}	
		private function posny(ev:Event):void {
			ev.target.sp +=(2-ev.target.sp)/3;
			ev.target.y +=(ev.target.trgY - ev.target.y )/ev.target.sp;
			if (ev.target.y<ev.target.trgY+.5 && ev.target.y>ev.target.trgY-.5) {
				ev.target.y=ev.target.trgY;
				ev.target.removeEventListener( Event.ENTER_FRAME, posny );
			}
		}			
		
		public function loadNewVideo(path) {
			video_mc.stage.removeEventListener( Event.ENTER_FRAME, _moviePlayer.rezEntFrm );
			
			_model.locVideo=(path.substring(path.length-3,path.length-4)=="." || path.substring(path.length-4,path.length-5)==".")?true:false;
			_model.vidSource= path;
			_model.rezStg=_model.autoPlayVideo=true;
			disableButtons();
			_moviePlayer.TmrAutoHide.stop();
			_model.vLoaded=_model.vidEnd=video_mc.yTub.vFirLod=false;
			video_mc.refMc.visible=_model.reflect?true:false;
			video_mc.yTub.visible=false;
			video_mc.locVid.visible = false;
			_moviePlayer.localVideoMCControl.vidDis.visible=false;
			_moviePlayer.localVideoMCControl.NS.close();
			
			vidButMod();
			video_mc.btns.rez.ico.gotoAndStop(1);
			_model.userRezMod="fittoarea";
			
			video_mc.btns.vidSekMc.staTxt.text = video_mc.btns.vidSekMc.endTxt.text = "00.00";
			
			_model.vidTotDur=0;
			
			if (video_mc.yTub.numChildren-1>0) {
				if (video_mc.yTub.player) {
					video_mc.yTub.player.destroy();
				}
				for (var k=video_mc.yTub.numChildren-1; k>0; k--) {
					video_mc.yTub.removeChildAt(k);
				}
			}
			if (video_mc.locVid.numChildren-1>0) {
				for (k=video_mc.locVid.numChildren-1; k>0; k--) {
					video_mc.locVid.removeChildAt(k);
				}
			}
			if (_model.locVideo) {
				video_mc.locVid.visible = true;
				_moviePlayer.localVideoMCControl.intVideo();
			} else {
				for (k=video_mc.refMc.numChildren-1; k>-1; k--) {
					video_mc.refMc.removeChildAt(k);
				}
				_moviePlayer.reflection(video_mc.yTub,_model.refDis,_model.refDep,_model.refAlp);
				video_mc.yTub.ytInt();
				video_mc.yTub.visible=true;
			}
			video_mc.btns.ply.ico.gotoAndStop(1);
			
			if (_model.startV && video_mc.thumbImg.alpha>0) {
				thumbFadeOut();
			}
		}
		
		
		
		private function vidButMod() {
			video_mc.locVid.mouseChildren= video_mc.yTub.mouseChildren= video_mc.refMc.mouseChildren=_model.locVideo?false:true;
			video_mc.locVid.mouseEnabled= video_mc.yTub.mouseEnabled= video_mc.refMc.mouseEnabled=_model.locVideo?false:true;
		}		
		// Disable the required navigation if the video is not load
		
		public function disableButtons() {
			video_mc.vid.btn.rez.visible= video_mc.vid.btn.hdv.visible= video_mc.vid.btn.bri.visible= video_mc.vid.btn.sha.visible=video_mc.vid.btn.sek.visible=false;
			video_mc.btns.rez.alpha= video_mc.btns.hdv.alpha= video_mc.btns.bri.alpha=video_mc.btns.sha.alpha=video_mc.btns.sek.alpha=video_mc.btns.vidSekMc.staTxt.alpha=video_mc.btns.vidSekMc.endTxt.alpha=.25;
			
			video_mc.btns.vidSekMc.vidSek.sek.scaleX= video_mc.btns.vidSekMc.vidSek.lod.scaleX=0;
		}
		// Enable the required navigation if the video is load
		
		public function enableButtons() {
			video_mc.vid.btn.rez.visible=video_mc.vid.btn.hdv.visible=video_mc.vid.btn.bri.visible=video_mc.vid.btn.sha.visible=video_mc.vid.btn.sek.visible=true;
			video_mc.btns.rez.alpha=video_mc.btns.hdv.alpha=video_mc.btns.bri.alpha=video_mc.btns.sha.alpha=video_mc.btns.sek.alpha=video_mc.btns.vidSekMc.staTxt.alpha=video_mc.btns.vidSekMc.endTxt.alpha=1;
		}		
	}
}