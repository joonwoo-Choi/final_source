package
{
	
	import flash.events.Event;
	
	public class ModelEvent extends Event
	{
		
		/** 결과 값 받기 완료 **/
		public static const RESULT_RECEIVE:String = "resultReceive";
		
		
		public function ModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}