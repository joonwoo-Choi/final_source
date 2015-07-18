package com.adqua.util
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class CountUtil
	{
		
		private var $tf:TextField;
		
		private var $cnt:Number;
		/**	"left" - "right" - "center" - "none"	*/
		private var $align:String;
		
		public function CountUtil()
		{
			$tf = new TextField();
		}
		
		/**	카운트 셋팅	*/
		public function count(cnt:Number, tf:TextField, time:Number, align:String="left"):void
		{
			$cnt = cnt;
			$tf = tf;
			$align = align;
			
			var mc:MovieClip = new MovieClip();
			mc.x = 0;
			TweenLite.to(mc, time, {x:100, onUpdate:countUpdate, onUpdateParams:[mc], ease:Expo.easeOut});
		}
		/**	카운팅	*/
		private function countUpdate(mc:MovieClip):void
		{
			var percent:Number = mc.x/100;
			$tf.text = String(int($cnt * percent));
			$tf.autoSize = $align;
		}
		
		/**	초기화	*/
		public function destroy():void
		{
			$tf = null;
		}
	}
}