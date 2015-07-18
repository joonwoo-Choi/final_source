package com.sk2.clips
{
	import com.sw.net.list.BaseNumClip;
	import com.sw.utils.SetText;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * SK2	::	블로그 리스트 clip
	 * */
	public class BlogClip extends BaseNumClip
	{
		public var txt1:TextField;
		public var txt2:TextField;
		public var img_name:String;
		public var link_name:String;
		public var scrap:String;
		
		/**	생성자	*/
		public function BlogClip()
		{
			super();
			
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
		}
		/**	페이지 번호 적용	*/
		override public function set idx($no:int):void
		{	
			no = $no;
			txt1.text = String($no);
		}
		/**	텍스트 내용 적용	*/
		public function setText($txt1:String,$txt2:String):void
		{
			txt1.autoSize = TextFieldAutoSize.LEFT;
			txt2.autoSize = TextFieldAutoSize.LEFT;
			txt1.text = $txt1+"님의";
			txt2.text = $txt2;
			SetText.space(txt1,{letter:-1});
			SetText.space(txt2,{letter:0.5});
			txt2.x = txt1.x + txt1.width;
		}
	}//class
}//package