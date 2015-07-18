package util
{
	import com.sw.net.Location;
	import com.sw.utils.SetText;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import net.LoaderClockWeather;
	
	/**		
	 *	SK2_Hershy :: 시계 (싱글톤) 
	 */
	public class Clock
	{
		/**	인스턴스	*/
		static private var ins:Clock;
		/**	데이터 로더	*/
		private var loader:LoaderClockWeather;
		/**	서버 시계	*/
		private var serverDate:Date;
		/**	서버 시계와 컴퓨터 시계의 차이	*/
		private var gap:Number;
		/**	시즌 문자	*/
		private var seasonStr:Array;
		/**	시간 타이밍 문자	*/
		private var hTimeStr:Array;
		
		/***/
		private var fncH:Array;
		private var fncSeasonDay:Array;
		private var fncCDate:Array;
		
		/**	생성자	*/
		public function Clock(time:String = "")
		{
			if(ins != null) throw new Error("Clock은 싱글톤 임묘.");
			
			if(time == "" && Location.setURL("local","web") == "local")
			{	//로컬 상에서 아무 시간 데이터도 없을 경우
				trace("locallllllllllllllllllll");
				time = "Apr 01 2012 07:21:47";
				setServerDate(time);
			}
			if(time == "" && Location.setURL("local","web") == "web")
			{	//웹상에서 아무시간 데이터 없을때 시간 가져와서 적용
				loadDate();
			}
			if(time != "") setServerDate(time);
			
//			loadDate();
//			if(time == "") serverDate = new Date();
//			else serverDate = new Date(time);	
//			["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
			
			init();
		}
		
		/**	인스턴스 반환	*/
		static public function getIns(time:String = ""):Clock
		{	
			if(ins == null) ins = new Clock(time);
			return ins;
		}
		/**	초기화	*/
		private function init():void
		{
			fncH = [];
			fncSeasonDay = [];
			fncCDate = [];
			
			seasonStr = ["발렌타인 데이","환절기","화이트 데이","다이어트"];
			hTimeStr = ["새벽","날씨","점심","시즌","밤"];
		}
		/**		*/
		private function loadDate():void
		{
			if(loader == null)
			{
				loader = new LoaderClockWeather(onLoadData);
				loader.load("time");
			}
		}
		private function setServerDate(str:String):void
		{
			trace("setServerData: ",str);
			serverDate = new Date(str);
			var date:Date = new Date();
			gap =  serverDate.getTime() - date.getTime();
		}
		/**	시간 시즌 배열 반환	*/
		public function getHTimeStr():Array
		{	return hTimeStr;	}
		
		/**	시즌 텍스트 배열 반환	*/
		public function getSeasonStr():Array
		{	return seasonStr;	}
		/**	
		 * 서버 시간 타이밍 반환	
		 * @param fnc :: (시즌 문자열)
		 */
		public function getHTime(fnc:Function):void
		{		
			if(serverDate != null) fnc(createH());
			else fncH.push(fnc);
		}
		/**	
		 * 현제 시간 반환	 
		 * @param fnc :: (Date)
		 */
		public function getCDate(fnc:Function):void
		{
			if(serverDate != null) fnc(createCDate());
			else fncCDate.push(fnc);			
		}
		/**
		 * 현제 시즌 반환 
		 * @param fnc :: [시즌문자,시즌문자열위치,날짜,영상위치,현제시간,이벤트상태(0:영상,1:FB팝업,2:Q&A)]
		 */
		public function getSeasonDay(fnc:Function):void
		{
			trace("getSeasonDay");
			trace("serverDate:::",serverDate);
			if(serverDate != null) {
				fnc(createSeasonDay());
			}else {
				fncSeasonDay.push(fnc);			
			}
		}
		
		/**	현제 시간 계산	*/
		private function createCDate():Date
		{	
			var date:Date = new Date();
			date.setTime(date.getTime()+gap);
			return date;
		}
		private function createH():String
		{	
			var hour:int = serverDate.getHours();
			
			if(0 <= hour && hour <= 6) return hTimeStr[0];
			if(7 <= hour && hour <= 11) return hTimeStr[1];
			if(12 <= hour && hour <= 13) return hTimeStr[2];
			if(14 <= hour && hour <= 18) return hTimeStr[3];
			if(19 <= hour && hour <= 23) return hTimeStr[4];
			
			return hTimeStr[3];
			//return serverDate.getHours();	
		}
		
		/**
		 * 현제 시즌 반환 
		 * @return [시즌문자,시즌문자열위치,날짜,영상위치,현제시간,이벤트상태(0:영상,1:FB팝업,2:Q&A)]
		 */
		private function createSeasonDay():Array
		{
			var ary:Array = [];
			
			var season:Date;
			var season1:Date = new Date("Feb 1 00:00:00 GMT+0900 2012");
			var season2:Date = new Date("Feb 15 00:00:00 GMT+0900 2012");
			var season3:Date = new Date("Feb 29 00:00:00 GMT+0900 2012");
			var season4:Date = new Date("Mar 14 00:00:00 GMT+0900 2012");
			var season5:Date = new Date("Mar 28 00:00:00 GMT+0900 2012");
			
//			ary[0] = "발렌타인데이";
//			ary[1] = 0;	
//			ary[2] = 1;
			
			ary[0] = "다이어트";
			ary[1] = 3;	
			ary[2] = 14;
			
			//trace(getCDate());
			var cDate:Date = createCDate();
			cDate.setHours(0);
			cDate.setMinutes(0);
			cDate.setSeconds(0);
			
			if(	cDate.getTime() >= season1.getTime() && 
				cDate.getTime() < season2.getTime())
			{
				ary[1] = 0;
				season = season1;
			}
			if(	cDate.getTime() >= season2.getTime() && 
				cDate.getTime() < season3.getTime())
			{
				ary[1] = 1;
				season = season2;
			}
			if(	cDate.getTime() >= season3.getTime() && 
				cDate.getTime() < season4.getTime())
			{
				ary[1] = 2;
				season = season3;
			}
			if(	cDate.getTime() >= season4.getTime() && 
				cDate.getTime() < season5.getTime())
			{
				ary[1] = 3;
				season = season4;
			}
			if(season != null)
			{	//시즌 문자, 시즌 몇일인지 
				season.setTime(cDate.getTime() - season.getTime());
				
				ary[0] = seasonStr[ary[1]];
				ary[2] = season.getDate();
			}
			//["발렌타인데이","환절기","화이트데이","다이어트"]
			
			//영상 위치 적용
			var num:int = (ary[1]*4)+1;
			
			if(ary[2] < 5) num += 0;
			else if(ary[2] < 10) num += 1;
			else if(ary[2] < 14) num += 2;
			else num += 3;
			
			//오후 2시 전에는 시즌 1개 뒤로
			var checkCDate:Date = createCDate();
			if(checkCDate.getHours() < 14)
			{
				if(	ary[2] == 1 || ary[2] == 5 ||
					ary[2] == 10 || ary[2] == 14 ) num--;
			}
			
			ary[3] = num;
			ary[4] = createCDate();
			
			var dateFB:Date = new Date("Mar 28 00:00:00 GMT+0900 2012");
			var dateQA:Date = new Date("Apr 2 14:00:00 GMT+0900 2012");
			trace("serverDate: ",serverDate);
			trace("dateQA: ",dateQA);
			trace("serverDate.getTime(): ",serverDate.getTime());
			trace("dateQA.getTime(): ",dateQA.getTime());

			if(serverDate.getTime() > dateQA.getTime()) 
			{	//Q&A
//				ary[5] = 2;
				ary[5] = 0;
			}
			else if(cDate.getTime() > dateFB.getTime()) ary[5] = 1; //facebook 팝업
			else ary[5] = 0;	//영상 이벤트
			
			return ary;
		}
		
		/**	외부 데이터 로드 완료*/
		private function onLoadData(str:String):void
		{
			//str = str.substr(0,str.lastIndexOf("/"));
			setServerDate(str);
			trace("serverTime: ",str);
			var i:int;
			
			for(i=0; i<fncH.length; i++)
			{
				fncH[i](createH());
			}
			for(i=0; i<fncSeasonDay.length; i++)
			{
				fncSeasonDay[i](createSeasonDay());			
			}
			for(i=0; i<fncCDate.length; i++)
			{
				fncCDate[i](createCDate());
			}
			//trace("fncSeasonDay:"+fncSeasonDay);
			
			fncH = [];
			fncSeasonDay = [];
			fncCDate = [];
		}
		
	}//class
}//package