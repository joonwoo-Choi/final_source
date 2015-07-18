package com.kiosk
{
	
	import bonanja.core.net.NetSenser;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.kiosk.event.ModelEvent;
	import com.kiosk.model.Model;
	
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

	public class KioskMain
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $focusTimer:Timer;
		
		public function KioskMain(con:MovieClip)
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_MAIN, settingMain);
//			$model.addEventListener(ModelEvent.SET_FOCUS_BARCODE, reStartFocusTimer);
			
			settingMain();
		}
		
		private function settingMain(e:Event = null):void
		{
			$model.kioskPageNum = 0;
			
			TweenLite.to($con, 1, {autoAlpha:1, ease:Cubic.easeOut});
			
			$con.intro.gotoAndPlay(1);
			
			$focusTimer = new Timer(1000);
			$focusTimer.addEventListener(TimerEvent.TIMER, setFocusTimer);
			$focusTimer.start();
			
			$con.barcode.addEventListener(Event.CHANGE, barcodeChange);
			$con.stage.focus = $con.barcode;
			$con.barcode.text = "";
			
			/**	바코드 필드 초기화	*/
			$con.stage.addEventListener(KeyboardEvent.KEY_DOWN, resetBarcodeField);
			
//			$model.dispatchEvent(new ModelEvent(ModelEvent.VIDEO_SETTING));
//			$model.dispatchEvent(new ModelEvent(ModelEvent.VIDEO_PLAY));
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
				$model.barcode = $con.barcode.text;
				/**	테스트 서버	*/
//				var url:String = "http://test.crm.piterahouse.com/Process/GetMagicRingData.ashx";
				/**	실 서버	*/
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
			}
			trace($con.barcode.text, $con.barcode.text.length);
		}
		/**	유저 정보 받기	*/
		protected function resultLoadComplete(e:Event):void
		{
			$model.userInform = new XML(e.target.data);
			trace($model.userInform);
			
			/**	유저 정보 셋팅*/
			$model.returnCheck = $model.userInform.MagicRingData.PreviousMagicRing;
			$model.sampleCheck = $model.userInform.MagicRingData.SampleYN;
			$model.visitDate = $model.userInform.MagicRingData.VisitDate;
			$model.gender = $model.userInform.MagicRingData.Gender;
			$model.skinAge = $model.userInform.MagicRingData.SkinAge;
			$model.skinScore = $model.userInform.MagicRingData.SkinScore;
			$model.userName = $model.userInform.MagicRingData.Name;
			$model.skinTrouble = $model.userInform.MagicRingData.SkinTrouble;
			$model.totalRank = $model.userInform.MagicRingData.Rank.TotalRank;
			$model.totalNum = $model.userInform.MagicRingData.Rank.TotalCount;
			/**	전국	*/
			$model.storeRank = $model.userInform.MagicRingData.AgeRank.AgeTotalRank;
			$model.storeNum = $model.userInform.MagicRingData.AgeRank.AgeTotalCount;
			
			$model.totalWinSkinAge =  $model.userInform.MagicRingData.Rank.TotalTopSkinAge;
			$model.totalWinSkinScore =  $model.userInform.MagicRingData.Rank.TotalTopSkinScore;
			/**	전국 같은 나이대	*/
			$model.agesWinSkinAge =  $model.userInform.MagicRingData.AgeRank.AgeTotalTopSkinAge;
			$model.agesWinSkinScore =  $model.userInform.MagicRingData.AgeRank.AgeTotalTopSkinScore;
			
			$model.weekNum = $model.userInform.MagicRingData.JoinChasu;
			$model.age = $model.userInform.MagicRingData.RealAge;
//			if(int($model.userInform.MagicRingData.RealAge) < 30) $model.age = 20;
//			else if(int($model.userInform.MagicRingData.RealAge) >= 30 && int($model.userInform.MagicRingData.RealAge) < 40) $model.age = 30;
//			else if(int($model.userInform.MagicRingData.RealAge) > 40)$model.age = 40;
			
			$model.previousVisitDate = String($model.userInform.MagicRingData.Previous.VisitDate).split("-");
			$model.previousSkinAge = $model.userInform.MagicRingData.Previous.SkinAge;
			$model.previousSkinScore = $model.userInform.MagicRingData.Previous.SkinScore;
			$model.previousTotalScore = $model.userInform.MagicRingData.Previous.TotalScore;
			$model.previousSkinTrouble = $model.userInform.MagicRingData.Previous.SkinTrouble;
			$model.ages = $model.userInform.MagicRingData.AgeRank.Ages;
			/**	피테라 하우스 */
			$model.ageTotalRank = $model.userInform.MagicRingData.Rank.StoreRank;
			$model.ageTotalCount = $model.userInform.MagicRingData.Rank.StoreCount;
			
			$model.ageStoreRank = $model.userInform.MagicRingData.AgeRank.AgeStoreRank;
			$model.ageStoreCount = $model.userInform.MagicRingData.AgeRank.AgeStoreCount;
			/**	피테라 하우스 같은 나이대 */
			$model.ageTotalTopSkinAge = $model.userInform.MagicRingData.Rank.StoreTopSkinAge;
			$model.ageTotalTopSkinScore = $model.userInform.MagicRingData.Rank.StoreTopSkinScore;
			trace($model.ageTotalTopSkinAge, $model.ageTotalTopSkinScore);
			$model.ageStoreTopSkinAge = $model.userInform.MagicRingData.AgeRank.AgeStoreTopSkinAge;
			$model.ageStoreTopSkinScore = $model.userInform.MagicRingData.AgeRank.AgeStoreTopSkinScore;
			
			$model.avgSkinAge = $model.userInform.MagicRingData.AgeAvg.AvgSkinAge;
			$model.avgSkinScore = $model.userInform.MagicRingData.AgeAvg.AvgSkinScore;
			
			result($model.sampleCheck);
		}
		
		/**	결과, 진행 여부 	*/
		private function result(result:String):void
		{
			trace("result: " + result);
//			$focusTimer.stop();
//			result = "N"
//			$model.sampleCheck = "Y";
//			$model.weekNum = 6;
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
				TweenLite.to($con, 1, {autoAlpha:0, ease:Cubic.easeOut, onComplete:stopIntro});
			}
		}
		
		/**	메인 영상 정지	*/
		private function stopIntro():void
		{
			$con.intro.gotoAndStop(1);
		}
	}
}