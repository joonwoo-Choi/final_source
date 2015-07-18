package contents
{
	import contents.sub.PaperGallery;
	
	import flash.display.MovieClip;
	
	import net.HersheysFncOut;
	
	import util.BtnHersheys;

	/**		
	 *	SK2_Hershy :: 피테라 이야기 3
	 */
	[SWF(width="1004",height="727",frameRate="30")]
	public class Story3 extends BaseContent
	{
		private var container:ContentStory3Clip;
		
		/**	생성자	*/
		public function Story3($data:Object = null)
		{
			super($data);
			
			container = new ContentStory3Clip();
			addChild(container);
			init();
			setTitle(3);
			
			var paper:Story3PaperClip = new Story3PaperClip();
			BtnHersheys.getIns().go(paper.btn,onClickBuy);
			addChild(new PaperGallery(paper));		
		}
		
		/**	구매하러 가기 버튼 클릭	*/
		private function onClickBuy(mc:MovieClip):void
		{
			HersheysFncOut.buy();
		}
	}//class
}//package