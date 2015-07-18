package event
{
	import flash.events.Event;
	
	/**		
	 *	SK2_Hersheys :: 영상 제어 관련 이벤트
	 */
	public class MovieEvent extends Event
	{
		/**	영상 플레이	*/
		static public const PLAY:String = "MoviePlay";
		/**	영상 일지 정지	*/
		static public const STOP:String = "MovieStop";
		/**	다음 영상 플레이	*/
		static public const NEXT:String = "MovieNext";
		/**	이전 영상 플레이	*/
		static public const PREV:String = "MoviePrev";
		/**	영상 모두 플레이	*/
		static public const FINISH:String = "MovieFinish";
		/**	영상 처음 플레이	*/
		static public const FIRST:String = "MovieFirst";
		
		/**	영상 내용 교체 후 플레이	*/
		static public const MOVE_PLAY:String = "MovieMovePlay";
		
		/**	영상플레이 횟수 데이터 가져옴	*/
		static public const LOAD_MOVCNT:String = "LoadMovieCount";
		
		/**	영상 플레이 체크 구분 고정 문자열	*/
		static public const SEAONMOVIE:String = "seasonMovie";
		/**	영상 플레이 새벽 고정 문자열	*/
		static public const DAWNMOVIE:String = "dawnMovie";
		/**	영상 플레이 아침 고정 문자열	*/
		static public const MORNINGMOVIE:String = "morningMovie";
		/**	영상 플레이 점심 고정 문자열	*/
		static public const AFTERNOONMOVIE:String = "afternoonMovie";
		/**	영상 플레이 저녁 고정 문자열	*/
		static public const EVENINGMOVIE:String = "eveningMovie";
		
		
		/**	페이스북에서 영상 보는 중간 게릴라 이벤트 안내 내용 고지	*/
		static public const FACEBOOKPOPUP:String = "facebookPopup";
		
		/**	시즌 영상 경로	*/
		static public const SEASON_PATH:String = "season/";
		/**	임의 영상 경로	*/
		static public const RANDOM_PATH:String = "random/";
		/**	날씨 영상 경로	*/
		static public const WEATHER_PATH:String = "weather/";
		/**	QnA 경로는 아닌 표시	*/
		static public const Q_AND_A_PATH:String = "QnA";
		
		/**	
		 * 주고 받을 데이터  </br>
		 * pos :: 영상위치 </br>
		 * maxMovie :: 가장 많이 플레이된 영상 위치 </br>
		 * movieCnt :: 영상 플레이 총수 </br>
		 * */
		public var data:Object;
		
		/**	생성자	*/
		public function MovieEvent(type:String, $data:Object = null)
		{
			super(type, false, false);
			
			data = $data;
			if(data == null) data = new Object();
			
		}
		
		
	}//class
}//package