package util.popup
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.utils.VideoPlayer;
	
	
	import flash.display.MovieClip;
	
	import net.HersheysFncOut;
	import util.BtnHersheys;
	import util.HersheysVideoPlayer;

	/**		
	 *	SK2_Hersheys :: 서브 팝업
	 */
	public class SubPopup extends BaseHersheysPopup
	{
		/**	동영상 플레이어	*/
		private var player:HersheysVideoPlayer;
		/**	갤러리 팝업	*/
		private var galleryPop:GalleryPopup;
		
		/**	생성자	*/
		public function SubPopup($scope:Object, $data:Object=null)
		{
			super($scope, $data);
			init();
		}
		/**	아키타	*/
		public function akita():void
		{
			BtnHersheys.getIns().go(body_mc.btnBuy,onClickBuy);	
		}
		public function akita_destroy():void{}
		/**	5가지 요소	*/
		public function five():void
		{
			body_mc.fiveMc.gotoAndStop(1);
			//TweenMax.to(body_mc.fiveMc,0,{alpha:1,colorMatrixFilter:{contrast:1}});
			for(var i:int = 1; i<=5; i++)
			{
				var btn:MovieClip = body_mc["btn"+i] as MovieClip;
				btn.idx = i;
				Button.setUI(btn,{click:onClickFive});
			}
			BtnHersheys.getIns().go(body_mc.btnBuy,onClickBuy);	
		}
		private function onClickFive(mc:MovieClip):void
		{
			//TweenMax.to(body_mc.fiveMc,0,{alpha:0,colorMatrixFilter:{contrast:3}});
			body_mc.fiveMc.gotoAndStop(mc.idx);
			//TweenMax.to(body_mc.fiveMc,0.5,{alpha:1,colorMatrixFilter:{contrast:1},ease:Expo.easeOut});
		}
			
		/**	14일 키트 구매하기 버튼	*/
		private function onClickBuy(mc:MovieClip):void
		{
			HersheysFncOut.buy();
		}
		public function five_destroy():void{}
		/**	투어 영상	*/
		public function tour():void
		{
			BtnHersheys.getIns().go(body_mc.btn,onClickPlay);	
			body_mc.btn.visible = true;
			
			player = new HersheysVideoPlayer(body_mc.movMc,body_mc.tourBtnPlay,body_mc.maskMc,{});
		}
		private function onClickPlay(mc:MovieClip):void
		{
			mc.visible = false;
			player.playVideo("asset/flv/tour.flv");
		}
		private function tourPlay():void
		{
			TweenMax.to(body_mc.movMc,1,{alpha:1});
		}
		public function tour_destroy():void
		{
			if(player != null)
			{
				player.destroy();
				player = null;
			}
		}
		/**	겔러리 영상 보기 팝업	*/
		public function gallery():void
		{
			//trace(viewData.pos);
			galleryPop = new GalleryPopup(body_mc,viewData.pos);
		}
		public function gallery_destroy():void
		{
			galleryPop.destory();
		}
	}//class
}//package