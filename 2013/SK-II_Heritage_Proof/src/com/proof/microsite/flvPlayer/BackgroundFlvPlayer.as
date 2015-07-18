package com.proof.microsite.flvPlayer
{
	
	import com.adqua.display.Resize;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class BackgroundFlvPlayer
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	넷 스트림	*/
		private var $ns:NetStream;
		/**	넷 커넥션	*/
		private var $nc:NetConnection;
		/**	비디오	*/
		private var $video:Video;
		/**	플레이 true / false	*/
		private var $playing:Boolean = false;
		/**	전체 시간	*/
		private var $totalTime:Number;
		/**	비디오 가로 크기	*/
		private var $videoWidth:int;
		/**	비디오 세로 크기	*/
		private var $videoHeight:int;
		/**	비디오 경로	*/
		private var $videoPath:String;
		/**	리사이즈	*/
		private var $resize:Resize;
		/**	영상 타입 배열	*/
		private var $movType:Array;
		/**	영상 갯수 배열	*/
		private var $movLength:Array;
		/**	영상 플레이 리스트 배열	*/
		private var $movPlayList:Array;
		/**	메인 영상 플레이 갯수	*/
		private var $movListLength:int;
		/**	서브 영상 플레이 갯수	*/
		private var $subMovListLength:int;
		/**	플레이 번호	*/
		private var $playNum:int = 0;
		
		public function BackgroundFlvPlayer(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.PLAY_LIST_LOADED, playListLoaded);
			$model.addEventListener(ModelEvent.MENU_CHANGE, menuChange);
			
			$resize = new Resize();
			
			resizeHandler();
			$con.stage.addEventListener(Event.RESIZE, resizeHandler);
		}
		/**	메뉴 변경시 실행	*/
		private function menuChange(e:Event):void
		{		menuCheck();		}
		
		/**	최초 리스트 로드시 실행	*/
		protected function playListLoaded(e:Event):void
		{
			$movType = [	$model.backMovList.intro,
									$model.backMovList.mainMov,
									$model.backMovList.subMov,
									$model.backMovList.outro];
			menuCheck();
		}
		
		private function menuCheck():void
		{
			$playNum = 0;
			
			$movListLength = 8;
			mainMovListArrange();
			
//			if($model.menuNum == 0)
//			{		
//				$movListLength = 9;
//				mainMovListArrange();
//			}
//			else
//			{		
//				$movListLength = 1;
//				subMovListArrange();
//			}
			trace("플레이 리스트 영상 갯수_____: " + $movListLength);
		}
		/**	메인 영상 플레이 리스트 정렬	*/
		private function mainMovListArrange():void
		{
			$movPlayList = [];
			
//			var randomNum:int = Math.random() * $movType[3].list.length();
			$movPlayList.push($movType[0].list.@path);
			
			var chkArr:Array = [];
			for (var j:int = 0; j < $movType[1].list.length(); j++) 
			{		chkArr.push(j);		}
			
			/**	중복 검사 & 랜덤 번호 배열 저장	*/
			var cnt:int = 0;
			while (cnt < $movListLength - 2)
			{
				var randomNum:int = Math.random() * $movType[1].list.length();
				
				for (var i:int = 0; i < chkArr.length; i++) 
				{
					if(chkArr[i] == randomNum)
					{
						$movPlayList.push($movType[1].list[randomNum].@path);
						chkArr[i] = chkArr.length;
						cnt ++;
						trace("영상 배열 번호_____: " + randomNum);
					}
				}
			}
			
//			randomNum = Math.random() * $movType[0].list.length();
			$movPlayList.push($movType[3].list.@path);
			
			if($playing == false) videoSetting();
			else playVideo();
		}
		/**	서브 영상 플레이 리스트 정렬	*/
		private function subMovListArrange():void
		{
			$movPlayList = [];
			
			$movPlayList.push($movType[2].list[$model.menuNum].@path);
			
			if($playing == false) videoSetting();
			else playVideo();
		}
		
		/**	비디오 셋팅	*/
		private function videoSetting():void
		{
			trace("플레이 리스트 저장된 영상_____: " + $movPlayList);
			$nc = new NetConnection();
			$nc.connect( null );
			$ns = new NetStream( $nc );
			$video = new Video();
			$video.smoothing = true;
			$video.attachNetStream( $ns );
			$con.addChild($video);
			$con.alpha = 0;
			
			playVideo();
		}
		/** 비디오 플레이 **/
		private function playVideo():void
		{
			var meta:Object = new Object();
			
			meta.onMetaData = function(info:Object):void{
				$totalTime = info["duration"];
				$videoWidth = info["width"];
				$videoHeight = info["height"];
				$video.width =  $videoWidth;
				$video.height =  $videoHeight;
				resizeHandler();
				trace("$totalTime: "+$totalTime);
				trace("$videWidth: "+$videoWidth);
				trace("$videHeight: "+$videoHeight);
			};
			
			meta.onCuePoint = function(info:Object):void{
				for (var infoName:String in info) 
				{	trace("infoName: "+infoName);	}
			};
			
			$videoPath = $movPlayList[$playNum];
			trace("영상 경로_____: " + $videoPath);
			
			if($playing ==  false)
			{
				$playing = true;
				TweenLite.to($con, 1, {delay:0.5, alpha:1, ease:Cubic.easeOut});
			}
			
			$ns.client = meta;
			$ns.play( $videoPath );
			$ns.addEventListener(NetStatusEvent.NET_STATUS, playChk);
		}
		/** 비디오 플레이 체크 **/
		protected function playChk( e:NetStatusEvent ):void
		{
			switch(e.info.code)
			{
				case "NetStream.Play.Start" :
					resizeHandler();
					trace("video_Start");
					break;
				case "NetStream.Play.Stop" :
//					if($model.menuNum == 0)
//					{
						if($playNum < $movListLength - 1)
						{
							$playNum++;
							playVideo();
							trace("영상 교체__$playNum ==>  " + $playNum);
						}
						else
						{
							menuCheck();
							trace("영상 리스트 회전__$playNum ==>  " + $playNum);
						}
//					}
//					else
//					{
//						playVideo();
//					}
//					trace("video_Stop");
					break;
			}
		}
		/**	비디오 제거	*/
		private function destroyVideo(e:Event):void
		{
			$ns.close();
			
			$video.clear();
			$con.removeChild($video);
			$video = null;
			$playing = false;
		}
		
		private function resizeHandler(e:Event = null):void
		{
			$resize.stageResize($con, $con.stage.stageWidth, $con.stage.stageHeight, 1659, 877, false, false);
			$resize.arrangeX($con, 1024);
		}
	}
}