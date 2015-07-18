package contents
{
	import flash.display.MovieClip;
	
	import net.Track;
	
	
	/**		
	 *	SK2_Hershy :: Gallery
	 */
	[SWF(width="1004",height="727",frameRate="30")]
	public class Gallery extends BaseContent
	{
		private var container:ContentGalleryClip;
		
		/**	생성자	*/
		public function Gallery($data:Object = null)
		{
			super($data);
			container = new ContentGalleryClip();
			
			init();
			setTitle(4);
			setList(container);
			
			addChild(container);
		}
		/**	버튼 클릭	*/
		override protected function onClickList(mc:MovieClip):void
		{
			if(mc.idx == 1) Track.go("60","18");
			if(mc.idx == 2) Track.go("61","19");
			if(mc.idx == 3) Track.go("62","20");
			
			Global.getIns().viewPop("gallery",{pos:mc.idx});
		}
		
	}//class
}//package