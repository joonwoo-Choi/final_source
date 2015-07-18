package util
{
	import away3d.loaders.Obj;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.loading.VideoLoader;
	import com.sw.buttons.Button;
	import com.sw.utils.VideoPlayer;
	
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	
	/**		
	 *	SK2_Hersheys :: 영상 플레이어
	 */
	public class HersheysVideoPlayer
	{
		/**	외부에서 받아온 데이터	*/
		private var data:Object;
		/**	플레이어 클래스	*/
		private var player:VideoPlayer;
		/**	영상 무비클립	*/
		private var movMc:MovieClip;
		/**	영상을 감싸고 있는 마스크	*/
		private var maskMc:MovieClip;
		/**	영상 일시정지 버튼	*/
		private var btn:MovieClip;
		/**	영상 모두 플레이 했는지 여부	*/
		private var bFinish:Boolean;
		/**	영상 경로	*/
		private var url:String;
		/**	버튼 오버 알파 표현 여부	*/
		private var bAlpha:Boolean;
		
		private var autoPlay:Boolean;
		
		/**	생성자	*/
		public function HersheysVideoPlayer($movMc:MovieClip,$btn:MovieClip,$maskMc:MovieClip,$data:Object = null)
		{
			movMc = $movMc;
			btn = $btn;
			bAlpha = true;
			autoPlay = true;
			
			data = $data;
			if(data == null) data = new Object();
			if($data.alpha != null) bAlpha = data.alpha;
			if($data.autoPlay != null) autoPlay = data.autoPlay;
			
			maskMc = $maskMc;
			
			btn.visible = false;
			init();
		}
		/**	초기화	*/
		private function init():void
		{
			bFinish = false;
			btn.gotoAndStop(1);
			BtnHersheys.getIns().playBtn(btn,onClickPlay,true);
		}
		public function getLoader():VideoLoader
		{	
			if(player != null) return player.loader;	
			return null;
		}
		public function playVideo($url:String = ""):void
		{
			btn.visible = true;
			bFinish = false;
			if($url != "") url = $url;
			
			//영상 플레이전 기존 영상 서서히 사라지고 난후 등장
			if(player != null) 
				if(player.loader != null) player.loader.videoPaused = true;
			
			if(movMc.alpha != 0) TweenMax.to(movMc,0.5,{alpha:0,onComplete:play});
			else play();
		}
		
		/**	영상 플레이	*/
		private function play():void
		{
			if(player != null)
			{
				player.remove();
				player = null;
			}
			var obj:Object = new Object();
			obj.url = url;
			obj.width = maskMc.width;
			obj.height = maskMc.height;
			obj.color = 0xffffff;
			obj.mode = "proportionalOutside";
			obj.fnc_play = viewMov;
			obj.finish = onFinishMovie;
			obj.autoPlay = autoPlay;
			
			player = new VideoPlayer(movMc,obj);
		}
		
		/**	영상 모두 플레이	*/
		private function onFinishMovie():void
		{
			bFinish = true;
			btn.gotoAndStop(1);
			TweenMax.to(btn,1,{alpha:1});
		}
		private function viewMov():void
		{
			TweenMax.to(movMc,1,{alpha:1});
			TweenMax.to(btn,1,{alpha:0});
			btn.gotoAndStop(2);
			if(data.play != null) data.play();
		}
		/**	영상 일시 정지	버튼 클릭	*/
		private function onClickPlay(mc:MovieClip):void
		{
			if(mc.currentFrame == 1)
			{
				mc.nextFrame();
				player.loader.videoPaused = false;
				
				if(bFinish == true)
				{
					player.remove();
					player = null;
					playVideo();
				}
				
			}
			else if(mc.currentFrame == 2)
			{
				mc.prevFrame();
				player.loader.videoPaused = true;
			}
		}
		
		/**	소멸자	*/
		public function destroy():void
		{
			if(player != null)
			{
				player.remove();
				player = null;
			}
			TweenMax.to(movMc,0,{alpha:0});
		}
		
	}//class
}//package