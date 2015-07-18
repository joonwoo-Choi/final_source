package
{
	import com.sw.net.Location;
	
	import event.MovieEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.Security;
	import flash.text.TextField;
	
	import net.MovieCount;
	
	import util.BGM;
	import util.popup.BaseHersheysPopup;
	
	/**		
	 *	SK2_Hershy :: 전역 변수 (싱글톤)
	 */
	public class Global extends EventDispatcher
	{
		/**	인스턴스	*/
		static private var ins:Global = new Global();
		/**	자원 경로	*/
		public var rootURL:String;
		/**	데이터 경로	*/
		public var dataURL:String;
		public var urlType:String="web";
		
		public var accessToken:String;
		public var naviType:String="";
		
		public var fbLoginChk:String="notLogin";
		/**	보여지고 있는 영상 상황	*/
		public var movieState:String;
		
		
		/** XML 저장 **/
		public var essayXml:XML;
		/** 에세이 페이지 번호 **/
		public var essayNum:int = 4;
		/** 에세이 페이지 개수 **/
		public var maxNum:int = 0;
		/** 중앙 버튼 번호 **/
		public var centerBtnNum:int = 0;
		/** 페이지 마스크 Y값 **/
		public var maskY:int = -535;
		/** 마우스 무브 영역 높이 값 **/
		public var btnMoveHeight:int = -535;
		/** 플레이 상태 **/
		public var playIs:Boolean = true;
		/** 플레이 상태 체크 2 **/
		public var $playIs:String = "reset";
		/** 영상 번호 배열 **/
		public var $movAry:Array = [];
		/** 버튼 갯수 **/
		public var max:Array = [];
		
		public var gnbVisible:Boolean = true;
		
		public var imgOpen:Boolean = false;
		
		public var essayBtnMoveY:int;
		
		public var titleY:int;
		
		public var centerBtnY:int;
		
		public var titleMovX:int;
		
		public var stageH:int;
		
		/**	팝업	*/
		public var popup:BaseHersheysPopup;
		/**	외부에서 가져온 데이터	*/
		public var outData:String;
		/**	영상 카운트	*/
		private var movieCount:MovieCount;
		
		/**	콜백 수행 상황	*/
		public var callbackSate:String;
		/**	재방송 시 팝업 띄우는 인지 여부	*/
		public var bPopReview:Boolean;
		/**	영상 내용 안에서 재방송인지 여부	*/
		public var bMovReview:Boolean;
		/**	배경음악	*/
		public var bgm:BGM;
		/**	전체 소리 음량	*/
		public var volum:Number;
		/**	입력 가능한 텍스트 필드	*/
		public var inputTxt1:TextField;
		public var inputTxt2:TextField;
		
		/**	생성자	*/
		public function Global(target:IEventDispatcher=null)
		{
			super(target);
			if(ins != null) throw new Error("Global은 싱글톤 입니다.");	
			init();	
		}
		/**	인스턴스 반환	*/
		static public function getIns():Global
		{	return ins;	}
		/**	초기화	*/
		private function init():void
		{
			Security.allowDomain("*");
			
			rootURL = Location.setURL("","/swf/");
			dataURL = Location.setURL("http://hertest.purepitera.co.kr/","");
			//			dataURL = Location.setURL("http://www.purepitera.co.kr/","");
			
			volum = 1;
			movieState = "rest";
			bPopReview = false;
			bMovReview = false;
			callbackSate = "";
			
			movieCount = new MovieCount(null,dataURL+"/Process/MovieGetSave.ashx",{});
		}
		
		/**	영상 카운트 클래스 반환	*/
		public function getMovCnt():MovieCount
		{	
			return movieCount;	
		}
		/**	팝업 alpha값 반환	*/
		public function getPopAlpha():Number
		{	
			if(popup == null)
			{	
				trace("Popup이 구성되지 않았습니다.");		
				return 0;		
			}
			return popup.getBodyAlpha();	
		}
		
		/**	팝업 보여지기	*/
		public function viewPop($pos:String, $data:Object=null):void
		{
			if(popup == null)
			{
				trace("Popup이 구성되지 않았습니다.");
				return;
			}
			popup.viewPop($pos,$data);
		}
		/**	팝업 가려지기	*/
		public function hidePop():void
		{
			if(popup == null)
			{
				trace("Popup이 구성되지 않았습니다.");
				return;
			}
			popup.hidePop();
		}
		/**	영상 플레이	*/
		public function playMovie():void
		{	dispatchEvent(new MovieEvent(MovieEvent.PLAY));	}
		/**	영상 일시 정지	*/
		public function stopMovie():void
		{	dispatchEvent(new MovieEvent(MovieEvent.STOP));	}
		/**	다음 영상 플레이	*/
		public function nextMovie():void
		{	dispatchEvent(new MovieEvent(MovieEvent.NEXT));	}
		
	}//class
}//package