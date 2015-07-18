package util
{
	import com.adqua.control.flvPlayer.BasicPlayer;
	import com.adqua.control.flvPlayer.events.MovieStatusEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import orpheus.utils.ArrayUtil;
	
	import pEvent.PEventCommon;
	import pEvent.PEventVideo;

	public class BgPlayer extends AbstractMain
	{
		private var $moviePlayer:BasicPlayer;
		
		public function BgPlayer()
		{
			super();
			$moviePlayer = new BasicPlayer(null,1280,850);
			addChild($moviePlayer);
			$moviePlayer.addEventListener(MovieStatusEvent.STATUS_EVENT, videoStatusHandler);
			
			_model.addEventListener(PEventCommon.MOVIE_CHANGE,playSetting);
			_model.addEventListener(PEventVideo.VIDEO_CLEAR,clearVideo);
			_model.addEventListener(PEventVideo.VIDEO_CLOSE,closeVideo);
			_model.addEventListener(PEventVideo.VIDEO_PAUSE,pauseVideo);
		}
		
		protected function playSetting(event:Event):void
		{
			trace("_model.activeVideoNum: ",_model.numActiveVideo);
			
			//인트로일때			
			if(ArrayUtil.compare(_model.numActiveVideo,[0]))
			{
				trace("aaa");
				var url:String = _model.xmlData.list[int(_model.numActiveVideo[0])].@video;
				playMovie(url);
				$moviePlayer.visible = true;
			}
			//메인일때 
			else if(ArrayUtil.compare(_model.numActiveVideo,[1]))
			{
				trace("bbb");
				$moviePlayer.close();
				$moviePlayer.visible = false;
			}
			else
			{
				trace("ccc");
				trace("--------------------------------------------------------------")
				trace("_model.activeVideoNum: ",_model.numActiveVideo);
				$moviePlayer.visible = true;
			}
		}
		
		protected function videoStatusHandler(event:MovieStatusEvent):void
		{
			if(event.code=="NetStream.Play.Stop"){
//				_controler.movieFinished();

//				_controler.changeMovie([1]);
				
				_model.dispatchEvent(new PEventCommon(PEventCommon.INTRO_NEXT))
				
				trace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			}
		}
		
		protected function playMovie(videoURL:String):void{
			$moviePlayer.play(videoURL);
		}
		
		protected function clearVideo(event:Event):void{
			$moviePlayer.clear();
			trace("clear_________________________________________");
		}
		protected function closeVideo(event:Event):void{
			$moviePlayer.close();
			trace("close_______________________________");
		}
		protected function pauseVideo(event:Event):void{
			$moviePlayer.pause();
			trace("pause-------------------------------");
		}
		
	}
}