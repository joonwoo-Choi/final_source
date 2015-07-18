package contents.qnaevent.step
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.net.Location;
	import com.sw.utils.VideoPlayer;
	
	import contents.qnaevent.QnAGlobal;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import util.BGM;
	import util.BtnHersheys;
	
	/**		
	 *	SK2_Hersheys :: Q&A 영상 플레이
	 */
	public class QnAStepMovie extends BaseQnAStep
	{
		/**	그래픽	*/
		private var container:QnAMovieClip;
		
		private var player:VideoPlayer;
		/**	영상 위치	*/
		private var pos:int;
		/**	생성자	*/
		public function QnAStepMovie(mc:MovieClip=null)
		{
			container = new QnAMovieClip();
			init();
			super(container);
			
			
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		private function onAdd(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			
			//테스트 페이지, 로컬에서 테스트 시 
			if(	Location.setURL("local","") == "local" || 
				loaderInfo.url.substr(0,14) == "http://hertest")
				container.stage.addEventListener(KeyboardEvent.KEY_DOWN,onClickKey);	
		}
		private function onClickKey(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.N)
			{
				onComplete();
			}
		}
		/**	초기화	*/
		private function init():void
		{
//			trace(QnAGlobal.getIns().qPos);
			
			pos = QnAGlobal.getIns().qPos;
			container.mcTxt.gotoAndStop(pos);
			container.btnPlay.gotoAndStop(1);
			container.mcMov.alpha = 0;
			
			BtnHersheys.getIns().playBtn(container.btnPlay,onClickPlay);
		}
		private function onOverMov(mc:MovieClip):void
		{
			TweenMax.to(container.btnPlay,1,{alpha:1});
		}
		private function onOutMov(mc:MovieClip):void
		{
			if( container.mouseX > container.btnPlayArea.x && 
				container.mouseX < container.btnPlayArea.width + container.btnPlayArea.x &&
				container.mouseY > container.btnPlayArea.y && 
				container.mouseY < container.btnPlayArea.height) return;
			
			TweenMax.to(container.btnPlay,0.5,{alpha:0,ease:Expo.easeIn});
		}
		
		/**	영상 플레이 버튼 클릭	*/
		private function onClickPlay(mc:MovieClip):void
		{
			if(player != null && mc.currentFrame == 1)
			{
				mc.nextFrame();
				player.loader.videoPaused = false;
				return;
			}
			else if(player != null && mc.currentFrame == 2)
			{
				mc.prevFrame();
				player.loader.videoPaused = true;
				return;
			}
			
			var obj:Object = new Object();
			obj.url = "asset/flv/Question"+pos+".flv";
			obj.width = 830;
			obj.height = 466;
			obj.finish = onComplete;
			obj.color = 0xffffff;
			obj.fnc_play = onPlay;
			player = new VideoPlayer(container.mcMov,obj);
			
			Button.setUI(container.btnPlayArea,{over:onOverMov,out:onOutMov});
			
			container.btnPlayArea.buttonMode = false;
			
			container.btnPlay.nextFrame();
			
			QnAGlobal.getIns().viewDot();
			Global.getIns().bgm.snd.soundPaused = true;
		}
		private function onPlay():void
		{
			TweenMax.to(container.mcMov,1.5,{alpha:1,ease:Expo.easeInOut});
		}
		/**	영상 플레이 완료	*/
		private function onComplete():void
		{
			Global.getIns().bgm.snd.soundPaused = false;
			
			if(pos == 1 || pos == 2 || pos == 5) QnAGlobal.getIns().moveStep(3);
			if(pos == 3 || pos == 4) QnAGlobal.getIns().moveStep(4);
		}
		/**	사라지기	*/
		override public function hide():void
		{
			super.hide();
			QnAGlobal.getIns().hideDot();
			destoryPlayer();
		}
		/**	동영상 플레이어 소멸자	*/
		private function destoryPlayer():void
		{
			if(player == null) return;
			player.remove();
			player = null;
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			container.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onClickKey);	
			destoryPlayer();
			
			super.destroy();
		}
		
	}//class
}//package