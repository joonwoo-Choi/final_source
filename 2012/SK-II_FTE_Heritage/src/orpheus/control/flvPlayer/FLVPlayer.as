package orpheus.control.flvPlayer
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.AutoFitArea;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	
	import orpheus.control.scrollbar.BasicScrollEx;
	import orpheus.control.scrollbar.events.ScrollEvent;
	
	public class FLVPlayer extends Sprite
	{
		
		private var $url:String;
		private var $w:int;
		private var $h:int;
		private var $playBtn:MovieClip;
		
		public var videoLoader:VideoLoader;
		
//		private var $scaleMode:String="proportionalInside";
		private var $scaleMode:String="proportionalOutside";
		private var $videoImgURL:String;
		private var $autoPlay:Boolean=false;
		private var $imgLoader:ImageLoader;
		private var $imgCon:Sprite;
		private var $videoCon:Sprite;
		private var $info:Object;
		private var $gap:int=20;
		private var $scroll:BasicScrollEx;
		private var $seekBar:MCScrollW;
		private var $xMax:Number;
		private var $stageVideo:StageVideo;
		private var $bgAlpha:int=1;
		private var $size:String = "normal";
		private var $area:AutoFitArea;
		public function FLVPlayer(url:String,playBtn:MovieClip=null,info:Object=null)
		{
			super();
			TweenPlugin.activate([AutoAlphaPlugin]);
			$videoCon = new Sprite;
			addChild($videoCon);
			$url = url;
			$playBtn = playBtn;
			if($playBtn){
				$playBtn.visible = false;
				$playBtn.alpha = 0;
				addChild($playBtn);
			}
			$info = info;
			infoSetting(info);
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			// TODO Auto-generated method stub
			stage.addEventListener(Event.RESIZE,onResize);
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			$w = ($size=="full")?stage.stageWidth:$w;
			$h = ($size=="full")?stage.stageHeight:$h;
			setting();
		}
		
		protected function onResize(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("onResize::::>>>>");
			changeWH();
			var content:ContentDisplay = LoaderMax.getContent("myVideo");
			content.fitWidth = $w;
			content.fitHeight = $h;
			moveCenterPlayBtn();
			scrollSet();
		}
		
		private function changeWH():void
		{
			$w = stage.stageWidth;
			$h = stage.stageHeight;
		}
		
		private function infoSetting(info:Object):void
		{
			// TODO Auto Generated method stub
			if(info){
				if(info.scaleMode)$scaleMode = info.scaleMode;
				if(info.videoImg)$videoImgURL = info.videoImg;
				if(info.stageVideo)$stageVideo = info.stageVideo;
				if(info.bgAlpha!=null)$bgAlpha = info.bgAlpha;
				if(info.width)$w = info.width;
				if(info.height)$h = info.height;
				if(info.size)$size = info.size;
				if($videoImgURL){
					$imgCon = new Sprite;
					addChild($imgCon);
					$imgLoader = new ImageLoader($videoImgURL, {name:"videoImg", 
					container:$imgCon, 
//					x:180, 
//					y:100, 
//					width:200, 
//					height:150, 
					scaleMode:"proportionalOutside", 
//					centerRegistration:true, 
					onComplete:onImageLoad
					});
					
					//begin loading
					$imgLoader.load();
				}
			}
		}
		
		private function onImageLoad():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function setting():void
		{
			// TODO Auto Generated method stub
			if(videoLoader){
				videoLoader.unload();
			}
			
			videoLoader =new VideoLoader($url, {
				name:"myVideo", 
				container:this, 
				width:$w, height:$h, 
				scaleMode:$scaleMode, 
				bgColor:0x000000, 
				autoPlay:$autoPlay, 
				volume:1,
				bgAlpha:$bgAlpha,
				onOpen:onMovieStart,
				stageVideo:$stageVideo,
				onError:onMovieError
			});
			var content:ContentDisplay = LoaderMax.getContent("myVideo");
			content.addEventListener(Event.CHANGE, onAreaUpdate);
			playBtnSetting();
			videoLoader.addEventListener(VideoLoader.VIDEO_COMPLETE,playComplete);
			videoLoader.load();
			addEventListener(MouseEvent.ROLL_OVER,ctrlPanelShow);
			addEventListener(Event.MOUSE_LEAVE,ctrlPanelHide);
			addEventListener(MouseEvent.ROLL_OUT,ctrlPanelHide);
			//$playBtn.addEventListener(MouseEvent.ROLL_OVER,ctrlPanelShow);
		}
		
		protected function onAreaUpdate(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("onAreaUpdate================");
		}
		public function playMovie(url:String):void{
			videoLoader.url = url;
		}
		
		protected function ctrlPanelHide(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("ctrlPanelHide");
			$seekBar.mcControl.visible = false;
			$seekBar.mcControl.alpha= 0;
			TweenMax.allTo([$playBtn,$seekBar],.5,{autoAlpha:0});
		}
		
		protected function ctrlPanelShow(event:Event):void
		{
			trace("ctrlPanelShow");
			// TODO Auto-generated method stub
			TweenLite.to($seekBar.mcControl,.5,{autoAlpha:1,delay:.5});
			TweenMax.allTo([$playBtn,$seekBar],.5,{autoAlpha:1});
		}
		
		private function playBtnSetting():void
		{
			// TODO Auto Generated method stub
			if($playBtn){
				$playBtn.addEventListener(MouseEvent.CLICK,onPlayClick);
				moveCenterPlayBtn();
				$playBtn.gotoAndStop(1);
			}			
		}
		
		private function moveCenterPlayBtn():void
		{
			$playBtn.x = ($w-$playBtn.width)/2;
			$playBtn.y = ($h-$playBtn.height)/2;
		}
		
		protected function onPlayClick(event:MouseEvent):void
		{
			trace("onPlayClick");
			// TODO Auto-generated method stub
			videoLoader.videoPaused = !videoLoader.videoPaused;
			if(videoLoader.videoPaused)$playBtn.gotoAndStop(1);
			else $playBtn.gotoAndStop(2);
		}
		
		private function onMovieError(event:LoaderEvent):void
		{
			// TODO Auto Generated method stub
				trace("event.type: ",event.type);
		}
		
		private function onMovieStart(event:LoaderEvent):void
		{
			// TODO Auto Generated method stub
			trace("onMovieStart");	
			if($info.seekBar)makeSeekBar();
			addEventListener(Event.ENTER_FRAME,checkCurrentTime);
		}
		
		protected function checkCurrentTime(event:Event):void
		{
			// TODO Auto-generated method stub
			var ratio:Number =videoLoader.videoTime / videoLoader.duration;

			var tx:Number = $xMax*ratio;
			$seekBar.mcControl.x = tx;
			$seekBar.y =  $h-$seekBar.height-$gap;
			$seekBar.mcProgress.x = ($seekBar.mcControl.x+$seekBar.mcControl.width*.5)+($seekBar.mcProgress.width*-1);
		}
		
		private function makeSeekBar():void
		{
			// TODO Auto Generated method stub
			$seekBar = new MCScrollW;
//			$seekBar.mcProgress.visible = false;
			$seekBar.mcProgressMask.mouseEnabled = false;
			$seekBar.mcProgressMask.mouseChildren = false;
//			$seekBar.x = ($w-$seekBar.width)/2
			
			scrollSet();
			
			addChild($seekBar);
			
			$seekBar.mcProgress.mask = $seekBar.mcProgressMask;
			$seekBar.mcControl.addEventListener(MouseEvent.MOUSE_DOWN,stopEnterFrame);
			$seekBar.mcControl.addEventListener(MouseEvent.MOUSE_UP,startEnterFrame);
			setChildIndex($playBtn,numChildren-1);
		}
		
		private function scrollSet():void
		{
			if($info.barWidth){
				$seekBar.mcArea.width = $w*$info.barWidth;
				$seekBar.mcProgressMask.mcProgressMask.width = $seekBar.mcArea.width;
				$seekBar.mcProgress.width = $seekBar.mcProgressMask.width+($seekBar.mcControl.mcIcon.width)/2; 
				$seekBar.mcProgress.x = $seekBar.mcProgressMask.width*-1;
			}
			$xMax = $seekBar.mcArea.width-$seekBar.mcControl.mcIcon.width;
			
			var rect:Rectangle = new Rectangle(0,0,$seekBar.mcArea.width-$seekBar.mcControl.mcIcon.width,0);
			
			$scroll = new BasicScrollEx($seekBar,rect);			
			$scroll.addEventListener(ScrollEvent.CHANGE,scrollChange);
		}
		
		protected function startEnterFrame(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			addEventListener(Event.ENTER_FRAME,checkCurrentTime);
		}
		
		protected function stopEnterFrame(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			removeEventListener(Event.ENTER_FRAME,checkCurrentTime);
		}
		
		protected function scrollChange(evt:ScrollEvent):void
		{
			// TODO Auto-generated method stub
			var playTime:Number = videoLoader.duration*evt.value;
			videoLoader.gotoVideoTime(playTime);
			$seekBar.mcProgress.x = ($seekBar.mcControl.x+$seekBar.mcControl.width*.5)+($seekBar.mcProgress.width*-1);
			
		}
		
		protected function playComplete(event:Event):void
		{
			// TODO Auto-generated method stub
			trace("비디오 재생완료");
			videoLoader.gotoVideoTime(0);
			if($playBtn)$playBtn.gotoAndStop(1);
		}
		public function stopVideo():void{
			if(videoLoader)videoLoader.pauseVideo();
		}
	}
}