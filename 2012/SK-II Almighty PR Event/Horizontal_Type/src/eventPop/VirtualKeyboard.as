package eventPop
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import eventPop.keyBoardMain.VirtualKeyboardMain;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0xffffff")]
	public class VirtualKeyboard extends Sprite
	{
		private var _clip:TestKeyboardClip;
		private var _keyboard:VirtualKeyboardMain;
		
		public function VirtualKeyboard()
		{
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event=null):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			_clip = new TestKeyboardClip();
			_clip.txt.selectable = false;
			_clip.txt.setSelection(0,0);
			
			
			_keyboard = new VirtualKeyboardMain(_clip);
			addChild(_clip);
		}
		
	}
}