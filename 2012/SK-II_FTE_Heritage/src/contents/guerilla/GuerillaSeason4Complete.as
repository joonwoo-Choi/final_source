package contents.guerilla
{
	import flash.display.MovieClip;
	
	/**		
	 *	SK2_Hersheys :: 다이어트 게릴라 이벤트 완료 모습
	 */
	public class GuerillaSeason4Complete extends GuerillaSeason2Complete
	{
		/**	생성자	*/
		public function GuerillaSeason4Complete($btnMc:MovieClip, $viewMc:MovieClip)
		{
			super($btnMc, $viewMc);
		
			btnMc.scaleX = 1;
			gapY = -40;
		}
		
		
	}//class
}//package