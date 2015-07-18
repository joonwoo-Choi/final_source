package util
{
	import com.adqua.system.SecurityUtil;

	public class ONLineCheck
	{
		public function ONLineCheck()
		{

		}
		public static function url():int
		{
			var url:int;
			if(SecurityUtil.isWeb()==true){
				url =0;
			}else{
				url =1;
			}			
			return url;
		}		
	}
}