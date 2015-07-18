package contents.qnaevent.event
{
	import flash.events.Event;
	
	/**		
	 *	SK2_Hersheys :: Q&A 이벤트
	 */
	public class QnAEvent extends Event
	{
		/**	QnA Step 이동	*/
		static public const STEP_MOVE:String = "movePos";
		static public const CHANGE_BTN_B:String = "changeBtnB";
		static public const CHANGE_BTN_A:String = "changeBtnA";
		
		/**	추가 데이터	*/
		public var data:Object;
		/**	이동할 위치	*/
		public var pos:int;
		
		/**	생성자	*/
		public function QnAEvent(type:String,$pos:int,$data:Object = null)
		{
			super(type, false, false);
			
			pos = $pos;
			data = $data;
			if(data == null) data = new Object();
		}
		
	}//class
}//package