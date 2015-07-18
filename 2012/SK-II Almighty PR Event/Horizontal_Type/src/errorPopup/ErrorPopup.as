package errorPopup
{
	
	import bonanja.core.net.NetSenser;
	
	import flash.events.Event;
	
	public class ErrorPopup
	{
		
		private var $model:Model;
		
		public function ErrorPopup()
		{
			$model = Model.getInstance();
			/**	인터넷 접속 상태 체크	*/
			var senser:NetSenser = new NetSenser("http://prevent.purepitera.co.kr", receiveStatus);
		}
		
		private function receiveStatus(obj:Object):void
		{
			switch (obj.status)
			{
				case "online" :
					return;
					break;
				case "offline" :
				case "Error" :
					/**	인터넷 접속 에러 팝업	*/
					$model.dispatchEvent(new Event(ModelEvent.ERROR_POPUP));
					break;
			}
		}
	}
}