package orpheus.util
{
	import flash.text.TextField;

	public class Tracer
	{
		private static var _tf:TextField;
		private static var _txtDy:int = -234;
		private static var _txtDh:int = 470;
		public function Tracer()
		{
		}
		public static function setting(txt:TextField):void{
			_tf = txt;
		}
		
		public static function trace(... arguments){ 
			
			for(var i:int=0; i<arguments.length; i++){
				_tf.appendText(arguments[i]);
//				TextField(_tf).appendText(String(arguments.length));
			}
			
			_tf.appendText("\n");
			if(_tf.height>470){
				_tf.y = _txtDy-(_tf.height-_txtDh);
			}
		}		
	}
}