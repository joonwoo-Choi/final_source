package microsite.Main
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class MainModel extends EventDispatcher
	{
		
		private static var $main:MainModel;
		
		public var specialIs:Boolean = false;
		
		public var truePageAry:Array = [];
		public var lastPageNum:int;
		
		public var movieCount:int = 0;
		
		public var newIconShowNum:int =2;
		
		public var userXml:XML;
		
		
		/** G 트래킹 사이트**/
		public var essayAry:Array = [ "essay_movie1" , "essay_movie2" , "essay_movie3" , "essay_movie4" , "essay_movie5","special_cut" ];
		public var playAry:Array = [ "essay_movie1_play" , "essay_movie2_play" , "essay_movie3_play" , "essay_movie4_play" , "essay_movie5_play" ];
		public var evtAry:Array = [ "essay_movie1_event" , "essay_movie2_event" , "essay_movie3_event" , "essay_movie4_event" , "essay_movie5_event" ];
		public var behindAry:Array = [ "essay_movie1_behind" , "essay_movie2_behind" , "essay_movie3_behind" , "essay_movie4_behind" , "essay_movie5_behind" ];
		
		/** G 트래킹 페이스 북 **/
		public var gmovAry:Array = [ "f_essay_movie1_play" , "f_essay_movie2_play" , "f_essay_movie3_play" , "f_essay_movie4_play" , "f_essay_movie5_play" ];
		public var gmovArySpecial:Array = [ "tvcf_play","makingfilm_play" ];
		
		/** 리얼 트래킹 사이트**/
		public var realpageAry:Array = [ 2 , 6 , 10 , 16 , 18 ];
		public var realmovAry:Array = [ 3 , 7 , 11 , 15 , 19 ];
		public var realfbAry:Array = [ 4 , 8 , 12 , 16 , 20 ];
		public var realfullAry:Array = [ 5 , 9 , 13 , 17 , 21 ];
		
		/** 리얼 트래킹 페이스 북 **/
		public var realnumAry:Array = [ 31 , 34 , 37 , 40 , 43 ];
		public var realnumArySpcialCut:Array = [ 24,27];
		
		
		
		public var specialMovieShareG:Array = ["tvcf_scrap","makingfilm_scrap"];
		public var specialMovieShareR:Array = [25,28];
		public var specialBtnClickShareG:Array = ["printad","printad","printad","printad","tvcf","makingfilm"];
		public var specialBtnClickShareR:Array = [29,29,29,29,23,26];
		
		public var activeSpecialNum:int = -1; 
		public var imgConDefaultY:int = 35; 
		public var imgConADDGap:int = 60; 
//		public var imgConADDGap:int = 0; 
		
		public function MainModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():MainModel{
			if(!$main)$main = new MainModel;
			return $main;
		}
	}
}