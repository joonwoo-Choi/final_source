package contents.guerilla
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	
	import event.MovieEvent;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;

	/**		
	 *	SK2_Hersheys :: 게릴라 이벤트 공통 내용
	 */
	public class BaseGuerilla
	{
		/**	버튼 내용 MovieClip	*/
		protected var btnMc:MovieClip;
		/**	화면에 보여지는 MovieClip	*/
		protected var viewMc:MovieClip;
		
		/**	버튼 내용 위치값 x차이	*/
		protected var gapX:Number;
		/**	버튼 내용 위치값 y차이	*/
		protected var gapY:Number;
		
		/**	생성자	*/
		public function BaseGuerilla($btnMc:MovieClip,$viewMc:MovieClip)
		{
			btnMc = $btnMc;
			viewMc = $viewMc;
			gapX = 0;
			gapY = 0;
			
			viewMc.addEventListener(Event.REMOVED_FROM_STAGE,destroy);
		}
		
		/**	초기화	*/
		protected function init():void
		{
		
		}
		
		/**	버튼 위치값 제 정렬	*/
		public function updatePosition(point:Point):void
		{
			if(btnMc == null) return;
			
			btnMc.x = point.x+gapX;
			btnMc.y = point.y+gapY;
		}
		/**	다음 영상 플레이	*/
		protected function playNextMovie():void
		{
			destroy();
			Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.NEXT));
		}
		/**	이전 영상 플레이	*/
		protected function playPrevMovie():void
		{
			destroy();
			Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.PREV));
		}
		
		/**	버튼화	*/
		protected function setButton(mc:MovieClip,fnc:Function = null):void
		{
			MovieClip(mc.view).blendMode = BlendMode.OVERLAY;
			TweenMax.to(mc.view,0,{tint:0xffffff});
			var obj:Object = new Object();
			obj.over = onOver;
			obj.out = onOut;
			if(fnc != null) obj.click = fnc;
			
			Button.setUI(mc,obj);
		}
		private function onOver(mc:MovieClip):void
		{
			TweenMax.to(mc.view,1,{alpha:0.8,ease:Expo.easeOut});
		}
		private function onOut(mc:MovieClip):void
		{
			TweenMax.to(mc.view,1,{alpha:0,ease:Expo.easeOut});
		}
		
		/**	소멸자	*/
		public function destroy(e:Event = null):void
		{
			viewMc.removeEventListener(Event.REMOVED_FROM_STAGE,destroy);
			
			//Remove.all(btnMc);
			//btnMc.parent.removeChild(btnMc);
		}
	}//class
}//package