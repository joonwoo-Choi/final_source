package contents.movie
{
	import event.MovieEvent;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	import util.BGM;
	import util.Clock;

	/**		
	 *	SK2_Hershys :: 임의의 영상 플레이
	 */
	public class RandomTime extends BaseMovie
	{
		
		/**	로또 선택 번호	*/
		private var lottoNum:int;
		/**	로또 반복음	*/
		private var lottoSnd:BGM;
		
		/**	생성자	*/
		public function RandomTime(data:Object=null)
		{
			super(data);
			
			if(data.time == null) throw new Error("RandomTime은 시간이 필요 합니다.");
			if(data.time is Array == false) throw new Error("RandomTime의 time은 Array여야 합니다.");
			
			var time:Array = data.time;
			var ran:int = Math.round(Math.random()*(time.length-2))+1;
			//trace(time);
			//trace(time.length);
			//trace(ran);
			loadPath = MovieEvent.RANDOM_PATH;
			
			loadAry = [time[ran]];
			
			//loadAry = [["F19_1","F19_2"]];
			//loadAry = ["F18_Key"];
			
			init();
		}
		/**	초기화	*/
		override protected function init():void
		{
			if(loadAry[0] is Array == true)
			{
				if(loadAry[0][0] == "F19_1")
				{	//로또 게임 일때 추가 내용 
					loadAry[0] = "F19_2";
					loadAry[1] = "F19_Loop";
					lottoNum = Math.round(Math.random()*3)+1;
					
					loadAry[2] = "F19n"+lottoNum+"_Key";
				}
			}
			super.init();
		}
		/**	매순간 수행 하는 함수	*/
		override protected function onEnter(e:Event):void
		{
			super.onEnter(e);
			//로또 반복 영상 반복 플레이
			if(	loadAry[playPos] == "F19_Loop" &&
				playMc.currentFrame == playMc.totalFrames -1)
			{
				//playMc.gotoAndPlay(1);
				playMc.first = false;
				playMc.gotoAndStop(1);
			}
			if(loadAry[playPos] == "F19_Loop" &&
				playMc.currentFrame == 1 && playMc.first == false)
			{	playMc.gotoAndPlay(2);	}
			if(loadAry[playPos] == "F19_2" &&
				playMc.currentFrame == 430)
			{	
				if(lottoSnd != null)
				{
					lottoSnd.destroy();
					lottoSnd = null;
				}
				lottoSnd = new BGM(Global.getIns().rootURL+"asset/lotto_voice.mp3",{volume:0.5});
			}
			
		}
		override protected function setPlayMc(mc:MovieClip,bPlay:String = "play"):void
		{
			super.setPlayMc(mc);
			if(loadAry[playPos] == "F19_Loop")
			{	//로또 기계 반복 내용 버튼 적용
				var btn:MovieClip = playMc.btn as MovieClip;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK,onClick);
				btn.gotoAndPlay(2);
				btn.img.gotoAndPlay(1);
				playMc.first = true;
			}
		}
		private function onClick(e:MouseEvent):void
		{
			var btn:MovieClip = playMc.btn as MovieClip;
			btn.removeEventListener(MouseEvent.CLICK,onClick);
			if(lottoSnd != null)
			{
				lottoSnd.destroy();
				lottoSnd = null;
			}
			setNextPlay();
		}
		/**	인터렉션 내용 구성	*/
		override protected function setInter():void
		{
			interFnc = this[loadAry[playPos]];
			super.setInter();
			
			var str:String = loadAry[playPos];
			if( str.substr(0,4) == "F19n")
			{	
				sourceMc.txt1Mc.gotoAndStop(lottoNum);
				sourceMc.txt2Mc.gotoAndStop(lottoNum);
			}
			interSp.alpha = 0.9;
		}
		/**	인터렉션 내용 적용	*/
		override protected function onSetTrack():void
		{
			super.onSetTrack();
		}
		/**	인터렉션 내용 그리기	*/
		override protected function drawInter():Boolean
		{
			var str:String = loadAry[playPos];
			if( str.substr(0,4) == "F19n")
			{
				return drawF19();
			}
			else return super.drawInter();
		}
		
		/**	로또 구슬 키 내용 그리기	*/
		private function drawF19():Boolean
		{
			var view:Boolean = false;
			var xml:XML = _xmlAry[playPos] as XML;
			
			for(var i:int = 0; i<stepAry.length; i++)
			{
				var cpos:int = playMc.currentFrame;
				if(	cpos > stepAry[i] && cpos < stepCnt[i] )
				{
					sourceMc.nextFrame();
					if(bitData != null) 
					{
						bitData.dispose();
						bitData = null;
					}
					bitData = new BitmapData(sourceMc.width,sourceMc.height,true,0x00ffffff);
					bitData.draw(sourceMc);
					
					var num:int = cpos-stepAry[i];
					view = true;
					interSp.visible = true;
					interSp.graphics.clear();
					
					var point1:Point = getPoint(xml.step[i].item[num].@LT.toString());
					var point2:Point = getPoint(xml.step[i].item[num].@LB.toString());
					var point3:Point = getPoint(xml.step[i].item[num].@RT.toString());
					var point4:Point = getPoint(xml.step[i].item[num].@RB.toString());
					
					var gapX:int = -8;
					var gapY:int = 10;
					dis.setTransform(
						interSp.graphics,
						bitData,
						new Point(point1.x-400+gapX,point1.y+gapY),
						new Point(point3.x+10+gapX,point3.y+gapY),
						new Point(point2.x-400+gapX,point2.y+gapY),
						new Point(point4.x+10+gapX,point4.y+gapY)
					);
				}
			}
			return view;
		}
		
		/**	취침 시계 표현	*/
		protected function F4_Key():void
		{
			interSp.alpha = 0.4;
			Clock.getIns().getCDate(setDigitalDate);
		}
		/**	식사 시계 표현	*/
		protected function F18_Key():void
		{
			interSp.alpha = 0.6;
			interSp.filters = [new BlurFilter(1.2,1.2)];
			Clock.getIns().getCDate(setAnalogueDate);
		}
		/**	로또 기계 내용 구성	*/
		protected function F19n1_Key():void	{}
		protected function F19n2_Key():void	{}
		protected function F19n3_Key():void	{}
		protected function F19n4_Key():void	{}
		
	}//class
}//package