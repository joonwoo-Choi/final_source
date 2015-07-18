package com.sw.buttons
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	

	/**
	 * <p>버튼 오버시 알파값 등장 아웃 버튼<p>
	 * ex : BtnAlpha(mc,{over:onOver,out:onOut,click:onClick,speed:0.5,alpha:1});
	 * */
	public class BtnAlpha
	{
		private var mc:MovieClip;
		private var data:Object;
		private var speed:Number;
		private var alpha:Number;
		/**
		 * 생성자	
		 * @param $mc		:: 버튼 오브젝트
		 * @param $data	:: 속성 값
		 * 
		 */
		public function BtnAlpha($mc:MovieClip=null,$data:Object=null)
		{
			if($data == null)
			{ 
				throw new Error("오류:BtnAlpha $data값이 없습니다.");
				return;
			}
			mc = $mc;
			data = $data;
			speed = (data.speed != null) ? (data.speed) : (0.5);
			alpha = (data.alpha != null) ? (data.alpha) : (1);
			Button.setUI(mc,{over:onOver,out:onOut,click:onClick});
		}
		/**	소멸자	*/
		public function destroy():void
		{		}
		/**	오버시 */
		private function onOver($mc:MovieClip):void
		{
			TweenMax.to($mc,speed,{alpha:alpha});
			if(data.over) data.over($mc);
		}
		/**	아웃시 */
		private function onOut($mc:MovieClip):void
		{
			TweenMax.to($mc,speed,{alpha:0});
			if(data.out) data.out($mc);
		}
		/**	클릭시 */
		private function onClick($mc:MovieClip):void
		{
			if(data.click) data.click($mc);
		}
	}//class
}//package