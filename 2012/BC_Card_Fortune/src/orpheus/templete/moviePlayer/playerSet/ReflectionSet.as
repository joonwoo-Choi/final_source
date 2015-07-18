package orpheus.templete.moviePlayer.playerSet
{
	import orpheus.templete.moviePlayer.AbsrtractMCCtrler;
	import orpheus.templete.moviePlayer.MoviePlayer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	public class ReflectionSet extends AbsrtractMCCtrler
	{
		public function ReflectionSet(mc:MoviePlayer)
		{
			super(mc);
		}
		public function reflection(mc,refDis,depth,alp) {
			var bmp = snapShot(mc,0,_con.StageHeight-depth,_con.StageWidth,depth);
			_con.video_mc.refMc.addChild(bmp);
			// flip horizontal
			bmp.rotation = 180;
			var matrix:Matrix = bmp.transform.matrix;
			matrix.a=-1*matrix.a;
			matrix.tx=bmp.x-bmp.width;
			bmp.transform.matrix=matrix;
			
			// draw gradient mask
			var rect:Shape=new Shape();
			_con.video_mc.refMc.addChild(rect);
			var mat:Matrix;
			var colors:Array;
			var alphas:Array;
			var ratios:Array;
			mat=new Matrix();
			colors=[0x0,0x0];
			alphas=[1,0];
			ratios = [0x00, 0xFF];
			mat.createGradientBox(_con.StageWidth,depth,(90 * Math.PI / 180));
			rect.graphics.lineStyle();
			rect.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
			rect.graphics.drawRect(0,0,_con.StageWidth,depth);
			rect.graphics.endFill();
			rect.alpha=alp;
			
			//set Mask
			bmp.x=rect.x=0;
			bmp.y=(_con.StageHeight+depth+refDis);
			rect.y=_con.StageHeight;
			bmp.cacheAsBitmap=rect.cacheAsBitmap=true;
			bmp.mask=rect;
			
			_con.bmp2 = snapShot(_con.video_mc.refMc,0,_con.StageHeight,_con.StageWidth,depth);
			_con.video_mc.refMc.addChild(_con.bmp2);
			_con.bmp2.y=_con.StageHeight;
			
			_con.video_mc.refMc.removeChild(rect);
			_con.video_mc.refMc.removeChild(bmp);
		}		
		private function snapShot(mc,xP,yP,w,h):Bitmap {
			var m : Matrix = new Matrix ( );
			m.translate( xP ,-yP);
			var bmpData:BitmapData=new BitmapData(w,h,true,0x00000000);
			bmpData.draw(mc,m,null,null,null,true);
			var bmp:Bitmap=new Bitmap(bmpData);
			return bmp;
			
		}		
	}
}