package contents.movie
{
	import contents.guerilla.BaseGuerilla;
	import contents.guerilla.GuerillaSeason1;
	import contents.guerilla.GuerillaSeason2;
	import contents.guerilla.GuerillaSeason2Complete;
	import contents.guerilla.GuerillaSeason3;
	import contents.guerilla.GuerillaSeason3Complete;
	import contents.guerilla.GuerillaSeason4;
	import contents.guerilla.GuerillaSeason4Complete;
	import contents.guerilla.GuerillaSeason4ListView;
	
	import event.MovieEvent;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.media.SoundTransform;
	
	import net.ConLoader;
	
	import util.Clock;

	/**		
	 *	SK2_Hershys :: 시즌 영상
	 */
	public class SeasonTime extends BaseMovie
	{
		/**	보드용 내용	*/
		private var interSp2:Sprite;
		private var interSp3:Sprite;
		private var interSp4:Sprite;
		
		private var bitData2:BitmapData;
		private var bitData3:BitmapData;
		private var bitData4:BitmapData;
		
		/**	이벤트 버튼	*/
		private var evtBtn:MovieClip;
		/**	이벤트 내용 클래스	*/
		private var guerilla:BaseGuerilla;
		
		/**	시즌 영상 위치	*/
		private var moviePos:int;
		/**	재방송 플레이 인지여부	*/
		private var bReview:Boolean;
		
		/**	생성자	*/
		public function SeasonTime(data:Object=null)
		{
			//trace("시즌 영상 플레이");
			
			super(data);
			
			init();
		}
		/**	초기화	*/
		override protected function init():void
		{
			loadPath = MovieEvent.SEASON_PATH;
			//loadAry = [Asset.getIns().season[0]];
			
			if(_data.season == null)
			{	//생방송 영상
				bReview = false;
				//초기 인사 내용 랜덤 수행
				loadAry = [Asset.getIns().season[0]];
				//loadAry = [Asset.getIns().season[0][0]];
				//시간 로드
				Clock.getIns().getSeasonDay(setDate);
			}
			else
			{	//일정 시즌 영상 플레이 (재방송)
				bReview = true;
				Global.getIns().bMovReview = true;	//영상 내용 재방송
				
				var num:int = _data.season;
				var ary:Array = [];
				
				ary[3] = num;
				ary[1] = Math.floor((num-1)/4);
				ary[0] = Clock.getIns().getHTimeStr()[ary[1]];
				
				num = Math.floor((num-1)%4)+1
				var numAry:Array = ["",1,5,10,14];
				ary[2] = numAry[num];
				
				//초기 인사 내용 일정 내용으로 고정
				loadAry = [Asset.getIns().season[0][num-1]];
				setDate(ary);
			}
		}
		/**	영상 내용 생성	*/
		private function setDate(sData:Array):void
		{
			if(bReview == false)
			{	//생방송 중에 날짜가 중간일때
				if(sData[2] != 1 && sData[2] != 5 && sData[2] != 10 && sData[2] != 14)
				{
					Global.getIns().bPopReview = true;
				}
			}
			
			moviePos = sData[3];
			var season:Array = Asset.getIns().season[sData[1]+1];
			var num:int = -1;
			
			if(sData[2] < 5) num = 1;
			else if(sData[2] < 10) num = 2; 
			else if(sData[2] < 14) num = 3; 
			else if(sData[2] == 14) num = 4;
			
			var dayAry:Array = ["",1,5,10,14];
			Global.getIns().movieState = "day"+dayAry[num];
			
			var i:int;
			for(i = 1; i < season[num].length; i++)
			{	//시즌 영상
				loadAry.push(season[num][i]);
			}
			var beauty:Array = Asset.getIns().beauty;
			var realBT:Array = [];
			for(i = 1; i < beauty[num].length; i++)
			{	//뷰티 영상
				realBT.push(beauty[num][i]);
			}
			
			var btRan:int = Math.round(Math.random()*1);
			//trace(btRan); 0,1
			
			//뷰티 영상 분기
			for(i = 1; i<realBT.length; i++)
			{	
				if(realBT[i] is Array == true)
				{
					var ary:Array = realBT[i];
					realBT[i] = ary[btRan];
				}
			}
			
			for(i = 0; i < realBT.length; i++)
			{	//뷰티 영상
				loadAry.push(realBT[i]);
			}
			
			var realAry:Array = [];
			
			for(i = 0; i<loadAry.length; i++)
			{	realAry[i] = loadAry[i]; }
			
			for(i = 0; i < loadAry.length; i++)
			{	//반복 내용 적용
				if( loadAry[i] == "F38" || loadAry[i] == "F41" ||
					loadAry[i] == "H38" || loadAry[i] == "H41" ||
					loadAry[i] == "J38" || loadAry[i] == "J41" ||
					loadAry[i] == "L38"
				) loadAry[i] = "Board_Key";
			}
			//trace(loadAry);
			if(sData[3] == 16) loadAry[loadAry.length-1] = "L44";
			
			super.init();	//로드 시작
			
			movieAry = [];
			for(i = 0; i<loadAry.length; i++)
			{	movieAry[i] = realAry[i]; }
			
		}
		private function checkBLoadContact(type:String = "mc"):void
		{
			if(loader.bLoadContact == false) return;
			
			var str:String = loadAry[playPos+1];
			if(str.substr(str.length-3) == "Key" && type == "mc") return;
			
			ConLoader.getIns().setHideLoading();
			setNextPlay();
			loader.bLoadContact = false;
		}
		/**	분기 영상 로드 완료	*/
		override protected function upDataMcAry(mcAry:Array):void
		{
			super.upDataMcAry(mcAry);
			checkBLoadContact("mc");
		}
		/**	XML데이터 로드	*/
		override protected function upDateXmlAry(xmlAry:Array):void
		{
			super.upDateXmlAry(xmlAry);
			//시즌 영상 내용은 초기 데이터 로드시 플레이
			//return;
			
			if(_xmlAry.length == 1) 
			{	//시즌 영상 처음 xml내용 로드 하면 영상 플레이
				playFirst();
			}
			checkBLoadContact("xml");
		}
		
		/**	모든 데이터 로드 완료	*/
		override protected function onComplete(mcAry:Array, xmlAry:Array):void
		{
			//super.onComplete(mcAry,xmlAry);
			//영상 본 카운트 저장
			Global.getIns().getMovCnt().save(MovieEvent.SEAONMOVIE+moviePos);
		}
		
		/**	매순간 반복 내용	*/
		override protected function onEnter(e:Event):void
		{
			super.onEnter(e);
			
			if((movieAry[playPos] == "J25_Key" ||
				movieAry[playPos] == "J28_2" ||
				movieAry[playPos] == "J31_Key" ||
				movieAry[playPos] == "J34_Key") && 
				playMc.currentFrame == 10 &&
				_data.playStage == "facebook"	)
			{	//페이스북 페이지에서 볼때 게릴라 이벤트 안내 팝업
				Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.FACEBOOKPOPUP));
			}
			
			//화이트데이 이벤트 정엽 노래 플레이중 배경 음악 제거
			if( movieAry[playPos] == "J31" && 
				playMc.currentFrame >= 850 &&
				Global.getIns().bgm != null)
			{
				Global.getIns().bgm.destroy();
				Global.getIns().bgm = null;
			}
			//페이스북에서는 이벤트 적용이 되지 않음
			if(_data.playStage == "facebook") return;
			
			//**** 게릴라 이벤트 내용 적용 ************//
			
			//발렌타인데이 게릴라 이벤트 내용 
			if(movieAry[playPos] == "J25_Key" && 
				playMc.currentFrame >= playMc.totalFrames-1-210) 
			{
				playMc.stop();
				var transform:SoundTransform = playMc.soundTransform;
				transform.volume = 0;
				playMc.soundTransform = transform;
			}
			
			if(movieAry[playPos] == "J28_2" && playMc.currentFrame == playMc.totalFrames-2)
			{	//환절기 게릴라 이벤트 적용
				playMc.nextFrame();
				playMc.stop();
				GuerillaSeason2(guerilla).view();
			}
			
			if(	
				(
					movieAry[playPos] == "J28_3_Key" ||
					movieAry[playPos] == "J31_2_Key" ||
					movieAry[playPos] == "J34_2_Key" ||
					movieAry[playPos] == "J31_Key" ||
					movieAry[playPos] == "J34_Key" ||
					movieAry[playPos] == "J34_LIST"
				)
				&& playMc.currentFrame == playMc.totalFrames-2)
			{	//게릴라 이벤트 완료 영상 멈추기
				playMc.nextFrame();
				playMc.stop();
			}
			
		}
		/**	영상 플레이 하는 순간	*/
		override protected function setPlayMc(mc:MovieClip,bPlay:String = "play"):void
		{
			var str:String = loadAry[playPos];
			//보드 내용 3장만 나올때
			if(	str == "Board_Key" &&
				movieAry[playPos] != "L38") mc.gotoAndStop(200);
			
			super.setPlayMc(mc,bPlay);
			
			if( str == "J25_Key" || 
				str == "J28_2" || str == "J28_3_Key" || 
				str == "J31_Key" || str == "J31_2_Key" ||
				str == "J34_Key" || str == "J34_2_Key" || str == "J34_LIST")
			{	
				//게릴라 이벤트 내용 적용
				evtBtn = getAsset()[str.substr(0,3)+"_BTN"];
				
				if(str == "J28_3_Key") evtBtn = getAsset()["J28_3_BTN"];
				if(str == "J31_2_Key") evtBtn = getAsset()["J31_2_BTN"];
				if(str == "J34_2_Key") evtBtn = getAsset()["J34_2_BTN"];
				if(str == "J34_2_Key") evtBtn = getAsset()["J34_2_BTN"];
				if(str == "J34_LIST") evtBtn = getAsset()["J34_LIST_BTN"];
				
				evtBtn.x = 0; evtBtn.y = 0;
				container.movieMc.addChild(evtBtn);
				
				if(str == "J25_Key") guerilla = new GuerillaSeason1(evtBtn,sourceMc);
				if(str == "J28_2") guerilla = new GuerillaSeason2(evtBtn,sourceMc);
				if(str == "J28_3_Key") guerilla = new GuerillaSeason2Complete(evtBtn,sourceMc);
				if(str == "J31_Key") guerilla = new GuerillaSeason3(evtBtn,sourceMc);
				if(str == "J31_2_Key") guerilla = new GuerillaSeason3Complete(evtBtn,sourceMc);
				if(str == "J34_Key") guerilla = new GuerillaSeason4(evtBtn,sourceMc);
				if(str == "J34_2_Key") guerilla = new GuerillaSeason4Complete(evtBtn,sourceMc);
				if(str == "J34_LIST")
				{
					//guerilla = new GuerillaSeason4ListView(evtBtn,sourceMc);
					guerilla = new GuerillaSeason4ListView(getAsset(),sourceMc);
				}
				Clock.getIns().getSeasonDay(checkSeaonPlay);
			}

		}
		/**	게릴라 이벤트 이벤트 참여 시간이 아닐때 안내 팝업 	*/
		private function checkSeaonPlay(ary:Array):void
		{
			var date:Date = ary[4] as Date;
			if(ary[2] == 10 && date.getHours() <= 18) return;
			
			Global.getIns().viewPop("evtAlert");
		}
		/**	인터렉티브 내용		*/
		override protected function drawInter():Boolean
		{
			var view:Boolean = false;
			
			var str:String = loadAry[playPos];
			if(str == "Board_Key") view = drawBoard(); 		//보드판 내용
			else if(str == "H26_Key") view = drawPicket(); 	//피켓 내용
			else
			{
				setGuerillaInter();
				view = super.drawInter();
			}
			return view;
		}
		/**	게릴라 이벤트 버튼 영역 위치 값 적용	*/
		private function setGuerillaInter():void
		{
			if(	loadAry[playPos] != "J25_Key" &&
				loadAry[playPos] != "J28_3_Key" &&
				loadAry[playPos] != "J31_Key" &&
				loadAry[playPos] != "J31_2_Key" &&
				loadAry[playPos] != "J34_Key" &&
				loadAry[playPos] != "J34_2_Key"
			) return;
			
			if(guerilla == null) return;
			
			for(var i:int = 0; i<stepAry.length; i++)
			{
				var cpos:int = playMc.currentFrame;
				var num:int = cpos-stepAry[i];
				if(	cpos > stepAry[i] && cpos < stepCnt[i] )
				{
					var xml:XML = _xmlAry[playPos] as XML;
					guerilla.updatePosition(getPoint(xml.step[i].item[num].@LT.toString()));
				}
			}
		}
		/**	본방 사수 피켓 그리기	*/
		private function drawPicket():Boolean
		{
			var view:Boolean = false;
			var xml:XML = _xmlAry[playPos] as XML;
			
			for(var i:int = 0; i<stepAry.length; i++)
			{
				var cpos:int = playMc.currentFrame;
				if(	cpos > stepAry[i] && cpos < stepCnt[i] )
				{
					var num:int = cpos-stepAry[i];
					view = true;
					interSp.visible = true;
					interSp2.visible = true;
					interSp.graphics.clear();
					interSp2.graphics.clear();
					
					dis.setTransform(
						interSp.graphics,
						bitData,
						getPoint(xml.step[i].item[num].@LT.toString()),
						getPoint(xml.step[i].item[num].@RT.toString()),
						getPoint(xml.step[i].item[num].@LB.toString()),
						getPoint(xml.step[i].item[num].@RB.toString())
					);
					dis.setTransform(
						interSp2.graphics,
						bitData2,
						getPoint(xml.step[i].item[num].@LT2.toString()),
						getPoint(xml.step[i].item[num].@RT2.toString()),
						getPoint(xml.step[i].item[num].@LB2.toString()),
						getPoint(xml.step[i].item[num].@RB2.toString())
					);
				}
			}
			return view;
		}
		/**	보드 내용 그리기	*/
		private function drawBoard():Boolean
		{
			var view:Boolean = false;
			//trace("cc"+playMc.currentFrame);
			var xml:XML = _xmlAry[playPos] as XML;
			
			for(var i:int = 0; i<stepAry.length; i++)
			{
				var cpos:int = playMc.currentFrame;
				if(	cpos > stepAry[i] && cpos < stepCnt[i] )
				{
					var num:int = cpos-stepAry[i];
					view = true;
					
					if(playMc.currentFrame >= 1 && playMc.currentFrame <= 165)
					{
						interSp.visible = true;
						interSp.graphics.clear();
						dis.setTransform(
							interSp.graphics,
							bitData,
							getPoint(xml.step[i].item[num].@LT.toString()),
							getPoint(xml.step[i].item[num].@RT.toString()),
							getPoint(xml.step[i].item[num].@LB.toString()),
							getPoint(xml.step[i].item[num].@RB.toString())
						);
					}
					else 
					{
						interSp.graphics.clear();
						interSp.visible = false;
					}
					if(playMc.currentFrame >= 113 && playMc.currentFrame <= 370)
					{
						interSp2.visible = true;
						interSp2.graphics.clear();
						dis.setTransform(
							interSp2.graphics,
							bitData2,
							getPoint(xml.step[i].item[num].@LT2.toString()),
							getPoint(xml.step[i].item[num].@RT2.toString()),
							getPoint(xml.step[i].item[num].@LB2.toString()),
							getPoint(xml.step[i].item[num].@RB2.toString())
						);
						if(playMc.currentFrame < 168)
							interSp2.mask = playMc.mask1;
						else interSp2.mask = null;
						playMc.mask1.nextFrame();
						
					}else 
					{
						interSp2.graphics.clear();
						interSp2.visible = false;
					}
					
					if(playMc.currentFrame >= 326 && playMc.currentFrame <= 558)
					{
						interSp3.visible = true;
						interSp3.graphics.clear();
						dis.setTransform(
							interSp3.graphics,
							bitData3,
							getPoint(xml.step[i].item[num].@LT3.toString()),
							getPoint(xml.step[i].item[num].@RT3.toString()),
							getPoint(xml.step[i].item[num].@LB3.toString()),
							getPoint(xml.step[i].item[num].@RB3.toString())
						);
						
						if(playMc.currentFrame < 371)
							interSp3.mask = playMc.mask2;
						else interSp3.mask = null;
						playMc.mask2.nextFrame();
						
					}else 
					{
						interSp3.graphics.clear();
						interSp3.visible = false;
					}
					
					if(playMc.currentFrame >= 515)
					{
						interSp4.visible = true;
						interSp4.graphics.clear();
						dis.setTransform(
							interSp4.graphics,
							bitData4,
							getPoint(xml.step[i].item[num].@LT4.toString()),
							getPoint(xml.step[i].item[num].@RT4.toString()),
							getPoint(xml.step[i].item[num].@LB4.toString()),
							getPoint(xml.step[i].item[num].@RB4.toString())
						);
						if(playMc.currentFrame < 557)
							interSp4.mask = playMc.mask3;
						else interSp4.mask = null;
						playMc.mask3.nextFrame();
						
					}else
					{
						interSp4.graphics.clear();
						interSp4.visible = false;
					}
					
				}
			}
			return view;
		}
		
		/**	초기 인터렉티브 영상 내용 적용	*/
		override protected function setInter():void
		{
			interFnc = this[loadAry[playPos]];
			super.setInter();
			
			var str:String = loadAry[playPos];
			if( str == "J25_Key" || 
				str == "H26_Key" || 
				str == "Board_Key") this["set"+loadAry[playPos]]();
		}
		/**	이벤트 참여 내용 초기화	*/
		private function setJ25_Key():void
		{
			//이벤트 참여 내용 적용
			//trace("aaa");
		}
		/**	본방사수 피켓 내용 초기화	*/
		private function setH26_Key():void
		{
			interSp2 = new Sprite();
			container.movieMc.addChild(interSp2);
			//interSp.blendMode = BlendMode.MULTIPLY;
			//interSp2.blendMode = BlendMode.MULTIPLY;
			interSp.alpha =interSp2.alpha =  0.8;
			
			bitData = new BitmapData(sourceMc.width,sourceMc.height,true,0x00ffffff);
			sourceMc.img1.alpha = 1;
			sourceMc.img2.alpha = 0;
			bitData.draw(sourceMc);
			bitData2 = new BitmapData(sourceMc.width,sourceMc.height,true,0x00ffffff);
			sourceMc.img1.alpha = 0;
			sourceMc.img2.alpha = 1;
			bitData2.draw(sourceMc);
		}
		
		/**	보드 내용 초기화	*/
		private function setBoard_Key():void
		{
			bitData = new BitmapData(sourceMc.width,sourceMc.height,true,0x00ffffff);
			bitData.draw(sourceMc);
			sourceMc.img1.alpha = 0;
			interSp.blendMode = BlendMode.MULTIPLY;
			interSp.filters = [new BlurFilter(1.2,1.2)];
			
			for(var i:int = 3; i>=1; i--)
			{
				var mc:MovieClip = playMc["mask"+i] as MovieClip;
				mc.gotoAndStop(1);
				mc.visible = false;
				mc.cacheAsBitmap = true;
				
				this["interSp"+(i+1)] = new Sprite();
				var sp:Sprite = this["interSp"+(i+1)];
				
				sp.cacheAsBitmap = true;
				container.movieMc.addChild(sp);
				container.movieMc.addChild(mc);
				sp.blendMode = BlendMode.MULTIPLY;
				sp.filters = [new BlurFilter(1.2,1.2)];
				
				this["bitData"+(i+1)] = new BitmapData(sourceMc.width,sourceMc.height,true,0x00ffffff);
				var bData:BitmapData = this["bitData"+(i+1)];
				
				for(var j:int = 1; j<= 3; j++)
				{
					var img:MovieClip = sourceMc["img"+(j+1)] as MovieClip;
					img.gotoAndStop(checkBoardImg());
					img.alpha = 0;
					if(j == i) img.alpha = 1;
				}
				
				bData.draw(sourceMc);
			}
		}
		/**	보드에 보여질 이미지 위치 반환	*/
		private function checkBoardImg():int
		{
			var str:String = movieAry[playPos] as String;
			var ary:Array = ["","F38","F41","H38","H41","J38","J41","L38"];
			
			for(var i:int = 1; i<ary.length; i++)
			{
				if(str == ary[i]) return i;
			}
			return 1;
		}
		/**	처음 등장때 시계 시간 계속 업데이트*/
		protected function F22_Key():void
		{
			interSp.filters = [new BlurFilter(1.1,1.1)];
			//interSp.blendMode = BlendMode.MULTIPLY;
			Clock.getIns().getCDate(setAnalogueDate);
		}
		protected function F22_1_Key():void{	F22_Key();	}
		protected function F22_2_Key():void{	F22_Key();	}
		protected function F22_3_Key():void{	F22_Key();	}
		protected function F22_4_Key():void{	F22_Key();	}
		
		/**	환절기 영상중 시계	*/
		protected function J28_Key():void
		{	
			F22_Key();	
			var mc:MovieClip = getAsset();
			mc.J28_Key.timeMc.dotMc.visible = false;
		}
		protected function L27_Key():void
		{
			F22_Key();	
			var mc:MovieClip = getAsset();
			
			mc.L27_Key.timeMc.lineH.height = 35;
			mc.L27_Key.timeMc.lineM.height = 30;
		}
		
		/**	xoom들고 있는 장면에서 중간에 나오는 시계	*/
		protected function H25_Key():void
		{
			Clock.getIns().getCDate(setAnalogueDate);
		}
		/**	피켓 2개 들고 나오는 장면	*/
		protected function H26_Key():void
		{
		
		}
		/**	피켓 1개 들고 나오는 장면	*/
		protected function H43_Key():void{}
		/**	보드 내용	*/
		protected function Board_Key():void{}
		/**	발렌타인 데이 게릴라 이벤트 	*/
		protected function J25_Key():void{}
		/**	환절기 완료 	*/
		protected function J28_3_Key():void
		{
			interSp.alpha = 0.8;
		}
		
		protected function J31_2_Key():void{}
		protected function J34_2_Key():void{}
		
		/**	화이트 데이 이벤트 페이지	*/
		protected function J31_Key():void{}
		
		/**	다이어트 시계	*/
		protected function J34_0_Key():void
		{
			F22_Key();
		}
		
		/**	다이어트 이벤트 참여	*/
		protected function J34_Key():void
		{
			
		}
		
	}//class
}//package