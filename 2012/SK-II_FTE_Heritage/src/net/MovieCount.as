package net
{
	import com.sw.net.list.BaseList;
	
	import event.MovieEvent;
	
	/**		
	 *	SK2_Hersheys :: 영상 데이터 본 횟수 카운트
	 */
	public class MovieCount extends BaseList
	{
		private var cntData:Object;
		
		/**	생성자	*/
		public function MovieCount($scope:Object, $url:String, $data:Object)
		{
			super($scope, $url, $data);
			init();
		}
		/**	카운트 데이터 반환	*/
		public function getData():Object
		{	return cntData;	}
		
		/**	데이터 로드 완료	*/
		override protected function onNoneList():void
		{
//			trace(getXML());
			var xml:XML = getXML();
			//if(xml.RequestType.toString() == "SAVE") return;
			
			var movieCnt:int = 0;
			var movieMax:int = 0;
			var moviePos:int = -1;
			
			var cnt:int = xml.MovieCountList.MovieData.length();
			var obj:Object;
			
			if(cnt == 0) 
			{
				obj = {};
				obj.maxMovie = 1;
				obj.movieCnt = 0;
				Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.LOAD_MOVCNT,obj));
				return;
			}
			
			for(var i:int = 0; i<cnt; i++)
			{
				var cXml:XML = xml.MovieCountList.MovieData[i] as XML;
//				trace(cXml.MovieName.toString());
				
				var str:String = cXml.MovieName.toString();
				var degree:String = MovieEvent.SEAONMOVIE;
				var num:int = int(cXml.MovieCount.toString());
				
				movieCnt += num;
				
//				trace(str.substr(0,degree.length));
//				trace(degree);
//				trace("num:"+num);
				if(str.substr(0,degree.length) != degree) continue;
				
				if(num > movieMax)
				{
//					trace("length:"+str.substr(degree.length));
					movieMax = num;
					moviePos = int(str.substr(degree.length));
				}
//				trace(str);
//				trace(num);
			}
//			trace("--------------");
//			trace(movieCnt);
//			trace(moviePos);
			
			cntData = {};
			cntData.maxMovie = moviePos;
			cntData.movieCnt = movieCnt;
			Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.LOAD_MOVCNT,cntData));

		}
		/**	영상 카운트 세이브	*/
		public function save(str:String):void
		{
			load({type:"SAVE",movieName:str});
		}
		/**	영상 카운트 결과 반환	*/
		public function get():void
		{
			load({type:"GET"});
		}
	}//class
}//package