package com.cj.display
{
	import com.cj.interfaces.IBitmapEffect;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 화면전환 이펙트를 위한 비트맵레이어 
	 * @author cj
	 * 
	 */	
	public class BitmapLayer extends Sprite
	{
		private var _layers:Vector.<Bitmap>;
		
		public function BitmapLayer($totalLayer:int)
		{
			super();
			mouseEnabled = mouseChildren = false;
			
			_layers = new Vector.<Bitmap>($totalLayer);
			for (var i:int = 0; i < $totalLayer; i++) 
			{
				_layers[i] = new Bitmap(null, "auto", true);
				addChild(_layers[i]);
			}
			
		}

		public function get layers():Vector.<Bitmap>
		{
			return _layers;
		}

		/**
		 * 비트맵데이터 만들기 
		 * @param dop
		 * @param layerIndex
		 * @param reflection
		 * 
		 */		
		public function drawMap(dop:DisplayObject, layerIndex:int, reflection:Boolean=false, dopW:Number=0, dopH:Number=0):void
		{
			var layer:Bitmap = _layers[layerIndex];
			if(layer.bitmapData != null){
				layer.bitmapData.dispose();
				layer.bitmapData = null;
			}
			layer.bitmapData = createBitmapData((dopW == 0) ? dop.width : dopW, (dopH == 0) ? dop.height : dopH);
			
			var mt:Matrix;
			if(reflection){
				mt = new Matrix(-1, 0, 0, 1, dop.width);
			}
			
			layer.bitmapData.fillRect(new Rectangle(0,0,dop.width,dop.height),0x00000000);
			layer.bitmapData.draw(dop, mt);
		}
		
		
		/**
		 * 이펙트 실행 
		 * @param ef
		 * @param layerIndex
		 * @param onComplete
		 * @param showDelay
		 * 
		 */		
		public function showEffect(ef:IBitmapEffect, layerIndex:int, data:Object, showDelay:Number=0):void
		{
			// 이전 엔터프레임 있다면 삭제..
			if(hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, enterframe);
			}
			
			// 딜레이 타임이 있다면..
			if(showDelay > 0){
				var frameRate:int = (stage) ? stage.frameRate : 30;
				var time:Number= showDelay * frameRate;
				var cnt:int=0;
				addEventListener(Event.ENTER_FRAME, enterframe);
				
			}else{
				// 다음 화면 등장 효과
				ef.execute(_layers[layerIndex], data);
			}
			
			
			function enterframe(e:Event):void
			{
				cnt ++;
				if(cnt > time){
					// 다음 화면 등장 효과
					ef.execute(_layers[layerIndex], data);
					removeEventListener(Event.ENTER_FRAME, enterframe);
				}
			}
		}
		
		
		private function createBitmapData(srcW:Number, srcH:Number):BitmapData
		{
			return new BitmapData(srcW, srcH, true, 0x00000000);
		}
		
		private function removeBitmap(bt:Bitmap):void
		{
			if(bt == null) return;
			if(bt.bitmapData){
				bt.bitmapData.dispose();
				bt.bitmapData = null;
			}
			if(contains(bt)) removeChild(bt);
			bt = null;
		}
		
		public function removeLayers():void
		{
			var total:int = _layers.length;
			for (var i:int = 0; i < total; i++) 
			{
				removeBitmap(_layers[i]);
			}
			_layers = null;
		}
	}
}