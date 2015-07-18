package com.sk2.sub
{
	
	import com.greensock.TweenMax;
	import com.sk2.net.CLEAR_LIST;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.BtnAlpha;
	import com.sw.buttons.Button;
	import com.sw.display.PlaneClip;
	import com.sw.utils.VideoPlayer;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.filters.BlurFilter;
	import flash.system.System;
	
	public class CLEAR_FOR_LIFE extends BaseSub
	{
		private var list:CLEAR_LIST;
		private var player:VideoPlayer;
		
		private var mov_mc:MovieClip;
		private var video_mc:MovieClip;
		
		private var pause_btn:MovieClip;
		private var control_mc:MovieClip;
		
		private var clear_list:MovieClip;
		
		
		/**		생성자	*/
		public function CLEAR_FOR_LIFE($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			if(player != null) player.remove();
		}
		/**
		 * 물결 효과 전 초기화
		 * */
		override public function setRipple():void
		{
			mov_mc = scope_mc.img_mc.mov_mc;
			control_mc = mov_mc.control_mc;
			pause_btn = control_mc.btn;
			//clear_list = scope_mc.clear_list;
			//clear_list.visible = false;
			
			video_mc = new MovieClip();
			mov_mc.addChild(video_mc);
			var mask_mc:PlaneClip = new PlaneClip({});
			mask_mc.width = 290;
			mask_mc.height = 200;
			mov_mc.addChild(mask_mc);
			video_mc.mask = mask_mc;
			
			playRipple();
		}
		/**
		 * 물결 효과 후 초기화
		 * */
		override public function init():void
		{
			//clear_list.visible = false;
			setBaseBtn(scope_mc.btn,onClickBtn);
			Button.setUI(mov_mc,{over:onOverMov,out:onOutMov,click:onClickMov});
		
		}
		
		private function onClickBtn($mc:MovieClip):void
		{
			/*
			DataProvider.popup.viewPop("alert",{txt:"준비중입니다."});
			return;
			*/
			DataProvider.track.check("502");
			DataProvider.loader.navi.clickMenu(3,1);
			/*
			scope_mc.btn.visible = false;
			
			clear_list.alpha = 0;
			clear_list.visible = true;
			TweenMax.to(clear_list,1,{alpha:1});
			viewBlurObj(scope_mc.img_mc,finishImg,null,0,1);
			*/
		}
		private function finishImg():void
		{	
			scope_mc.img_mc.visible = false;
//			list = new CLEAR_LIST(clear_list,DataProvider.dataURL+"/Xml/PurList.aspx",{});
			//list.loadList();
			//list.setGage();
			
			trace(scope_mc.img_mc);
		}
		/**	영상 플레이	*/
		private function onOverMov($mc:MovieClip):void
		{
			if(player == null) return;
			TweenMax.to(pause_btn,1,{alpha:1});
		}
		private function onOutMov($mc:MovieClip):void
		{
			if(player == null) return;
			TweenMax.to(pause_btn,1,{alpha:0});
		}
		private function removeViewVideo():void
		{
			player.loader.videoPaused = true;
			player.loader.gotoVideoTime(0);
			pause_btn.gotoAndStop(1);
		}
		private function onClickMov($mc:MovieClip):void
		{
			if(player == null)
			{
				player = new VideoPlayer(	video_mc,
											{
												url:"flv/Clear_for_Life.flv",
												UI:control_mc,
												width:290,height:200,
												finish:removeViewVideo
											});
				mov_mc.addChild(control_mc);
				TweenMax.to(control_mc.slide_mc,1,{alpha:1});
				pause_btn.gotoAndStop(2);
				return;
			}
			if(pause_btn.currentFrame == 1)
			{
				player.loader.videoPaused = false;
				pause_btn.gotoAndStop(2);
			}
			else if(pause_btn.currentFrame == 2)
			{
				player.loader.videoPaused = true;
				pause_btn.gotoAndStop(1);
			}
		}
	}//class
}//package