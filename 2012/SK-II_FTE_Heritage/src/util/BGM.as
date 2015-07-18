package util
{
	import com.sw.utils.BGMClip;

	/**		
	 *	SK2_Hersheys :: 배경 음악, 쿠키 반복음, 로또 반복음
	 */
	public class BGM extends BGMClip
	{
		/**	생성자	*/
		public function BGM($url:String,$data:Object = null)
		{
			var data:Object = $data;
			if(data == null) 
			{
				data = new Object();
				data.volume = 0.25;
			}
			
			super($url,data);
		}
		
	}//class
}//package