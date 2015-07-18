package com.proof.kiosk
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.proof.event.ModelEvent;
	import com.proof.kiosk.flvPlayer.FlvPlayer;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Mouse;
	import flash.utils.Timer;

	public class Kiosk_Main
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $movCon:FlvPlayer;
		
		private var $focusTimer:Timer;
		
		public function Kiosk_Main(con:MovieClip)
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_MAIN, settingMain);
//			$model.addEventListener(ModelEvent.SET_FOCUS_BARCODE, reStartFocusTimer);
			
			$movCon = new FlvPlayer($con.movCon);
			
			settingMain();
		}
		
//		private function reStartFocusTimer(e:Event):void
//		{
//			$focusTimer.start();
//			$con.stage.focus = $con.barcode;
//		}
		
		private function settingMain(e:Event = null):void
		{
			$model.kioskPageNum = 0;
			
			TweenLite.to($con, 1, {autoAlpha:1, ease:Cubic.easeOut});
			
			$focusTimer = new Timer(1000);
			$focusTimer.addEventListener(TimerEvent.TIMER, setFocusTimer);
			$focusTimer.start();
			
			$con.barcode.addEventListener(Event.CHANGE, barcodeChange);
			$con.stage.focus = $con.barcode;
			$con.barcode.text = "";
			
			/**	바코드 필드 초기화	*/
			$con.stage.addEventListener(KeyboardEvent.KEY_DOWN, resetBarcodeField);
		}
		
		private function resetBarcodeField(e:KeyboardEvent):void
		{
			if(e.keyCode == 32)
			{
				$con.barcode.text = "";
				$con.stage.focus = $con.barcode;
				trace(e.keyCode);
			}
		}
		
		private function setFocusTimer(e:TimerEvent):void
		{
			$con.stage.focus = $con.barcode;
			/**	마우스 숨기기	*/
			Mouse.hide();
		}
		
		/**	텍스트 필드에 바코드 입력	*/
		private function barcodeChange(e:Event):void
		{
			if($con.barcode.text == " ") $con.barcode.text = "";
			if($con.barcode.text.length >= 6)
			{
				var url:String = "http://crm.piterahouse.com/Process/GetMagicRingData.ashx";
				var vari:URLVariables = new URLVariables();
				vari.rand = Math.round(Math.random()*10000);
				vari.bNo = $con.barcode.text;
				vari.type = "data";
				
				var req:URLRequest = new URLRequest(url);
				req.data = vari;
				req.method =URLRequestMethod.POST;
				
				var ldr:URLLoader = new URLLoader();
				ldr.load(req);
				ldr.addEventListener(Event.COMPLETE, resultLoadComplete);
				
				$con.barcode.text = "";
				$con.stage.focus = $con.movCon;
				
				$focusTimer.stop();
				trace($con.barcode.text, $con.barcode.text.length);
			}
			trace($con.barcode.text, $con.barcode.text.length);
		}
		/**	유저 정보 받기	*/
		protected function resultLoadComplete(e:Event):void
		{
			$model.userInform = new XML(e.target.data);
			trace($model.userInform);
			
			/**	유저 정보 셋팅*/
			$model.joinCheck = $model.userInform.MagicRingData.SampleYN;
			$model.visitDate = $model.userInform.MagicRingData.VisitDate;
			$model.gender = $model.userInform.MagicRingData.Gender;
			$model.skinAge = $model.userInform.MagicRingData.SkinAge;
			$model.skinScore = $model.userInform.MagicRingData.SkinScore;
			$model.userName = $model.userInform.MagicRingData.Name;
			$model.skinTrouble = $model.userInform.MagicRingData.SkinTrouble;
			$model.totalRank = $model.userInform.MagicRingData.Rank.TotalRank;
			$model.storeRank = $model.userInform.MagicRingData.Rank.StoreRank;
			$model.totalNum = $model.userInform.MagicRingData.Rank.TotalCount;
			$model.storeNum = $model.userInform.MagicRingData.Rank.StoreCount;
			$model.totalWinSkinAge =  $model.userInform.MagicRingData.Rank.TotalTopSkinAge;
			$model.totalWinSkinScore =  $model.userInform.MagicRingData.Rank.TotalTopSkinScore;
			$model.agesWinSkinAge =  $model.userInform.MagicRingData.Rank.StoreTopSkinAge;
			$model.agesWinSkinScore =  $model.userInform.MagicRingData.Rank.StoreTopSkinScore;
			$model.weekNum = $model.userInform.MagicRingData.JoinChasu;
			if(int($model.userInform.MagicRingData.RealAge) < 30) $model.age = 20;
			else if(int($model.userInform.MagicRingData.RealAge) >= 30 && int($model.userInform.MagicRingData.RealAge) < 40) $model.age = 30;
			else if(int($model.userInform.MagicRingData.RealAge) > 40)$model.age = 40;
			 
			trace("$model.age: " + $model.age);
//			$model.joinCheck = "Y";
//			$model.visitDate = "2013-02-06";
//			$model.age = 40;
//			$model.gender = "F";
//			$model.skinAge = 18;
//			$model.skinScore = 90;
//			$model.userName = "최준우";
//			$model.badPoint = "광채";
//			$model.totalRank = 350;
//			$model.storeRank = 350;
//			$model.totalNum = 1000;
//			$model.storeNum = 1000;
//			$model.weekNum = 3;
//			$model.totalWinSkinAge = 17;
//			$model.totalWinSkinScore = 92;
//			$model.storeWinSkinAge = 21;
//			$model.storeWinSkinScore = 87;
			
			result($model.joinCheck);
		}
		
		/**	결과, 진행 여부 	*/
		private function result(result:String):void
		{
			trace("result: " + result);
//			$focusTimer.stop();
//			result = "N"
			if(result == "" || $model.userInform.Result == "NONE")
			{
				$focusTimer.start();
				$con.stage.focus = $con.barcode;
				trace("데이터 없음");
				return;
			}
			else
			{
				$focusTimer.removeEventListener(TimerEvent.TIMER, setFocusTimer);
				$focusTimer = null;
				$con.barcode.removeEventListener(Event.CHANGE, barcodeChange);
				
				$model.dispatchEvent(new ModelEvent(ModelEvent.KIOSK_PAGE_ONE));
				TweenLite.to($con, 1, {autoAlpha:0, ease:Cubic.easeOut});
			}
//			switch (result)
//			{
//				case "N":
//					$focusTimer.removeEventListener(TimerEvent.TIMER, setFocusTimer);
//					$focusTimer = null;
//					$con.barcode.removeEventListener(Event.CHANGE, barcodeChange);
//					
//					$model.dispatchEvent(new ModelEvent(ModelEvent.KIOSK_PAGE_ONE));
//					TweenLite.to($con, 1, {autoAlpha:0, ease:Cubic.easeOut});
//					break;
//				case "Y":
//					$model.dispatchEvent(new ModelEvent(ModelEvent.SHOW_POPUP));
//					break;
//			}
		}
	}
}