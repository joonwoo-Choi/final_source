package com.adqua.movieclip
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class MCAlign extends Sprite
	{
		private var _con:DisplayObject;
		public var cover:Sprite;
		private var _mcAlign:String;
		public function MCAlign(con:DisplayObject,mcAlign:String)
		{
			super();
			_mcAlign = mcAlign;
			_con = con;
			setting();
		}
		
		private function setting():void
		{
			// TODO Auto Generated method stub
			cover = new Sprite;
			switch(_mcAlign)
			{
				case "tr":
				{
					_con.x = _con.width*-1;
					cover.addChild(_con);
					cover.x = _con.width;
					break;
				}
			}
			addChild(cover);
		}
	}
}