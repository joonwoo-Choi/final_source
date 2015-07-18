package com.sw.utils
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 *	폰트 적용 (싱글톤 패톤)
	 * */
	public class SetFont
	{
		static private var ins:SetFont = new SetFont();
		
		/**	생성자	*/
		public function SetFont()
		{
			if(ins != null) new Error("SetFont는 싱글톤 임더.");
		}
		/**	소멸자	*/
		public function destroy():void
		{		}
		static public function getIns():SetFont
		{
			return ins;
		}
		/**
		 * 무비클립 안에 있는 텍스트 필드 폰트 적용 
		 * */
		public function go($txt:TextField,$obj:Object=null,$mc:MovieClip=null):TextField
		{
			//if($txt.embedFonts == true) return $txt;
			var mc:MovieClip = $txt.parent as MovieClip;
			//var mc:MovieClip = $mc;
			if(mc == null) throw new Error("SetFont, 텍스트필드 어미는 무비클립으로 부탁.");
			
			var txt:TextField = new TextField();
			
			var tf:TextFormat = $txt.getTextFormat();
			$obj.align = tf.align;
			
			txt.name = $txt.name;
			txt.selectable = $txt.selectable;
			txt.type = $txt.type;
			txt.wordWrap = $txt.wordWrap;
			
			txt.rotation = $txt.rotation;
			txt.x = $txt.x;	txt.y = $txt.y;
			txt.thickness = $txt.thickness;
			txt.sharpness = $txt.sharpness;
			//회전 값에 의해 넓이 높이 값이 바뀌는 경우 해결 코드
			if($txt.width*2 > $txt.height)
			{
				txt.width = $txt.width;
				txt.height = $txt.height;
			}
			else
			{
				txt.height = $txt.width;
				txt.width = $txt.height;
			}
			/*
			//txt.width = $txt.textWidth;
			//txt.height = $txt.textHeight;
			//txt.scaleX = $txt.scaleX;
			//txt.scaleY = $txt.scaleY;
			trace($txt.name,"---------------------------");
			trace($txt.rotation);
			trace($txt.width);
			trace($txt.height);
			*/
			txt.textColor = $txt.textColor;
			txt.autoSize = $txt.autoSize;
			txt.text = $txt.text;
			
			var txt_name:String = $txt.name;
			while(mc.getChildByName(txt_name) != null) mc.removeChild(mc.getChildByName(txt_name));
			
			mc.addChild(txt);
			$txt = null;
			mc[txt_name] = txt;
			SetText.space(txt,$obj);
			
			//trace(mc.numChildren);
			return txt;
		}
		
	}//class
}//package