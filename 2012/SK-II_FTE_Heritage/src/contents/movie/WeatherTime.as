package contents.movie
{
	import event.MovieEvent;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	
	import util.BGM;
	import util.Weather;

	/**		
	 *	SK2 Hersheys :: 날씨 데이터 
	 */
	public class WeatherTime extends BaseMovie
	{
		/**	날씨 문자 데이터 종류	*/
		private var strAry:Array;
		/**	날씨에 따른 데이터 위치	*/
		private var numAry:Array;
		
		/**	포춘쿠키 영상 최대 위치	*/
		private var cookieMax:int;
		/**	포춘쿠키 영상 속도	*/
		private var cookieSpeed:Number;
		/**	포춘쿠키 영상 방향	*/
		private var cookieDir:Boolean;
		
		/**	포춘 쿠키 사운드	*/
		private var cookieSnd:BGM;
		/**	사운드 상황	*/
		private var sndPos:int;
		
		/**	생성자	*/
		public function WeatherTime(data:Object=null)
		{
			super(data);
			
			loadPath = MovieEvent.WEATHER_PATH;
			
			strAry = ["맑음","구름조금","구름많음","흐림","비","눈/비"];//눈
			numAry = [2,4,4,5,3,3];
			/*
			["","F7","F8"],//기본 
			["","F9","F10"],//맑음
			["","F11","F12","F13"],//비
			["","F14","F15"],//바람
			["","F16","F17"]//흐림
			*/
			Weather.getIns().getTxt(onLoadWeather);
		}
		/**	날씨 데이터 적용	*/
		private function onLoadWeather(str:String):void
		{
			setLoadAry(str);
			
			//강제로 포춘쿠키 보기
			//loadAry = ["F7"];
			
			if(loadAry[0] == "F7")
			{	//포춘쿠키 일때 
				loadAry[1] = "F7_Loop";
				loadAry[2] = "F7_Key";
			}
			init();
		}
		/**		*/
		private function setLoadAry(str:String):void
		{
			trace(str);
			
			//str = "바람";
			var num:int = Math.round(Math.random()*(3))+1;
			
			if(num > 2)
			{	//날씨 데이터 로드
				var wNum:int = -1;
				for(var i:int = 0; i<strAry.length; i++)
				{
					if(strAry[i] == str) 
					{
						setWeather(numAry[i]);
						return;
					}
				}
				if(wNum == -1) setDefault();
			}
			else
			{	//기본 데이터 
				setDefault();
			}

		}
		/**	기본 영상 내용 로드	*/
		private function setDefault():void
		{
			var num:int = Math.round(Math.random()*(2))+1;
			
			if(num > 1) num = 1;
			else num = 2;
			
			loadAry = [Asset.getIns().time07_11[1][num]];
		}
		/**	날씨데이터 적용	*/
		private function setWeather(num:int):void
		{
			var wAry:Array = Asset.getIns().time07_11[num];
			var num:int = Math.round(Math.random()*(wAry.length-2))+1;
			
			var str:String = wAry[num];
			loadAry = [str];
		}
		
		
		
		/**	영상 플레이	*/
		override protected function setPlayMc(mc:MovieClip,bPlay:String = "play"):void
		{
			super.setPlayMc(mc);
			if(loadAry[playPos] == "F7_Loop")
			{	//반복 수행 내용에 버튼 내용 적용
				cookieDir = true;
				cookieMax = 30;
				cookieSpeed = 1;
				var mc:MovieClip = getAsset();
				container.movieMc.addChild(mc.F7_Loop);
				var btn:MovieClip = mc.F7_Loop.btn as MovieClip;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK,onClickF7);
				btn.gotoAndPlay(2);
				btn.img.gotoAndPlay(1);
			}
		}
		/**	포춘 쿠키 클릭	*/
		private function onClickF7(e:MouseEvent):void
		{
			cookieDir = true;
			cookieMax += 20;
			cookieSpeed += 0.3;
			
			if(cookieMax >= 200) 
			{
				cookieMax = playMc.totalFrames;
				var mc:MovieClip = getAsset();
				var btn:MovieClip = mc.F7_Loop.btn as MovieClip;
				btn.removeEventListener(MouseEvent.CLICK,onClickF7);
			}
		}
		/**	인터렉티브 내용 적용	*/
		override protected function setInter():void
		{
			super.setInter();
			if(loadAry[playPos] == "F7_Key")
			{	//포춘쿠키 결과 내용 적용
				var num:int = (Math.random()*4)+1;
				sourceMc.txtMc.gotoAndStop(num);
				interSp.filters = [new BlurFilter(1.3,1.3)];
				interSp.alpha = 0.75;	
				//interSp.blendMode = BlendMode.MULTIPLY;
			}
		}
		/**	반복 수행 내용	*/
		override protected function onEnter(e:Event):void
		{
			super.onEnter(e);
			
			if(loadAry[playPos] == "F7" && playMc.currentFrame == 180)
			{
				sndPos = 1;
				delSnd();
				cookieSnd = new BGM(Global.getIns().rootURL+"asset/cookie_voice_loop.mp3",{volume:0.5});
			}
			
			if(loadAry[playPos] == "F7_Loop")
			{	//포춘쿠키 내용 
				F7Control();
			}
			if(loadAry[playPos] == "F7_Loop" && playMc.currentFrame > 260 && sndPos == 1)
			{
				sndPos = 2;
				delSnd();
				cookieSnd = new BGM(Global.getIns().rootURL+"asset/cookie_voice_final.mp3",{volume:0.5,repeat:0});
			}
		}
		/**	사운드 삭제	*/
		private function delSnd():void
		{
			if(cookieSnd != null)
			{
				cookieSnd.destroy();
				cookieSnd = null;
			}
		}
		/**	포춘쿠키 반복 수행 내용	*/
		private function F7Control():void
		{
			var cnt:int = Math.floor(cookieSpeed);
			
			for(var i:int = 1; i<=cnt; i++)
			{
				if(cookieDir == true) playMc.nextFrame();
				if(cookieDir == false) playMc.prevFrame();
			}
			
			if(playMc.currentFrame >= cookieMax) cookieDir = false;
			if(playMc.currentFrame == 1)
			{ 
				cookieMax = 30;
				cookieSpeed = 1;
				cookieDir = true;
			}
		}
	}//class
}//package
