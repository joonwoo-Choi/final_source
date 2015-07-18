package orpheus.templete.countDown
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.StaticText;
	
	public class CountDownModel extends EventDispatcher
	{
		private static var main:CountDownModel;
		public var coverBank:Array=[];
		public var numHeightCnt:int = 11;//swc에 적힌 숫자의 개수...
		public var numBank:Array;
		public var prevNumBank:Array;
		public var hGap:Number;
		public var timerGap:Number = 0;
		public var wGap:int=7;
//		public var commaGap:int = 15;
		public var commaGap:int = -5;
		public var moveTY:Array=[];
		public var delTime:Array = [0,0,300];
		public var defaultDelay:Number = 0;
		public function CountDownModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():CountDownModel{
			if(!main) main = new CountDownModel;
			return main;
		}
	}
}