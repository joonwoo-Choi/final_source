package com.cj.manager
{
	import com.cj.data.ButtonEventData;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	/**
	 * 버튼 이벤트 관리자 
	 * @author cj
	 * 
	 */	
	public class ButtonEventManager
	{
		private var _buttons:Array = [];
		private var _eventDic:Dictionary = new Dictionary();
		
		public function ButtonEventManager()
		{
			super();
		}
		
		public function createButtonEvent(target:Object, eventData:ButtonEventData):void
		{
			if(!(target is Sprite)) throw new Error("타겟 객체가 Sprite 상속객체가 아닙니다");
			target.mouseChildren = (eventData.rollOverListener==null) ? false : true;
			target.buttonMode = !target.mouseChildren; 
			
			// 리스너 객체 유무확인
			checkListener(target, eventData.downListener, MouseEvent.MOUSE_DOWN);
			checkListener(target, eventData.clickListener, MouseEvent.CLICK);
			checkListener(target, eventData.overListener, MouseEvent.MOUSE_OVER);
			checkListener(target, eventData.outListener, MouseEvent.MOUSE_OUT);
			
			checkListener(target, eventData.rollOverListener, MouseEvent.ROLL_OVER);
			checkListener(target, eventData.rollOutListenrer, MouseEvent.ROLL_OUT);
			
			// 딕셔너리에 넣기
			_eventDic[target] = eventData;
			
			// 배열 넣기
			_buttons.push(target);
		}
		
		private function checkListener(target:Object, func:Function, evtName:String, remove:Boolean=false):void
		{
			if(func == null){
			}else{
				if(remove){
					(target as Sprite).removeEventListener(evtName, func);
				}else{
					(target as Sprite).addEventListener(evtName, func);
				}
			}
		}
		
		public function removeButtonEvent(target:Object, removeArr:Boolean=true):void
		{
			var data:ButtonEventData = _eventDic[target];
			checkListener(target, data.downListener, MouseEvent.MOUSE_DOWN, true);
			checkListener(target, data.clickListener, MouseEvent.CLICK, true);
			checkListener(target, data.overListener, MouseEvent.MOUSE_OVER, true);
			checkListener(target, data.outListener, MouseEvent.MOUSE_OUT, true);
			
			checkListener(target, data.rollOverListener, MouseEvent.ROLL_OVER, true);
			checkListener(target, data.rollOutListenrer, MouseEvent.ROLL_OUT, true);
			delete _eventDic[target];
			
			if(removeArr){
				var id:int = _buttons.indexOf(target);
				_buttons.splice(id, 1);
			}
		}
		
		public function removeAllButtonEvent():void
		{
			var total:int = _buttons.length;
			var i:int = 0;
			for (; i < total; i++) 
			{
				removeButtonEvent( _buttons[i], false );
			}
			
			_buttons.length = 0;
		}
	}
}
