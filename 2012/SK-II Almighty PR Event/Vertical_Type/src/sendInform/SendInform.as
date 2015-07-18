package sendInform
{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class SendInform
	{
		private static var $main:SendInform;
		/**	모델	*/
		private var $model:Model;
		/**	url	*/
		private var $url:String = "http://prevent.purepitera.co.kr/Process/EventDataSave.ashx";
		/**	URLRequest	*/
		private var $req:URLRequest;
		/**	로더	*/
		private var $ldr:URLLoader;
		
		public function SendInform()
		{
			$model = Model.getInstance();
		}
		
		public function evtOneSend(uname:String, ucellular:String, progress:String):void
		{
			var vari:URLVariables = new URLVariables();
			vari.uname = uname;
			vari.ucellular = ucellular;
			vari.progress = progress
			
			$req = new URLRequest($url);
			$req.data = vari;
			$req.method =URLRequestMethod.POST;
			$ldr = new URLLoader();
			$ldr.load($req);
			$ldr.addEventListener(Event.COMPLETE, resultLoad);
			
			trace("vari: "+vari);
			/**	evtTwoCon 페이지 보이기	*/
//			if($model.evtPageNum == 0) 
//			{
//				$model.dispatchEvent(new Event(ModelEvent.EVT_TWO_VIEW));
//			}
//			else
//			{
//				$model.dispatchEvent(new Event(ModelEvent.COMPLETE_PAGE));
//			}
		}
		
		public function evtTwoSend(fname:String, fcellular:String, progress:String):void
		{
			var vari:URLVariables = new URLVariables();
			vari.uname = $model.uname;
			vari.ucellular = $model.ucellular;
			vari.fname = fname;
			vari.fcellular = fcellular;
			vari.progress = progress;
			
			$req = new URLRequest($url);
			$req.data = vari;
			$req.method =URLRequestMethod.POST;
			$ldr = new URLLoader();
			$ldr.load($req);
			$ldr.addEventListener(Event.COMPLETE, resultLoad);
		}
		
		/**	결과 받기	*/
		private function resultLoad(e:Event):void
		{
			var resultTxt:XML = new XML(e.target.data);
			trace("xml:\n",resultTxt);
//			result(resultTxt.Result);
			/**	테스트 */
			result(1);
		}
		
		/**	피드 날리기 결과 	*/
		private function result(result:int):void
		{
			switch (result) 
			{
				case -1 :
					/**	값이 올바르지 않음	*/
					break;
				case -2 :
					/** 이미 참여한 정보임	*/
					break;
				case -3 :
					/** 이미 3명의 친구를 초대하였음	*/
					break;
				case -9 :
					/**	데이터베이스 오류	*/
					break;
				case 1  :
					/**	참여 이력 없음	*/
					viewEvtPage();
					break;
			}
			trace("result: "+result);
		}
		
		private function viewEvtPage():void
		{
			/**	evtTwoCon 페이지 보이기	*/
			if($model.evtPageNum == 0) $model.dispatchEvent(new Event(ModelEvent.EVT_TWO_VIEW));
			else $model.dispatchEvent(new Event(ModelEvent.COMPLETE_PAGE));
		}
		
		public static function getInstance():SendInform{
			if(!$main)$main = new SendInform;
			return $main;
		}
	}
}