package orpheus.graphics {
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
		    mc.graphics.lineStyle(0,0xff0000);
		    mc.graphics.moveTo(x,y);
		    angle=(Math.abs(angle)>360)?360:angle;
		    var n:Number=Math.ceil(Math.abs(angle)/45);
		    var angleA:Number=angle/n;
		    angleA=angleA*Math.PI/180;
		    startFrom=startFrom*Math.PI/180;
		    mc.graphics.lineTo(x+r*Math.cos(startFrom),y+r*Math.sin(startFrom));
		    for (var i=1; i<=n; i++) {
		        startFrom+=angleA;
		        var angleMid=startFrom-angleA/2;
		        var bx=x+r/Math.cos(angleA/2)*Math.cos(angleMid);
		        var by=y+r/Math.cos(angleA/2)*Math.sin(angleMid);
		        var cx=x+r*Math.cos(startFrom);
		        var cy=y+r*Math.sin(startFrom);
		        mc.graphics.curveTo(bx,by,cx,cy);
		    }
		    if (angle!=360) {
		        mc.graphics.lineTo(x,y);
		    }
		    mc.graphics.endFill();// if you want a sector without filling color , please remove this line.
		}	
	}
}

