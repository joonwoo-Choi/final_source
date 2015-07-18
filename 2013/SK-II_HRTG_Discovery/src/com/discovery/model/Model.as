package com.discovery.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/**	공통 경로	*/
		public var defaultPath:String = "";
		
		public function Model(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public var isEmbedFont:Boolean;
		public const font_ygo540:String = "Yoon YGO 540_TT";
		
		public function initFont():void
		{
//			new YGO(); 
			
			var arr:Array = Font.enumerateFonts();
			var total:int = arr.length;
			var f:Font;
			for (var i:int = 0; i < total; i++) 
			{
				f = arr[i];
				trace("폰트 목록 : " + f.fontName);
				if(f.fontName == font_ygo540)
				{
					isEmbedFont = true;
					break;
				}
			}
		}
		
		public function setTextformat(tf:TextField):void
		{
			if(!isEmbedFont) return;
			
			var tm:TextFormat = new TextFormat(font_ygo540);
			tf.embedFonts = true;
//			tf.antiAliasType = AntiAliasType.ADVANCED;
//			tf.gridFitType = GridFitType.SUBPIXEL;
			tf.defaultTextFormat = tm;
		}
		
		/**	인스턴스 반환	*/
		static public function getInstance():Model
		{
			return $model;
		}
	}
}