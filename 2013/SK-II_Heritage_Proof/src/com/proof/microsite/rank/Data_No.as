package com.proof.microsite.rank
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.utils.setTimeout;
	
	public class Data_No
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $productLength:int = 3;
		
		public function Data_No(con:MovieClip)
		{
			$con = con;
			
			$model =Model.getInstance();
			$model.addEventListener(ModelEvent.DATA_NO, showDataNoPage);
		}
		
		private function showDataNoPage(e:Event = null):void
		{
			TweenLite.to($con, 1, {alpha:1, ease:Cubic.easeOut});
			setTimeout(showContent, 500);
		}
		
		private function showContent():void
		{
			
			TweenLite.to($con.txt_no, 1, {alpha:1});
			TweenMax.to($con.txt_no, 1, {
				colorTransform:{exposure:1.15},
				blurFilter:new BlurFilter(4,4),
				reversed:true,
				onReverseComplete:finishBlur,
				onReverseCompleteParams:[$con.txt_no]
			});
			
			TweenLite.to($con.txt_center, 1, {delay:0.25, alpha:1});
			TweenMax.to($con.txt_center, 1, {
				delay:0.25,
				colorTransform:{exposure:1.15},
				blurFilter:new BlurFilter(4,4),
				reversed:true,
				onReverseComplete:finishBlur,
				onReverseCompleteParams:[$con.txt_center]
			});
			
			setTimeout(showProduct, 500)
			
//			TweenMax.to($con.result0_up, 1, {delay:0.75, y:$con.result0_up.y + 3, reversed:true});
		}
		
		private function showProduct():void
		{
			for (var i:int = 0; i < $productLength; i++) 
			{
				var target:MovieClip = $con.getChildByName("product" + i) as MovieClip;
				TweenLite.to(target, 1, {delay:0.25 * i, alpha:1});
				TweenMax.to(target, 1, {
					delay:0.25 * i,
					colorTransform:{exposure:1.15},
					blurFilter:new BlurFilter(4,4),
					reversed:true,
					onReverseComplete:finishBlur,
					onReverseCompleteParams:[target]
				});
				
				TweenLite.to(target.up, 1, {delay:0.4, alpha:1});
				TweenLite.to(target.down, 1, {delay:0.4, alpha:1});
				TweenMax.to(target.up, 1, {delay:0.4, y:target.up.y - 3, reversed:true});
				TweenMax.to(target.down, 1, {delay:0.4, y:target.down.y + 3, reversed:true});
			}
		}
		/**	블러 종료	*/
		private function finishBlur(mc:MovieClip):void
		{	mc.filters = null;	}
	}
}