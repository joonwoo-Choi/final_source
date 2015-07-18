package com.pokemon.gnb
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
	
	public class GNBMenu
	{
		
		private var $con:MovieClip;
		/**	1뎁스 메뉴 수	*/
		private var $btnLength:int = 3;
		/**	서브 메뉴 수	*/
		private var $subMenuLength:Array = [4, 2, 4];
		/**	1뎁스 활성 번호	*/
		private var $menuNum:int = -1;
		/**	메뉴 활성 리셋 타임아웃	*/
		private var $menuTimeout:uint;
		/**	1뎁스 배열	*/
		private var $menuArr:Array;
		/**	2뎁스 배열	*/
		private var $subArr:Array;
		/**	마우스 오버시 1뎁스 번호	*/
		private var $overNum:int = -1;
		/**	2뎁스 활성 번호	*/
		private var $subNum:int = -1;
		
		public function GNBMenu(con:MovieClip, menuNum:int, subNum:int)
		{
			TweenPlugin.activate([FramePlugin]);
			$con = con;
			
			$menuNum = menuNum;
			$subNum = subNum;
			
			makeButton();
		}
		
		private function makeButton():void
		{
			$menuArr = [];
			$subArr = [];
			
			var i:int;
			var j:int
			for (i = 0; i < $btnLength; i++) 
			{
				var btnShowMenu:MovieClip = $con.getChildByName("btn" + i) as MovieClip;
				btnShowMenu.no = i;
				$menuArr.push(btnShowMenu);
				
				/**	1뎁스 메뉴	*/
				btnShowMenu.btn.no = i;
				btnShowMenu.btn.buttonMode = true;
				btnShowMenu.btn.addEventListener(MouseEvent.MOUSE_OVER, mainMenuHandler);
				btnShowMenu.btn.addEventListener(MouseEvent.MOUSE_OUT, mainMenuHandler);
				btnShowMenu.btn.addEventListener(MouseEvent.CLICK, mainMenuHandler);
				
				/**	2뎁스 메뉴	*/
				var subArr:Array = [];
				for (j = 0; j < $subMenuLength[i]; j++) 
				{
					var subBtn:MovieClip = btnShowMenu.getChildByName("sub" + j) as MovieClip;
					subArr.push(subBtn);
					subBtn.no = j;
					ButtonUtil.makeButton(subBtn, subBtnHandler);
				}
				$subArr.push(subArr);
			}
			activeMenu($menuNum, $subNum);
		}
		/**	메인 버튼	*/
		private function mainMenuHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.target as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					$overNum = target.no;
					clearTimeout($menuTimeout);
					if($overNum == $menuNum) activeMenu(target.no, $subNum);
					else activeMenu(target.no, -1);;
					break;
				case MouseEvent.MOUSE_OUT :
					$menuTimeout = setTimeout(resetMenu, 1000);
					break;
				case MouseEvent.CLICK : 
					$menuNum = target.no;
					$subNum = 0;
					activeMenu($menuNum, $subNum);
					
					JavaScriptUtil.call("menu0" + ($menuNum + 1));
					break;
			}
		}
		/**	서브 버튼	*/
		private function subBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					clearTimeout($menuTimeout);
					activeMenu($overNum, target.no);
					break;
				case MouseEvent.MOUSE_OUT :
					$menuTimeout = setTimeout(resetMenu, 1000);
					break;
				case MouseEvent.CLICK : 
					$menuNum = $overNum;
					$subNum = target.no;
					activeMenu($menuNum, $subNum);
					
					JavaScriptUtil.call("menu0" + ($overNum + 1) + "0" + ($subNum +1));
					break;
			}
		}
		/**	마우스 아웃 - 메뉴 복귀	*/
		private function resetMenu():void
		{
			$overNum = $menuNum;
			activeMenu($menuNum, $subNum);
		}
		/**	메뉴 활성화	*/
		private function activeMenu(menuNum:int, subNum:int):void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				if(i == menuNum)
				{
					TweenLite.to($menuArr[i], 0.5, {frame:$menuArr[i].totalFrames, ease:Expo.easeOut});
					for (var j:int = 0; j < $subMenuLength[i]; j++) 
					{
						if(j == subNum)
						{
							TweenLite.to($subArr[i][j], 0.5, {frame:$subArr[i][j].totalFrames, ease:Expo.easeOut});
						}
						else
						{
							TweenLite.to($subArr[i][j], 0.5, {frame:1, ease:Expo.easeOut});
						}
					}
				}
				else
				{
					TweenLite.to($menuArr[i], 0.5, {frame:1, ease:Expo.easeOut});
					for (var k:int = 0; k <$subMenuLength[i]; k++) 
					{
						TweenLite.to($subArr[i][k], 0.5, {frame:1, ease:Expo.easeOut});
					}
				}
			}
		}
	}
}