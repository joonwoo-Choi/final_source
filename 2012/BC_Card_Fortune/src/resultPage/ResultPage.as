package resultPage
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.utils.lumpens.ButtonUtil;
	import com.utils.lumpens.JavaScriptUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Security;
	
	public class ResultPage
	{
		
		private var $main:MovieClip;
		private var $model:Model;
		private var $ldr:URLLoader;
		
		public function ResultPage(main:MovieClip)
		{
			$main = main;
			$model = Model.getInstance();
			$main.resultCon.visible = false;
			
			$model.addEventListener(ModelEvent.RESULT_RECEIVE, resultHandler);
		}
		
		protected function resultHandler(e:Event):void
		{
			$main.loadCon.stop();
			TweenMax.to($main.loadCon, 0.4, {autoAlpha:0});
			switch($model.resultNum)
			{
				case -1 :
					/** 로그인X	*/
					JavaScriptUtil.call("facebookLogin");
					break;
				case -2 :
					/** 이미 당첨	*/
					$main.resultCon.gotoAndStop(6);
					TweenMax.to($main.resultCon, 0.4, {autoAlpha:1});
					ButtonUtil.makeButton($main.resultCon.btnInfo, showUserInfo);
					break;
				case -3 :
					$main.resultCon.gotoAndStop(7);
					TweenMax.to($main.resultCon, 0.4, {autoAlpha:1});
//					JavaScriptUtil.alert("포춘송편 즉석당첨 이벤트는 1일 3회 참여가 가능합니다.내일 다시 참여 해주세요");
					break;
				case 0 :
					/** 꽝	*/
					$main.resultCon.gotoAndStop(Math.ceil(Math.random()*3+2));
					TweenMax.to($main.resultCon, 0.4, {autoAlpha:1});
					break;
				case 1 :
					/** CGV 당첨	*/
					$main.resultCon.gotoAndStop(1);
					TweenMax.to($main.resultCon, 0.4, {autoAlpha:1});
					break;
				case 2 :
					/** 스타벅스 당첨	*/
					TweenMax.to($main.resultCon, 0.4, {autoAlpha:1});
					$main.resultCon.gotoAndStop(2);
					break;
			}
			ButtonUtil.makeButton($main.resultCon.btn0, btn0Handler);
			ButtonUtil.makeButton($main.resultCon.btn1, btn1Handler);
			$main.resultCon.btn2.addEventListener(MouseEvent.CLICK, btn2Handler);
			$main.resultCon.btn2.buttonMode = true;
			trace("$main.resultCon.currentFrame: "+$main.resultCon.currentFrame)
		}
		
		private function showUserInfo(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					JavaScriptUtil.call("showUserInfo");
					break;
			}
		}
		
		private function btn2Handler(e:MouseEvent):void
		{
			init();
		}
		private function btn0Handler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					switch ($main.resultCon.currentFrame)
					{
						case 1 :
							/** 당첨	*/
						case 2 :
							if(ExternalInterface.available) ExternalInterface.call("showUserInfo");
							break;
						case 3 :
							/** 실패	*/
						case 4 :
						case 5 :
							init();
							break;
						case 6 :
							/** 이미 당첨	*/
							friendInvite();
							JavaScriptUtil.alert("담벼락에 게시 되었습니다.");
							break;
					}
					trace("btn0 click");
					break;
			}
		}
		
		private function init():void
		{
			TweenMax.to($main.resultCon, 0.4, {autoAlpha:0});
		}
		
		private function btn1Handler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					navigateToURL(new URLRequest("http://www.bccard.com/app/card/ContentsLinkActn.do?pgm_id=ind1004"),"_blank");
					trace("btn1 click");
					break;
			}
		}
		
		private function friendInvite():void
		{
			var url:String;
			if(Security.sandboxType == Security.REMOTE)
			{
				url = "/fortune/SharePrizeWinner.action";
			}
			else
			{
				url = "http://www.fortunebc.com/fortune/SharePrizeWinner.action";
			}
			var req:URLRequest = new URLRequest(url);
			
			req.method =URLRequestMethod.POST;
			
			$ldr = new URLLoader();
			$ldr.load(req);
			$ldr.addEventListener(Event.COMPLETE,loadHandler);
		}
		
		private function loadHandler(e:Event):void
		{
			var resultNum:int = $ldr.data;
			switch (resultNum)
			{
				case -1 :
					/** 로그인 X */
					JavaScriptUtil.call("facebookLogin");
					trace("로그인 X");
					break;
				case -2 :
					/** 당첨 이력 X */
					trace("당첨 이력 X");
					break;
				case 1 :
					/** 완료 */
					TweenMax.to($main.resultCon, 0.5, {autoAlpha:0});
					trace("완료");
					break;
			}
			trace("친구 소문내기 결과 값: "+resultNum);
		}
	}
}