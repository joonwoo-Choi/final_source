﻿package adqua.control.flvPlayer.events {	import flash.events.Event;	/**	 * @author philip	 */	public class CuePointEvent extends Event 	{		public var info:Object;		public static const CUE_POINT:String = "CUE_POINT";		public function CuePointEvent(info:Object, type:String, bubbles:Boolean = false, cancelable:Boolean = false)		{			this.info = info;			super(type, bubbles, cancelable);		}				override public function clone():Event		{			return new CuePointEvent(info, type, bubbles, cancelable);		}	}}