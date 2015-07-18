package orpheus.templete.moviePlayer
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ModelPlayer extends EventDispatcher
	{
		private static var main:ModelPlayer;
		public var videoURL:String;
		public var objs:Array=new Array("ply","sek","vol","txt","rez","ful","hdv","bri");
		public var autoHideF:Boolean;
		public var autoHide:Boolean;
		public var vidFixSiz:Boolean;		
		
		public var parameter:Object;
		
		public var volPrePos:Number;
		public var volval:Number;
		
		public var vidWidF:Number;
		public var vidHig:Number;
		public var vidBr:Number;
		public var vidMrg:Number;
		public var vidVMrg:Number;
		public var vidCorRad:Number;
		public var vidCol:String;
		public var vidBrCol:String;
		public var vidBgTra:Number;
		public var vidBrTra:Number;
		public var vidTimAlignB:Boolean;
		public var skinType:Number;
		public var vidOvrLayCol:String;
		public var vidOvrLayTra:Number;
		public var shadowAlpha:Number;
		public var vidSekBarCol:String;
		public var sekHig:Number;
		
		public var btnWid:Number;
		public var btnOvrCol:String;
		public var btnSprCol:String;
		public var icoCol:String;
		public var icoSiz:Number;
		public var volWid:Number=76;
		public var vidFixSizF:Boolean;	
	
		public var locVideo:Boolean=true;
		
		
		public var dataPath:String;
		public var settingLI:String;
		public var xmlLoad:URLLoader;
		public var url:URLRequest;		

		public var thumbImgPath:String;
		public var pArr:String;
		public var pathArr:Array;
		
		public var pArrHd:String;
		public var pathArrHd:Array;
		
		public var logoPath:String;
		public var logoXmargin:Number;
		public var logoYmargin:Number;		
		
		public var autoPlayVideo:Boolean;
		
		public var bufTim:Number;
		public var vidWid:Number;		
		
		public var videoSmoothness:Boolean;		
		
		public var btnSprTra:Number;	
		
		public var textBgAlpha:Number;
		
		public var textBgColor:String;		
		
		public var embedFont:Boolean;		
		public var titleText:String;
		public var titleVspace:Number;
		public var desText:String;		
		
		public var bgColor:String;		
		public var reflect:Boolean;
		public var refVidOnly:Boolean;
		public var refDis:Number;
		public var refDep:Number;
		public var refAlp:Number;		
		
		public var rStgW:Number=500;// If you need to change the videoplayer width just change rStgW value
		public var rStgH:Number=300;// If you need to change the videoplayer height just change rStgH value		
		
		public var vidQulLoc:String;	
		public var vidSource:String;
		public var vLoaded:Boolean=false;
		
		public var hideDelayTim:Number=0;		
		public var sekDrg:Boolean=false;	
		public var volDrg:Boolean=false;	
		
		public var spd:Number=50;
		
		public var btnOvrTra:Number=.75;
		public var vidTotDur:Number=0;
	
		public var curPathNum:Number=0;
		public var rezStg:Boolean=true;
		
		public var vidCurDur:Number=0;		
		
		public var userRezMod:String="fittoarea";
		
		
		public var fulScreen:Boolean=false;		
		public var startV:Boolean=false;
		public var vidEnd:Boolean=false;	
		
		public var fadSpd:Number=3;		
		public function ModelPlayer(target:IEventDispatcher=null)
		{
			super(target);
		}
		public static function getInstance():ModelPlayer{
			if(!main)main = new ModelPlayer;
			return main;
		}
		
		// Validate Variable function 
		
		public function validate(v,t) :*{
			var chk:Boolean=String(v) && v!="" && v !=undefined && v !=null && v!="" && v !="undefined" && v !="null"?true:false;
			if (t=="n") {
				chk=!isNaN(v)?chk:false;
			}
			return chk;
		}

		
	}
}