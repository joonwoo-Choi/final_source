package orpheus.control.scrollbar 
{

	import orpheus.control.scrollbar.BasicScroll;
	import orpheus.control.scrollbar.events.ScrollEvent;
	import adqua.util.MathUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author p2ri
	 * 
	 */
	public class StepScroll extends BasicScroll 
	{
		private var _step : Number;
		private var gap : Number;
		private var _location : Number;
		private var _fixBtnSize : Boolean;

		public function StepScroll(btn : Sprite, rect : Rectangle, step : Number = 0, fixBtnSize : Boolean = false, wheelArea : DisplayObject = null, mouseWheel : Boolean = false )
		{
			super(btn, rect, wheelArea, mouseWheel);
			this.fixBtnSize = fixBtnSize;
			this.step = step;
		}

		override public function setSize(contentWidth : Number, maskMc : Number = NaN) : void
		{
			rect[_type] = oriRect[_type];
			
			step = Math.ceil(contentWidth / maskMc);
			if (step < 0) step = 0;
		}

		override protected function adjust() : void
		{
			_location = MathUtil.multipleRound(btn[_direction] - rect[_direction], gap);
			adjustBtn(_location);
		}

		override protected function stopTween() : void
		{
			TweenLite.killTweensOf(btn);
		}

		override protected function getValue() : Number
		{
			return Math.round((btn[_direction] - rect[_direction]) / rect[_type] * step);
		}

		override public function set value(value : Number) : void
		{
			_value = value;
			
			var obj : Object = new Object();
			obj[_direction] = int(_value * gap) + rect[_direction];
			obj["ease"] = Cubic.easeOut;
			TweenLite.to(btn, 0.3, obj);
		}

		override protected function wheelHandler(event : MouseEvent) : void
		{
			if (btn.stage) if (btn.stage.hasEventListener(MouseEvent.MOUSE_UP)) stopDragHandler();
			
			var wheelCheck : Boolean = false;
			if (_mouseWheel && btn.stage)
			{
				if (_wheelArea)
				{
					if (_wheelArea.hitTestPoint(btn.stage.mouseX, btn.stage.mouseY))
					{
						wheelCheck = true;
					}
				}
				else
				{
					wheelCheck = true;
				}
			}
			if (wheelCheck)
			{
				var tmp : Number = _value;
				if (event.delta > 0 && _value > 0)
				{
					value = _value - 1;
				}
				else if (event.delta < 0 && _value < step - 1)
				{
					value = _value + 1;
				}
				if (_value == tmp) return;
				
				dispatchEvent(new ScrollEvent(ScrollEvent.CHANGE, _value));
				dispatchEvent(new ScrollEvent(ScrollEvent.MOUSE_WHEEL, event.delta));
			}
		}

		public function adjustBtn(tg : Number) : void
		{
			var obj : Object = new Object();
			obj[_direction] = int(tg + rect[_direction]);
			obj["ease"] = Cubic.easeOut;
			TweenLite.to(btn, 0.3, obj);
		}

		public function get step() : Number
		{
			return _step;
		}

		public function set step(step : Number) : void
		{
			_step = step;
			if (!_fixBtnSize) 
			{
				btnSize = rect[_type] / _step;
				gap = (rect[_type] + btnSize) / step;
			}
			else 
			{
				gap = rect[_type] / step;
			}
			trace(_step, btnSize, gap);
		}

		public function get fixBtnSize() : Boolean
		{
			return _fixBtnSize;
		}

		public function set fixBtnSize(fixBtnSize : Boolean) : void
		{
			_fixBtnSize = fixBtnSize;
		}
	}
}
