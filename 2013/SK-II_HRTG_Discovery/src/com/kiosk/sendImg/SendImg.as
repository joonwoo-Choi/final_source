package com.kiosk.sendImg
{
	
	import com.adqua.util.CurrencyFormat;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.kiosk.event.ModelEvent;
	import com.kiosk.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFieldAutoSize;
	
	import orpheus.nets.UploadBitmap;
	
	public class SendImg
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $upLoader:UploadBitmap;
		
		private var $badPointLength:int = 5;
		
		private var $badPointArr:Array;
		
		private var $badPointSearchArr:Array = ["피부결", "탄력", "표정라인", "피부톤", "광채"];
		/**	텍스트 콤마 생성	*/
		private var $currencyTxt:CurrencyFormat;
		/**	텍스트 드랍쉐도우 필터	*/
		private var $dsFilter:BitmapFilter = new DropShadowFilter(1, 135, 0x000000, 0.3, 2, 2, 1, 1, true);
		
		public function SendImg(con:MovieClip)
		{
			TweenPlugin.activate([TintPlugin]);
			$con = con;
			
			$model = Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_PAGE_ONE, settingImg);
			$model.addEventListener(ModelEvent.SEND_IMG, sendImg);
			
			$currencyTxt = new CurrencyFormat();
			
			$badPointArr = [];
			for (var i:int = 0; i < 5; i++) 
			{
				var badPoint:MovieClip = $con.getChildByName("bad" + i) as MovieClip;
				$badPointArr.push(badPoint);
			}
			
			/**	랭킹 텍스트 드랍쉐도우 적용	*/
			$con.score.filters = [$dsFilter];
			$con.age.filters = [$dsFilter];
		}
		
		/**	페이스북 이미지 셋팅	*/
		protected function settingImg(e:Event):void
		{
			/**	오각형 나쁜 부분	*/
			for (var i:int = 0; i < $badPointLength; i++) 
			{
				if($badPointSearchArr[i] == $model.skinTrouble)
				{	$badPointArr[i].gotoAndStop(2);	}
				else
				{	$badPointArr[i].gotoAndStop(1);		}
			}
			
			/**	자기 피부 나이 & 점수	*/
			$con.score.text = $model.skinScore;
			$con.age.text = $model.skinAge;
			$con.score.autoSize = TextFieldAutoSize.CENTER;
			$con.age.autoSize = TextFieldAutoSize.CENTER;
			$con.scoreTxt.x = $con.score.x + $con.score.width;
			$con.ageTxt.x = $con.age.x + $con.age.width;
			
			/**	피부 점수 & 나이 셋팅	*/
			$con.ages.text = $model.ages;
			var txt:String = $currencyTxt.makeCurrency(String($model.totalNum), 3);
			$con.totalCnt.text = txt;
			txt = $currencyTxt.makeCurrency(String($model.storeNum), 3);
			$con.ageCnt.text = txt;
			$con.totalCnt.autoSize = TextFieldAutoSize.LEFT;
			$con.ageCnt.autoSize = TextFieldAutoSize.LEFT;
			$con.totalJoinTxt.x = int($con.totalCnt.x + $con.totalCnt.width) - 3;
			$con.ageJoinTxt.x = int($con.ageCnt.x + $con.ageCnt.width) - 3;
			
			/**	최고 점수	*/
			$con.totalTopScore.text = $model.totalWinSkinScore + "%";
			$con.totalTopAge.text = $model.totalWinSkinAge;
			$con.ageTopScore.text = $model.agesWinSkinScore + "%";
			$con.ageTopAge.text = $model.agesWinSkinAge;
			$con.totalTopScore.autoSize = TextFieldAutoSize.LEFT;
			$con.totalTopAge.autoSize = TextFieldAutoSize.LEFT;
			$con.ageTopScore.autoSize = TextFieldAutoSize.LEFT;
			$con.ageTopAge.autoSize = TextFieldAutoSize.LEFT;
			$con.totalTopAgeTxt.x = $con.totalTopAge.x + $con.totalTopAge.width - 3;
			$con.storeTopAgeTxt.x = $con.ageTopAge.x + $con.ageTopAge.width - 3;
			
			/**	랭킹	*/
			$con.totalRank.text = $model.totalRank;
			$con.ageRank.text = $model.storeRank;
			$con.totalRank.autoSize = TextFieldAutoSize.LEFT;
			$con.ageRank.autoSize = TextFieldAutoSize.LEFT;
			$con.totalRankTxt.x = int($con.totalRank.x + $con.totalRank.width);
			$con.ageRankTxt.x = int($con.ageRank.x + $con.ageRank.width);
			
			/**	그래프	*/
			var totalBarScaleY:Number =1 -  ($model.totalRank / $model.totalNum);
			var ageBarScaleY:Number = 1 - ($model.storeRank / $model.storeNum);
			/**	참가자가 혼자일 떄	*/
			if($model.totalRank == 1) totalBarScaleY = 1;
			if($model.storeRank == 1) ageBarScaleY = 1;
			/**	그래프 최저 높이	*/
			if(totalBarScaleY <= 0.05) totalBarScaleY = 0.05;
			if(ageBarScaleY <= 0.05) ageBarScaleY = 0.05;
			$con.totalBar.scaleY = totalBarScaleY;
			$con.ageBar.scaleY = ageBarScaleY;
			
			/**	랭킹 위치	*/
			var totalBarY:int = $con.totalBar.y - $con.totalBar.height;
			var ageBarY:int = $con.ageBar.y - $con.ageBar.height;
			
			if(totalBarY < 396) $con.totalRank.y = totalBarY;
			else $con.totalRank.y = 396;
			$con.totalRankTxt.y = $con.totalRank.y + 6;
			
			if(ageBarY < 396) $con.ageRank.y = ageBarY;
			else $con.ageRank.y = 396;
			$con.ageRankTxt.y = $con.ageRank.y + 6;
		}
		
		/**	이미지 보내기	*/
		protected function sendImg(e:Event):void
		{
			/**	테스트 서버	*/
//			var url:String = "http://test.crm.piterahouse.com/Facebook/Process/KioskUploader.ashx";
			/**	실 서버	*/
			var url:String = "http://crm.piterahouse.com/Facebook/Process/KioskUploader.ashx";
			
			var bitmapdata:BitmapData = new BitmapData(500, 500);
			bitmapdata.draw($con);
			
			var bitmap:Bitmap = new Bitmap(bitmapdata);			
			
			var urlVars:URLVariables = new URLVariables;
			urlVars.rand = Math.random() * 10000;
			urlVars.barcode = String($model.barcode);
			
			$upLoader = new UploadBitmap(url, {onProgress:uploadProgress, onComplete:sendOK});
			$upLoader.upload(bitmap,urlVars);
			trace(urlVars.barcode);
		}
		
		private function uploadProgress(evt:ProgressEvent):void
		{
			trace("evt.bytesLoaded: ",evt.bytesLoaded);
		}		
		/**	전송 결과 값	*/
		private function sendOK(data:Object):void
		{
			switch (int(data))
			{
				case -1 : trace("바코드 파라미터가 없음"); break;
				case -2 : trace("해당하는 고객정보가 없음"); break;
				case -3 : trace("업로드 가능한 이미지가 없음(업로드파일데이터크기가 0이거나 파일이 없음)"); break;
				case -4 : trace("파일 용량이 5MB를 초과함"); break;
				case -5 : trace("이미지 업로드 실패(웹서비스팀과 확인이 필요함)"); break;
				case -9 : trace("시스템 오류(웹서비스팀에 문의요망)"); break;
				case 1 : trace("업로드 성공"); break;
			}
		}
	}
}