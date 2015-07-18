package com.sk2.sub
{
	import com.greensock.TweenMax;
	import com.sw.buttons.Button;
	import com.sw.display.SetBitmap;
	import com.sw.utils.McData;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	/**
	 * SK2	::
	 * */
	public class HOW_TO_USE extends BaseSub
	{
		private var btnAry:Array;
		private var imgPos:int;
		private var face_mc:MovieClip;
		private var txt_mc:MovieClip;
		
		private var tip:WOMEN_STORY_TIP;
		
		/**	생성자	*/
		public function HOW_TO_USE($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
			scope_mc.tip_mc.visible = false;
			tip = new WOMEN_STORY_TIP(scope_mc.tip_mc);
			tip.setRipple();
			tip.init();
			setBaseBtn(scope_mc.txt_mc.btn,viewTip);
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			//scope_mc.face_mc.visible = false;
		}
		/**	
		 * 물결 효과 주기전 셋팅	
		 * */
		override public function setRipple():void
		{
			imgPos = 0;
			face_mc = scope_mc.face_mc;
			txt_mc = scope_mc.txt_mc;
			face_mc.alpha = 1;
			face_mc.visible = true;
			
			btnAry = ["btn","btn1","btn2","btn3"];
			for(var i:int = 0; i<btnAry.length; i++)
			{
				var btn:MovieClip = btnAry[i] = scope_mc[btnAry[i]];
				btn.idx = i;
				Button.setUI(btn,{over:onOverBtn,out:onOutBtn,click:onClickBtn});
				if(i == 0) continue;
				btn.alpha = 0.5;
				btn.txt.text = i;
			}
			SetBitmap.go(btnAry[0].img,true);
			McData.save(btnAry[0]);
			setImg();
			
			playRipple();
		}
		/**
		 * 초기화
		 * */
		override public function init():void
		{
			face_mc.alpha=0;
			//TweenMax.to(face_mc,1,{alpha:1});
			viewBlurObj(face_mc);
		}
		
		private function onOverBtn($mc:MovieClip):void
		{		
			if($mc.idx == 0)
				TweenMax.to($mc.img,0.5,{x:20});
			else
			{
				TweenMax.to(btnAry[imgPos],0.5,{alpha:0.5});
				TweenMax.to($mc,0.5,{alpha:1});
			}
		}
		private function onOutBtn($mc:MovieClip):void
		{		
			if($mc.idx == 0)
				TweenMax.to($mc.img,0.5,{x:10});
			else
			{
				TweenMax.to($mc,0.5,{alpha:0.5});
				TweenMax.to(btnAry[imgPos],0.5,{alpha:1});
			}
		}
		private function onClickBtn($mc:MovieClip):void
		{
			if($mc.idx == 0)
			{
				$mc.alpha =0;
				$mc.x = $mc.dx;
				$mc.scaleX = $mc.scaleX*-1;
				if($mc.scaleX < 0) $mc.x = $mc.x + $mc.width;
				TweenMax.to($mc,1,{alpha:1});
				if(imgPos == 0) 
				{
					imgPos = 1;
				}else 
				{
					imgPos = 0;
				}
				if($mc.scaleX == 1)
					scope_mc.txt_mc.btn.visible = true;
				else
					scope_mc.txt_mc.btn.visible = false;
			}
			else
			{
				imgPos = $mc.idx;
			}
			setImg();
		}
		/**	이미지 내용셋팅	*/
		private function setImg():void
		{
			var view:Boolean = true;
			var da:int = 1;
			if(imgPos == 0)
			{	view = false;	da = 0;	}
			
			for(var i:int=1; i<btnAry.length; i++)
			{	
				btnAry[i].visible = view;
				btnAry[imgPos].alpha = 1;
			}
			face_mc.alpha = 0;
			face_mc.gotoAndStop(imgPos+1);
			viewBlurObj(face_mc);
			//TweenMax.to(face_mc,1,{alpha:1});
			
			if(imgPos == 0 && txt_mc.currentFrame != 1)
			{
				txt_mc.alpha = 0;
				txt_mc.gotoAndStop(1);
			}
			if(imgPos != 0 && txt_mc.currentFrame == 1)
			{
				txt_mc.alpha = 0;
				txt_mc.gotoAndStop(2);
			}
			TweenMax.to(txt_mc,1,{alpha:1});
			//viewBlurObj(txt_mc);
		}
		private function finishFace():void
		{
		
		
		}
		/**	tip 보여주기	*/
		private function viewTip($mc:MovieClip = null):void
		{
			viewBlurObj(scope_mc.tip_mc);
			Button.setUI(scope_mc.tip_mc.btnX,{click:onClickTipX});
		}
		/**	tip 가려지기	*/
		private function onClickTipX($mc:MovieClip = null):void
		{
			viewBlurObj(scope_mc.tip_mc,null,null,0);
		}
		
	}//class
}//package