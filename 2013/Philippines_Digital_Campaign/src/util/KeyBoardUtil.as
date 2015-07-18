package util
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class KeyBoardUtil
	{
		public function KeyBoardUtil()
		{
		}
		public static function checkNumPad(keyCode:uint,$keymenuMcBank:Array):void{
			switch(keyCode)
			{
				case Keyboard.NUMBER_0:
				{
					MovieClip($keymenuMcBank[0]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_0:
				{
					MovieClip($keymenuMcBank[0]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_1:
				{
					MovieClip($keymenuMcBank[1]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_1:
				{
					MovieClip($keymenuMcBank[1]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_2:
				{
					MovieClip($keymenuMcBank[2]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_2:
				{
					MovieClip($keymenuMcBank[2]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_3:
				{
					MovieClip($keymenuMcBank[3]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_3:
				{
					MovieClip($keymenuMcBank[3]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_4:
				{
					MovieClip($keymenuMcBank[4]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_4:
				{
					MovieClip($keymenuMcBank[4]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_5:
				{
					MovieClip($keymenuMcBank[5]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_5:
				{
					MovieClip($keymenuMcBank[5]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_6:
				{
					MovieClip($keymenuMcBank[6]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_6:
				{
					MovieClip($keymenuMcBank[6]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_7:
				{
					MovieClip($keymenuMcBank[7]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_7:
				{
					MovieClip($keymenuMcBank[7]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_8:
				{
					MovieClip($keymenuMcBank[8]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_8:
				{
					MovieClip($keymenuMcBank[8]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMBER_9:
				{
					MovieClip($keymenuMcBank[9]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.NUMPAD_9:
				{
					MovieClip($keymenuMcBank[9]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				case Keyboard.BACKSPACE:
				{
					MovieClip($keymenuMcBank[10]).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					break;
				}
				default:
				{
					break;
				}
			}			
		}
	}
}