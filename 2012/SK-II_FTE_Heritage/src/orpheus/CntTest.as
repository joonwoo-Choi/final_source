package orpheus
{
	import adqua.movieclip.TestButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import orpheus.templete.countDown.PiteraCount;
	
	public class CntTest extends Sprite
	{
		private var _countDown:PiteraCount;
		private var _testBtn:Sprite;
		public function CntTest()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			// TODO Auto-generated method stub
			_countDown =new PiteraCount(1322);
			addChild(_countDown);
			_testBtn = TestButton.btn();
			_testBtn.y = 100;
			_testBtn.addEventListener(MouseEvent.CLICK,onClick);
			addChild(_testBtn);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			_countDown.countUp();
		}
	}
}