// 		Petri Leskinen, leskinen[dot]petri[at]luukku.com
//		July 2008,  Espoo, Finland
//		November 2008, line 100: var derG:Number =1.0/bitmapData.height;
//		fix for correct scaling in y-direction
package com.cj.display
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.Point;
	
	public class FreeTransform extends Sprite 
	{
		private var n:int =8; 	// number of divisions in x-dim.
		private var m:int =5;	// number of divisions in y-dim.
		private var _bitmapData:BitmapData;
		
		public var dstPoints:Array ;	// 8 포인트에 대한 새로운 위치
		public var srcPoints:Array ;	// 직교의 원래 위치 좌표
		
		private var _vertices:Vector.<Number>;
		private	 var _indices:Vector.<int>;
		private	 var _uvtData:Vector.<Number>;
		
		public function FreeTransform(bmp:BitmapData, sizeX:int =15, sizeY:int =10) 
		{
			this._bitmapData = bmp;
			this.n = sizeX;
			this.m = sizeY;
			
			init();
			reCount();
		}
		
		public function dispose():void
		{
			if(_bitmapData){
				_bitmapData.dispose();
				_bitmapData = null;
			}
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
		}
		
		public function init():void 
		{
			//	0	1	2
			//	3		4
			//	5	6	7
			srcPoints = [
				new Point(0,0),
				new Point(_bitmapData.width/2,0),
				new Point(_bitmapData.width,0),
				
				new Point(0,_bitmapData.height/2),
				new Point(_bitmapData.width,_bitmapData.height/2),
				
				new Point(0,_bitmapData.height),
				new Point(_bitmapData.width/2,_bitmapData.height),
				new Point(_bitmapData.width,_bitmapData.height)
			];
			
			for each (var po:Point in srcPoints) {
				po.x += Math.random()*0.5;	// adding some random will remove 
				po.y += Math.random()*0.5;	// divisions by zero when solving the equitations
			}
			
			dstPoints = [
				new Point(0,0),
				new Point(_bitmapData.width/2,0),
				new Point(_bitmapData.width,0),
				
				new Point(0,_bitmapData.height/2),
				new Point(_bitmapData.width,_bitmapData.height/2),
				
				new Point(0,_bitmapData.height),
				new Point(_bitmapData.width/2,_bitmapData.height),
				new Point(_bitmapData.width,_bitmapData.height)
			];
		}
		
		public function reCount():void 
		{
			var i:int=0;
			var j:int=0;
			
			//	the new location for a point(x,y) is counted by functions (fx(x,y),fy(x,y))
			//	there are 12 coefficients which are solved by a group of equitations (Mx,My)
			//	we know the new coordinates in 8 points, and functions derivatives in 4 locations
			// 
			//	f(x,y) = A	+B*x	+C*x2	+D*x3	+E*y	+F*xy 	+Gx2y	+Hx3y	+Iy2	+Jxy2	+Ky3	+Lxy3
			//	f'x	= 		+B		+2Cx	+3Dx2			+Fy		+2gxy	+3Hx2y			+Jy2			+Ly3
			//	f'y	=								+E		+Fx		+Gx2	+Hx3	+2Iy	+2Jx	+3Ky2	+3Lxy2
			
			var Mx:Array =new Array();
			var My:Array =new Array();
			var fx:Number;
			var fx2:Number;
			var fx3:Number;
			
			var fy:Number;
			var fy2:Number;
			var fy3:Number;
			var derF:Number =1.0/_bitmapData.width;
			var derG:Number =1.0/_bitmapData.height;
			
			//	for each of the eigth vertices 
			//	f(srcPoints.x,srcPoints.y)=dstPoints.x,dstPoints.y 								
			for (i=0; i<8; i++) {
				fx= srcPoints[i].x;
				fx2= fx*fx;	
				fx3= fx2*fx;
				fy= srcPoints[i].y;
				fy2= fy*fy;
				fy3= fy2*fy;
				
				Mx.push( [dstPoints[i].x, 	1.0,fx,fx2,fx3,
					fy,fx*fy,fx2*fy,fx3*fy,
					fy2,fx*fy2,fy3,fx*fy3] );
				My.push( [dstPoints[i].y, 	1.0,fx,fx2,fx3,
					fy,fx*fy,fx2*fy,fx3*fy,
					fy2,fx*fy2,fy3,fx*fy3] );
			}
			
			// left edge: y-derivative for point 3
			i=3;
			fx= srcPoints[i].x;
			fx2= fx*fx;	
			fx3= fx2*fx;
			fy= srcPoints[i].y;
			fy2= fy*fy;
			fy3= fy2*fy;
			Mx.push( [derF*(dstPoints[5].x-dstPoints[0].x),
				0,0,0,0,
				1,fx,fx2,fx3,
				2*fy,2*fx*fy,3*fy2,3*fx*fy2] );
			My.push( [derG*(dstPoints[5].y-dstPoints[0].y),
				0,0,0,0,
				1,fx,fx2,fx3,
				2*fy,2*fx*fy,3*fy2,3*fx*fy2] );										
			
			// top: x-derivative for point 1
			i=1;
			fx= srcPoints[i].x;
			fx2= fx*fx;
			fx3= fx2*fx;
			fy= srcPoints[i].y;
			fy2= fy*fy;
			fy3= fy2*fy;
			Mx.push( [derF*(dstPoints[2].x-dstPoints[0].x),
				0,1,2*fx,3*fx2,
				0,fy,2*fx*fy,3*fx2*fy,
				0,fy2,0,fy3] );
			My.push( [derG*(dstPoints[2].y-dstPoints[0].y),
				0,1,2*fx,3*fx2,
				0,fy,2*fx*fy,3*fx2*fy,
				0,fy2,0,fy3] );										
			
			// right: y-derivative for point 4
			i=4;
			fx= srcPoints[i].x;
			fx2= fx*fx;
			fx3= fx2*fx;
			fy= srcPoints[i].y;
			fy2= fy*fy;
			fy3= fy2*fy;
			Mx.push( [derF*(dstPoints[7].x-dstPoints[2].x),
				0,0,0,0,
				1,fx,fx2,fx3,
				2*fy,2*fx*fy,3*fy2,3*fx*fy2] );
			My.push( [derG*(dstPoints[7].y-dstPoints[2].y),
				0,0,0,0,
				1,fx,fx2,fx3,
				2*fy,2*fx*fy,3*fy2,3*fx*fy2] );
			
			// bottom: x-derivative for point 6
			i=6;
			fx= srcPoints[i].x;
			fx2= fx*fx;
			fx3= fx2*fx;
			fy= srcPoints[i].y;
			fy2= fy*fy;
			fy3= fy2*fy;
			Mx.push( [derF*(dstPoints[7].x-dstPoints[5].x),
				0,1,2*fx,3*fx2,
				0,fy,2*fx*fy,3*fx2*fy,
				0,fy2,0,fy3] );
			My.push( [derG*(dstPoints[7].y-dstPoints[5].y),
				0,1,2*fx,3*fx2,
				0,fy,2*fx*fy,3*fx2*fy,
				0,fy2,0,fy3] );										
			
			//	solving
			var funcX:Array = Msolver(Mx);
			var funcY:Array = Msolver(My);
			
			//	start drawing
			_vertices = new Vector.<Number>();
			_indices = new Vector.<int>();
			_uvtData = new Vector.<Number>();
			var nx:Number;
			var ny:Number;
			var x:Number;
			var y:Number;
			var x2:Number;
			var x3:Number;
			var y2:Number;
			var y3:Number;
			
			for (j=0; j!=m; j++) {
				
				ny = j/(m-1.0); // relatively between 0.0 and 1.0
				y = _bitmapData.height*j/(m-1.0);
				y2 =y*y; // squared
				y3 =y*y2; // cubic
				
				for (i=0 ; i!=n; i++) {
					// x coordinates
					nx =i/(n-1.0);
					x = _bitmapData.width*i/(n-1.0);
					x2 =x*x;
					x3 =x*x2;
					
					// new Coordinate
					// f(x,y) = A	+B*x	+C*x2	+D*x3	+E*y	+F*xy 	+Gx2y	+Hx3y	+Iy2	+Jxy2	+Ky3	+Lxy3
					_vertices.push(
						funcX[0]	+funcX[1]*x		+funcX[2]*x2	+funcX[3]*x3+
						funcX[4]*y	+funcX[5]*x*y	+funcX[6]*x2*y 	+funcX[7]*x3*y+
						funcX[8]*y2	+funcX[9]*x*y2	+funcX[10]*y3 	+funcX[11]*x*y3,
						
						funcY[0] 	+funcY[1]*x		+funcY[2]*x2 	+funcY[3]*x3+
						funcY[4]*y	+funcY[5]*x*y	+funcY[6]*x2*y	+funcY[7]*x3*y+
						funcY[8]*y2 +funcY[9]*x*y2	+funcY[10]*y3 	+funcY[11]*x*y3
					);
					
					
					// texture mapping coordinates between 0,0 and 1,1
					_uvtData.push(nx,ny);
				}
			}
			
			//
			// indices for two triangles, CCW
			//
			//		ii-----ii+1
			//		 |\    | 
			//		 | \   |
			//		 |   \ |     
			//		 |    \|       
			//		ii+n---ii+n+1
			//
			
			var ii:int =0;
			for (j=0 ; j!=m-1; j++) {
				for (i=0 ; i!=n-1; i++) {
					_indices.push(ii,ii+n+1,ii+1);
					_indices.push(ii+n,ii+n+1,ii++);
				}
				ii++;
			}
			
			this.graphics.clear();
			//this.graphics.lineStyle(1);
			this.graphics.beginBitmapFill(this._bitmapData, null, true, true);
			this.graphics.drawTriangles(_vertices,_indices,_uvtData,TriangleCulling.POSITIVE);
			this.graphics.endFill();
		}
		
		private function Msolver(M:Array):Array 
		{
			//	solves a group of equitations
			//	
			//	A = Bx + Cy
			//	D = Ex + Fy
			//	
			//	Msolver([ A,B,C,	D,E,F ])
			
			var i:int;
			var j:int;
			var k:int;
			
			for (k=M.length-1; k>0;k--) {
				
				for (i=0; i<k+2; i++) { 
					M[k][i] /= M[k][k+1];
				}
				
				for (j=0; j<k; j++){
					for (i=0; i<k+1; i++){
						M[j][i]=  M[j][i]*M[k][k+1] - M[j][k+1] *M[k][i];
					} // for i
				} // for j
			} // for k
			
			var Msolved:Array = new Array();
			for (k=0;k<M.length;k++){
				Msolved[k]= M[k][0]/M[k][k+1]; 
				for (j=k+1; j<M.length; j++) {
					M[j][0] -= Msolved[k]*M[j][k+1];
				}
			}
			return Msolved;
		}
	} 
}
