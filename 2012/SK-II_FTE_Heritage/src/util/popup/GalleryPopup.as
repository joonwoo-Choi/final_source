package util.popup
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.utils.VideoPlayer;
	
	import flash.display.MovieClip;
	
	import util.BtnHersheys;
	import util.HersheysVideoPlayer;

	/**		
	 *	SK2_Hersheys :: 갤러리 팝업 페이지
	 */
	public class GalleryPopup
	{
		/**	그래픽	*/
		private var container:MovieClip;
		/**	동영상 플레이어	*/
		private var player:HersheysVideoPlayer;
		/**	위치	*/
		private var pos:int;
		
		/**	현제 리스트 위치	*/
		private var cList:MovieClip;
		
		/**	광고 영상 리스트	*/
		private var flvAry1:Array;
		/**	메이킹 영상 리스트	*/
		private var flvAry3:Array;
		
		private var img1:MovieClip;
		private var img2:MovieClip;
		
		private var feedAry:Array;
		
		/**	생성자	*/
		public function GalleryPopup($container:MovieClip,$pos:int)
		{
			container = $container;
			pos = $pos;
			
			init();	
		}
		/**	초기화	*/
		private function init():void
		{
			flvAry1 = ["","TVC15_MS","TVC20_MS","interview_MS"];
			flvAry3 = ["","MF1","MF2","MF3"];
			
			feedAry = [	"",
						["","tvcf15","tvcf20","interview"],
						["","printad1","printad2","printad3"],
						["","making2","rest","making1"]];
			
			container.btnLike.alpha = 1;
			container.titleMc.gotoAndStop(pos);
			
			container.galleryBtnPlay.gotoAndStop(1);
			container.galleryBtnPlay.visible = false;
			container.galleryBtnPlay.alpha = 0;
			
			img1 = container.adImg1 as MovieClip;
			img2 = container.adImg2 as MovieClip;
			img1.gotoAndStop(1);
			img2.gotoAndStop(1);
			img1.alpha = 0;
			img2.alpha = 0;
			
			for(var i:int = 1; i<=3; i++)
			{
				var thumb:MovieClip = container["thumb"+i] as MovieClip;
				thumb.idx = i;
				var num:int = i+((pos-1)*10); 
				thumb.imgMc.gotoAndStop(num);
				thumb.overImg.gotoAndStop(num);
			
				Button.setUI(thumb,{over:onOverMenu,out:onOutMenu,click:onClickMenu});
			}
			
			if(pos == 2) setAD();
			else setMov();	
		
			container.btnLike.visible = true;
			TweenMax.to(container.btnLike.planeMc,0,{tint:0x000000});
			BtnHersheys.getIns().go(container.btnLike.planeMc,onClickLike);
			
			onOverMenu(container.thumb1);
			onClickMenu(container.thumb1);
		}
		
		/**	메뉴 오버	*/
		private function onOverMenu(mc:MovieClip):void
		{
			if(mc != cList) BtnHersheys.move(cList,"out");
			BtnHersheys.move(mc,"over");
		}
		/**	메뉴 아웃	*/
		private function onOutMenu(mc:MovieClip):void
		{
			if(mc != cList) BtnHersheys.move(mc,"out");
			BtnHersheys.move(cList,"over",Expo.easeIn);
		}
		/**	메뉴 클릭	*/
		private function onClickMenu(mc:MovieClip):void
		{
			if(pos == 2) clickGallery(mc);
			else clickMov(mc);
		}
		/**	이미지 내용 클릭	*/
		private function clickGallery(mc:MovieClip):void
		{
			
			img2.gotoAndStop(img1.currentFrame);
			img1.gotoAndStop(mc.idx);
			
			TweenMax.to(img2,0,{alpha:img1.alpha});
			
			TweenMax.to(img1,0,{alpha:0,colorMatrixFilter:{contrast:2}});
			
			TweenMax.to(img1,1.2,{alpha:1,colorMatrixFilter:{contrast:1},ease:Expo.easeOut});
			TweenMax.to(img2,1,{alpha:0,ease:Expo.easeOut});
			
			cList = mc;
		
		}
		/**	동영상 클릭	*/
		private function clickMov(mc:MovieClip):void
		{
			var flvAry:Array = this["flvAry"+pos] as Array;
			if(flvAry[mc.idx] == "") 
			{
				FncOut.call("alert","준비중입니다.");
				return;
			}
			player.playVideo("asset/flv/"+flvAry[mc.idx]+".flv");
			cList = mc;
		}
		
		/**	인쇄물 광고	*/
		private function setAD():void
		{
			//container.btnLike.visible = false;
			
		}
		
		/**	동영상	*/
		private function setMov():void
		{
//			container.btnLike.visible = true;
//			TweenMax.to(container.btnLike.planeMc,0,{tint:0x000000});
//			BtnHersheys.getIns().go(container.btnLike.planeMc,onClickLike);
			
			player = new HersheysVideoPlayer(container.galleryMov,container.galleryBtnPlay,container.maskMc,{});
		}
		
		
		private function onClickLike(mc:MovieClip):void
		{
			//FncOut.call("FacebookFeed","etc");
			FncOut.call("FacebookFeed","season1",feedAry[pos][cList.idx]);
			
		}
		/**	소멸자	*/
		public function destory():void
		{
			if(player != null)
			{
				player.destroy();
				player = null;
			}
			container.adImg1.alpha = 0;
			container.adImg2.alpha = 0;
		}
	}//class
}//package