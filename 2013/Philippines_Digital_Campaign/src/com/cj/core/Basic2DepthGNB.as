package com.cj.core
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * 2012.03.07 
	 * @author jun
	 * 
	 */	
	public class Basic2DepthGNB
	{
		protected var _menuArray:Array;
		protected var _subArray:Array;
		
		protected var _menuIdx:int = -1;
		protected var _subIdx:int = -1;
		
		private var _menuActiveIndex:int=-1;
		
		/**
		 * ** 다이나믹 속성으로 idx값 설정요함!
		 * mainMenu.idx = depth1
		 * 
		 * subMenu.menuIdx = depth1
		 * subMenu.subIdx = depth2
		 * 
		 * @param $menuArr
		 * 
		 */		
		public function Basic2DepthGNB($menuArr:Array)
		{
			_menuArray = $menuArr;
			
			// 이중배열로 셋팅할것.
			_subArray = [];
			
			menuSetting();
		}
		
		public function setDepthMenu($depth1:int, $depth2:int):void
		{
			if($depth1 != _menuIdx && $depth1 != _menuActiveIndex){
				onCurrentMenu(false);
			}
			onCurrentSub(false);
			_menuIdx = $depth1;
			_subIdx = $depth2;
			
			onCurrentMenu();
			onCurrentSub();
		}
		
		/////////// MAIN MENU SET //////////////////////////////////////////////////////////////
		
		protected function menuSetting():void
		{
			// override..
		}
		
		protected function menuRollOver(e:MouseEvent):void
		{
			TweenMax.killDelayedCallsTo(onCurrentMenu);
			
			// 선택메뉴가 아닌 메뉴오버시 디폴트메뉴 초기화
			if(e.target.idx != _menuIdx){
				onCurrentMenu(false);
				onCurrentSub(false);
			}
			menuEffect(e.target as MovieClip, true);
			_menuActiveIndex = e.target.idx;
		}
		
		protected function menuRollOut(e:MouseEvent):void
		{
			// 선택메뉴가 아닌 메뉴아웃시 해당메뉴 초기화
			if(e.target.idx != _menuIdx){
				menuEffect(e.target as MovieClip, false);
				
				TweenMax.delayedCall(.4, onCurrentMenu);
				onCurrentSub();
			}
		}
		
		protected function menuEffect(target:MovieClip, over:Boolean):void
		{
			// override..
		}
		
		protected function onCurrentMenu(interraction:Boolean=true):void
		{
			if(_menuIdx == -1) return;
			var menu:MovieClip = _menuArray[_menuIdx];
			if(menu) menuEffect(menu, interraction);
		}
		
		protected function menuClick(e:MouseEvent, depth1:int, depth2:int):void
		{
			callIndex(depth1, depth2);
		}
		
		/////////// SUB MENU SET //////////////////////////////////////////////////////////////
		
		protected function subBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.target as MovieClip;
			var bool:Boolean = (_menuIdx == target.menuIdx && _subIdx == target.subIdx) ? false : true;
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					// 선택서브가 아닌 서브오버시 디폴트서브 초기화
					if(bool) onCurrentSub(false);
					subEffect(target,true);
					break;
				case MouseEvent.MOUSE_OUT:
					// 선택서브가 아닌 서브아웃시 해당서브 초기화
					if(bool){
						subEffect(target,false);
						onCurrentSub();
					}
					break;
			}
		}
		
		protected function subEffect(target:MovieClip, over:Boolean):void
		{
			// override..
		}
		
		protected function onCurrentSub(interraction:Boolean=true):void
		{
			if(_menuIdx == -1) return;
			
			if(_subArray[_menuIdx]){
				if(_subIdx > -1 && _subIdx < _subArray[_menuIdx].length){
					var sub:MovieClip = _subArray[_menuIdx][_subIdx];
					if(sub) subEffect(sub, interraction);
				}
			}
		}
		
		public function callIndex(depth1:int, depth2:int):void
		{
			
		}
	}
}