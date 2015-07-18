package com.cj.progress
{
	
	public class SProgressBar
	{
		private var _loadedValue:Number;
		private var _totalValue:Number;
		
		public function SProgressBar(){ super(); }
		
		public function initProgress():void
		{
			_loadedValue = 0;
			_totalValue = 0;
			
			showInitProgress();
		}
		
		public function setProgress($loadedValue:Number, $totalValue:Number):void
		{
			_loadedValue = $loadedValue;
			_totalValue = $totalValue;
			
			showSetProgress();
		}
		
		public function completeProgress($totalValue:Number = 100):void
		{
			_loadedValue = $totalValue;
			_totalValue = $totalValue;
			
			showCompleteProgress();
		}
		
		protected function getPercent():uint
		{
			var value:uint = Math.round(_loadedValue * (100 / _totalValue));
			return value;
		}
		
		// ----- 추상 메서드 ----------------------------------------------------------------
		
		protected function showInitProgress():void
		{
			trace("오버라이드한 후 사용하세요");
		}
		
		protected function showSetProgress():void
		{
			trace("오버라이드한 후 사용하세요");
		}
		
		protected function showCompleteProgress():void
		{
			trace("오버라이드한 후 사용하세요");
		}
	}
}