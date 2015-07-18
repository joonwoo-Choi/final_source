package util {
	import flash.display.*;

	public class Arc {
		public function Arc() : void {
			trace("Draw is a static class and should not be instantiated.");
		}

		public static function DrawSector(mc:MovieClip,x:Number=200,y:Number=200,r:Number=100,angle:Number=27,startFrom:Number=270,color:Number=0xff0000):void {
		  			mc.graphics.clear();
		    mc.graphics.beginFill(color,50);
		    //remove this line to unfill the sector
		    /* the border of the secetor with color 0xff0000 (red) , you could replace it with any color 
		    * you want like 0x00ff00(green) or 0x0000ff (blue).
		    */
		    mc.graphics.lineStyle(0,color);
		    mc.graphics.moveTo(x,y);
		    angle=(Math.abs(angle)>360)?360:angle;
		    var n:Number=Math.ceil(Math.abs(angle)/45);
		    var angleA:Number=angle/n;
		    angleA=angleA*Math.PI/180;
		    startFrom=startFrom*Math.PI/180;
		    mc.graphics.lineTo(x+r*Math.cos(startFrom),y+r*Math.sin(startFrom));
		    for (var i:int=1; i<=n; i++) {
		        startFrom+=angleA;
		        var angleMid:Number=startFrom-angleA/2;
		        var bx:Number=x+r/Math.cos(angleA/2)*Math.cos(angleMid);
		        var by:Number=y+r/Math.cos(angleA/2)*Math.sin(angleMid);
		        var cx:Number=x+r*Math.cos(startFrom);
		        var cy:Number=y+r*Math.sin(startFrom);
		        mc.graphics.curveTo(bx,by,cx,cy);
		    }
		    if (angle!=360) {
		        mc.graphics.lineTo(x,y);
		    }
		    mc.graphics.endFill();// if you want a sector without filling color , please remove this line.
		}	
	}
}

