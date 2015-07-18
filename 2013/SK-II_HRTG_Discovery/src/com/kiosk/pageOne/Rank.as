package com.kiosk.pageOne
{
	import com.adqua.util.CurrencyFormat;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.kiosk.event.ModelEvent;
	import com.kiosk.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	
	public class Rank
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	텍스트 콤마 생성	*/
		private var $currencyTxt:CurrencyFormat;
		/**	텍스트 드랍쉐도우 필터	*/
		private var $dsFilter:BitmapFilter = new DropShadowFilter(1, 135, 0x000000, 0.3, 2, 2, 1, 1, true);
		/**	bar 기준 높이	*/
		private var $barHeight:int = 121;
		/**	탭 버튼	*/
		private var $btnArr:Array;
		
		public function Rank(con:MovieClip)
		{
			$con = con;
			
			$model =Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_PAGE_ONE, pageSetting);
			
			$currencyTxt = new CurrencyFormat();
			
			/**	랭킹 텍스트 드랍쉐도우 적용	*/
			$con.totalRank.filters = [$dsFilter];
			$con.ageRank.filters = [$dsFilter];
			
			/**	탭버튼 만들기	*/
			$btnArr = [];
			for (var i:int = 0; i < 2; i++) 
			{
				var btn:MovieClip = $con.getChildByName("btnTap" + i) as MovieClip;
				$btnArr.push(btn);
				btn.no = i;
				btn.addEventListener(MouseEvent.CLICK, tapHandler);
			}
		}
		
		private function tapHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			graphChange(target.no);
		}
		
		private function graphChange(num:int):void
		{
			for (var i:int = 0; i < 2; i++) 
			{
				if(num == i) TweenLite.to($btnArr[i].over, 0.5, {alpha:1});
				else TweenLite.to($btnArr[i].over, 0.5, {alpha:0});
			}
			
			if(num == 0)
			{
				totalSetting();
				showTotalResult();
			}
			else
			{
				storeSetting();
				showStoreResult();
			}
			trace(num);
		}
		
		private  function pageSetting(e:Event):void
		{
			/**	탭버튼 초기화	*/
			graphChange(0);
			
			/**	유저 이름 셋팅	*/
			$con.userName1.text = $model.userName + "님";
			$con.userName2.text = $model.userName + "님";
			$con.userName1.autoSize = TextFieldAutoSize.CENTER;
			$con.userName2.autoSize = TextFieldAutoSize.CENTER;
			
			totalSetting();
			
			/**	순위 리셋	*/
			$con.totalRank.totalRank.text = "";
			$con.ageRank.ageRank.text = "";
			
			/**	랭킹 셋팅	*/
			$con.totalBar.scaleY = 0;
			$con.totalUserBar.scaleY = 0;
			$con.ageBar.height = 0;
			$con.ageUserBar.height = 0;
			
			/**	전국 & 매장 랭킹 리셋	*/
			$con.totalRank.y = 1128;
			$con.totalRank.totalRank.text = Math.ceil($model.totalRank * $con.totalBar.scaleY);
			$con.totalRank.totalRank.autoSize = TextFieldAutoSize.LEFT;
			$con.totalRank.txt.x = $con.totalRank.totalRank.x + $con.totalRank.totalRank.width;
			$con.ageRank.y = 1128;
			$con.ageRank.ageRank.text = Math.ceil($model.ageTotalRank * $con.ageBar.scaleY);
			$con.ageRank.ageRank.autoSize = TextFieldAutoSize.LEFT;
			$con.ageRank.txt.x = $con.ageRank.ageRank.x + $con.ageRank.ageRank.width;
			
			setTimeout(showTotalResult, 500);
		}
		/**	전국 셋팅	*/
		private function totalSetting():void
		{
			/**	피부 점수 & 나이 셋팅	*/
			var txt:String = $currencyTxt.makeCurrency(String($model.totalNum), 3);
			$con.totalNum.text = txt;
			txt = $currencyTxt.makeCurrency(String($model.storeNum), 3);
			$con.ageNum.text = txt
			$con.totalNum.autoSize = TextFieldAutoSize.LEFT;
			$con.ageNum.autoSize = TextFieldAutoSize.LEFT;
			$con.joinTxt0.x = int($con.totalNum.x + $con.totalNum.width);
			$con.joinTxt1.x = int($con.ageNum.x + $con.ageNum.width);
			$con.rankAges.text = $model.ages;
			
			/**	전국 & 매장 1위 피부 나이 & 스코어	*/
			$con.totalScore.text = $model.totalWinSkinScore;
			$con.totalAge.text = $model.totalWinSkinAge;
			$con.ageScore.text = $model.agesWinSkinScore;
			$con.ageAge.text = $model.agesWinSkinAge;
			$con.totalScore.autoSize = TextFieldAutoSize.LEFT;
			$con.totalAge.autoSize = TextFieldAutoSize.LEFT;
			$con.ageScore.autoSize = TextFieldAutoSize.LEFT;
			$con.ageAge.autoSize = TextFieldAutoSize.LEFT;
			$con.per0.x = $con.totalScore.x + $con.totalScore.width - 2;
			$con.age0.x = $con.totalAge.x + $con.totalAge.width - 2;
			$con.per1.x = $con.ageScore.x + $con.ageScore.width - 2;
			$con.age1.x = $con.ageAge.x + $con.ageAge.width - 2;
		}
		/**	스토어 셋팅	*/
		private function storeSetting():void
		{
			/**	전국 & 매장 1위 피부 나이 & 스코어	*/
			var txt:String = $currencyTxt.makeCurrency(String($model.ageTotalCount), 3);
			$con.totalNum.text = txt;
			txt = $currencyTxt.makeCurrency(String($model.ageStoreCount), 3);
			$con.ageNum.text = txt;
			$con.totalNum.autoSize = TextFieldAutoSize.LEFT;
			$con.ageNum.autoSize = TextFieldAutoSize.LEFT;
			$con.joinTxt0.x = int($con.totalNum.x + $con.totalNum.width);
			$con.joinTxt1.x = int($con.ageNum.x + $con.ageNum.width);
			
			$con.totalScore.text = $model.ageTotalTopSkinScore;
			$con.totalAge.text = $model.ageTotalTopSkinAge;
			$con.ageScore.text = $model.ageStoreTopSkinScore;
			$con.ageAge.text = $model.ageStoreTopSkinAge;
			$con.totalScore.autoSize = TextFieldAutoSize.LEFT;
			$con.totalAge.autoSize = TextFieldAutoSize.LEFT;
			$con.ageScore.autoSize = TextFieldAutoSize.LEFT;
			$con.ageAge.autoSize = TextFieldAutoSize.LEFT;
			$con.per0.x = $con.totalScore.x + $con.totalScore.width - 2;
			$con.age0.x = $con.totalAge.x + $con.totalAge.width - 2;
			$con.per1.x = $con.ageScore.x + $con.ageScore.width - 2;
			$con.age1.x = $con.ageAge.x + $con.ageAge.width - 2;
		}
		
		/**	전국 1위 랭킹 & 그래프	*/
		private function showTotalResult():void
		{
			/**	중앙 랭킹	*/
			TweenLite.to($con.totalBar, 3, {scaleY:1, ease:Cubic.easeOut, onUpdate:totalRankingUpdate});
			TweenLite.to($con.ageBar, 3, {scaleY:1, ease:Cubic.easeOut, onUpdate:ageRankingUpdate});
			
			var totalBarScaleY:Number =1 -  ($model.totalRank / $model.totalNum);
			var ageBarScaleY:Number = 1 - ($model.storeRank / $model.storeNum);
			/**	참가자가 혼자일 떄	*/
			if($model.totalRank == 1) totalBarScaleY = 1;
			if($model.storeRank == 1) ageBarScaleY = 1;
			/**	그래프 최저 높이	*/
			if(totalBarScaleY <= 0.05) totalBarScaleY = 0.05;
			if(ageBarScaleY <= 0.05) ageBarScaleY = 0.05;
			TweenLite.to($con.totalUserBar, 3, {scaleY:totalBarScaleY, ease:Cubic.easeOut});
			TweenLite.to($con.ageUserBar, 3, {scaleY:ageBarScaleY, ease:Cubic.easeOut});
		}
		/**	전국 랭킹 & 그래프	*/
		private function totalRankingUpdate():void
		{
			$con.totalRank.totalRank.text = Math.ceil($model.totalRank * $con.ageBar.scaleY);
			$con.totalRank.totalRank.autoSize = TextFieldAutoSize.LEFT;
			$con.totalRank.txt.x = $con.totalRank.totalRank.x + $con.totalRank.totalRank.width;
			
			if($con.totalUserBar.height / $barHeight < 0.5) return;
			$con.totalRank.y = 1100 - int(100 * ($con.totalUserBar.height / $barHeight) - 80);
		}
		/**	전국 나이 랭킹 & 그래프	*/
		private function ageRankingUpdate():void
		{
			$con.ageRank.ageRank.text = Math.ceil($model.storeRank * $con.ageBar.scaleY);
			$con.ageRank.ageRank.autoSize = TextFieldAutoSize.LEFT;
			$con.ageRank.txt.x = $con.ageRank.ageRank.x + $con.ageRank.ageRank.width;
			
			if($con.ageUserBar.height / $barHeight < 0.5) return;
			$con.ageRank.y = 1100 - int(100 * ($con.ageUserBar.height / $barHeight) - 80);
		}
		
		/**	스토어 1위 랭킹 & 그래프	*/
		private function showStoreResult():void
		{
			/**	중앙 랭킹	*/
			TweenLite.to($con.totalBar, 3, {scaleY:1, ease:Cubic.easeOut, onUpdate:storeTotalRankingUpdate});
			TweenLite.to($con.ageBar, 3, {scaleY:1, ease:Cubic.easeOut, onUpdate:storeAgeRankingUpdate});
			
			var totalBarScaleY:Number = 1 - ($model.ageTotalRank / $model.ageTotalCount);
			var ageBarScaleY:Number = 1 - ($model.ageStoreRank / $model.ageStoreCount);
			/**	참가자가 혼자일 떄	*/
			if($model.ageTotalRank == 1) totalBarScaleY = 1;
			if($model.ageStoreRank == 1) ageBarScaleY = 1;
			/**	그래프 최저 높이	*/
			if(totalBarScaleY <= 0.05) totalBarScaleY = 0.05;
			if(ageBarScaleY <= 0.05) ageBarScaleY = 0.05;
			TweenLite.to($con.totalUserBar, 3, {scaleY:totalBarScaleY, ease:Cubic.easeOut});
			TweenLite.to($con.ageUserBar, 3, {scaleY:ageBarScaleY, ease:Cubic.easeOut});
		}
		/**	스토어 랭킹 & 그래프	*/
		private function storeTotalRankingUpdate():void
		{
			$con.totalRank.totalRank.text = Math.ceil($model.ageTotalRank * $con.ageBar.scaleY);
			$con.totalRank.totalRank.autoSize = TextFieldAutoSize.LEFT;
			$con.totalRank.txt.x = $con.totalRank.totalRank.x + $con.totalRank.totalRank.width;
			
			if($con.totalUserBar.height / $barHeight < 0.5) return;
			$con.totalRank.y = 1100 - int(100 * ($con.totalUserBar.height / $barHeight) - 80);
		}
		/**	스토어 나이 랭킹 & 그래프	*/
		private function storeAgeRankingUpdate():void
		{
			$con.ageRank.ageRank.text = Math.ceil($model.ageStoreRank * $con.ageBar.scaleY);
			$con.ageRank.ageRank.autoSize = TextFieldAutoSize.LEFT;
			$con.ageRank.txt.x = $con.ageRank.ageRank.x + $con.ageRank.ageRank.width;
			
			if($con.ageUserBar.height / $barHeight < 0.5) return;
			$con.ageRank.y = 1100 - int(100 * ($con.ageUserBar.height / $barHeight) - 80);
		}
	}
}