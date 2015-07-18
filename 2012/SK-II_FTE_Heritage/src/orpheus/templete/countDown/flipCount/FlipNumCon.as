package orpheus.templete.countDown.flipCount
{
	import flash.display.Sprite;
	
	import orpheus.templete.countDown.CountUpDown;
	import orpheus.templete.countDown.NumCon;
	
	public class FlipNumCon extends NumCon
	{
		public function FlipNumCon()
		{
			super();
		}

		override public function setting():void
		{
			// TODO Auto Generated method stub
			for (var i:int = 0; i < _numBank[myNum].length; i++)
			{
				var numMC:CounterCon = new CounterCon;
				
				numMC.x = i*_model.wGap;
				addChild(numMC);
				for (var j:int = 0; j < 10; j++) 
				{
					var txtMC:Sprite = numMC["n"+j];
					txtMC.rotationX = 1;
					txtMC.rotationX = 0;
				}
				
				var numMCCtl:CounterConCtl = new CounterConCtl(numMC);
				numMCCtl.groupNum = myNum;
				numMCCtl.myNum = i;
				numMCCtl.myNumber = int(String(_numBank[myNum]).charAt(i));
				numMCCtl.myLifeNum = _numBank[myNum].length-i;
				numMCCtl.setting(_model.delTime[myNum]+i*100+_model.defaultDelay);
				_numMCBank.push(numMC);
			}
			if(myNum>0){
				x = _numConBank[myNum-1].x+_numConBank[myNum-1].width+_model.commaGap;
			}
		}		
	}
}