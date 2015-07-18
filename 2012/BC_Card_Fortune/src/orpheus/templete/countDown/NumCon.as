package orpheus.templete.countDown
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class NumCon extends Sprite
	{
		

		public var myNum:int;
		public var myLifeNum:int;
		private var _strPrev:Object;
		private var _strNow:Object;
		protected var _numConBank:Array;
		protected var _model:CountDownModel;
		protected var _numMCBank:Array = [];
		protected var _numBank:Array;
		public function NumCon()
		{
			super();
			
			_model = CountDownModel.getInstance();
			_model.addEventListener(CountDownEvent.NUMBER_CHANGED, onChanged);
			_numConBank = _model.coverBank;
			_numBank = _model.numBank;
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		protected function onRemoved(event:Event):void
		{
			// TODO Auto-generated method stub
			_model.removeEventListener(CountDownEvent.NUMBER_CHANGED, onChanged);
		}
		
		protected function onChanged(event:CountDownEvent):void
		{
			// TODO Auto-generated method stub
			if(myLifeNum>_model.numBank.length){
				_model.removeEventListener(CountDownEvent.NUMBER_CHANGED,onChanged);
				this.parent.removeChild(this);
				return;
			}
			_strPrev = _model.prevNumBank[myNum];
			trace("myNum: ",myNum);
			trace("_model.numBank[myNum]: ",_model.numBank[myNum]);
			_strNow= _model.numBank[myNum];
			if(_strNow.length==_strPrev.length){
				checkChangeNum();
			}else{
				
			}
		}
		
		private function checkChangeNum():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function setting():void
		{
			// TODO Auto Generated method stub
			for (var i:int = 0; i < _numBank[myNum].length; i++)
			{
				var numMC:NumberMC = new NumberMC;
				numMC.x = i*_model.wGap;
				if(i==0 && myNum==0){
					_model.hGap = numMC.height/_model.numHeightCnt;
					for (var j:int = 0; j < 10; j++) 
					{
						var ty:Number = (numMC.height*-1)+(_model.hGap*(_model.numHeightCnt-j));
						_model.moveTY.push(ty);
					}
				}
				numMC.y = numMC.height*-1+_model.hGap;
				
				var numMCCtl:NumberMCCtl = new NumberMCCtl(numMC);
				numMCCtl.groupNum = myNum;
				numMCCtl.myNum = i;
				numMCCtl.myNumber = int(String(_numBank[myNum]).charAt(i));
				numMCCtl.myLifeNum = _numBank[myNum].length-i;
				addChild(numMC);
				numMCCtl.setting(0);
				_numMCBank.push(numMC);
			}
			if(myNum>0){
				x = _numConBank[myNum-1].x+_numConBank[myNum-1].width+_model.commaGap;
			}
		}
	}
}