package com.sw.buttons
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 이벤트 발생시 frame 이름으로 이동 <br>
	 * ex : new BtnFrame(mc,{over:"over",out:"out",click:onClick});
	 * */
	public class BtnFrame extends Sprite
	{
		public var scope_mc:MovieClip;
		private var nameOver:String;
		private var nameOut:String;
		public var cbk_click:Function;
		public var dataObj:Object;
		
		/**	생성자		*/
		public function BtnFrame($scope_mc:MovieClip,$dataObj:Object)
		{
			super();
			scope_mc = $scope_mc;
			
			dataObj = new Object();
			
			dataObj.over = ($dataObj.over)? ($dataObj.over):("over");
			dataObj.out = ($dataObj.out)? ($dataObj.out):("out");
			
			dataObj.over_fnc = $dataObj.over_fnc;
			dataObj.out_fnc = $dataObj.out_fnc;
			
			cbk_click = ($dataObj.click)?($dataObj.click):(null);
			//scope.cbk_click();
			
			scope_mc.buttonMode = ($dataObj.mode) ? ($dataObj.mode):(true);
			scope_mc.mouseChildren = ($dataObj.child) ? ($dataObj.child):(false);
			
			scope_mc.addEventListener(MouseEvent.ROLL_OVER,fN_onOver);
			scope_mc.addEventListener(MouseEvent.ROLL_OUT,fN_onOut);
			scope_mc.addEventListener(MouseEvent.CLICK,fN_onClick);
		}
		/**	소멸자	*/
		public function destroy():void
		{		}
		/**	오버시		*/
		private function fN_onOver($e:MouseEvent):void
		{
			var mc:MovieClip = $e.currentTarget as MovieClip;
			
			if(dataObj.over_fnc != null) dataObj.over_fnc(mc); 
			scope_mc.gotoAndPlay(dataObj.over);
			
			
		}
		/**	아웃시		*/
		private function fN_onOut($e:MouseEvent):void
		{
			var mc:MovieClip = $e.currentTarget as MovieClip;
			
			scope_mc.gotoAndPlay(dataObj.out);
			if(dataObj.out_fnc != null) dataObj.out_fnc(mc); 
		}
		/**	클릭시		*/
		private function fN_onClick($e:MouseEvent):void
		{
			if(cbk_click != null) cbk_click($e);
		}		
	}//class
}//package