package com.sw.utils
{
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.MP3Loader;
	import com.sw.buttons.Button;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class BGMClip extends Sprite
	{
		/**	사운드 내용	*/
		public var snd:MP3Loader;
		/**	버튼 내용	*/
		//private var scope_mc:MovieClip;
		/**	파일 경로	*/
		private var url:String;
		private var data:Object;
		private var volume:Number;
		/**	생성자	*/
		public function BGMClip($url:String,$data:Object = null)
		{
			super();
			//scope_mc = $scope_mc;
			url = $url;
			data = $data;
			if(data == null) data = new Object();
			
			volume = 1;
			if(data.volume != null) volume = data.volume;
			init();	
		}
		/**
		 * 초기화
		 */ 
		private function init():void
		{
			var autoPlay:Boolean = true;
			if(data.autoPlay != null) autoPlay = data.autoPlay;
			var repeat:int = -1;
			if(data.repeat != null) repeat = data.repeat;
			var obj:Object = new Object();
			obj.name = "audio";
			obj.autoPlay = autoPlay;
			obj.repeat = repeat;
			obj.volume = volume;
			obj.onComplete = onCompleteLoad;
			
			snd = new MP3Loader(url,obj);
			snd.addEventListener(MP3Loader.SOUND_COMPLETE,onCompleteSnd);
			snd.load();
		}
		/**	로드 완료	*/
		private function onCompleteLoad(e:LoaderEvent):void
		{
			//Button.setUI(scope_mc,{click:onClick});
			if(data.onLoad != null) data.onLoad();
			
		}
		/**	사운드 플레이 완료	*/
		private function onCompleteSnd(e:LoaderEvent):void
		{
			//trace("aaaa");
			if(data.completePlay != null) data.completePlay();
		}
		/**
		 *	사운드 상대 외부에서 키고 끄기 
		 * @param $state	:: "start","off","volOff","volOn"
		 * 
		 */		
		public function setSnd($state:String = "off"):void
		{
			switch($state)
			{	
			case "start":
				snd.gotoSoundTime(0);
				//scope_mc.gotoAndStop(2);
				//onClick(scope_mc);
				break;
			case "on":
				snd.soundPaused = false;
				break;
			case "off": 
				snd.soundPaused = true;
			
				//scope_mc.gotoAndStop(1);
				//onClick(scope_mc);
				break;
			case "volOff":
				setVol(0,1);
				//snd.volume = 0;
				break;
			case "volOn":
				setVol(1,1);
				//snd.volume = 1;
				break;
			}
		}
		
		/**	사운드 조절	*/
		public function setVol($num:Number,$speed:Number = 0.7,$complete:Function = null):void
		{
			var obj:Object = {};
			obj.volume = $num;
			if($complete != null) obj.onComplete = $complete;
			
			TweenMax.to(snd,$speed,obj);
		}
		/**		
		 * 마우스 클릭시
		 */
		/*
		private function onClick($mc:MovieClip=null):void
		{
			if($mc.currentFrame == 1)
			{
				$mc.nextFrame();
				snd.soundPaused = true;	
			}
			else if($mc.currentFrame == 2)
			{
				$mc.prevFrame();
				snd.soundPaused = false;
			}
		}
		*/
		/**	소멸자	*/
		public function destroy():void
		{	
			if(snd != null)
			{
				snd.dispose();
				snd = null;
			}
			data = null;
			
		}
	}//class
}//package