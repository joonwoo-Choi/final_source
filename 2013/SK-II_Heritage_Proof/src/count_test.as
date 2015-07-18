package 
{
	import com.adqua.util.CountUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class count_test extends Sprite
	{
		
		private var tf:TextField;
		
		private var count:CountUtil;
		
		public function count_test()
		{
			count = new CountUtil();
			
			tf = new TextField();
			this.addChild(tf);
			
			count.count(420, tf, 7);
		}
	}
}