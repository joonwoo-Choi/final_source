package day.day2
{
	
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import pEvent.PEventCommon;
	
	[SWF(width="961", height="541", frameRate="30", backgroundColor="0x999999")]
	
	public class Day2_2 extends AbstractMain
	{
		
		private var $main:AssetDay2_2;
		
		private var $btnLength:int = 2;
		
		
		public function Day2_2()
		{
			super();
			TweenPlugin.activate([AutoAlphaPlugin]);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			//노란바
			_model.dispatchEvent(new PEventCommon(PEventCommon.YELLOW_OPEN));
			
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.addEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
			
			$main = new AssetDay2_2();
			this.addChild($main);
			
			makeBtn();
			
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, btnHandler);
			}
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					target["overMc"].gotoAndStop(2);
					break;
				case MouseEvent.MOUSE_OUT :
					target["overMc"].gotoAndStop(1);
					break;
				case MouseEvent.CLICK : 
					removeEvent();
					_controler.changeMovie([3,3,target.no]);
					TweenLite.to($main, 0.5, {alpha:0, onComplete:destroy});
					break;
			}
		}
		
		
		/**	초기화	*/
		private function destroy(e:Event=null):void
		{
			_model.dispatchEvent(new PEventCommon(PEventCommon.REMOVE_INTERACTION));
		}
		/**	이벤트 제거	*/
		private function removeEvent(e:Event=null):void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btns, btnHandler);
			}
			
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, removeEvent);
			_model.removeEventListener(PEventCommon.DESTROY_INTERACTION, destroy);
		}
	}
}