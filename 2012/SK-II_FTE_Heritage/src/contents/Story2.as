package contents
{
	import away3d.loaders.Obj;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.display.PlaneClip;
	import com.sw.utils.McData;
	
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	
	import util.BtnHersheys;

	/**		
	 *	SK2_Hershy :: 피테라 이야기 2
	 */
	[SWF(width="1004",height="727",frameRate="30")]
	public class Story2 extends BaseContent
	{
		private var container:ContentStory2Clip;
		
		/**	생성자	*/
		public function Story2($data:Object = null)
		{
			super($data);
			
			container = new ContentStory2Clip();
			
			init();
			setList(container);
			
			addChild(container);
			setTitle(2);
		}
		
		override protected function onClickList(mc:MovieClip):void
		{
			var popAry:Array = ["","akita","five","tour"];
			Global.getIns().viewPop(popAry[mc.idx],{});
			
		}
	}//class
}//package