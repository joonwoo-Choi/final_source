package com.sw.buttons
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 버튼 이벤트 등록 클래스 <br>
	 */	
	public class Button
	{	
		/**	생성자	*/
		public function Button()
		{	}
		/**	소멸자	*/
		public function destroy():void
		{		}
		
		/**	버튼 적용 static 함수	<br>
		 * 반환 값 MovieClip<br>
		 * over	:	마우스 오버시 실행 함수<br>
		 * out	:	마우스 아웃시 실행 함수<br>
		 * click :	마우스 클릭시 실행 함수<br>
		 * 모든 함수 실행시 인자 값 : MovieClip<br>
		 * <p> ex : Button.setUI(mc,{over:onOver,out:onOut,click:onClick});
		 * */
		static public function setUI($mc:MovieClip,$data:Object):void
		{
			$mc.obj = $data;
			if($data.override == null) removeUI($mc);
			
			$mc.buttonMode = true;
			$mc.mouseEnabled = true;
			
			if($data.down != null)
				$mc.addEventListener(MouseEvent.MOUSE_DOWN,Button.onDown);
			if($data.over != null)
				$mc.addEventListener(MouseEvent.MOUSE_OVER,Button.onOver);
			if($data.out != null)
				$mc.addEventListener(MouseEvent.MOUSE_OUT,Button.onOut);
			if($data.click != null)
				$mc.addEventListener(MouseEvent.CLICK,Button.onClick);
		}
		/**	마우스 다운시	*/
		static public function onDown(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.obj.down(mc);
		}
		
		/**	오버시 실행 함수	*/
		static public function onOver(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.obj.over(mc);
		}
		/**	아웃시 실행 함수	*/
		static public function onOut(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.obj.out(mc);
		}
		/**	클릭시 실행 함수	*/
		static public function onClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.obj.click(mc);
		}
		/** 이벤트 지우기		*/
		static public function removeUI($mc:MovieClip):void
		{
			if(!$mc || !$mc.obj) return;
			$mc.mouseEnabled = false;
			if($mc.obj.down)
				$mc.removeEventListener(MouseEvent.MOUSE_DOWN,Button.onDown);
			if($mc.obj.over)
				$mc.removeEventListener(MouseEvent.MOUSE_OVER,Button.onOver);
			if($mc.obj.out)
				$mc.removeEventListener(MouseEvent.MOUSE_OUT,Button.onOut);
			if($mc.obj.click)
				$mc.removeEventListener(MouseEvent.CLICK,Button.onClick);
		}
		/**해당 오브젝트 버튼 기능 끄기<br>
		 * @param $obj :: 대상 오브젝트 
		 */
		static public function doNot($obj:MovieClip = null):void
		{
			if($obj == null) return;
			$obj.mouseEnabled = false;
			$obj.mouseChildren = false;
			
		}
	}//class
}//package