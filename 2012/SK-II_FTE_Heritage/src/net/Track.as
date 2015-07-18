package net
{
	import com.sw.net.FncOut;

	/**		
	 *	SK2_Hersheys :: 트래킹 호출
	 */
	public class Track
	{
		/**	생성자	*/
		public function Track()
		{}
		/**	트래킹 호출*/
		static public function go(pos1:String,pos2:String):void
		{
			FncOut.call("realTracking",pos1,pos2);
			FncOut.call("googleSender","hershey",pos1+pos2);
		}
		
	}//class
}//package