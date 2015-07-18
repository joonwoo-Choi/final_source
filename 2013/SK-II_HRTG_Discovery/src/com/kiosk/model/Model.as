package com.kiosk.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/**	공통 경로	*/
		public var defaulfPath:String = "";
		/**	인트로 있냐 없냐	*/
		public var isIntro:String = "true";
		/**	SWF 로드 퍼센트	*/
		public var percent:Number;
		/**	서브 컨텐츠 비디오 번호	*/
		public var subMovNum:String = "0";
		/**	키오스크 페이지 번호	*/
		public var kioskPageNum:int;
		/**	유저 정보	*/
		public var userInform:XML;
		/**	샘플 받았는지 여부	*/
		public var sampleCheck:String = "";
		/**	방문 날짜	*/
		public var visitDate:String = "";
		/**	실제 나이	*/
		public var age:int;
		/**	성별	*/
		public var gender:String = "";
		/**	피부 나이	*/
		public var skinAge:int;
		/**	피부 점수	*/
		public var skinScore:int;
		/**	유저 이름	*/
		public var userName:String = "";
		/**	안 좋은 부분	*/
		public var skinTrouble:String = "";
		/**	전국 랭킹	*/
		public var totalRank:int;
		/**	매장 랭킹	*/
		public var storeRank:int;
		/**	전국 참여자 수	*/
		public var totalNum:int;
		/**	매장 참여자 수	*/
		public var storeNum:int;
		/**	몇 주차	*/
		public var weekNum:int;
		/**	전국 1위 피부 나이	*/
		public var totalWinSkinAge:int;
		/**	전국 1위 피부 스코어	*/
		public var totalWinSkinScore:int;
		/**	나이대 1위 피부 나이	*/
		public var agesWinSkinAge:int;
		/**	나이대 1위 피부 스코어	*/
		public var agesWinSkinScore:int;
		/**	사이트 메인 메뉴 & 서브 비디오 플레이어 경로	*/
		public var siteXml:XML;
		/**	영상 경로	*/
		public var videoPath:String = "";
		/**	서브 매직링 팝업 데이터 통신 주소	*/
		public var magicRingPath:String = "";
		/**	백그라운드 영상 XML	*/
		public var backMovList:XML;
		/**	서브 페이지 번호	*/
		public var menuNum:int = 0;
		
		/**
		 * Season2 키오스크
		 * /
		/**	유저 바코드	*/
		public var barcode:String;
		 /**	참여한적 있는지 체크	*/
		public var returnCheck:String;
		/**	이전 방문 날짜	*/
		public var previousVisitDate:Array = [];
		/**	이전 피부 나이	*/
		public var previousSkinAge:int;
		/**	이전 피부 점수	*/
		public var previousSkinScore:int;
		
		public var previousTotalScore:String;
		/**	이전 피부 문제점	*/
		public var previousSkinTrouble:String;
		/**	나이대	*/
		public var ages:String;
		/**	나이대 자신의 랭킹	*/
		public var ageTotalRank:int;
		/**	나이대 전국 참여자	*/
		public var ageTotalCount:int;
		/**	나이대 피테라하우스 랭킹	*/
		public var ageStoreRank:int;
		/**	나이대 피테라하우스 참여자	*/
		public var ageStoreCount:int;
		/**	나이대 전국1등의 피부나이	*/
		public var ageTotalTopSkinAge:int;
		/**	나이대 전국1등의 피부점수	*/
		public var ageTotalTopSkinScore:int;
		/**	나이대 매장1등의 피부나이	*/
		public var ageStoreTopSkinAge:int;
		/**	나이대 매장1등의 피부점수	*/
		public var ageStoreTopSkinScore:int;
		/**	동일 나이 평균 피부 나이	*/
		public var avgSkinAge:int
		/**	동일 나이 평균 피부 점수	*/
		public var avgSkinScore:int
		
		public function Model(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**	인스턴스 반환	*/
		static public function getInstance():Model
		{
			return $model;
		}
	}
}