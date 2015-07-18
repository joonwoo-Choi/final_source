package com.sw.utils
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 *	원과 원 사이 녹은 것같은 표현 클래스
	 * 
	 * */
	public class Melt extends Sprite
	{
		public var shapeCom:Shape;
		public var canvas:MovieClip;
		public var mcAry:Array;		
		public var color:uint;
		public var smooth:int;
		
		public function Melt($data:Object)
		{
			fN_init($data);
		}
		
		public function fN_init($data:Object):void
		{
			mcAry = $data.mcAry;
			canvas = $data.canvas; 
			color = ($data.color) ? ($data.color) : (0x000000);
			smooth = ($data.smooth) ? ($data.smooth) : (20);
			
			shapeCom = new Shape();
			canvas.addChild(shapeCom);
			if($data.enter != false) fN_setEnter();
		}
		public function fN_setEnter():void
		{
			this.addEventListener(Event.ENTER_FRAME, fN_onEnter);
		}
		public function fN_removeEnter():void
		{
			this.removeEventListener(Event.ENTER_FRAME, fN_onEnter);
		}
		public function fN_onEnter(e:Event):void
		{
			shapeCom.graphics.clear();
			for(var i:int=0; i<mcAry.length; i++)
			{
				for(var j:int=0; j<mcAry.length; j++)
				{
					if(i >= j) continue;
					//trace(mcAry[i],mcAry[j]);
					fN_createCurve(mcAry[i],mcAry[j]);
				}
			}	
			
		}
		
		public function fN_createCurve($mc1:MovieClip,$mc2:MovieClip):void
		{
			var g1Ban:Number = $mc1.width / 2;
			var g2Ban:Number = $mc2.width / 2;
			var meetBall:Number = g1Ban + g2Ban;
			
			var getDistance:Number = Math.sqrt(Math.pow($mc1.x-$mc2.x, 2) + Math.pow($mc1.y-$mc2.y, 2));
			var getB2gili:Number = (Math.pow(g2Ban, 2)-Math.pow(g1Ban, 2)+Math.pow(getDistance, 2))/(2 * getDistance);
			var centerToB2:Number = Math.sqrt(Math.pow($mc1.x - $mc2.x, 2) + Math.pow($mc1.y - $mc2.y, 2));
			var centerToB1:Number = Math.sqrt(Math.pow($mc1.x - $mc2.x, 2) + Math.pow($mc1.y - $mc2.y, 2));
			var degree:Number = (Math.atan2($mc2.y - $mc1.y, $mc2.x - $mc1.x) + Math.PI) * 180 / Math.PI;
			var degree2:Number = (Math.atan2($mc1.y - $mc2.y, $mc1.x - $mc2.x) + Math.PI) * 180 / Math.PI;
			var giliCenter:Number = Math.sqrt(Math.pow(g2Ban, 2) - Math.pow(getB2gili, 2));
			
			var point1:Array = [];
			point1[0] = $mc2.x + Math.cos(degree / 180 * Math.PI) * getB2gili;
			point1[1] = $mc2.y + Math.sin(degree / 180 * Math.PI) * getB2gili;
			var pp1:Array = [];
			pp1[0] = point1[0] + Math.cos((degree - 90) / 180 * Math.PI) * giliCenter;
			pp1[1] = point1[1] + Math.sin((degree - 90) / 180 * Math.PI) * giliCenter;
			
			var b2Do:Number = Math.atan2(pp1.y - $mc2.y, pp1.x - $mc2.x) * 180 / Math.PI - degree;
			var b1Do:Number = Math.atan2(pp1.y - $mc1.y, pp1.x - $mc1.x) * 180 / Math.PI - degree;
			
			var pp2:Array = [];
			pp2[0] = point1[0] + Math.cos((degree + 90) / 180 * Math.PI) * giliCenter;
			pp2[1] = point1[1] + Math.sin((degree + 90) / 180 * Math.PI) * giliCenter;
			var ppp1:Array = [];
			ppp1[0] = point1[0] + Math.cos((degree - 90) / 180 * Math.PI) * (giliCenter + 10);
			ppp1[1] = point1[1] + Math.sin((degree - 90) / 180 * Math.PI) * (giliCenter + 10);
			var ppp2:Array = [];
			ppp2[0] = point1[0] + Math.cos((degree + 90) / 180 * Math.PI) * (giliCenter + 10);
			ppp2[1] = point1[1] + Math.sin((degree + 90) / 180 * Math.PI) * (giliCenter + 10);
			
			var _loc_2:Number = point1[0] + Math.cos((degree - 90) / 180 * Math.PI) * giliCenter;
			var _loc_3:Number = point1[1] + Math.sin((degree - 90) / 180 * Math.PI) * giliCenter;
			degree = (Math.atan2($mc2.y - $mc1.y, $mc2.x - $mc1.x) + Math.PI) * 180 / Math.PI;
			degree2 = (Math.atan2($mc1.y - $mc2.y, $mc1.x - $mc2.x) + Math.PI) * 180 / Math.PI;
			b2Do = Math.atan2(_loc_3 - $mc2.y, _loc_2 - $mc2.x) * 180 / Math.PI - degree;
			b1Do = Math.atan2(_loc_3 - $mc1.y, _loc_2 - $mc1.x) * 180 / Math.PI - degree;
			
			var aa1:Array = [];
			aa1[0] = $mc1.x + Math.cos((degree - b1Do - smooth) / 180 * Math.PI) * g1Ban;
			aa1[1] = $mc1.y + Math.sin((degree - b1Do - smooth) / 180 * Math.PI) * g1Ban;
			var aa2:Array = [];
			aa2[0] = $mc1.x + Math.cos((degree + b1Do + smooth) / 180 * Math.PI) * g1Ban;
			aa2[1] = $mc1.y + Math.sin((degree + b1Do + smooth) / 180 * Math.PI) * g1Ban;
			var bb1:Array = [];
			bb1[0] = $mc2.x + Math.cos((degree - b2Do + smooth) / 180 * Math.PI) * g2Ban;
			bb1[1] = $mc2.y + Math.sin((degree - b2Do + smooth) / 180 * Math.PI) * g2Ban;
			var bb2:Array = [];
			bb2[0] = $mc2.x + Math.cos((degree + b2Do - smooth) / 180 * Math.PI) * g2Ban;
			bb2[1] = $mc2.y + Math.sin((degree + b2Do - smooth) / 180 * Math.PI) * g2Ban;
			
			shapeCom.graphics.lineStyle(1, 16711680, 0);
			shapeCom.graphics.beginFill(color, 100);
			shapeCom.graphics.moveTo(bb2[0], bb2[1]);
			shapeCom.graphics.curveTo(pp1[0], pp1[1], aa2[0], aa2[1]);
			shapeCom.graphics.lineTo(bb1[0], bb1[1]);
			shapeCom.graphics.curveTo(pp2[0], pp2[1], aa1[0], aa1[1]);
			shapeCom.graphics.endFill();
		}
	}
}