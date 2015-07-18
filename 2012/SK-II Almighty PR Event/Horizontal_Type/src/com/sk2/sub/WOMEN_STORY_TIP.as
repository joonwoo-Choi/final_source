package com.sk2.sub
{
	import com.greensock.TweenMax;
	import com.sw.buttons.Button;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * SK2	:: TIP
	 * */
	public class WOMEN_STORY_TIP extends BaseSub
	{
		private var cList:MovieClip;
		private var btnAry:Array;
		private var txt_mc:MovieClip;
		
		/**	생성자	*/
		public function WOMEN_STORY_TIP($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
		}
		/**	물결 효과 전 셋팅	*/
		override public function setRipple():void
		{
			txt_mc = scope_mc.txt_mc;
			
			btnAry = ["","btn1","btn2","btn3"];
			for(var i:int = 1; i<btnAry.length; i++)
			{
				var btn:MovieClip = btnAry[i] = scope_mc[btnAry[i]];
				btn.idx = i;
				
				btn.txt.text = "TIP 0"+i;
				
				btn.plane_mc.alpha = 0;
				btn.plane_mc.height = 5;
				btn.plane_mc.y = 15;
				Button.setUI(btn,{over:onOverList,out:onOutList,click:onClickList});
			}
			cList = btnAry[1];
			playRipple();
		}
		override public function init():void
		{
			onOverList(cList);
		}
		/**	물결화후 셋팅	*/
		private function onOverList($mc:MovieClip):void
		{	
			TweenMax.to(cList.plane_mc,0.5,{alpha:0,height:5,y:15});
			TweenMax.to($mc.plane_mc,0.5,{alpha:1,height:$mc.height,y:0});	
		}
		private function onOutList($mc:MovieClip):void
		{	
			TweenMax.to($mc.plane_mc,0.5,{alpha:0,height:5,y:15});	
			TweenMax.to(cList.plane_mc,0.5,{alpha:1,height:$mc.height,y:0});
		}
		private function onClickList($mc:MovieClip):void
		{
			cList = $mc;
			txt_mc.alpha = 0;
			txt_mc.gotoAndStop($mc.idx);
			viewBlurObj(txt_mc);
			//TweenMax.to(txt_mc,1,{alpha:1});
		}
	}//class
}//package