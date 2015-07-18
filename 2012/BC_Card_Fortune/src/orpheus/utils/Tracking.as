package orpheus.utils
{
	import flash.external.ExternalInterface;

	public class Tracking
	{
		public function Tracking()
		{
		}
		public static function call(info:Array):void
		{
			trace("HugCityRealMedia: ",info[0]," : ",info[1]);
			if(ExternalInterface.available)ExternalInterface.call("HugCityRealMedia", info[0],info[1]);
		}			
	}
}