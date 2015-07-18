package
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Model extends EventDispatcher
	{
		private static var $main:Model;
		public var xmlData:XML;
		public var galleryPhotXMLData:XML;
		
		public var prependURL:String;
		
		public var numActiveVideo:Array;
		public var numNext:Array;
		public var videoPlay:Boolean = false;
		
		public var urlDefault:String="";
		public var urlDefaultWeb:String="http://cdn.funtrip2manila.co.kr/www/";
		
		public var urlVideoDefault:String="";
		public var phoneNum:String;
		
		public var numMovieGroup:int = 0;//0:날씨	1:전화번호 입력	2:다운로드 확인	3:메인진입영상		4:사진	5:무료통화	6:유투브	7:그룹채팅	8,9:히든무비		10아웃트로
		public var numMovie:int = 0;
		public var numProgress:int;
		
		public var checkUserInfo:String="";
		public var checkDown:String="";
		
		public var dataPhoneNum:Object;
		public var dataVerify:Object;
		public var dataText:Object;
		public var dataGetPhoto:Object;
		public var dataVideo:XML;
		public var dataCheckDown:Object;
		
		public var urlUserInfo:Array =  ["/process/cellularCheck.ashx","xml/userInfo.xml"];
		public var urlAuth:Array = ["/process/cellularAuth.ashx","xml/userAuth.xml"];
		public var urlWatch:Array = ["/process/MovieEventCheckList.ashx","xml/watchedMov.xml"];
//		public var urlUserInfo:Array =  ["http://test.funtrip2manila.co.kr/process/cellularCheck.ashx","http://test.funtrip2manila.co.kr/process/cellularCheck.ashx"];
//		public var urlAuth:Array = ["http://test.funtrip2manila.co.kr/process/cellularAuth.ashx","http://test.funtrip2manila.co.kr/process/cellularAuth.ashx"];
//		public var urlWatch:Array = ["http://test.funtrip2manila.co.kr/process/MovieEventCheckList.ashx","http://test.funtrip2manila.co.kr/process/MovieEventCheckList.ashx"];
		
		
		public var dataFeatureComplete:Object;
//		public var watchedMov:Array=["0","2"];
		public var watchedMov:Array=[];		
		/////////$$$$$$$$$$$$$$$$$$$$$$$$$$$
		public var menuBank:Array=["0","1","2","3","4","5","6","7"];		
		//시작하는 번호
		public var watchedMov2:Array=	[
			[2,0],[2,2],[2,3],
			[3,0],[3,2],[3,4],
			[4,0],[4,1]
		];
		//끝나는 번호 해당 번호영상이 끝나면 v표로 메뉴에 체크됨..
		public var watchedMov3:Array=	[
			[2,1,1],[2,2,5],[2,4,0],
			[3,1,3],[3,3,1],[3,6],
			[4,0,7],[4,2,0],[4,2,1]
		];
		public var lastMovieWatched:Boolean = false;		
		/////////$$$$$$$$$$$$$$$$$$$$$$$$$$$		
		
		public var popupNum:int=-1;
		public var menuNum:int = 0;
		public var pageNum:int;
		public var listNum:int = 0;
		public var routeNum:int;
		public var sw:int;
		public var sh:int;
		public var objW:int;
		public var objH:int;

		public var botUrl:String;
		public var activeMenu:int = 0;
		public var pepleScaleX:Number=1;
		public var pepleScaleY:Number=1;
		public var objW2:int;
		public var objH2:int;
		public var swimChkNum:Number = 0;
		public var markerPoint:Array;
		public var content:MovieClip;
		public var mainPopupFrame:int;
		public var skipChk:String;
		public var mall:Number = 0;
		public var botChk:Boolean;
		public var activeMenu2:MovieClip;
		public var activeBottonContent:Boolean;
		public var userAuth:int = 0;
		
		public var underMovTitleSetting:int;
		public var underTitleFrameSrtting:int;
		
		public var allWatched:String = "false";
		public var login:Boolean = false;
		public var shotCnt:int;
		public var botPopupType:String;
		
		
		
		public function Model(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():Model{
			if(!$main)$main = new Model;
			return $main;
		}
	}
}