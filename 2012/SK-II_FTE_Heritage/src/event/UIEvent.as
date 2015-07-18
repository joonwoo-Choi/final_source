package event
{
	import flash.events.Event;
	
	/**		
	 *	SK2_Hersheys :: 메뉴, 이벤트
	 */
	public class UIEvent extends Event
	{
		/**	우측 영상 리스트 텝 보여지기	*/
		static public const TAB_VIEW:String = "tabView";
		/**	우측 영상 리스트 텝 가려지기	*/
		static public const TAB_HIDE:String = "tabHide";
		
		/**	상단 시즌 내용 출력 내용 보여지기	*/
		static public const TOP_SEASON_VIEW:String = "topSeasonView";
		/**	상단 시즌 내용 출력 내용 가려지기	*/
		static public const TOP_SEASON_HIDE:String = "topSeasonHide";
		
		
		/**	생성자	*/
		public function UIEvent(type:String)
		{
			super(type, false, false);
		
		}
		
		
	}//class
}//package