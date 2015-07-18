package contents
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.display.BaseIndex;
	import com.sw.display.PlaneClip;
	import com.sw.utils.McData;
	
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	
	import util.BtnHersheys;
	
	/**		
	 *	SK2_Hersheys :: 서브 페이지 공통 내용
	 */
	
	public class BaseContent extends BaseIndex
	{
		protected var data:Object;
		protected var titleMc:SubTitleClip;
		
		/**	생성자	*/
		public function BaseContent($data:Object = null)
		{
			super();
			data = $data;
			if(data == null) data = new Object();
			
		}
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
		}
		/**	상단 타이틀 적용	*/
		protected function setTitle(num:int = 1):void
		{
			titleMc = new SubTitleClip();
			
			for(var i:int = 1; i<=2; i++)
			{
				var mask:MovieClip = titleMc["mask"+i] as MovieClip;
				var title:MovieClip = titleMc["title"+i] as MovieClip;
				
				title.gotoAndStop(num);
				McData.save(mask);
				mask.height = 1;
				
				title.filters = [new BlurFilter(8,8)];
				title.alpha = 0;
				
				TweenMax.to(title,1.5,{delay:(i-1)*0.3,alpha:1,blurFilter:new BlurFilter(0,0),ease:Expo.easeOut});
				TweenMax.to(mask,1,{delay:(i-1)*0.3,height:mask.dh,ease:Expo.easeOut});			
			}
			
			addChild(titleMc);
		}
		/**	리스트 내용 등장 구성	*/
		protected function setList(container:MovieClip):void
		{
			for(var i:int = 1; i<=3; i++)
			{
				var list:MovieClip = container["list"+i] as MovieClip;
				list.titleMc.gotoAndStop(i);
				list.imgMc.gotoAndStop(i);
				
				var maskMc:PlaneClip = new PlaneClip({});
				maskMc.width = list.titleMc.width;
				maskMc.height = list.titleMc.height;
				maskMc.x = list.titleMc.x;
				maskMc.y = list.titleMc.y;
				
				list.addChild(maskMc);
				list.titleMc.mask = maskMc;
				
				McData.save(maskMc);
				maskMc.height = 2;
				
				list.imgMc.scaleX = 0.5;
				list.imgMc.scaleY = 0.5;
				
				list.btnMc.alpha = 0;
				list.imgMc.alpha = 0;
				list.titleMc.alpha = 0;
				
				list.titleMc.filters = [new BlurFilter(8,8)];
				list.btnMc.filters = [new BlurFilter(8,8)];
				list.imgMc.filters = [new BlurFilter(8,8)];
				var ease:Object = Expo.easeOut;
				
				TweenMax.to(maskMc,1,{delay:i*0.2,height:maskMc.dh,ease:ease});
				
				TweenMax.to(list.titleMc,0.7,{delay:i*0.21,alpha:1,overwrite:0,ease:ease});
				TweenMax.to(list.titleMc,1.2,{delay:i*0.3,blurFilter:new BlurFilter(0,0),ease:ease});
				
				TweenMax.to(list.btnMc,0.6,{delay:i*0.22,alpha:1,overwrite:0,ease:ease});
				TweenMax.to(list.btnMc,1,{delay:i*0.3,blurFilter:new BlurFilter(0,0),ease:ease});
				
				TweenMax.to(list.imgMc,0.7,{delay:i*0.23,alpha:1,scaleX:1,scaleY:1,overwrite:0,ease:ease});
				TweenMax.to(list.imgMc,3,{delay:i*0.35,blurFilter:new BlurFilter(0,0),ease:ease});
				
				var btn:MovieClip = container["btn"+i] as MovieClip;
				btn.idx = i;
				
				BtnHersheys.getIns().go(btn,onClickList);
			}
		
		}
		/**	리스트 내용 클릭	*/
		protected function onClickList(mc:MovieClip):void
		{
		
		}
	}//class
}//package