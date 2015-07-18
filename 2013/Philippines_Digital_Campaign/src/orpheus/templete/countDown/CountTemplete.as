package orpheus.templete.countDown
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import orpheus.movieclip.TestButton;
	import orpheus.templete.countDown.flipCount.FlipCount;
	public class CountTemplete extends Sprite
	{
		private var $flipCount:FlipCount;
		private var $makeMC:Sprite;
		private var $firstNum:int;
		public function CountTemplete(firstNum:int)
		{
			$firstNum = firstNum;
			super();
			addEventListener(Event.ADDED_TO_STAGE, setting);
		}
		
		protected function setting(event:Event):void
		{
			// TODO Auto-generated method stub
			stage.scaleMode = "noScale";
			stage.align = "TL";
			$flipCount = new FlipCount(String(1000000+$firstNum),true);
			$flipCount.setting();
			$flipCount.x = -10;
			addChild($flipCount);
		}
		public function startMotion():void{
			$flipCount.startFlipMotion();
		}
		public function countUp():void
		{
			$flipCount.onCountDown();
		}
		
		public function countChange(newNum:int):void{
			$flipCount.countChange(newNum);
		}
		public function newCount(newNum:int):void{
			$flipCount.newCount(1000000+newNum);
		}
	}
}