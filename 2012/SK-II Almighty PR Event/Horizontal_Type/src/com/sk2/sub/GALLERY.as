package com.sk2.sub
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.BtnEnter;
	import com.sw.buttons.Button;
	import com.sw.display.PlaneClip;
	import com.sw.display.Remove;
	import com.sw.net.FncOut;
	import com.sw.utils.SetText;
	import com.sw.utils.VideoPlayer;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
//	import org.osmf.layout.AbsoluteLayoutFacet;

	/**
	 * SK2	:: GALLERY
	 * */
	public class GALLERY extends BaseSub
	{
		/**	영상 플레이어	*/
		private var player:VideoPlayer;
		/**	영상 파일 이름	*/
		private var fileName:Array;
		/**	버튼 배열	*/
		private var btnAry:Array;
		/**	버튼 당 이름	*/
		private var btnName:Array;
		/**	현제 보고 있는 버튼	*/
		private var viewBtn:MovieClip;	
		
		private var videoAry:Array;
		private var playerAry:Array;
		
		/**	생성자	*/
		public function GALLERY($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			for(var i:int =0; i<playerAry.length; i++)
			{	if(playerAry[i] != null) playerAry[i].remove();	}
		}
		/**
		 * 물결 효과 주기 전 셋팅
		 * */
		override public function setRipple():void
		{
			fileName = ["FTE11_TVC_Kim","FTE11_TVC_Toj"];
			//버튼 셋팅
			btnName = ["TV광고_김희애편","TV광고_주조사의 이야기편","PRINT AD"];	
			btnAry = [];
			videoAry = [];
			playerAry = [null,null];
			for(var i:int = 0; i<btnName.length; i++)
			{
				btnAry.push(scope_mc["btn"+(i+1)]);
				var btn:MovieClip = btnAry[i];
				btn.idx = i;
				
				var be:BtnEnter;
				if(i > 1) 
				{
					//Button.setUI(btn,{click:onClickThumb});
					be = new BtnEnter(btn,{click:onClickThumb});
					continue;
				}
				//썸네일 버튼
				btn.box_mc.idx = i;
				be = new BtnEnter(btn.box_mc,{click:onClickThumb,over:onOverThumb,out:onOutThumb});
				
				//스크랩 부분 셋팅
				for(var j:int = 1; j<=3; j++)
				{	
					var scrap_btn:MovieClip = scope_mc["btn"+(i+1)+"_"+j];
					scrap_btn.visible = false;
					/*
					scrap_btn.viewIdx = i;
					scrap_btn.idx = j;
					Button.setUI(scrap_btn,{click:onClickScrap});
					*/
				}
				videoAry[i] = new MovieClip();
				btn.addChild(videoAry[i]);
				var mask_mc:PlaneClip = new PlaneClip({});
				mask_mc.width = 303;
				mask_mc.height = 185;
				btn.addChild(mask_mc);
				videoAry[i].mask = mask_mc;
				btn.addChild(btn.control_mc);
				btn.addChild(btn.box_mc);
			}
			
			playRipple();
		}
		/**
		 * 물결 효과 주고 난후 셋팅
		 * */
		override public function init():void
		{}
		
		private function finishImg($img:MovieClip):void
		{	$img.visible = false;	}
		
		/** 버튼화 */
		private function onOverThumb($mc:MovieClip):void
		{
			if(playerAry[$mc.idx] != null)
			{	
				$mc.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
				TweenMax.to(btnAry[$mc.idx].control_mc.btn,0.5,{alpha:1});
			}
		}
		private function onOutThumb($mc:MovieClip):void
		{
			if(playerAry[$mc.idx] != null)
				TweenMax.to(btnAry[$mc.idx].control_mc.btn,0.5,{alpha:0});
		}
		private function onClickThumb($mc:MovieClip):void
		{
			
			if($mc.idx == 0)
			{	
				FncOut.call("piteraMenu.movieCall","1");	
				DataProvider.track.check2("305");
			}
			else if($mc.idx == 1)
			{
				FncOut.call("piteraMenu.movieCall","2");	
				DataProvider.track.check2("304");
			}
			else if($mc.idx == 2)
//				DataProvider.popup.viewPop("gallery");
			
			return;
			
			
			//이전 영상 자신이 가지고 있을때
			var player:VideoPlayer = playerAry[$mc.idx];
			if(player != null)
			{
				var pause_btn:MovieClip = btnAry[$mc.idx].control_mc.btn;
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
				return;
			}
			$mc.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			if(viewBtn != null)
				removeVideo(viewBtn);
			
			if($mc.idx == 2)
			{
//				DataProvider.popup.viewPop("gallery");
				return;
			}
			setVideo(btnAry[$mc.idx]);
			viewBtn = btnAry[$mc.idx];
			btnAry[$mc.idx].control_mc.btn.gotoAndStop(2);
			TweenMax.to(btnAry[$mc.idx].control_mc.slide_mc,0.5,{alpha:1});
			
		}
		
		private function removeVideo($mc:MovieClip):void
		{
			Remove.child(videoAry[$mc.idx]);
			
			if(playerAry[$mc.idx] == null) return;
			
			VideoPlayer(playerAry[$mc.idx]).remove();
			playerAry[$mc.idx] = null;
			btnAry[$mc.idx].control_mc.btn.gotoAndStop(1);
			btnAry[$mc.idx].control_mc.btn.alpha = 1;
			TweenMax.to(btnAry[$mc.idx].control_mc,0.5,{alpha:1});
			TweenMax.to(btnAry[$mc.idx].control_mc.slide_mc,0.5,{alpha:0});
		}
		private function removeViewVideo():void
		{
			var player:VideoPlayer =  VideoPlayer(playerAry[viewBtn.idx]);
			player.loader.videoPaused = true;
			player.loader.gotoVideoTime(0);
			var pause_btn:MovieClip = btnAry[viewBtn.idx].control_mc.btn;
			pause_btn.gotoAndStop(1);
			/*
			if(viewBtn != null)
				removeVideo(viewBtn);
			*/
		}
		private function setVideo($mc:MovieClip):void
		{
			removeVideo($mc);
			videoAry[$mc.idx].alpha = 0;
			playerAry[$mc.idx] = 
				new VideoPlayer(videoAry[$mc.idx],
									{	
										fnc_play:onPlay,
										url:"flv/"+fileName[$mc.idx]+".flv",
										width:303,height:185,
										UI:$mc.control_mc,
										resize:"proportionalOutside",
										finish:removeViewVideo
									});
		}
		
		private function onPlay():void
		{
			TweenMax.to(videoAry[viewBtn.idx],0.5,{alpha:1,ease:Expo.easeIn});
		}
		
		/**	스크랩 클릭	*/
		private function onClickScrap($mc:MovieClip):void
		{
			switch($mc.idx)
			{
			case 1:			//트위터
				FncOut.call("piteraMenu.scrapPiteraToTwitter","mov",$mc.viewIdx+1);
				break;
			case 2:			//페이스북
				FncOut.call("piteraMenu.scrapPiteraToFacebook","mov",$mc.viewIdx+1);
				break;
			case 3:			//미투데이
				FncOut.call("piteraMenu.scrapPiteraToMe2day","mov",$mc.viewIdx+1);
				break;
			}
		}
	}//class
}//package