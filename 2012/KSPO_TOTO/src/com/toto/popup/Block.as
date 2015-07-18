package com.toto.popup
{
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Block extends Sprite
	{
		
		private var $con:MovieClip;
		/**	차단 비트맵 데이터	*/
		private var $bmd:BitmapData;
		/**	팝업 배경 차단	*/
		private var $block:Sprite;
		
		public function Block(con:MovieClip)
		{
			$con = con;
			
//			$bmd = new block(0,0);
//			$block = new Sprite;
//			$con.blockCon.addChild( $block );
//			
//			$con.stage.addEventListener(Event.RESIZE, resizeHandler);
//			resizeHandler();
		}
		
		private function resizeHandler(e:Event = null):void
		{
			$block.graphics.clear();
			$block.graphics.beginBitmapFill( $bmd );
			$block.graphics.drawRect( 0 , 0 , $con.stage.stageWidth , $con.stage.stageHeight );
			$block.graphics.endFill();
		}
	}
}