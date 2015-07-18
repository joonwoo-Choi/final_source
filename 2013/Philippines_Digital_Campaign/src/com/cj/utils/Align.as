package com.cj.utils 
{
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * from.		http://bumpslide.com/ 
	 * by.			@author David Knape
	 * 
	 * modified.	@jun
	 */	
	public class Align
	{
		
		static public function right(clip:DisplayObject, containerSize:Number=Number.NaN, clipSize:Number=Number.NaN):void 
		{ 	
			var rect:Rectangle = clip.getRect(clip);	
			if(isNaN(clipSize)) clipSize = rect.width;
			clip.x = Math.round( containerSize - clipSize - rect.x);	
		}	
		
		static public function center( clip:DisplayObject, containerSize:Number=Number.NaN, clipSize:Number=Number.NaN ):void 
		{	
			var rect:Rectangle = clip.getRect(clip);
			if(isNaN(clipSize)) clipSize = rect.width;					
			clip.x = Math.round( (containerSize - clipSize - rect.x) / 2);
		}
		
		
		static public function middle( clip:DisplayObject, containerSize:Number=Number.NaN, clipSize:Number=Number.NaN ):void 
		{	
			var rect:Rectangle = clip.getRect(clip);
			if(isNaN(clipSize)) clipSize = rect.height;					
			clip.y = Math.round( (containerSize - clipSize - rect.y) / 2);
		}
		
		static public function bottom( clip:DisplayObject, containerSize:Number=Number.NaN, clipSize:Number=Number.NaN ):void 
		{	
			var rect:Rectangle = clip.getRect(clip);
			if(isNaN(clipSize)) clipSize = rect.height;					
			clip.y = Math.round( (containerSize - clipSize - rect.y) );
		}	
		
		static public function vbox( clips:Array, padding:Number=2 ):void 
		{
			var count:int = clips.length;
			if(count<2) return;		
			var yPos:Number = (clips[0] as DisplayObject).getBounds( clips[0].parent ).bottom + padding;	
			for(var n:uint=1; n<count; ++n) {
				var mc:DisplayObject = clips[n] as DisplayObject;
				if(mc.visible==false) continue;
				mc.y = Math.round( yPos + mc.y - mc.getBounds( mc.parent ).top);		
				yPos = mc.getBounds( mc.parent ).bottom + padding;
			}		
		}
		
		static public function hbox( clips:Array, padding:Number=2 ):void 
		{
			var count:int = clips.length;
			if(count<2) return;		
			var xPos:Number = (clips[0] as DisplayObject).getBounds( clips[0].parent ).right + padding;	
			for(var n:uint=1; n<count; ++n) {
				var mc:DisplayObject = clips[n] as DisplayObject;
				if(mc.visible==false) continue;
				mc.x = Math.round( xPos + mc.x - mc.getBounds( mc.parent ).left);		
				xPos = mc.getBounds( mc.parent ).right + padding;
			}		
		}
		
	}
}
