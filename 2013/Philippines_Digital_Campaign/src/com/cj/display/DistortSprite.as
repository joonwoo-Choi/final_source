package com.cj.display
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class DistortSprite extends Sprite
	{
		private var _points: Vector.<Vector.<Point>>;
		
		private var _vertex:Vector.<Number>;
		private var _index:Vector.<int>;
		private var _uvdata:Vector.<Number>;
		private var _segments:int;
		private var _imgData:BitmapData;
		
		public function DistortSprite($segments:int=10)
		{
			super();
			_segments = $segments;
		}
		
		public function get imgData():BitmapData
		{
			return _imgData;
		}
		
		public function dispose():void
		{
			if(_imgData != null){
				_imgData.dispose();
				_imgData = null;
			}
		}

		public function addImage($imgData:BitmapData):void
		{
			if(_imgData != null){
				_imgData.dispose();
				_imgData = null;
			}
			_imgData = $imgData;
			createData();
		}
		
		public function draw($lt:Point, $rt:Point, $lb:Point, $rb:Point):void
		{
			if(_imgData==null) return;
			setDistort(this.graphics, $lt, $rt, $lb, $rb);
		}
		
		private function createData(): void
		{
			_points = new Vector.<Vector.<Point>>();
			_vertex = new Vector.<Number>();
			_index = new Vector.<int>();
			_uvdata = new Vector.<Number>();
			
			var px: Number;
			var k: int = 0;
			var uvx: Number;
			var uvy: Number;
			
			for ( var x: int = 0; x < _segments + 1; ++x )
			{
				_points[x] = new Vector.<Point>();
				px = ( x / _segments ) * _imgData.width;
				uvx = x / _segments;
				
				for ( var y: int = 0; y < _segments + 1; y++ )
				{
					var py: Number = ( y / _segments ) * _imgData.height;
					_points[x][y] = new Point( px, py );
					uvy = y / _segments;
					
					if ( y < _segments && x < _segments )
					{
						_index.push( k, k + _segments + 1, k + 1, k + _segments + 1, k + _segments + 2, k + 1 );
					}
					_uvdata.push( uvx, uvy );
					++k;
				}
			}
			/*
			_vertex.push(0, 0, 0, 0, 0, 0, 0, 0);
			_index.push(0, 1, 3, 1, 2, 3);
			_uvdata.push(0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1);*/
		}
		
		protected function setDistort(g:Graphics, no: Point, ne: Point, so: Point, se: Point): void
		{
			_vertex.length = 0;
			//_vertex.push(no.x, no.y, ne.x, ne.y, se.x, se.y, so.x, so.y);
			
			var dist1: Number = ne.y - no.y;
			var dist2: Number = se.y - so.y;
			var dist3: Number = so.x - no.x;
			var dist4: Number = se.x - ne.x;
			var ystep_min: Number = ( so.y - no.y ) / _segments;
			var xstep_min: Number = ( ne.x - no.x ) / _segments;
			var ystep1: Number = 0;
			var ystep2: Number = 0;
			var xstep1: Number = 0;
			var xstep2: Number = 0;
			var pt: Point;
			var k: int = 0;
				
			for ( var x: int = 0; x < _segments+1; ++x )
			{
				xstep1 = 0;
				xstep2 = 0;
				
				for ( var y: int = 0; y < _segments+1; ++y )
				{
					pt = _points[x][y];
					pt.y = no.y + ystep1 + ( ystep_min * y ) + ((( ystep2 / _segments ) * y ) - (( ystep1 / _segments ) * y ));
					pt.x = no.x + xstep1 + ( xstep_min * x ) + ((( xstep2 / _segments ) * x ) - (( xstep1 / _segments ) * x ));
					
					_vertex.push( pt.x, pt.y );
					xstep1 += ( dist3 / _segments );
					xstep2 += ( dist4 / _segments );
					
					k += 2;
				}
				ystep2 += ( dist2 / _segments );
				ystep1 += ( dist1 / _segments );
			}
			
			g.clear();
			//g.lineStyle(1, 0, .7);
			g.beginBitmapFill( _imgData, null, false, true );
			g.drawTriangles( _vertex, _index, _uvdata );
			g.endFill();
		}
	}
}