package com.cj.display
{
	import com.greensock.TweenMax;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flashsandy.display.DistortImage;
	
	public class MenuRollingBox extends Sprite
	{
		private var _frontPlane:Sprite;
		private var _bottomPlane:Sprite;
		private var _frontImg:DistortImage;
		private var _bottomImg:DistortImage;
		
		private var _srcW:Number;
		private var _srcH:Number;
		private var _gap:Number;
		
		private var _isOver:Boolean;
		private var _src:DisplayObject;
		
		public function MenuRollingBox()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			
			visible = false;
		}
		
		public function initDraw(src:DisplayObject):void
		{
			_src = src;
			_srcW = src.width;
			_srcH = src.height;
			_gap = _srcW/3;
			
			///// FRONT ///////////////////////////////////////////////////////////////////
			var front:BitmapData = new BitmapData(_srcW, _srcH, true, 0x00ffffff);
			front.draw(src);
			
			_frontPlane = new Sprite;
			_frontImg = new DistortImage(_srcW, _srcH);
			_frontImg.initTransform(_frontPlane.graphics, front, new Point(),new Point(_srcW,0),new Point(_srcW,_srcH),new Point(0,_srcH));
			_frontPlane.scaleY = 0;
			_frontImg.setTransform(new Point(_srcW/2-_gap,0),new Point(_srcW/2+_gap,0),new Point(_srcW, _srcH),new Point(0,_srcH));
			addChild(_frontPlane);
			
			///// BOTTOM //////////////////////////////////////////////////////////////////
			var bottom:BitmapData = new BitmapData(_srcW, _srcH, true, 0x00ffffff);
			bottom.draw(src);
			
			_bottomPlane = new Sprite;
			_bottomImg = new DistortImage(_srcW, _srcH);
			_bottomImg.initTransform(_bottomPlane.graphics, bottom, new Point(),new Point(_srcW,0),new Point(_srcW, _srcH),new Point(0,_srcH));
			addChild(_bottomPlane);
		}
		
		public function downDraw(src:DisplayObject, index:int):void
		{
			if(index==0){
				// 초기화
				_bottomPlane.scaleY = 1;
				_bottomPlane.y = 0;
				_bottomImg.setTransform(new Point(),new Point(_srcW,0),new Point(_srcW, _srcH),new Point(0,_srcH));
				
				_frontPlane.scaleY = 0;
				_frontImg.setTransform(new Point(_srcW/2-_gap,0),new Point(_srcW/2+_gap,0),new Point(_srcW, _srcH),new Point(0,_srcH));
				
				bmdDraw(_bottomImg.bmd, src);
			}else{
				bmdDraw(_frontImg.bmd, src);
			}
		}
		
		public function upDraw(src:DisplayObject, index:int):void
		{
			if(index==0){
				// 초기화
				_bottomPlane.scaleY = 0;
				_bottomPlane.y = 0;
				_bottomImg.setTransform(new Point(),new Point(_srcW,0),new Point(_srcW/2+_gap, _srcH),new Point(_srcW/2-_gap,_srcH));
				
				_frontPlane.scaleY = 1;
				_frontImg.setTransform(new Point(),new Point(_srcW,0),new Point(_srcW, _srcH),new Point(0,_srcH));
				
				bmdDraw(_frontImg.bmd, src);
			}else{
				bmdDraw(_bottomImg.bmd, src);
			}
		}
		
		private function bmdDraw(bmd:BitmapData,src:DisplayObject):void
		{
			bmd.fillRect( new Rectangle(0,0,_srcW, _srcH), 0x00ffffff );
			bmd.draw(src);
		}
		
		public function rolling(isOver:Boolean, $delay:Number=0):void
		{
			_src.visible = false;
			visible = true;
			/*if(_isOver == isOver) return;
			_isOver = isOver;*/
			var sp:Number = .6;
			if(isOver){
				TweenMax.to(_frontPlane, sp, {scaleY:1, delay:$delay, onComplete:tweenComplete});
				tweenTransformImage(sp, _frontImg, 0, _srcW, _srcW/2-_gap, _srcW/2+_gap, true, $delay);
				
				TweenMax.to(_bottomPlane, sp, {scaleY:0, y:_srcH, delay:$delay});
				tweenTransformImage(sp, _bottomImg, _srcW/2-_gap, _srcW/2+_gap, 0, _srcW, false, $delay);
				
			}else{
				TweenMax.to(_frontPlane, sp, {scaleY:0, delay:$delay, onComplete:tweenComplete});
				tweenTransformImage(sp, _frontImg, _srcW/2-_gap, _srcW/2+_gap, 0, _srcW, true, $delay);
				
				TweenMax.to(_bottomPlane, sp, {scaleY:1, y:0, delay:$delay});
				tweenTransformImage(sp, _bottomImg, 0, _srcW, _srcW/2-_gap, _srcW/2+_gap, false, $delay);
				
			}
		}
		
		private function tweenComplete():void
		{
			_src.visible = true;
			visible = false;
		}
		
		private function tweenTransformImage(speed:Number, di:DistortImage, lx:Number, rx:Number, plx:Number, prx:Number, 
											 	isTop:Boolean=true, $delay:Number=0):void
		{
			var pt:Point = new Point(plx, prx);
			if(isTop) TweenMax.to(pt, speed, {x:lx, y:rx, delay:$delay, onUpdate:topTweenUpdate, onUpdateParams:[di, pt]});
			else TweenMax.to(pt, speed, {x:lx, y:rx, delay:$delay, onUpdate:bottomTweenUpdate, onUpdateParams:[di, pt]});
		}
		
		private function topTweenUpdate(di:DistortImage, pt:Point):void
		{
			di.setTransform(new Point(pt.x,0),new Point(pt.y,0),new Point(_srcW, _srcH),new Point(0,_srcH));
		}
		
		private function bottomTweenUpdate(di:DistortImage, pt:Point):void
		{
			di.setTransform(new Point(),new Point(_srcW,0),new Point(pt.y, _srcH),new Point(pt.x,_srcH));
		}
		
	}
}