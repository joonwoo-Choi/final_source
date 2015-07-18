package net
{
	import com.sw.net.FncOut;
	
	import util.Clock;

	/**		
	 *	SK2_Hersheys :: 외부 페이지 링크
	 */
	public class HersheysFncOut
	{
		
		//hersheyMenu(1,1);
		/**	생성자	*/
		public function HersheysFncOut()
		{	}
		
		/**	Q&A 로그인	*/
		static public function qnaLogin():void
		{
			Global.getIns().callbackSate = CallBack.QNA_LOGIN;
			FncOut.call("commonLogin");
		}
		/**	Q&A 페이스북 로그인	*/
		static public function qnaLoginFB():void
		{
			Global.getIns().callbackSate = CallBack.QNA_FACEBOOK;
			FncOut.call("fbLoginStatus");
		}
		/**
		 * 다이어트 게릴라 이벤트 
		 * @param str :: 입력한 내용
		 */		
		static public function sendEvent4(str:String):void
		{
			Global.getIns().callbackSate = CallBack.EVENT4_COMMENT;
			FncOut.call("guerilla4Validation",str);
		}
		/**	상단 벨소리 다운로드	*/
		static public function topDownBell():void
		{	
//			FncOut.call("downloadBell");	
			FncOut.call("downloadRing");	
		}
		/**	벨소리 다운 로드	*/
		static public function downBell():void
		{
			FncOut.call("guerilla3Pop",1);
		}
		/**	컬러링 다운로드	*/
		static public function downRing():void
		{
			FncOut.call("guerilla3Pop",2);
		}
		/**
		 *	외부 링크 
		 * @param depth1 :: 1뎁스 위치
		 * @param depth2 :: 2뎁스 위치
		 */
		static public function link(depth1:int,depth2:int = 1):void
		{
			if(depth1 == 2 && depth2 == 1) 
			{
				FncOut.call("alert","14일 체험단 모집 이벤트 기간이 종료 되었습니다.");
				return;
			}
			//FncOut.call("alert","hersheyMenu("+depth1+","+depth2+")");
			FncOut.call("hersheyMenu",depth1,depth2);
		}
		/**	14일 키트 구매하기 외부 링크	*/
		static public function buy():void
		{
			//FncOut.call("alert","14일 키트 구매하기");
			Clock.getIns().getCDate(goBuy);
			//http://www.hyundaihmall.com/front/shSectR.do?SectID=3149
		}
		static public function goBuy(date:Date):void
		{
			var link:String = "http://www.lotte.com/display/viewDispShop.lotte?disp_no=1692554";
			
			var date1:Date = new Date("Feb 03 2012 00:00:00");
			var date2:Date = new Date("Mar 01 2012 00:00:00");
			var date3:Date = new Date("Mar 26 2012 00:00:00");
			var date4:Date = new Date("Apr 16 2012 00:00:00");
			
			if(date.getTime() < date1.getTime()) link = "http://www.hyundaihmall.com/front/shSectR.do?SectID=3149";
			else if(date.getTime() < date2.getTime()) link = "http://www.hyundaihmall.com/front/shSectR.do?SectID=3149";
			else if(date.getTime() < date3.getTime()) link = "http://mall.shinsegae.com/display/display/planshop.do?disp_ctg_id=10004368#name";
			else if(date.getTime() < date4.getTime()) link = "http://www.lotte.com/display/viewDispShop.lotte?disp_no=1692554";
			
//			trace(date.getTime() , date3.getTime());
			
			FncOut.link(link,"_blank");
		}
		/**	준비중입니다 내용 노출	*/
		static public function comingsoon():void
		{
			FncOut.call("alert","coming soon");
		}
	}//class
}//package