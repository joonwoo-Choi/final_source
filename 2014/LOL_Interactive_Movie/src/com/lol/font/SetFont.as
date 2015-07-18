package com.lol.font
{
	
	import com.lol.model.Model;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SetFont
	{
		
		private var _model:Model = Model.getInstance();
		
		public function SetFont(){	}
		
		public function setYgdFont(tf:TextField):void
		{
			var tm:TextFormat = new TextFormat(_model.fontYgd.fontName);
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.SUBPIXEL;
			tf.defaultTextFormat = tm;
		}
		
		public function setRixFont(tf:TextField):void
		{
			var tm:TextFormat = new TextFormat(_model.fontRix.fontName);
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.SUBPIXEL;
			tf.defaultTextFormat = tm;
		}
	}
}