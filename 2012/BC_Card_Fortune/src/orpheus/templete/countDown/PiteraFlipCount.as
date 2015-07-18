package orpheus.templete.countDown
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import orpheus.movieclip.TestButton;
	import orpheus.templete.countDown.flipCount.FlipCount;

	[SWF(width="520", height="1079", frameRate="48", backgroundColor="0x666666")]	
	public class PiteraFlipCount extends Sprite
	{

		private var _flipCount:FlipCount;
		private var testbtn:Sprite;
		public function PiteraFlipCount()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, setting);
		}
		
		protected function setting(event:Event):void
		{
			// TODO Auto-generated method stub
			stage.scaleMode = "noScale";
			stage.align = "TL";
			_flipCount = new FlipCount("1000000",true);
			_flipCount.setting();
//			_flipCount.x = (stage.stageWidth-_flipCount.width)/2;
//			_flipCount.y = (stage.stageHeight-_flipCount.height)/2;
			trace("_flipCount: ",_flipCount.width);
			addChild(_flipCount);
			testbtn = TestButton.btn(_flipCount.width);
			testbtn.y = 100;
			testbtn.addEventListener(MouseEvent.CLICK,onClick);
			addChild(testbtn);

		}
		
		protected function onClick(event:MouseEvent):void
		{
			_flipCount.onCountDown();
			// TODO Auto-generated method stub
			
		}
		
	}
}