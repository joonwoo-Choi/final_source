package com.pokemon.main
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.pokemon.event.PokemonEvent;
	import com.pokemon.model.Model;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	public class Banner
	{
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $imgLength:int;
		
		private var $bannerMaskWidth:int = 290;
		
		private var $imgArr:Array;
		
		private var $arrowBtnLength:int = 2;
		
		private var $imgCnt:int;
		
		private var $bannerTimer:Timer;
		
		public function Banner(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(PokemonEvent.POKEMON_XML_LOADED, settingBanner);
		}
		
		protected function settingBanner(e:Event):void
		{
			$imgLength = $model.pokemonXml.info2.children().length();
			
			$imgArr = [];
			for (var i:int = 0; i < $imgLength; i++) 
			{
				var imgLdr:Loader = new Loader();
				var mcCon:MovieClip = new MovieClip();
				mcCon.no = i;
				imgLdr.load(new URLRequest($model.defaulfPath + $model.pokemonXml.info2.children()[i].img));
				imgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
				mcCon.addChild(imgLdr);
				$con.img.addChild(mcCon);
				$imgArr.push(mcCon);
				
				mcCon.buttonMode = true;
				mcCon.addEventListener(MouseEvent.CLICK, bannerClickHandler);
				
				if(i > 0) mcCon.x = $bannerMaskWidth;
			}
			
			for (var j:int = 0; j < $arrowBtnLength; j++) 
			{
				var btnArrow:MovieClip = $con.getChildByName("btn" + j) as MovieClip;
				if($imgLength <= 1)
				{
					btnArrow.visible = false;
				}
				else
				{
					btnArrow.alpha = 1;
					btnArrow.no = j;
					btnArrow.buttonMode = true;
					btnArrow.addEventListener(MouseEvent.CLICK, btnArrowHandler);
					
					if(j >= 1) return;
					
					$bannerTimer = new Timer(3500);
					$bannerTimer.addEventListener(TimerEvent.TIMER, bannerRolling);
					$bannerTimer.start();
					
					$con.addEventListener(MouseEvent.MOUSE_OVER, timerToggle);
					$con.addEventListener(MouseEvent.MOUSE_OUT, timerToggle);
				}
			}
		}
		
		private function timerToggle(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : $bannerTimer.stop(); break;
				case MouseEvent.MOUSE_OUT : $bannerTimer.start(); break;
			}
			trace(e.type);
		}
		
		private function imgLoadComplete(e:Event):void
		{	TweenLite.to($con, 0.6, {alpha:1});	}
		
		private function bannerClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			JavaScriptUtil.call("menu0201");
			/**	XML에 있는 링크 경로	*/
//			navigateToURL(new URLRequest($model.defaulfPath + $model.pokemonXml.info2.children()[target.no].link), "_self");
		}
		
		private function btnArrowHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			var direction:String;

			if(target.no == 0)
			{
				$imgCnt--;
				direction = "left";
			}
			else
			{
				$imgCnt++;
				direction = "right";
			}
			
			/**	화살표 버튼 이벤트 제거	*/
			for (var j:int = 0; j < $arrowBtnLength; j++) 
			{
				var btnArrow:MovieClip = $con.getChildByName("btn" + j) as MovieClip;
				btnArrow.removeEventListener(MouseEvent.CLICK, btnArrowHandler);
			}
			
			changeBanner(direction);
		}
		
		private function changeBanner(direction:String):void
		{
			$imgCnt = checkCount($imgCnt);
			
			var oldImgNum:int;
			if(direction == "left") oldImgNum = $imgCnt + 1;
			else if(direction == "right") oldImgNum = $imgCnt - 1;
			oldImgNum = checkCount(oldImgNum);
			
			for (var i:int = 0; i < $imgLength; i++) 
			{
				if($imgCnt == i)
				{
					if(direction == "left") $imgArr[i].x = -$imgArr[i].width;
					else if(direction == "right") $imgArr[i].x = $bannerMaskWidth;
					TweenLite.to($imgArr[i], 0.6, {x:0, onComplete:addArrowMouseEvent});
				}
				else
				{
					if(direction == "left") TweenLite.to($imgArr[oldImgNum], 0.6, {x:$bannerMaskWidth});
					else if(direction == "right") TweenLite.to($imgArr[oldImgNum], 0.6, {x:-$imgArr[oldImgNum].width});
				}
			}
			trace($imgCnt, oldImgNum);
		}
		/**	화살표 버튼 이벤트 다시 주기	*/
		private function addArrowMouseEvent():void
		{
			for (var j:int = 0; j < $arrowBtnLength; j++) 
			{
				var btnArrow:MovieClip = $con.getChildByName("btn" + j) as MovieClip;
				btnArrow.addEventListener(MouseEvent.CLICK, btnArrowHandler);
			}
		}
		
		private function checkCount(cnt:int):int
		{
			if(cnt < 0) cnt = $imgLength - 1;
			else if(cnt >= $imgLength) cnt = 0;
			
			return cnt;
		}
		
		private function bannerRolling(e:TimerEvent):void
		{
			$imgCnt++;
			changeBanner("right");
		}
	}
}