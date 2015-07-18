package orpheus.templete.countDown.flipCount
{
	import orpheus.templete.countDown.CommaCtl;
	import orpheus.templete.countDown.CountUpDown;
	import orpheus.util.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class FlipCount extends CountUpDown
	{
		
		public function FlipCount(num:String,up:Boolean=false,numLength:int=-1)
		{
			super(num,up,numLength);
		}
		override public function setting():void
		{
			_model.wGap = 41;
			super.setting();
		}
		
		override protected function makeComma(num:int,numNum:int):void
		{
			// TODO Auto Generated method stub
			var comma:FlipComma = new FlipComma;
			comma.x = _model.coverBank[num-1].x+_model.coverBank[num-1].width-1;
			addChild(comma);
			var commaCtl:CommaCtl = new CommaCtl(comma);
			commaCtl.commaLifeNum = totalGroupNum-(num-1);
		}
		
		override protected function makeNumMC(num:int):void{
			var cover:FlipNumCon = new FlipNumCon();
			cover.myNum = num;
			cover.myLifeNum = totalGroupNum-num;
			cover.setting();
			addChild(cover);
			_model.coverBank.push(cover);
		}		
		
	}
}