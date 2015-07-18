package com.cj.utils 
{
	import flash.events.FocusEvent;
	import flash.text.TextField;

	public class TextFieldUtil
	{
		public function TextFieldUtil(){}
		
		/**
		 * 텍스트 길이 체크후 자르기 
		 * @param $txt
		 * @param $limitWidth
		 * @param $dot
		 * 
		 */		
		public static function restrictField( $txt:TextField, $limitWidth:int, $dot:String="..."):void
		{
			var p:int = $txt.getCharIndexAtPoint( $limitWidth, $txt.height/2);
			if(p == -1) return;
			$txt.text = $txt.text.slice(0,p) + $dot;
		}
		
		
		/**
		 * 여러텍스트 공백 체크하여 공백텍스트 인덱스 반환(-1 = 공백통과)
		 * @param $array
		 * @param $temp
		 * @return 
		 * 
		 */		
		static public function allCheckBlank( $array:Array, $temp:Array = null ):int
		{
			var chk:int = -1;
			var total:int = $array.length;
			
			for (var i:int = 0; i < total; i++) 
			{
				var txt:TextField = $array[i];
				var bool:Boolean;
				
				// 공백체크할 문자열 배열이 있을때만 값을 넘겨줌
				if ($temp != null) {
					bool = TextFieldUtil.checkBlank(txt.text, $temp[i]);
				}else {
					bool = TextFieldUtil.checkBlank(txt.text);
				}
				
				if ( bool ) {
					chk = i;
					break;
				}
			}
			return chk;
		}
		
		
		/**
		 * 문자열 공백체크 
		 * @param $str
		 * @param $temp
		 * @return 
		 * 
		 */		
		static public function checkBlank( $str:String, $temp:String = null ):Boolean
		{
			var len:uint = $str.length;
			var slen:uint = (($str + " ").match(/ /g)).length - 1;
			var bool:Boolean;
			
			if ($temp) {
				if ($str == $temp) bool = true;
			}
			
			if (len == slen) bool = true;
			return bool;
		}
		
		
		/**
		 * 텍스트필드 포커스 이벤트주기 
		 * @param txt
		 * @param str
		 * 
		 */		
		static public function addFocusEvent( txt:TextField, str:String ):void
		{
			txt.text = str;
			
			txt.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			txt.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			function focusIn(e:FocusEvent):void
			{
				if (txt.text == str) txt.text = "";
			}
			
			function focusOut(e:FocusEvent):void
			{
				if (txt.text == "") txt.text = str;
				txt.setSelection(0, 0);
			}
		}
		
	}
}