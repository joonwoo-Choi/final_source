package orpheus.control.scrollbar
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import orpheus.control.scrollbar.events.ScrollEvent;
	import orpheus.movieclip.TestButton;
	
	public class BasicScrollEx extends BasicScroll
	{
		private var $rectSp:Sprite;
		private var $scrollType:String;
		private var $maxW:int;
		private var $maxH:int;
		public function BasicScrollEx(scrollMC:MCScrollW, rect:Rectangle, wheelArea:DisplayObject=null, mouseWheel:Boolean=false)
		{
			super(scrollMC.mcControl, rect, wheelArea, mouseWheel);
			var tw:int
			var th:int
			if(rect.width>rect.height){
				$scrollType = "W";
				tw = rect.width+scrollMC.mcControl.width;
				th = scrollMC.mcControl.height;
				$maxW = tw-scrollMC.mcControl.width;
				trace("$maxW: ",$maxW);
			}else{
				$scrollType = "H";
				th = rect.height+scrollMC.mcControl.height
				tw = scrollMC.mcControl.width;
				$maxH = th-scrollMC.mcControl.height;
			}
			trace("$scrollType: ",$scrollType);
			$rectSp = scrollMC.mcArea;
			$rectSp.x = rect.x;
			$rectSp.y = rect.y;
			//$rectSp.alpha = 0;
			$rectSp.addEventListener(MouseEvent.CLICK,onRectSpClick);
		}
		
		protected function onRectSpClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if($maxW>0){
				var tx:int = (btn.parent.mouseX>$rectSp.x+$rectSp.width-btn.width)?$rectSp.x+$rectSp.width-btn.width:btn.parent.mouseX-btn.width/2;
				if(tx<$rectSp.x)tx = $rectSp.x;
				TweenLite.to(btn,.5,{x:tx,onComplete:moveComplete});
			}else {
				var ty:int = (btn.parent.mouseY>$rectSp.y+$rectSp.height-btn.height)?$rectSp.y+$rectSp.height-btn.height:btn.parent.mouseY-btn.height/2;
				if(ty<$rectSp.y)tx = $rectSp.y;
				TweenLite.to(btn,.5,{y:ty,onComplete:moveComplete});
			}
		}
		
		private function moveComplete():void
		{
			// TODO Auto Generated method stub
			moveHandler();
			stopDragHandler();
//			dispatchEvent(new ScrollEvent(ScrollEvent.CHANGE, _value));
//			trace("_value: ",_value);
		}
	}
}