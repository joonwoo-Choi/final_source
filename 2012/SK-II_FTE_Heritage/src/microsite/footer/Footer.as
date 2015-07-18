package microsite.footer
{
	import adqua.movieclip.TestButton;
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.loading.MP3Loader;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	[SWF(width="1000",height="42",backgroundColor="0xffffff",frameRate="30")]
	public class Footer extends Sprite
	{
		[Embed(source = 'lib/copyright.png')]
		private var Copyright:Class;
		private var $copyright:Bitmap = new Copyright();
		private var $sndCon:Sprite;
		[Embed(source = 'lib/sound.png')]
		private var BtnImg:Class;
		private var $sndBtnImg:Bitmap = new BtnImg();
		private var $sndBtn:Sprite;
		private var $barCon:Sprite;
		private var $barBank:Array;
		private var $sndPlay:Boolean = true;
		
		public function Footer()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			if(ExternalInterface.available)ExternalInterface.addCallback("soundPause",sndOff);
			if(ExternalInterface.available)ExternalInterface.addCallback("soundPlay",sndOn);
		}
		
		protected function onAdded(event:Event):void
		{
			// TODO Auto-generated method stub
			stage.scaleMode = "noScale";
			stage.align = "TL";
			stage.addEventListener(Event.RESIZE,onResize);
			makeBar();
			flashVarSetting();
		}
		
		private function makeBar():void
		{
			// TODO Auto Generated method stub
			$barCon = new Sprite;
			addChild($barCon);
			$bar = TestButton.btn(stage.stageWidth,42,0x1a1a1a);
			$barCon.addChild($bar);
		}
		private function flashVarSetting():void
		{
			// TODO Auto Generated method stub
			$flashVars = root.loaderInfo.parameters;
			if($flashVars["sndPlay"]==undefined){
				$sndPlay = false;
			}else{
				if( $flashVars["sndPlay"]=="true"){
					$sndPlay = true;
				}else{
					$sndPlay = false;
				}
			}
			setting();			
			onResize();
		}
		
		protected function onResize(event:Event=null):void
		{
			// TODO Auto-generated method stub
			var th:int = (stage.stageWidth>1280)?stage.stageWidth:1280;
			$copyright.x = (th-$copyright.width)/2;
			$sndCon.x = $copyright.x+$copyright.width+40;
			$bar.width = th;
		}
		
		private function setting():void
		{
			// TODO Auto Generated method stub
//			makeSndPlayer();
			$copyright.y = int((42-$copyright.height)/2);
			$barCon.addChild($copyright);
			
			$sndCon = new Sprite();
			$sndCon.visible = false;
			$sndCon.y = $copyright.y;
			$sndBtn = new Sprite();
			$sndBtn.addChild($sndBtnImg)
			$sndBtn.addEventListener(MouseEvent.CLICK,onPlayPauseClick);
			$sndCon.addChild($sndBtn);
			$barCon.addChild($sndCon);
			
			makeBars();
		}
		
		private function makeSndPlayer():void
		{
			
			// TODO Auto Generated method stub
			$bgmSound = new MP3Loader(SecurityUtil.getPath(root)+"sound/2pro.mp3", {name:"audio", 
//				onProgress:progressHandler,
//				onError:errorHandler,
//				onComplete:bgmFinished,
				autoPlay:$sndPlay, 
				repeat:-1, 
				estimatedBytes:9500
			});
			$bgmSound.load();
			$bgmSound.addEventListener(MP3Loader.SOUND_COMPLETE,bgmFinished);			
		}
		
		protected function bgmFinished(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		public function bgmStop():void{
			trace("bgmStop");
			TweenLite.to($bgmSound,.5,{volume:0,onComplete:pauseBgm});
		}
		public function bgmPlay():void{
			$bgmSound.resume();
			TweenLite.to($bgmSound,.5,{volume:1});
		}
		
		private function pauseBgm():void
		{
			$bgmSound.pause();
		}
				
		protected function onPlayPauseClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			$sndPlay = !$sndPlay;
			trace("$sndPlay: ",$sndPlay);
			if($sndPlay){
				sndOn();
			}else{
				sndOff();
			}
		}
		
		private function sndOff():void
		{
			// TODO Auto Generated method stub
			for (var i:int = 0; i < $randomNum.length; i++) 
			{
				var bar:Sprite = $barBank[i];
				TweenMax.killTweensOf(bar);
				TweenMax.to(bar,.5,{scaleY:.2,ease:Cubic.easeInOut});
			}
			bgmStop();
		}
		
		private function sndOn():void
		{
			// TODO Auto Generated method stub
			for (var i:int = 0; i < $randomNum.length; i++) 
			{
				var bar:Sprite = $barBank[i];
				TweenMax.to(bar,.8,{scaleY:1,repeat:-1,yoyo:true,delay:$randomNum[i],ease:Cubic.easeInOut});
			}
			if($bgmSound.paused){
				bgmPlay();
			}else{
				$bgmSound.playSound();
			}
		}
		private var $randomNum:Array=[0,.4,.2,.3,.5,.1];
		private var $flashVars:Object;
		private var $bgmSound:MP3Loader;
		private var $bar:Sprite;
		private function makeBars():void
		{
			// TODO Auto Generated method stub
			$barCon = new Sprite;
			$barCon.x = 5;
			$barCon.y =5;
			$sndCon.addChild($barCon);
			$barBank = [];
			$barCon.scaleY = -1;
			for (var i:int = 0; i < 6; i++) 
			{
				var bar:Sprite= TestButton.btn(1,9,0xa5a5a5);
				bar.x = i*2+($sndBtnImg.width+5);
				bar.scaleY = .1;
				$barBank.push(bar);
				if($sndPlay)TweenMax.to(bar,.8,{scaleY:1,repeat:-1,yoyo:true,delay:$randomNum[i],ease:Cubic.easeInOut});
				$barCon.addChild(bar);
			}
			
		}
	}
}