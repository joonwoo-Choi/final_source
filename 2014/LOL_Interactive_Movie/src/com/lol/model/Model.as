package com.lol.model
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.SoundTransform;
	import flash.text.Font;
	
	public class Model extends EventDispatcher
	{
		
		/**	인스턴스	*/
		static private var $model:Model = new Model();
		/**	공통 경로	*/
		public var commonPath:String = "";
		/**	데이타 경로	*/
		public var dataPath:String = "";
		/**	언어 설정	*/
		public var verEng:Boolean = false;
		/**	윤고딕 폰트	*/
		public var fontYgd:Font;
		/**	릭스 폰트	*/
		public var fontRix:Font;
		/**	인트로 체크	*/
		public var introChk:Boolean = true;
		/**	로드 백분율	*/
		public var loadPercent:Number;
		/**	영상 리스트	*/
		public var videoList:XML;
		/**	영상 그룹	*/
		public var videoGroup:String = "intro";
		/**	영상 종류	*/
		public var videoType:String = "flv";
		/**	영상 번호	*/
		public var videoNum:int = 0;
		/**	영상 경로	*/
		public var videoPath:String = "";
		/**	팝업 오픈 true // false	*/
		public var isPopup:Boolean = false;
		/**	팝업 번호	*/
		public var popupNum:int = 2;
		/**	인터랙션 팝업 오픈	*/
		public var isInterPopup:Boolean = false;
		/**	인터랙션 팝업 번호	*/
		public var interPopupNum:int = -1;
		/**	리액션 팝업 오픈	*/
		public var isReactionPopup:Boolean = false;
		/**	리액션 팝업 번호	*/
		public var reactionPopupNum:int = 0;
		/**	팝업 종류	*/
		public var popupType:String = "";
		/**	팝업 선택 번호	*/
		public var selectPopupBtnNum:int = 0;
		/**	소환사명	*/
		public var userName:String = "명예로운유저";
		/**	랭크팀명	*/
		public var rankName:String = "팀랭크가좋아";
		/**	토크 팝업 번호	*/
		public var talkPopupNum:int = 0;
		/**	랜덤 조합 번호	*/
		public var randomMixNum:int = 0;
		/**	팝업 타임오버	*/
		public var popupTimeOver:Boolean = false;
		/**	서브메뉴 이동 - 비디어 일시정지 */
		public var isVideoPause:Boolean = false;
//		/**	퀵메뉴 팝업 오픈	*/
//		public var showQuickPopup:Boolean = false;
		/**	퀵버튼 다시 클릭가능	*/
		public var quickReClick:Boolean = true;
		/**	퀵메뉴 show / hide 	*/
		public var quickMenuShow:Boolean = false;
		/**	팝업9 조합 번호	*/
		public var combiNum:int;
		/**	패닝영상 경로	*/
		public var panningPath:String = "";
		/**	패닝영상인지 체크	*/
		public var isPanningVideo:Boolean = false;
		/**	전체 볼륨	*/
		public var totalVolume:SoundTransform = new SoundTransform();
		
		public var wallNum:int;
		
		public var hpMainNum:int;
		public var hpSubNum:int;
		public var comMainNum:int;
		public var comSubNum:int;
		
		public var endingPopup:Boolean = false;
		
		/**	퀵 메뉴 그룹 번호	*/
		public var quickNum:int;
		
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