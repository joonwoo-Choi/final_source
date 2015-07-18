package com.proof.kiosk.pageOne
{
	import com.adqua.util.CurrencyFormat;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
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
		
		public function Rank(con:MovieClip)
		{
			$con = con;
			
			$model =Model.getInstance();
			$model.addEventListener(ModelEvent.KIOSK_PAGE_ONE, pageSetting);
			
			$currencyTxt = new CurrencyFormat();
		}
		
		private  function pageSetting(e:Event):void
		{
			/**	랭킹 텍스트 드랍쉐도우 적용	*/
			$con.totalRank.filters = [$dsFilter];
			$con.storeRank.filters = [$dsFilter];
			
			/**	유저 이름 셋팅	*/
			$con.userName1.text = $model.userName + "님";
			$con.userName2.text = $model.userName + "님";
			$con.userName1.autoSize = TextFieldAutoSize.CENTER;
			$con.userName2.autoSize = TextFieldAutoSize.CENTER;
			
			/**	피부 점수 & 나이 셋팅	*/
			var txt:String = $currencyTxt.makeCurrency(String($model.totalNum), 3);
			$con.totalNum.text = txt;
			txt = $currencyTxt.makeCurrency(String($model.storeNum), 3);
			$con.storeNum.text = txt
			$con.totalNum.autoSize = TextFieldAutoSize.LEFT;
			$con.storeNum.autoSize = TextFieldAutoSize.LEFT;
			$con.joinTxt0.x = int($con.totalNum.x + $con.totalNum.width - 1);
			$con.joinTxt1.x = int($con.storeNum.x + $con.storeNum.width - 2);
			
			/**	전국 & 매장 1위 피부 나이 & 스코어	*/
			$con.totalScore.text = $model.totalWinSkinScore;
			$con.totalAge.text = $model.totalWinSkinAge;
			$con.storeScore.text = $model.agesWinSkinScore;
			$con.storeAge.text = $model.agesWinSkinAge;
			$con.totalScore.autoSize = TextFieldAutoSize.LEFT;
			$con.totalAge.autoSize = TextFieldAutoSize.LEFT;
			$con.storeScore.autoSize = TextFieldAutoSize.LEFT;
			$con.storeAge.autoSize = TextFieldAutoSize.LEFT;
			$con.per0.x = $con.totalScore.x + $con.totalScore.width - 2;
			$con.age0.x = $con.totalAge.x + $con.totalAge.width - 2;
			$con.per1.x = $con.storeScore.x + $con.storeScore.width - 2;
			$con.age1.x = $con.storeAge.x + $con.storeAge.width - 2;
			
			/**	순위 리셋	*/
			$con.totalRank.totalRank.text = "";
			$con.storeRank.storeRank.text = "";
			
			/**	랭킹 셋팅	*/
			$con.totalBar.scaleY = 0;
			$con.totalUserBar.scaleY = 0;
			$con.storeBar.height = 0;
			$con.storeUserBar.height = 0;
			
			/**	전국 & 매장 랭킹 리셋	*/
			$con.totalRank.totalRank.text = Math.ceil($model.totalRank * $con.storeBar.scaleY);
			$con.totalRank.totalRank.autoSize = TextFieldAutoSize.LEFT;
			$con.totalRank.txt.x = $con.totalRank.totalRank.x + $con.totalRank.totalRank.width;
			$con.storeRank.storeRank.text = Math.ceil($model.storeRank * $con.storeBar.scaleY);
			$con.storeRank.storeRank.autoSize = TextFieldAutoSize.LEFT;
			$con.storeRank.txt.x = $con.storeRank.storeRank.x + $con.storeRank.storeRank.width;
			
			setTimeout(showResult, 500);
		}
		
		private function showResult():void
		{
			/**	중앙 랭킹	*/
			TweenLite.to($con.totalBar, 3, {scaleY:1, ease:Cubic.easeOut, onUpdate:totalRankingUpdate});
			TweenLite.to($con.storeBar, 3, {scaleY:1, ease:Cubic.easeOut, onUpdate:storeRankingUpdate});
			TweenLite.to($con.totalUserBar, 3, {
				height:$barHeight - Math.ceil($barHeight * ($model.totalRank / $model.totalNum)),
				ease:Cubic.easeOut});
			TweenLite.to($con.storeUserBar, 3, {
				height:$barHeight - Math.ceil($barHeight * ($model.storeRank / $model.storeNum)),
				ease:Cubic.easeOut});
		}
		/**	전국 랭킹 & 그래프	*/
		private function totalRankingUpdate():void
		{
			$con.totalRank.totalRank.text = Math.ceil($model.totalRank * $con.storeBar.scaleY);
			$con.totalRank.totalRank.autoSize = TextFieldAutoSize.LEFT;
			$con.totalRank.txt.x = $con.totalRank.totalRank.x + $con.totalRank.totalRank.width;
			
			if($con.totalUserBar.height / $barHeight < 0.5) return;
			$con.totalRank.y = 1100 - int(100 * ($con.totalUserBar.height / $barHeight) - 50);
		}
		/**	매장 랭킹 & 그래프	*/
		private function storeRankingUpdate():void
		{
			$con.storeRank.storeRank.text = Math.ceil($model.storeRank * $con.storeBar.scaleY);
			$con.storeRank.storeRank.autoSize = TextFieldAutoSize.LEFT;
			$con.storeRank.txt.x = $con.storeRank.storeRank.x + $con.storeRank.storeRank.width;
			
			if($con.storeUserBar.height / $barHeight < 0.5) return;
			$con.storeRank.y = 1100 - int(100 * ($con.storeUserBar.height / $barHeight) - 50);
		}
	}
}