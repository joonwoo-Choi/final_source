package
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.utils.lumpens.ButtonUtil;
	import com.utils.lumpens.JavaScriptUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.utils.setTimeout;
	
	import orpheus.system.SecurityUtil;
	
	import resultPage.ResultPage;
	
	[SWF(width="810",height="1145", backgroundColor = "#000000" ,frameRate="30")]
	
	public class BC_Fortune extends Sprite
	{
		
		private var $main:AssetMain;
		private var $model:Model;
		private var $btnLength:int = 7;
		private var $mcNum:int;
		private var $txtArr:Array;
		private var $resultPage:ResultPage;
		private var $ldr:URLLoader;
		
		public function BC_Fortune()
		{
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetMain();
			addChild($main);
			
			$model = Model.getInstance();
			
			$resultPage = new ResultPage($main);
			
			$main.loadCon.visible = false;
			$main.loadCon.txt.mc.gotoAndStop(1);
//			$main.guideCon.visible = false;
			TweenLite.to($main.guideCon, 0.5, {delay:2.3, alpha:1});
			
			makeBtn();
		}
		
		private function makeBtn():void
		{
			$txtArr = [];
			ButtonUtil.makeButton($main.mainCon.btnGuide, btnGuideHandler);
			ButtonUtil.makeButton($main.mainCon.btnInfo, btnInfoHandler);
			
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.mainCon.btnCon.getChildByName("btn"+i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, btnHandler);
				
				var $txt:MovieClip = $main.mainCon.btnCon.getChildByName("txt"+i) as MovieClip;
				$txt.mc.gotoAndStop(1);
				$txt.no = i;
				$txt.mouseEnabled = false;
				$txt.mouseChildren = false;
				$txtArr.push($txt);
			}
			for (var j:int = 0; j < 3; j++) 
			{
				var btnClose:MovieClip = $main.guideCon.getChildByName("btnClose"+j) as MovieClip;
				btnClose.no = i;
				ButtonUtil.makeButton(btnClose, guideCloseHandler);
			}
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					for (var i:int = 0; i < $btnLength; i++) 
					{
						if(mc.no == i)
						{
							$txtArr[i].gotoAndStop(Math.ceil(Math.random()*4))
							$txtArr[i].mc.gotoAndPlay(1);
						}
						else
						{
							$txtArr[i].mc.gotoAndStop(1);
						}
					}
					break;
				case MouseEvent.MOUSE_OUT :
					for (i = 0; i < $btnLength; i++) 
					{
						$txtArr[i].mc.gotoAndStop(1);
					}
					break;
				case MouseEvent.CLICK :
					$mcNum = mc.no;
					/**	이벤트 종료 시스템 팝업	*/
					JavaScriptUtil.alert(
						"이벤트가 종료되었습니다. \n당첨되신 분들 중 개인정보를 입력하지 않으신 분들은 \n“당첨자정보 입력하기”에서 입력해주세요.");
//					searchHandler();
					trace("dduck number: "+mc.no);
					break;
			}
		}
		
		private function searchHandler():void
		{
			$main.loadCon.mcCon.gotoAndStop($mcNum+1);
			$main.loadCon.txt.gotoAndStop(Math.ceil(Math.random()*4));
			$main.loadCon.txt.mc.gotoAndPlay(1);
			$main.loadCon.searchTxt.gotoAndPlay(1);
			$main.loadCon.visible = true;
			TweenLite.to($main.loadCon, 0.4, {alpha:1, ease:Quad.easeOut});
			$main.loadCon.play();
			
			sendEventComplete();
		}
		
		private function sendEventComplete():void
		{
			var url:String;
			if(Security.sandboxType == Security.REMOTE)
			{
				url = "/fortune/Apply.action";
			}
			else
			{
				url = "http://www.fortunebc.com/fortune/Apply.action";
			}
			if(SecurityUtil.isWeb()==false){
				loadHandler();
			}else{
				
				var req:URLRequest = new URLRequest(url);
				//var vari:URLVariables = new URLVariables();
				//req.data = vari;
				req.method =URLRequestMethod.POST;
				
				$ldr = new URLLoader();
				$ldr.load(req);
				$ldr.addEventListener(Event.COMPLETE,loadHandler);
			}
				
		}
		
		protected function loadHandler(e:Event=null):void
		{
			if(SecurityUtil.isWeb()){
				var resultNum:int = $ldr.data;
				$model.resultNum = resultNum;
			}else{
				$model.resultNum = 1;
			}
			$model.dispatchEvent(new Event(ModelEvent.RESULT_RECEIVE));
			trace("$model.resultNum: ",$model.resultNum);
		}
		
		private function btnGuideHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.CLICK :
					TweenMax.to($main.guideCon, 0.5, {autoAlpha:1});
					trace(mc.name);
					break;
			}
		}
		
		private function guideCloseHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK :
					TweenMax.to($main.guideCon, 0.5, {autoAlpha:0});
					break;
			}
		}
		
		
		private function btnInfoHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.CLICK :
					JavaScriptUtil.call("showUserInfo");
					break;
			}
		}
	}
}