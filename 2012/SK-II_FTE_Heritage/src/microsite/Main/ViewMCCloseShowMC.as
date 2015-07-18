package microsite.Main
{
	import adqua.net.XMLLoader;
	
	import com.adqua.utils.JavaScriptUtil;
	import com.facebook.graph.Facebook;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.lumpens.utils.ButtonUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	public class ViewMCCloseShowMC
	{
		private var $con:MCCloseShowMC;
		private var $model:MainModel;
		private var $global:Global;
		public function ViewMCCloseShowMC(con:MCCloseShowMC)
		{
			$model = MainModel.getInstance();
			$global = Global.getIns();
			$con = con;
			
//			$global.addEventListener( GlobalEvent.FB_SHOW , facebookShow );
			$global.addEventListener( GlobalEvent.VIDEO_PAUSE , startTimer );
			$global.addEventListener( GlobalEvent.VIDEO_STOP , startTimer );
			$global.addEventListener( GlobalEvent.CENTER_BUTTON , stopTimer );
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_OFF , startTimer );
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_ON , stopTimer );
			$model.addEventListener( GlobalEvent.USER_LOAD_COMPLETE , userNameLoadComplete );
			setting();
		}
		
		protected function stopTimer(e:Event):void
		{
			if($global.centerBtnNum == 0 && $timer) $timer.stop();
			else if($global.essayNum == 5 && $timer) $timer.stop();
		}
		
		private var firstChk:Boolean = false;
		protected function startTimer(e:Event):void
		{
			if(firstChk && $timer != null) { $timer.start(); }
			firstChk = true;
		}
		
//		protected function facebookShow(event:Event):void
//		{ setTimeout( evtDispatch , 2000 ); }
//		
//		private function evtDispatch():void
//		{ $con.mcBtn1.dispatchEvent( new MouseEvent( MouseEvent.CLICK )); }
		
		private function setting():void
		{
			for (var i:int = 0; i < 2; i++) 
			{
				var btn:MovieClip = $con["mcBtn"+i];
//				btn.addEventListener(MouseEvent.ROLL_OUT,onOut);
//				btn.addEventListener(MouseEvent.ROLL_OVER,onOver);
				btn.buttonMode = true;
			}
			$con.mcBtn0.addEventListener(MouseEvent.CLICK,onClickEvent);
//			$con.mcBtn1.addEventListener(MouseEvent.CLICK,onShowFaceBook);
		}
		
		protected function onClickEvent(event:MouseEvent):void
		{ JavaScriptUtil.call( "menuLink" , 1 ); }
		
//		protected function onOver(evt:MouseEvent):void
//		{
//			var btn:MovieClip = evt.currentTarget as MovieClip;
//			TweenLite.to(btn.mc,.4,{ease:Cubic.easeInOut,y:-3});
//		}
//		
//		protected function onOut(evt:MouseEvent):void
//		{
//			var btn:MovieClip = evt.currentTarget as MovieClip;
//			TweenLite.to(btn.mc,.4,{ease:Cubic.easeInOut,y:0});
//		}
		
//		protected function onShowFaceBook(event:MouseEvent):void
//		{
//			navigateToURL( new URLRequest( "http://www.facebook.com/#!/skii.korea/app_324931997581903" ),"_blank");
//		}
		
		private var $xmlLength:int;
		private var $listAry:Array = [];
		private var $timer:Timer;
		private var $tcnt:int;
		private var $user:MovieClip;
		private var $defaultY:int;
		
		protected function userNameLoadComplete(e:Event):void
		{
			$user = $con.txtContainer
			$xmlLength = $model.userXml.NameDatat.length();
			var tfFormat:TextFormat = new TextFormat;
			tfFormat.letterSpacing = 10;
//			tfFormat.bold = true;
			for (var i:int = 0; i < $xmlLength; i++) 
			{
				var mcClip:rollingTxtClip = new rollingTxtClip;
				mcClip.txt.text = $model.userXml.NameDatat[i].NAME;
				mcClip.txt.setTextFormat(tfFormat);
				mcClip.txt.autoSize = TextFieldAutoSize.LEFT;
				$user.addChild( mcClip );
				mcClip.no = i;
				
				$listAry.push( mcClip );
				if( i>0 ) $listAry[i].y = $listAry[i-1].y + $listAry[i-1].height;
				
				ButtonUtil.makeButton( mcClip , clickHandler );
			}
			mcClip = new rollingTxtClip;
			mcClip.txt.text = $model.userXml.NameDatat[0].NAME;
			mcClip.txt.setTextFormat(tfFormat);
			$user.addChild( mcClip );
			$defaultY = $user.y;
			mcClip.y = $listAry[$xmlLength-1].y + $listAry[$xmlLength-1].height;
			
			$timer = new Timer( 4000 );
			$timer.addEventListener( TimerEvent.TIMER , listTimer );
		}
		
		protected function listTimer(e:TimerEvent):void
		{
			$tcnt++;
			if( $tcnt > $xmlLength )
			{
				$tcnt = 1;
				$user.y = $defaultY;
				TweenLite.to( $user, 0.75, {y:$user.y - $listAry[0].height  , ease:Cubic.easeOut});
				trace( $tcnt );
			}
			else
			{
				TweenLite.to( $user, 0.75, {y:$user.y - $listAry[0].height  , ease:Cubic.easeOut});
				trace( $tcnt );
			}
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch ( e.type ) {
				case MouseEvent.CLICK : 
					navigateToURL( new URLRequest( "Board/Event_main.aspx?seq=" + $model.userXml.NameDatat[mc.no].IDX ),"_self");
					trace(mc.no)
					break;
			}
		}
	}
}