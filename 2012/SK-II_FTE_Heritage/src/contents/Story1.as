package contents
{
	import contents.sub.PaperGallery;

	/**		
	 *	SK2_Hershy :: 피테라 이야기 1
	 */
	[SWF(width="1004",height="727",frameRate="30")]
	public class Story1 extends BaseContent
	{
		private var container:ContentStory1Clip;
		
		/**	생성자	*/
		public function Story1($data:Object = null)
		{
			super($data);
			
			container = new ContentStory1Clip();
			addChild(container);
			init();
			setTitle(1);
			addChild(new PaperGallery(new Story1PaperClip()));		
		}

		
	}//class
}//package