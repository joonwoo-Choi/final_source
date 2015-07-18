package orpheus.templete.countDown.flipCount {
	import orpheus.templete.countDown.NumberMCCtl;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;

	/**
	 * @author CSI
	 */
	public class CounterConCtl extends NumberMCCtl {
		private var thisOne : Sprite;
		private var nextOne : Sprite;

		public function CounterConCtl(con:Sprite) {
			super(con);
		}
		override public function setting(del:Number):void{
			if(del==0) flip(myNumber);
			else setTimeout(flip,del,myNumber);;
		}		

		private function prepare() : void {
			thisOne = _con["n0"];
			nextOne = _con["n0"];
			defaultSetting();
		}

		private function defaultSetting() : void {
			for (var i : int = 0; i < _con.numChildren; i++) {
				var mc:Sprite = _con.getChildAt(i) as Sprite;
				mc["Top"].rotationX = 0;
				mc["Bot"].rotationX = 0;
			}
		}

		// variables 

		private var NewOnes : Number;
		private var NewTens : Number;

		private var OldOnes : Number = 0;
		private var OldTens : Number = 0;

		
		private var flipSpeed : Number = 0.40;

		public function flip(perc : Number) : void {
			NewOnes = perc % 10;
			NewTens = Math.floor(perc / 10);
			if(NewOnes != OldOnes) {
				FlipOnes();
				OldOnes = NewOnes;
			}
			if(NewTens != OldTens) {
				OldTens = NewTens;
			}	
		};

		private function FlipOnes() : void {
			thisOne = _con["n" + OldOnes];
			nextOne = _con["n" + NewOnes];
	
			setPositions();
			rotationMC(thisOne["Top"],0,90,"in",continueOnesTween);
			rotationMC(nextOne["Bot"],180,270,"in");
		}

		private function rotationMC(tmc : Sprite, or : int, tr: int,type:String, fn: Function=null) : void {
			tmc.rotationX = or;
			if(fn){
				if(type=="in")TweenLite.to(tmc, flipSpeed,{rotationX:tr,ease:Cubic.easeIn,onComplete:fn});
				else TweenLite.to(tmc, flipSpeed,{rotationX:tr,ease:Cubic.easeOut,onComplete:fn});
			}else{
				if(type=="in")TweenLite.to(tmc, flipSpeed,{rotationX:tr,ease:Cubic.easeIn});
				else TweenLite.to(tmc, flipSpeed,{rotationX:tr,ease:Cubic.easeOut});
			}
		}

		private function continueOnesTween() : void {
			_con.swapChildren(thisOne, nextOne);
			rotationMC(thisOne["Top"],90,180,"out");
			rotationMC(nextOne["Bot"],270,360,"out",continueOnesTween2);
		}
		
		private function continueOnesTween2() : void {
			thisOne["Top"].rotationX = 0;
		}
		
		private function setPositions() : void {
			var rest : Number = 7;
			
			_con.setChildIndex(thisOne, 9);
			_con.setChildIndex(nextOne, 8);
		
			for(var i : Number = 0;i <= 9;i++) {
				var tempObject : DisplayObject = _con["n" + i];
				if((tempObject != thisOne) && (tempObject != nextOne)) {
					_con.setChildIndex(tempObject, rest);
					rest--;
				}
			}
		}
	}
}
