﻿package orpheus.controls.ui.events {	import flash.events.Event;	/**	 * @author philip	 */	public class CheckBoxEvent extends Event 	{		public static const CHANGE:String = "CHANGE";		public var value:*;		public function CheckBoxEvent(value:*, type:String, bubbles:Boolean = false, cancelable:Boolean = false)		{			this.value = value;			super(type, bubbles, cancelable);		}				override public function clone():Event		{			return new CheckBoxEvent(value, type, bubbles, cancelable);		}	}}