package com.pokemon.main
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.pokemon.event.PokemonEvent;
	import com.pokemon.model.Model;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	
	public class Main
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	빵 롤링 타이머	*/
		private var $rollingTimer:Timer;
		/**	빵 갯수	*/
		private var $breadLength:int = 4;
		/**	빵 배열	*/
		private var $breadArr:Array;
		/**	현재 빵 번호	*/
		private var $breadNum:int;
		/**	이전 빵 번호	*/
		private var $prevNum:int;
		
		public function Main(con:MovieClip)
		{
			TweenPlugin.activate([TintPlugin]);
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(PokemonEvent.POKEMON_XML_LOADED, settingMain);
		}
		
		protected function settingMain(e:Event):void
		{
			/**	행운번호 배너	*/
			ButtonUtil.makeButton($con.banner.pointBanner.btn, pointButtonHandler);
			
			/**	이벤트 배너	*/
			$con.banner.eventBanner.btn.buttonMode = true;
			$con.banner.eventBanner.btn.addEventListener(MouseEvent.CLICK, eventButtonHandler);
			
			/**	브래드 배너	*/
			$con.banner.breadBanner.btn.buttonMode = true;
			$con.banner.breadBanner.btn.addEventListener(MouseEvent.CLICK, breadButtonHandler);
			
			/**	이벤트 배너 이미지 로드	*/
			var ldr:Loader = new Loader();
			var url:String;
			if(SecurityUtil.isWeb())
			{		url = SecurityUtil.getPath($con) + "data/event.jpg";		}
			else
			{		url = "data/event.jpg";		};
			ldr.load(new URLRequest(url));
			$con.banner.eventBanner.img.addChild(ldr);
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, eventImgLoaded);
			
			var i:int;
			$breadArr = [];
			for (i = 0; i < $breadLength; i++) 
			{
				var bread:MovieClip = $con.banner.breadBanner.getChildByName("bread" + i) as MovieClip;
				$breadArr.push(bread);
			}
			$rollingTimer = new Timer(3500);
			$rollingTimer.addEventListener(TimerEvent.TIMER, rollingBread);
			$rollingTimer.start();
		}
		
		private function rollingBread(e:TimerEvent):void
		{
			$breadNum++;
			
			if($breadNum >= $breadLength) $breadNum = 0;
			
			moveBread($breadNum);
		}
		
		private function moveBread(num:int):void
		{
			var i:int;
			for (i = 0; i < $breadLength; i++) 
			{
				if(i == num)
				{
					var moveNum:int = $con.banner.breadBanner.btn.x + $con.banner.breadBanner.btn.width/2 - $breadArr[i].width/2
					$breadArr[i].x = $con.banner.breadBanner.btn.x + $con.banner.breadBanner.btn.width;
					TweenLite.to($breadArr[i], 0.5, {x:moveNum});
				}
				else
				{
					TweenLite.to($breadArr[i], 0.5, {x:$con.banner.breadBanner.btn.x - $con.banner.breadBanner.btn.width});
				}
			}
		}
		
		private function eventImgLoaded(e:Event):void
		{	e.target.content.smoothing = true;	}
		
		private function pointButtonHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to($con.banner.pointBanner.over, 0.6, {alpha:1});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to($con.banner.pointBanner.over, 0.6, {alpha:0});
					break;
				case MouseEvent.CLICK :
					JavaScriptUtil.call("lucky");
					break;
			}
		}
		
		private function eventButtonHandler(e:MouseEvent):void
		{
			JavaScriptUtil.call("event");
		}
		
		private function breadButtonHandler(e:MouseEvent):void
		{
			JavaScriptUtil.call("menu0104");
		}
	}
}