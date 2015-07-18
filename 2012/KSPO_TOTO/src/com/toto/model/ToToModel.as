package com.toto.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ToToModel extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:ToToModel = new ToToModel();
		
		public function ToToModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**	인스턴스 반환	*/
		static public function getInstance():ToToModel
		{
			return $model;
		}
	}
}