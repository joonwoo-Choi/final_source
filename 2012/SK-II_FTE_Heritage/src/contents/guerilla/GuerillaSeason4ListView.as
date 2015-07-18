package contents.guerilla
{
	import com.sw.net.list.BaseList;
	
	import flash.display.MovieClip;
	
	import util.BtnHersheys;
	
	/**		
	 *	SK2_Hersheys :: 다이어티 개릴라 이벤트 리스트
	 */
	public class GuerillaSeason4ListView extends BaseGuerilla
	{
		private var list:GuerillaSeason4List;
		/**	상위 그래픽	*/
		private var mcAsset:MovieClip;
		
		/**	생성자	*/
		public function GuerillaSeason4ListView($btnMc:MovieClip, $viewMc:MovieClip)
		{
			mcAsset = $btnMc;
			$btnMc = mcAsset["J34_LIST_BTN"];
			
			super($btnMc, $viewMc);
			
			var numClass:Class = mcAsset.loaderInfo.applicationDomain.getDefinition("J34NumClip") as Class;
			var listClass:Class = mcAsset.loaderInfo.applicationDomain.getDefinition("J34ListClip") as Class;
			
			list = new GuerillaSeason4List(btnMc,listClass,numClass);		
			
			BtnHersheys.getIns().go(btnMc.btnNext,onClick);
		}
		/**	다음 영상 보기 버튼	*/
		private function onClick(mc:MovieClip):void
		{
			playNextMovie();
		}
	}//class
}//package