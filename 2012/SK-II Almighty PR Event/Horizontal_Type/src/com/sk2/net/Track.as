package com.sk2.net
{
	import com.sw.net.FncOut;

	/**
	 * SK2	::	트래킹 체크
	 * */
	public class Track
	{
		/**	생성자	*/
		public function Track()
		{
			
		}
		/**	소멸자	*/
		public function destroy():void
		{		}
		/**	트래킹 체크	*/
		public function check($txt:String=""):void
		{	FncOut.call("piteraMenu.trackingPage",$txt);	}
		/**	2차 트래킹	*/
		public function check2($txt:String=""):void
		{	FncOut.call("piteraMenu.trackingPage2",$txt);	}
		
	}//class
}//package