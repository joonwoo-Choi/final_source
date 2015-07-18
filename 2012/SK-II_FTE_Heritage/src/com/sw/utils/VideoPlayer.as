package com.sw.utils
{
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.display.ContentDisplay;
	import com.sw.buttons.Button;
	import com.sw.display.Remove;
	import com.sw.display.Scene;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	* <p>flv 영상 플레이 클래스
	*	UI 제어 버튼 내용 <br>
	 * UI.pause_mc		:: 일시정시,시작 <br>
	 * UI.stop_mc		:: 영상 멈춤 <br>
	 * UI.sound_mc		:: 사운드 키고,끄기 <br>
	 * UI.play_mc		:: 영상 플레이 버튼 <br>
	 * UI.slide_mc		::	슬라이드 mc <br>
	 * <br>
	 * <p>ex : player = new VideoPlayer(mov_mc,<br>
	 * {url:flvURL,UI:UI_mc,width:400,height:300,color:0x531C1C,finish:onFinish,fnc_play:onPlay,mode:"proportionalInside",enter:onEnter,autoPlay:true});
	* */
	public class VideoPlayer extends Scene
	{
		private var data:Object;
		
		public var mov_mc:MovieClip;
		public var UI_mc:MovieClip;
		public var loader:VideoLoader;
		public var flvURL:String;
		
		public var finish_fnc:Function;
		public var enter_fnc:Function;
		public var bFinish:Boolean;
		
		public var org_w:Number;
		public var org_h:Number;
		
		public var play_first:Boolean;
		/**	생성자<br>		
		 * */
		public function VideoPlayer($mov_mc:MovieClip,$data:Object)
		{
			super();
			fN_init($mov_mc,$data);
		}
		/**	소멸자		*/
		public function remove():void
		{
			this.removeEventListener(Event.ENTER_FRAME,onEnter);
			if(loader != null)
			{
				//loader.videoPaused = true;
				//loader.netStream.pause();
				
				loader.unload();
				loader.netStream.close();
				loader.pause();
				
				loader.dispose();
				loader = null;
			}
			Remove.all(this);
		}
		/**	진행중인 시간 반환	 
		 * @return		::		(Number)
		 */
		public function get time():Number
		{	return loader.videoTime;	}
		
		/**
		 * 	총 영상 시간 반환
		 * @return		::		(Number)
		 */
		public function get duration():Number
		{	return loader.duration;	}
		
		/**
		 * 초기화 
		 * @param $mov_mc		:: 영상 내용이 들어갈 MovieClip
		 * @param $data		:: 데이터 값
		 */
		public function fN_init($mov_mc:MovieClip,$data:Object):void
		{
			//trace(mov_mc.pause_mc.plane_mc.name);
			play_first = false;
			mov_mc = $mov_mc;
			UI_mc = ($data.UI) ? ($data.UI) : (null);
			bFinish = false;
			
			data = $data;
			flvURL = ($data.url);
			data.name = "flv";
			data.width = ($data.width != null) ? ($data.width) : (null);
			data.height = ($data.height != null) ? ($data.height) : (null);
			data.repeat = ($data.replay != null) ? ($data.replay) : (0);
			data.bgAlpha = ($data.bg != null) ? ($data.bg) : (1);
			data.bgColor = ($data.color != null) ? ($data.color) : (0x000000);
			data.smoothing = ($data.smooth != null) ? ($data.smooth) : (true);
			data.scaleMode = ($data.mode != null) ? ($data.mode) : ("proportionalInside");
			data.autoPlay = ($data.autoPlay != null) ? ($data.autoPlay) : (true);
			data.container = mov_mc;
			
			data.onInit = onInitVideo;
			
			
			if(data.width == null) delete data.width;
			if(data.height == null) delete data.height;
			
			loader = new VideoLoader(flvURL,data);
			
			if(data.width != null)
				loader.rawContent.width = data.width;
			if(data.height != null)
				loader.rawContent.height = data.height;
			loader.rawContent.x = 0;
			
			finish_fnc = ($data.finish != null) ? ($data.finish) : (null);
			enter_fnc = ($data.enter != null) ? ($data.enter) : (null);
			
			if(UI_mc != null)	fN_setUI(UI_mc);
			if(flvURL != null) loader.load();
			
			loader.addEventListener(VideoLoader.VIDEO_PLAY,onPlay);
			
			this.addEventListener(Event.ENTER_FRAME,onEnter);
		}
		
		private function onInitVideo(e:Event):void
		{
			org_w = loader.metaData.width;
			org_h = loader.metaData.height;
			if(data.init != null) data.init();
			//trace(org_w,org_h);
		}
		/**	처음 영상이 플레이를 시작 할때 함수 호출	*/
		private function onPlay(e:LoaderEvent):void
		{
			if(data.fnc_play != null && play_first == false) data.fnc_play();
			play_first = true;
		}
		/**	플레이가 끝까지 되었는지 체크, slide 셋팅	*/
		private function onEnter(e:Event):void
		{
			if(enter_fnc != null) enter_fnc();
			//trace(Math.abs(loader.videoTime - loader.duration));
			//trace(bFinish);
			if(Math.abs(loader.videoTime - loader.duration)<0.1 && bFinish == false) 
			{
				if(finish_fnc != null) finish_fnc();
				bFinish = true;
			}
			//슬라이드 표시
			if(UI_mc != null && MovieClip(UI_mc.slide_mc)) onEnterSlide();
		}
		
		/**	플레이 제어 네비게이션		*/
		private function fN_setUI($UI_mc:MovieClip):void
		{
			var uiAry:Array = [$UI_mc.pause_mc,$UI_mc.stop_mc,$UI_mc.sound_mc,$UI_mc.play_mc];
			for(var i:int=0; i<uiAry.length; i++)
			{
				var mc:MovieClip = uiAry[i] as MovieClip;
				if(mc == null) continue;							//해당 버튼 없을시 패스
				mc.mouseChildren = false;
				mc.code = i;
				Button.setUI(mc,{over:onOver,out:onOut,click:fN_onClickUI});
			}	
		}
		/** 버튼 오버시*/
		private function onOver($mc:MovieClip):void
		{	if(data.over) data.over($mc);	}
		/** 버튼 아웃시*/
		private function onOut($mc:MovieClip):void
		{	if(data.out) data.out($mc);	}
		/**
		 * 버튼 클릭
		 * */
		private function fN_onClickUI($mc:MovieClip):void
		{
			switch($mc.code)
			{
				case 0:		//일시 정지
					if($mc.currentFrame == 1)
					{
						loader.videoPaused= true;
						$mc.nextFrame();
					}
					else if($mc.currentFrame == 2)
					{
						bFinish = false;
						loader.videoPaused= false;
						$mc.prevFrame();
					}
					break;
				case 1:		//정지
					loader.videoPaused = true;
					loader.gotoVideoTime(0,false);
					if(UI_mc.pause_mc != null) UI_mc.pause_mc.nextFrame();
					break;
				case 2:		//사운드 토글 버튼
					if($mc.currentFrame == 1)
					{
						loader.volume = 0;
						$mc.nextFrame();
					}
					else if($mc.currentFrame == 2)
					{
						loader.volume = 1;
						$mc.prevFrame();
					}
					break;
				case 3:		//플레이
					loader.videoPaused = false;
					bFinish = false;
					if(UI_mc.pause_mc != null) UI_mc.pause_mc.prevFrame();
				break;
			}		
		}
		/**	slide 내용 셋팅	*/
		private function onEnterSlide():void
		{
			var mc:MovieClip = UI_mc.slide_mc;
			var pos:Number = (loader.videoTime/loader.duration)*mc.bg_mc.width;
			mc.bar_mc.width -= (mc.bar_mc.width - pos)*0.3;
			
			if(mc.dot_mc == null) return;
			pos = (loader.videoTime/loader.duration)*(mc.bg_mc.width-mc.dot_mc.width);
			mc.dot_mc.x -= (mc.dot_mc.x - pos)*0.3;		
		}
		/*
		private function fN_onEnterSlide(e:Event):void
		{
			var mc:MovieClip = e.target as MovieClip;
			var pos:Number = (loader.videoTime/loader.duration)*mc.bg_mc.width;
			mc.bar_mc.width -= (mc.bar_mc.width - pos)*0.3;
			pos = (loader.videoTime/loader.duration)*(mc.bg_mc.width-mc.dot_mc.width);
			mc.dot_mc.x -= (mc.dot_mc.x - pos)*0.3;
		}
		*/
	}
}