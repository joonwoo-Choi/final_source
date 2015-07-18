package com.sw.display
{
	import com.adqua.ui.AdquaContext;
	import com.sw.net.FncOut;
	import com.sw.utils.SetText;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * 
	 * @author LEESWK
	 *	윈도우 오른쪽 클릭, 리사이즈 내용 정의 클래스 
	 */	
	public class Scene extends Sprite
	{
		/**	윈도우 넓이	*/
		public var sw:Number;
		/**	윈도우 높이	*/
		public var sh:Number;
		
		protected var swMax:Number;
		protected var shMax:Number;
		
		//public var myContextMenu:ContextMenu;
		protected var testTxt:SetText;
		
		private var resizeFnc:Array;
		/**
		 * 생성자
		 * */
		public function Scene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			testTxt = new SetText();
			fN_setStageMax(900,600);
			resizeFnc = [];
		}
		/**
		 * 윈도우 크기 최대값 적용
		 * */
		protected function fN_setStageMax($sw:int,$sh:int):void
		{	swMax = $sw; shMax = $sh;	}
		/**	
		 * 윈도우 넓이높이 값 적용	
		 * */
		protected function setWH():void
		{
			sw = (stage.stageWidth < swMax) ? swMax : stage.stageWidth;
			sh = (stage.stageHeight < shMax) ? shMax : stage.stageHeight;
		}
		/**
		 * 스테이지에 index내용 붙으면 실행
		 * */
		public function onAdd(e:Event):void
		{
			stage.stageFocusRect = false;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//fN_setContextMenu();
			AdquaContext.addContextMenu(this);
			
			stage.addEventListener(Event.RESIZE,fN_onResize);	
			stage.dispatchEvent(new Event(Event.RESIZE));	
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		/**
		 * contextMenu 셋팅
		 * */
		/*
		public function fN_setContextMenu():void
		{
			myContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			
			var item:ContextMenuItem = new ContextMenuItem("Create by  AdQUA Interactive");
			myContextMenu.customItems.push(item);
			
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,fN_onClickMenu);
			
			this.contextMenu = myContextMenu;
		}
		*/
		public function fN_onClickMenu($e:ContextMenuEvent):void
		{
			FncOut.link("http://www.adqua.co.kr","_blank");
			//navigateToURL(new URLRequest("http://www.adqua.co.kr"));
		}
		/**==================================================================================//
		//									윈도우 사이즈에 따라 정렬													//
		//==================================================================================/*/
		/**
		 * 리사이즈
		 * */
		public function fN_onResize(e:Event):void
		{	
			if(stage == null) return;
			
			sw = (stage.stageWidth < swMax) ? swMax : stage.stageWidth;
			sh = (stage.stageHeight < shMax) ? shMax : stage.stageHeight;
			
			for(var i:int=0; i<resizeFnc.length; i++)
			{
				resizeFnc[i]();
			}
		}
		/**
		 * 리사이즈 함수 추가
		 * */
		public function addResize($fnc:Function):void
		{
			resizeFnc.push($fnc);
		}
		/**
		 * 리사이즈 함수 제거
		 * */
		public function removeResize($fnc:Function):void
		{
			var num:int = resizeFnc.indexOf($fnc);
			resizeFnc.splice(num,1);
		}
	}//class
}//package