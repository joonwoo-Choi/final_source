package orpheus.templete.countDown
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import orpheus.util.StringUtil;
	
	public class CountUpDown extends Sprite
	{
		private var _num:String;
		public var totalGroupNum:uint;


		private var _timer:Timer;
		private var _orignNum:Number;
		protected var _model:CountDownModel;
		private var _addNum:String;
		private var _numLength:int;
		private var _up:int;
		public function CountUpDown(num:String,up:Boolean=false,numLength:int = -1)
		{
			super();
			_up = (up)?1:-1;
			_model = CountDownModel.getInstance();
			_orignNum = Number(num);
			_numLength = numLength;
			_addNum = (numLength==-1)?String(num):makeAddNum()+num;
			_num = StringUtil.comma(_addNum);
		}
		
		private function makeAddNum():String
		{
			// TODO Auto Generated method stub
			var num = _numLength-String(_orignNum).length;
			var str:String="";
			for (var i:int = 0; i < _numLength; i++) 
			{
				str = str+"0";
			}
			
			return str;
		}
		
		public function setting():void
		{
			// TODO Auto Generated method stub
			if(_model.timerGap>0){
				_timer = new Timer(_model.timerGap);
				_timer.addEventListener(TimerEvent.TIMER, onCountDown);
				setTimeout(_timer.start,2000);
			}
			_model.numBank = _num.split(",");
			totalGroupNum = _model.numBank.length;
			for (var i:int = 0; i < _model.numBank.length; i++) 
			{
				makeNumMC(i);
				if(i>0){
					makeComma(i,_model.numBank[i].length);
				}
			}
		}
		
		public function onCountDown(event:TimerEvent=null):void
		{
			// TODO Auto-generated method stub
			_orignNum = _orignNum+_up;
			_addNum = (_numLength==-1)?String(_orignNum):makeAddNum()+_orignNum;
			_num = StringUtil.comma(_addNum);
			_model.prevNumBank = _model.numBank;
			_model.numBank = _num.split(",");
			_model.dispatchEvent(new CountDownEvent(CountDownEvent.NUMBER_CHANGED));
		}
		
		public function countChange(newCnt:int):void
		{
			_orignNum = _orignNum+newCnt;
			_addNum = (_numLength==-1)?String(_orignNum):makeAddNum()+_orignNum;
			_num = StringUtil.comma(_addNum);
			_model.prevNumBank = _model.numBank;
			_model.numBank = _num.split(",");
			_model.dispatchEvent(new CountDownEvent(CountDownEvent.NUMBER_CHANGED));			
		}
		
		public function newCount(newCnt:int):void{
			_orignNum = newCnt;
			_addNum =makeAddNum()+_orignNum;
			_num = StringUtil.comma(_addNum);
			_model.prevNumBank = _model.numBank;
			_model.numBank = _num.split(",");
			_model.dispatchEvent(new CountDownEvent(CountDownEvent.NUMBER_CHANGED2));			
		}
		
		protected function makeComma(num:int,numNum:int):void
		{
			// TODO Auto Generated method stub
			var comma:Comma = new Comma;
			comma.x = _model.coverBank[num-1].x+_model.coverBank[num-1].width;
			addChild(comma);
			var commaCtl:CommaCtl = new CommaCtl(comma);
			commaCtl.commaLifeNum = totalGroupNum-(num-1);
		}
		
		protected function makeNumMC(num:int):void{
			var cover:NumCon = new NumCon();
			cover.myNum = num;
			cover.myLifeNum = totalGroupNum-num;
			cover.setting();
			addChild(cover);
			_model.coverBank.push(cover);
		}
	}
}