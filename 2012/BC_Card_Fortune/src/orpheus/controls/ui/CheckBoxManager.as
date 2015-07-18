﻿package orpheus.controls.ui {	import flash.events.Event;		import flash.events.EventDispatcher;	import orpheus.controls.ui.events.CheckBoxEvent;			/**	 * @author philip	 */	public class CheckBoxManager extends EventDispatcher 	{		private var itemArr:Array = new Array();		private var _value:* = null;		private var _multiCheck:Boolean = false;		private var _enabled:Boolean = true;		private var _radioButton:Boolean = false;		public function CheckBoxManager()		{		}		public function addItem(item:CheckBox, value:*):void		{			if (findItem(item) != -1) return;			itemArr.push(item);			item.value = value;			item.radioButton = radioButton;			item.addEventListener(CheckBoxEvent.CHANGE, changeHandler);		}		public function removeItem(item:CheckBox):void		{			var num:int = findItem(item);			if (num != -1)			{				itemArr.splice(num, 1);			}		}		public function removeAllItem():void		{			itemArr = new Array();		}		private function findItem(item:CheckBox):int		{			for(var i:uint = 0;i < itemArr.length; i++)			{				if (item == itemArr[i])				{					return i;				}			}			return -1;		}		private function changeHandler(event:Event):void		{			var i:uint;			var tg:CheckBox = event.target as CheckBox;			if (!multiCheck)			{				_value = tg.value;				if (tg.checked)				{					for(i = 0;i < itemArr.length; i++)					{						if (tg.value != itemArr[i].value)						{							itemArr[i].checked = false;						}					}				}				else				{					_value = null;				}			}			else			{				_value = new Array();				for(i = 0;i < itemArr.length; i++)				{					if (itemArr[i].checked)					{						_value["push"](itemArr[i]);					}				}			}						dispatchEvent(new CheckBoxEvent(_value, CheckBoxEvent.CHANGE));		}		public function get multiCheck():Boolean		{			return _multiCheck;		}		public function set multiCheck(multiCheck:Boolean):void		{			_multiCheck = multiCheck;			if (_multiCheck && _radioButton) radioButton = false;		}		public function get value():*		{			return _value;		}		public function set enabled(b:Boolean):void		{			for(var i:uint = 0;i < itemArr.length; i++)			{				var item:CheckBox = itemArr[i];				item.active = b;			}		}		public function get enabled():Boolean		{			return _enabled;		}		public function reset():void		{			_value = null;		}		public function get radioButton():Boolean		{			return _radioButton;		}		public function set radioButton(radioButton:Boolean):void		{			_radioButton = radioButton;			if (_multiCheck && _radioButton) _multiCheck = false;			for(var i:uint = 0;i < itemArr.length; i++)			{				var item:CheckBox = itemArr[i];				item.radioButton = radioButton;			}		}	}}