package contents.movie
{
	import com.greensock.TweenMax;
	import com.sw.display.DistortImage;
	import com.sw.display.Remove;
	import com.sw.net.Location;
	
	import event.MovieEvent;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.ui.Keyboard;
	
	import net.ConLoader;
	import net.Track;
	
	import util.BGM;
	import util.Clock;

	/**		
	 *	SK2_Hershys :: 메인 영상 컨트롤 내용 공통 내용
	 */
	public class BaseMovie extends Sprite		
	{
		/**	그래픽	*/
		protected var container:MainMovieClip;
		/**	생성시 가져온 데이터	*/
		protected var _data:Object;
		/**	영상 로더	*/
		protected var loader:MovieLoader;
		/**	로드 위치	*/
		protected var loadPath:String;
		/**	로드 요소 배열	*/
		protected var loadAry:Array;
		/**	영상 명 배열	*/
		protected var movieAry:Array;
		/**	영상 배열	*/
		protected var _mcAry:Array;
		/**	xml 배열	*/
		protected var _xmlAry:Array;
		
		/**	현제 보여지고 있는 영상	*/
		protected var playMc:MovieClip;
		/**	플레이 영상 위치	*/
		protected var playPos:int;
		
		/**	인터렉션 내용이 그려질 MovieClip	*/
		protected var sourceMc:MovieClip;
		/**	인터렉션 Sprite	*/
		protected var interSp:Sprite;
		
		protected var stepPos:int;
		protected var stepAry:Array;
		protected var stepCnt:Array;
		
		protected var bitData:BitmapData;
		protected var dis:DistortImage;
		
		/**	인터렉션 수행시 호출 함수	*/
		protected var interFnc:Function;
		
		/**	영상이 플레이 되고 있는곳	*/
		private var playStage:String;
		
		
		/**	생성자	*/
		public function BaseMovie(data:Object = null)
		{
			_data = data;
			if(_data == null) _data = new Object();
			playStage = "site";
			if(data.playStage != null) playStage = data.playStage;
			
			movieAry = [];
			
			stepPos = 0;
			stepAry = [];
			stepCnt = [];
			loadPath = "";
			interSp = new Sprite();
			interSp.visible = false;
			container = new MainMovieClip();
			
			addChild(container);
			
			Global.getIns().addEventListener(MovieEvent.PLAY,onPlay);
			Global.getIns().addEventListener(MovieEvent.STOP,onStop);
			Global.getIns().addEventListener(MovieEvent.NEXT,onNextPlay);
			Global.getIns().addEventListener(MovieEvent.PREV,onPrevPlay);
			
			//테스트용 키 내용
			addEventListener(Event.ADDED_TO_STAGE,onAdd);	
		}
		/**	외부에서 영상 멈추는 이벤트	*/
		private function onStop(e:MovieEvent):void
		{	playMc.stop();	}
		/**	외부에서 영상 플레이 하는 이벤트	*/
		private function onPlay(e:MovieEvent):void
		{	
			trace("외부에서 영상 플레이 하는 이벤트playMc: ",playMc);
			if(playMc.currentFrame != playMc.totalFrames)
			{
				playMc.play();	
				TweenMax.to(interSp,1,{alpha:1});
				TweenMax.to(playMc,1,{alpha:1});
			}
		}
		/**	외부에서 다음 영상 플레이	*/
		private function onNextPlay(e:MovieEvent):void
		{
			setNextPlay();
		}
		/**	외부에서 이전 영상 플레이	*/
		private function onPrevPlay(e:MovieEvent):void
		{
			setNextPlay(-1);
		}
		/**	화면에 붙을 때 수행 내용	*/
		private function onAdd(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			
			//플래쉬 단독 실행 일때만 테스트 키 동작
			if(	Location.setURL("local","") == "local" || 
				loaderInfo.url.substr(0,14) == "http://hertest")
				stage.addEventListener(KeyboardEvent.KEY_DOWN,onTestKey);
		}
		/**	화면 바로 넘어가는 테스트 키	*/
		private function onTestKey(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.N)
			{
				setNextPlay();
			}
			if(e.keyCode == Keyboard.S)
			{
				playMc.stop();
			}
			if(e.keyCode == Keyboard.P)
			{
				playMc.play();
			}
		}
		/**	dotMc 반환	*/
		public function getDotMc():MovieClip
		{	return container.dotMc;	}
		/**	그래픽 최상위 반환	*/
		public function getContainer():MovieClip
		{	return container;	}
		
		/**	초기화	*/
		protected function init():void
		{
			//trace(loadAry);
			playPos = 0;
			
			for(var i:int = 0; i<loadAry.length; i++)
			{	//로드 하려는 영상 내용중 배열이 있으면 랜덤으로 배열 안의 내용중 하나 선택
				//trace(loadAry[i] is Array);
				if(loadAry[i] is Array == true)
				{
					var ary:Array = loadAry[i];
					loadAry[i] = ary[Math.round(Math.random()*(ary.length-1))];
					//trace(loadAry[i]);
				}
			}
			//trace(loadAry);
			movieAry = loadAry;
			var obj:Object = new Object();
			obj.onComplete = onComplete;
			obj.loadPath = loadPath;
			obj.playStage = playStage;
			obj.updateMc = upDataMcAry;
			obj.updateXml = upDateXmlAry;
			
			loader = new MovieLoader(loadAry,obj);
			
			addAsset();
//			loader.load();
		}
		/**	로드시작	*/
		public function load():void
		{
			loader.load();
		}
		/**	인터렉션 그래픽 자원 반환	*/
		public function getAsset():MovieClip
		{
			return loader.getAsset();
		}
		/**
		 *	로드 내용에 인터렉션이 있는지 여부 
		 * @return (true:있음,false:없음)
		 */
		protected function checkKey():Boolean
		{
			for(var i:int = 0; i<loadAry.length; i++)
			{
				var str:String = loadAry[i] as String;
				if(str.lastIndexOf("_Key") != -1)
				{
					return true;
				}
			}
			return false;
		}
		protected function checkCurrontKey():Boolean
		{
			if(loadAry[playPos].lastIndexOf("_Key") != -1) return true;
			return false;
		}
		/**	인터렉션 요소 자원 로드 추가	*/
		protected function addAsset():void
		{
			if(checkKey() == true) loader.setAssetPath();
		}
		
		/**	영상 객체 내용 	새로 추가*/
		protected function upDataMcAry(mcAry:Array):void
		{	_mcAry = mcAry;	}
		/**	xml 데이터 내용 새로 추가	*/
		protected function upDateXmlAry(xmlAry:Array):void
		{	_xmlAry = xmlAry;	}
		
		/**	필요한 영상,XML 모두 로드 완료		*/
		protected function onComplete(mcAry:Array,xmlAry:Array):void
		{
			playFirst();
			
		}
		
		/**	처음 플레이	*/
		protected function playFirst():void
		{
			//영상 상황 기록
			if(this is SeasonTime == false) Global.getIns().movieState = "rest";
			
			loader.playSound();
			
			var mc:MovieClip = _mcAry[0] as MovieClip;
			mc.alpha = 0;
			TweenMax.to(interSp,0,{alpha:0});
			interSp.blendMode = BlendMode.NORMAL;
			
			if(Global.getIns().bPopReview == true)
			{	//재방송일때 영상 잠시 멈춤
				setPlayMc(mc,"stop");
				Global.getIns().viewPop("review",{});
				//Global.getIns().bMovReview = true;
			}
			else 
			{
				setPlayMc(mc);
				TweenMax.to(interSp,1,{alpha:1});
				TweenMax.to(mc,1,{alpha:1});
			}
			Global.getIns().bPopReview = false;
			
			addEventListener(Event.ENTER_FRAME,onEnter);
		}
		/**	영상이 실행되는 매 순간 실행 함수	*/
		protected function onEnter(e:Event):void
		{
			if(checkCurrontKey() == true) onSetTrack();
			
			if(playMc.currentFrame == playMc.totalFrames)
			{	//플레이 중인 영상 플레이 완료
				playMc.stop();
				//loadAry
				//if(playMc == _mcAry[_mcAry.length-1])
				if(playMc == _mcAry[_mcAry.length-1] && _mcAry.length == loadAry.length)
				{	//모두 플레이 완료
					Track.go("44","02");
					onEndMov();
					removeEventListener(Event.ENTER_FRAME,onEnter);
					Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.FINISH));
					return;
				}
				setNextPlay();
			}
		}
		
		/**	영상 플레이	*/
		protected function setPlayMc(mc:MovieClip,bPlay:String = "play"):void
		{
			//if(checkKey() == true) setInter();
			interSp.visible = false;
			interSp.graphics.clear();
				
			container.movieMc.addChild(mc);
			playMc = mc;
			if(checkCurrontKey() == true) setInter();
			
			if(bPlay == "play")
			{
				interSp.alpha = 1;
				mc.play();
			}
			if(bPlay == "stop") mc.gotoAndStop(1);
			
			//trace(bPlay);
			
			onEnter(null);
		}
		
		/**	인터렉티브 내용 셋팅	*/
		protected function setInter():void
		{
			container.movieMc.addChild(interSp);
			setXML();
			var mc:MovieClip = getAsset();
			sourceMc = mc[loadAry[playPos]] as MovieClip;
			sourceMc.gotoAndStop(1);
			dis = new DistortImage(sourceMc.width,sourceMc.height,5,5);
			dis.smoothing = true;
			
			if(interFnc != null) interFnc();
			
		}
		/**	인터렉션 xml데이터 생성,적용	*/
		protected function setXML():void
		{
			stepAry = [];
			stepCnt = [];
			
			var xml:XML = _xmlAry[playPos] as XML;
			var cnt:int = xml.step.length();
			
			for(var i:int =0; i<cnt; i++)
			{
				stepAry.push(int(xml.step[i].@time.toString()));
				stepCnt.push(xml.step[i].item.length()+stepAry[i]);
			}
			
//			trace(stepAry);
//			trace(stepCnt);
		}
		
		protected function getPoint(str:String):Point
		{
			var ary:Array = str.split(",");
			return new Point(Number(ary[0]),Number(ary[1]))
		}
		
		/**	다음 영상 플레이	*/
		protected function setNextPlay(dir:int = 1):void
		{
			playMc.stop();
			
			if(_mcAry.length <= playPos+1)
			{	//현제 플레이 가능한 내용보다 앞 내용 요구시 일시 정지
				if(playMc.currentFrame != playMc.totalFrames) playMc.play();
				//아직 모두 로드 되지 않았을때
				if(_mcAry.length < loadAry.length)
				{
					loader.bLoadContact = true;
					ConLoader.getIns().setViewLoading();
				}
				return;
			}
			
			playPos += dir;
			playMc.gotoAndStop(1);
			
			Remove.child(container.movieMc);
			setPlayMc(_mcAry[playPos] as MovieClip);
		}
		
		/**	모든 영상 플레이 완료	*/
		protected function onEndMov():void
		{
			Clock.getIns().getSeasonDay(checkEndMovDate);
		}
		/**	모든 영상 플레이 완료 후 Q&A일때는 완료 팝업 띄우지 않음.	*/
		private function checkEndMovDate(ary:Array):void
		{
			if(ary[5] != 0) return;
			Global.getIns().viewPop("finishPop",{});
		}
		
		
		/**	매순간 트래킹 내용 적용	*/
		protected function onSetTrack():void
		{
			var view:Boolean = drawInter();
			
			if(interFnc != null && view == true) interFnc();
			
			interSp.visible = view;	
		}
		/**	인터렉션 내용 그리기	*/
		protected function drawInter():Boolean
		{
			var view:Boolean = false;
			var xml:XML = _xmlAry[playPos] as XML;
			
			if(bitData != null) 
			{
				bitData.dispose();
				bitData = null;
			}
			bitData = new BitmapData(sourceMc.width,sourceMc.height,true,0x00ffffff);
			bitData.draw(sourceMc);
			
			for(var i:int = 0; i<stepAry.length; i++)
			{
				var cpos:int = playMc.currentFrame;
				if(	cpos > stepAry[i] && cpos < stepCnt[i] )
				{
					var num:int = cpos-stepAry[i];
					view = true;
					interSp.visible = true;
					interSp.graphics.clear();
					
					sourceMc.nextFrame();
					
					dis.setTransform(
						interSp.graphics,
						bitData,
						getPoint(xml.step[i].item[num].@LT.toString()),
						getPoint(xml.step[i].item[num].@RT.toString()),
						getPoint(xml.step[i].item[num].@LB.toString()),
						getPoint(xml.step[i].item[num].@RB.toString())
					);
				}
			}
			return view;
		}
		
		/**	재방송 중에는 시간 고정	*/
		protected function setReviewDate($date:Date):Date
		{
			if(Global.getIns().bMovReview != true) return $date;
			
			$date.setHours(15);
			$date.setMinutes(37);
			var num:int = 10*30
			$date.setSeconds(Math.floor(((playMc.currentFrame+num)/30)%60));
			return $date;
		}
		/**	디지털 시계 적용	*/
		protected function setDigitalDate(date:Date):void
		{
			date = setReviewDate(date);
			
			var h1:MovieClip = sourceMc.timeMc.h1 as MovieClip;
			var h2:MovieClip = sourceMc.timeMc.h2 as MovieClip;			
			var m1:MovieClip = sourceMc.timeMc.m1 as MovieClip;
			var m2:MovieClip = sourceMc.timeMc.m2 as MovieClip;
			
			var strH:String = date.getHours()+"";
			var strM:String = date.getMinutes()+"";
			
			h1.gotoAndStop(1);
			if(strH.length > 1) 
			{
				h1.gotoAndStop(int(strH.substr(0,1))+1);
				h2.gotoAndStop(int(strH.substr(1,1))+1);			
			}
			else h2.gotoAndStop(int(strH)+1);
			
			m1.gotoAndStop(1);
			if(strM.length > 1) 
			{
				m1.gotoAndStop(int(strM.substr(0,1))+1);
				m2.gotoAndStop(int(strM.substr(1,1))+1);			
			}
			else m2.gotoAndStop(int(strM)+1);
		}
		/**	아날로그 시계 수현	*/
		protected function setAnalogueDate(date:Date):void
		{
			date = setReviewDate(date);
			
			var h:MovieClip = sourceMc.timeMc.lineH as MovieClip;
			var m:MovieClip = sourceMc.timeMc.lineM as MovieClip;			
			var s:MovieClip = sourceMc.timeMc.lineS as MovieClip;
			
			h.rotation = ((date.getHours()%12)/12)*360;
			
			h.rotation += (date.getMinutes()/60)*(360/12);
			
			m.rotation = (date.getMinutes()/60)*360;
			s.rotation = (date.getSeconds()/60)*360;
		}
		
		/**	소멸자	*/
		public function destroy():void
		{
			playMc.stop();
			playMc = null;
			for(var i:int =0; i<movieAry.length; i++)
			{
				var mc:MovieClip = movieAry[i] as MovieClip;
				Remove.all(mc);
				mc = null;
				movieAry[i] = null;
			}

			movieAry = null;
			
			stepAry = null;
			stepCnt = null;
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onTestKey);
			removeEventListener(Event.ENTER_FRAME,onEnter);
			
			Global.getIns().removeEventListener(MovieEvent.PLAY,onPlay);
			Global.getIns().removeEventListener(MovieEvent.STOP,onStop);
			Global.getIns().removeEventListener(MovieEvent.NEXT,onNextPlay);
			Global.getIns().removeEventListener(MovieEvent.PREV,onPrevPlay);
			
			Remove.all(container.movieMc);
			Remove.all(container);
		}
	}//class
}//package