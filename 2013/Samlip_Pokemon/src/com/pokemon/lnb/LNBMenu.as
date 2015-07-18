package com.pokemon.lnb
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class LNBMenu
	{
		
		private var $con:MovieClip;
		/**	서브메뉴 버튼 수	*/
		private var $btnLength:Array =[4, 2, 4, 1];
		
		private var $menuNum:int;
		
		private var $btnArr:Array;
		
		private var $activeNum:int;
		
		private var $menuTimeout:uint;
		
		public function LNBMenu(con:MovieClip, menuNum:int, subNum:int)
		{
			TweenPlugin.activate([FramePlugin]);
			$con = con;
			
			$menuNum = menuNum - 1;
			
			$con.smallCharcater.gotoAndStop(menuNum);
			$con.character.gotoAndStop(menuNum);
			$con.menu.gotoAndStop(menuNum);
			
			makeButton();
			$activeNum = subNum - 1;
			activeMenu($activeNum);
		}
		
		private function makeButton():void
		{
			$btnArr = [];
			
			for (var i:int = 0; i < $btnLength[$menuNum]; i++) 
			{
				var btn:MovieClip = $con.menu.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				$btnArr.push(btn);
				ButtonUtil.makeButton(btn, subBtnHandler);
			}
			
			$con.btnLogo.buttonMode = true;
			$con.btnLogo.addEventListener(MouseEvent.CLICK, logoHandler);
		}
		
		private function subBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					clearTimeout($menuTimeout);
					activeMenu(target.no);
					break;
				case MouseEvent.MOUSE_OUT :
					$menuTimeout = setTimeout(activeMenu, 500, $activeNum);
					break;
				case MouseEvent.CLICK :
					$activeNum = target.no;
					activeMenu($activeNum);
					JavaScriptUtil.call("menu0" + ($menuNum + 1) + "0" + ($activeNum + 1));
					break;
			}
		}
		
		private function activeMenu(num:int):void
		{
			for (var i:int = 0; i < $btnLength[$menuNum]; i++) 
			{
				if(i == num)
				{
					TweenLite.to($btnArr[i], 0.65, {frame:$btnArr[i].totalFrames, ease:Expo.easeOut});
				}
				else
				{
					TweenLite.to($btnArr[i], 0.65, {frame:1, ease:Expo.easeOut});
				}
			}
		}
		
		private function logoHandler(e:MouseEvent):void
		{
			JavaScriptUtil.call("home");
		}
	}
}