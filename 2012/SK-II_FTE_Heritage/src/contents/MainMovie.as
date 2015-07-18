package contents
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.display.BaseIndex;
	import com.sw.utils.McData;
	
	import contents.movie.BaseMovie;
	import contents.movie.QnATime;
	import contents.movie.RandomTime;
	import contents.movie.SeasonTime;
	import contents.movie.WeatherTime;
	import contents.qnaevent.QnAGlobal;
	
	import event.MovieEvent;
	import event.UIEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import util.BtnHersheys;
	import util.Clock;
	import util.MovieDot;
	
	/**		
	 *	SK2_Hershy :: 메인 영상 내용 (영상 뒤 리스트 내용)
	 */
	[SWF(width="830",height="466",frameRate="30")]
	public class MainMovie extends BaseIndex
	{
		/**	영상 제어 부분	*/
		private var control:BaseMovie;
		/**	영상 페이지 그래픽	*/
		private var container:MainMovieClip;
		/**	시즌 영상 리스트	*/
		private var listMc:MovieClip;
		/**	드래그 시작 위치 차이	*/
		private var dragGap:int;
		/**	드래그 시작 위치	*/
		private var dragStart:int;
		/**	시즌 위치	*/
		private var seasonPos:int;
		/**	리스트 위치	*/
		private var listPos:int;
		/**	영상 제한 위치	*/
		private var limit:int;
		
		/**	초기 로드 여부	*/
		private var bFirst:Boolean;
		
		/**	생성자	*/
		public function MainMovie()
		{
			init();
			Global.getIns();
		}
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
			
			limit = -1;
			
			bFirst = true;
			Clock.getIns();
			
			Global.getIns().addEventListener(MovieEvent.MOVE_PLAY,onPlaySeason);
			Global.getIns().addEventListener(MovieEvent.FINISH,onFinishMovie);
			Global.getIns().addEventListener(MovieEvent.FIRST,onFirstPlay);
			
			Clock.getIns().getSeasonDay(setPopup);
		}
		/**	현제 시간 가져오기	*/
		private function setPopup(ary:Array):void
		{
			if(ary[5] == 2)
			{	//Q&A 이벤트
				setQnA();
				return;
			}
			Clock.getIns().getHTime(setH);
			if(ary[5] == 1)
			{	//FB팝업
				Global.getIns().viewPop("infoFB");
				return;
			}
			//영상 이벤트
			Global.getIns().viewPop("firstPop");
		}
		/**	Q&A 구성	*/
		private function setQnA():void
		{
			bFirst = false;
			
			control = new QnATime({});
			addControl();
			
			for(var i:int = 2; i<= 5; i++)
			{
				var list:MovieClip = listMc["list"+i] as MovieClip;
				var txt:TextField = list.txt as TextField;
				
				var alpha:int = 0;
				var bool:Boolean = false;
				
				txt.alpha = alpha;
				list.btn.alpha = alpha;
				
				list.btn.mouseEnabled = 
				list.btn.mouseChildren = 
				list.btn.visible = bool
			}
		}
		private function onFirstPlay(e:MovieEvent):void
		{
			bFirst = false;
			control.load();
		}
		/**	모든 영상 플레이 완료	*/
		private function onFinishMovie(e:MovieEvent):void
		{
			TweenMax.to(control.getDotMc(),1,{alpha:0,overwrite:1});
			
			TweenMax.to(container.movieMc,1,{alpha:0});
			TweenMax.to(container.handMc,0,{alpha:0});
			TweenMax.to(container.handMc,1,{alpha:1});
			container.handMc.visible = true;
			
			container.movieMc.mouseChildren = false;
			container.movieMc.mouseEnabled = false;
		}
		
		/**	일정 시즌 영상 플레이	*/
		private function onPlaySeason(e:MovieEvent):void
		{
			bFirst = false;
			
			var pos:int = e.data.pos;
			
			if(	e.data.pos == "QnA" && control is QnATime == true)
			{	//Q&A 이벤트를 보고 있는 상황에서 메인 리스트로 이동
				QnAGlobal.getIns().moveStep(1);
				Global.getIns().bgm.snd.soundPaused = false;
				return;
			}
			//영상 일시 정지
			Global.getIns().stopMovie();
			if(control != null)
			{
				control.destroy();
				removeChild(control);
				control = null;
			}
			if(e.data.pos == "QnA")
			{	//QnA 내용 구성
				setQnA();
				return;
			}
			//상단 시즌 버튼 안보이게
			Global.getIns().dispatchEvent(new UIEvent(UIEvent.TOP_SEASON_VIEW));
			
			control = new SeasonTime({season:pos});
			addControl(["","","",pos]);
		}
		/**	시간에 따라 control 다르게 생성	*/
		private function setH(str:String):void
		{
			var ary:Array = Clock.getIns().getHTimeStr();
			trace("str: ",str);
			trace("ary: ",ary);
			if(str == ary[0]) 
			{	
				control = new RandomTime({time:Asset.getIns().time00_06});
				Global.getIns().getMovCnt().save(MovieEvent.DAWNMOVIE);
			}
			if(str == ary[1])
			{
				control = new WeatherTime({});
				Global.getIns().getMovCnt().save(MovieEvent.MORNINGMOVIE);
			}
			if(str == ary[2])
			{
				control = new RandomTime({time:Asset.getIns().time12_13});
				Global.getIns().getMovCnt().save(MovieEvent.AFTERNOONMOVIE);
			}
			if(str == ary[3]) 
			{
				control = new SeasonTime({});
			}
			if(str == ary[4]) 
			{
				control = new RandomTime({time:Asset.getIns().time19_24});
				Global.getIns().getMovCnt().save(MovieEvent.EVENINGMOVIE);
			}
			
			limit = -1;
			addControl();
		}
		
		/**		*/
		private function addControl(ary:Array = null):void
		{
			container = control.getContainer() as MainMovieClip;
			listMc = container.listMc as MovieClip;
			
			if(ary == null) Clock.getIns().getSeasonDay(setList);
			else setList(ary);
			
			TweenMax.to(control.getDotMc(),1,{alpha:0.3,overwrite:1});
			
			container.movieMc.mouseChildren = true;
			container.movieMc.mouseEnabled = true;
			
			MovieDot.go(control.getDotMc(),850,460);
			
			addChild(control);
			
			if(bFirst == false) control.load();
		}
		
		/**	화면에 붙고 난후 수행	*/
		override protected function onAdd(e:Event):void
		{
			super.onAdd(e);
		}
		
		/**	리스트 내용 셋팅	*/
		private function setList(ary:Array):void
		{
			var pos:int = ary[3];
			
			//제한 위치를 초기에 한번만 적용
			if(limit == -1) limit = pos;
			if(limit == 0) pos = 1;

			seasonPos = Math.floor((pos-1)/4);
			pos = Math.floor((pos-1)%4)+1;
			
			listPos = pos;
			
			container.handMc.visible = false;
			McData.save(container.handMc);
			container.handMc.buttonMode = true;
			container.handMc.point1.gotoAndPlay(5);
			container.handPlane.visible = false;
			
			if(container.handMc.hasEventListener(MouseEvent.MOUSE_DOWN) != true)
			{
				container.handMc.addEventListener(MouseEvent.MOUSE_DOWN,onDownHand);
				container.handMc.addEventListener(MouseEvent.MOUSE_UP,onUpHand);
			}
			
			var txtAry:Array = ["","","Day 1","Day 5","Day 10","Day 14",""];
			
			for(var i:int = 1; i<= 6; i++)
			{
				var list:MovieClip = listMc["list"+i];
				
				list.btn.gotoAndStop(1);
				
				list.gotoAndStop(i);
				list.btn.alpha = 0;
				
				var txt:TextField = list.txt as TextField;
				txt.text = txtAry[i];
				
				list.x = (i-2)*list.width;
				//중앙 영상 내용
				if(i == 1 || i == 6) continue;
				list.btn.alpha = 1;
				list.btn.idx = (seasonPos*4)+(i-1);
				if(list.btn.idx > limit) txt.appendText("  Coming Soon");
				
				var tf1:TextFormat = new TextFormat(null,65);
				tf1.letterSpacing = -2;
				txt.setTextFormat(tf1,0,3);
				var tf2:TextFormat = new TextFormat(null,90);
				tf2.letterSpacing = -10;
				txt.setTextFormat(tf2,3,txt.length);
				
				txt.textColor = 0xaa050b
				txt.y += 23;
				
				BtnHersheys.getIns().playBtn(list.btn,onClickPlay);
				
				if(list.btn.idx > limit)
				{
					list.btn.visible = false;
					txt.setTextFormat(tf2,4,txt.text.lastIndexOf("Coming")+1);
					txt.setTextFormat(tf1,txt.text.lastIndexOf("Coming"),txt.length);
				}
			}
			moveList(0);
		}
		
		/**	영상 플레이 버튼 클릭	*/
		private function onClickPlay(mc:MovieClip):void
		{
			Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.MOVE_PLAY,{pos:mc.idx}));
		}
		/**	드래그 손바닥 마우스 다운	*/
		private function onDownHand(e:MouseEvent):void
		{
			dragGap = listMc.x - container.mouseX;
			dragStart = container.handMc.x;
			
			listMc.stage.addEventListener(MouseEvent.MOUSE_UP,onUpHand);
			listMc.addEventListener(Event.ENTER_FRAME,onDrag);
		}
		/**	드래그 손바닥 마우스 업	*/
		private function onUpHand(e:MouseEvent = null):void
		{
			listMc.stage.removeEventListener(MouseEvent.MOUSE_UP,onUpHand);			
			listMc.removeEventListener(Event.ENTER_FRAME,onDrag);
			TweenMax.to(container.handMc,0.8,{x:container.handMc.dx,ease:Expo.easeOut});
		}
		/**	드래그 	*/
		private function onDrag(e:Event):void
		{
			listMc.x = dragGap+container.mouseX;
			container.handMc.x -= (container.handMc.x - mouseX)*0.3;
			
			if(listMc.x > -container.listMc.list2.x) listMc.x = -container.listMc.list2.x;
			if(listMc.x < -container.listMc.list5.x) listMc.x = -container.listMc.list5.x;
			
			var max:int = Math.max(container.handMc.x,dragStart);
			var min:int = Math.min(container.handMc.x,dragStart);
			if(max - min > 100)
			{
				if(container.handMc.x > dragStart) listPos--;
				if(container.handMc.x < dragStart) listPos++;
				
				if(listPos < 1) listPos = 1;
				if(listPos > 4) listPos = 4;
				
				moveList();
				onUpHand();
			}
		}
		/**	리스트 내용 이동	*/
		private function moveList(speed:Number = 1):void
		{
			
			var movePos:int = listPos-1;
			if(movePos < 0) movePos = 0;
			
			TweenMax.to(container.listMc,speed,{x:movePos*-container.handPlane.width,ease:Expo.easeOut});
			
			for(var i:int = 2; i<= 5; i++)
			{
				var list:MovieClip = listMc["list"+i] as MovieClip;
				var txt:TextField = list.txt as TextField;
				
				var alpha:int = 0;
				var txtAlpha:Number = 0.5;
				var bool:Boolean = false;
				
				if(i == listPos+1)
				{	
					txtAlpha = 1;
					if(list.btn.idx <= limit)
					{	alpha = 1; bool = true;	}
				}
				
				TweenMax.to(txt,speed,{alpha:txtAlpha});
				TweenMax.to(list.btn,speed,{alpha:alpha});
				
				list.btn.mouseEnabled = 
				list.btn.mouseChildren = 
				list.btn.visible = bool
			}
		}
	}//class	
}//package