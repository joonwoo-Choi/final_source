package com.proof.microsite.rank
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.CurrencyFormat;
	import com.adqua.util.StringUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	import com.proof.event.ModelEvent;
	import com.proof.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	public class Data_Yes
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $client:String;
		
		private var $userInfo:XML;
		
		private var $name:String;
		private var $realAge:String;
		private var $cellular:String;
		private var $score:int;
		private var $age:int;
		private var $totalScore:int;
		private var $totalAge:int;
		private var $storeScore:int;
		private var $storeAge:int;
		private var $toalCnt:int;
		private var $storeCnt:int;
		private var $totalRank:int;
		private var $storeRank:int;
		/**	텍스트 콤마 생성	*/
		private var $currencyTxt:CurrencyFormat;
		/**	탭 버튼	*/
		private var $btnArr:Array;
		/**	처음 체크	*/
		private var $firstCheck:Boolean = true;
		
		public function Data_Yes(con:MovieClip, client:String)
		{
			$con = con;
			
			$client = client;
			
			$model = Model.getInstance();
			
			$currencyTxt = new CurrencyFormat();
			
			$con.totalWin.scaleY = 0;
			$con.storeWin.scaleY = 0;
			$con.totalGraph.scaleY = 0;
			$con.storeGraph.scaleY = 0;
			
			userDataLoad();
		}
		/**	유저 정보 가져오기	*/
		private function userDataLoad():void
		{
			var vari:URLVariables = new URLVariables();
			vari.rand = Math.round(Math.random()*10000);
			vari.client = $client;
			
			var req:URLRequest = new URLRequest($model.magicRingPath );
			req.data = vari;
			req.method =URLRequestMethod.POST;
			
			var ldr:URLLoader = new URLLoader();
			ldr.load(req);
			ldr.addEventListener(Event.COMPLETE, resultLoadComplete);
		}
		/**	유저 정보 받기	*/
		private function resultLoadComplete(e:Event):void
		{
			$userInfo = new XML(e.target.data);
			trace($userInfo);
			
			$name = $userInfo.MagicRingData.Name;
			$realAge = $userInfo.MagicRingData.RealAge;
			$cellular = $userInfo.MagicRingData.Cellular;
			$score = $userInfo.MagicRingData.SkinScore;
			$age = $userInfo.MagicRingData.SkinAge;
			
			totalSetting();
			result($userInfo.Result);
		}
		/**	결과, 진행 여부 	*/
		private function result(result:String):void
		{
			if(result == "" || result == "NONE")
			{
				$model.dispatchEvent(new ModelEvent(ModelEvent.DATA_NO));
				trace("데이터 없음");
			}
			else
			{
				userInfoSetting();
				TweenLite.to($con, 1, {alpha:1, ease:Cubic.easeOut});
				trace("데이터 있음");
			}
		}
		/**	전국 값 셋팅	*/
		private function totalSetting():void
		{
			$toalCnt = $userInfo.MagicRingData.Rank.TotalCount;
			$totalRank = $userInfo.MagicRingData.Rank.TotalRank;
			$storeCnt = $userInfo.MagicRingData.AgeRank.AgeTotalCount;
			$storeRank = $userInfo.MagicRingData.AgeRank.AgeTotalRank;
			
			$totalScore = $userInfo.MagicRingData.Rank.TotalTopSkinScore;
			$totalAge = $userInfo.MagicRingData.Rank.TotalTopSkinAge;
			$storeScore = $userInfo.MagicRingData.AgeRank.AgeTotalTopSkinScore;
			$storeAge = $userInfo.MagicRingData.AgeRank.AgeTotalTopSkinAge;
			
			valueSetting();
		}
		/**	피테라 하우스 값 셋팅	*/
		private function houseSetting():void
		{
			$toalCnt = $userInfo.MagicRingData.Rank.StoreCount;
			$totalRank = $userInfo.MagicRingData.Rank.StoreRank;
			$storeCnt = $userInfo.MagicRingData.AgeRank.AgeStoreCount;
			$storeRank = $userInfo.MagicRingData.AgeRank.AgeStoreRank;
			
			$totalScore = $userInfo.MagicRingData.Rank.StoreTopSkinScore;
			$totalAge = $userInfo.MagicRingData.Rank.StoreTopSkinAge;
			$storeScore = $userInfo.MagicRingData.AgeRank.AgeStoreTopSkinScore;
			$storeAge = $userInfo.MagicRingData.AgeRank.AgeStoreTopSkinAge;
			
			valueSetting();
		}
		/**	전국 or 피테라 하우스 값 셋팅	*/
		private function valueSetting():void
		{
			/**	피부 점수 & 나이 셋팅	*/
			$con.skinPoint1.text = $totalScore + "%";
			$con.skinPoint2.text = $storeScore + "%";
			$con.skinAge1.text = + $totalAge + "세";
			$con.skinAge2.text = $storeAge + "세";
			$con.skinPoint1.autoSize = TextFieldAutoSize.LEFT;
			$con.skinPoint2.autoSize = TextFieldAutoSize.LEFT;
			$con.skinAge1.autoSize = TextFieldAutoSize.LEFT;
			$con.skinAge2.autoSize = TextFieldAutoSize.LEFT;
			
			/**	참여자 수	셋팅	*/
			for (var j:int = 0; j < 2; j++) 
			{
				var count:MovieClip = $con.getChildByName("countCon" + j) as MovieClip;
				if(j == 0) count.count.text = $currencyTxt.makeCurrency(String($toalCnt), 3);
				else count.count.text = $currencyTxt.makeCurrency(String($storeCnt), 3);
				count.count.autoSize = TextFieldAutoSize.LEFT;
				count.joinTxt.x = int(count.count.x + count.count.width - 2);
				var box:MovieClip = $con.getChildByName("box" + j) as MovieClip;
				count.x = int(box.x + (box.width/2 - count.width/2));
			}
			
			$con.totalRank.rank.text = $totalRank;
			$con.totalRank.rank.autoSize = TextFieldAutoSize.LEFT;
			$con.totalRank.txt.x = int($con.totalRank.rank.x + $con.totalRank.rank.width);
			$con.storeRank.rank.text = $storeRank;
			$con.storeRank.rank.autoSize = TextFieldAutoSize.LEFT;
			$con.storeRank.txt.x = int($con.storeRank.rank.x + $con.storeRank.rank.width);
			
			showResult();
		}
		
		/**	값 셋팅	*/
		private function userInfoSetting():void
		{
			for (var i:int = 0; i < 3; i++) 
			{
				/**	이름 셋팅	*/
				var name:TextField = $con.getChildByName("name" + i) as TextField;
				name.text = $name + "님";
				var tf:TextFormat = new TextFormat(null, null, null, true);
				if(i == 0) 
				{
					name.text = name.text + "( " + $cellular + " )"
					name.setTextFormat(tf);
					name.autoSize = TextFieldAutoSize.LEFT;
					name.x = int($con.stage.stageWidth/2 - (name.width + $con.name_txt.width)/2); 
					$con.name_txt.x = int(name.x + name.width);
				}
				else name.autoSize = TextFieldAutoSize.CENTER;
			}
			
			for (var k:int = 0; k < 2; k++) 
			{
				var circle:MovieClip = $con.getChildByName("circle" + k) as MovieClip;
				circle.scaleX = circle.scaleY = 0;
				TweenLite.to(circle, 1, {scaleX:1, scaleY:1, ease:Expo.easeOut});
			}
			
			/**	평균 값	*/
			$con.avgScore.text = $userInfo.MagicRingData.AgeAvg.AvgSkinScore + "%";
			$con.avgAge.text = $userInfo.MagicRingData.AgeAvg.AvgSkinAge + "세";
			$con.avgTxt.text = $name + "님과 같은 " + $realAge + "세의 평균 피부 상태입니다."
			$con.avgTxt.autoSize = TextFieldAutoSize.CENTER;
			$con.avgScore.setTextFormat(tf);
			$con.avgAge.setTextFormat(tf);
			$con.avgTxt.setTextFormat(tf);
			
			$btnArr = [];
			/**	탭버튼 만들기	*/
			for (var j:int = 0; j < 2; j++) 
			{
				var btns:MovieClip = $con.getChildByName("btnTap" + j) as MovieClip;
				$btnArr.push(btns);
				btns.no = j;
				btns.buttonMode = true;
				btns.addEventListener(MouseEvent.CLICK, graphChange);
			}
			showMySkinScoreAndAge();
//			setTimeout(showResult, 500);
		}
		
		private function showMySkinScoreAndAge():void
		{
			var mc:MovieClip = new MovieClip();
			mc.x = 0;
			TweenLite.to(mc, 3, {x:100, onUpdate:myScoreUpdate, onUpdateParams:[mc], ease:Quad.easeOut});
		}
		
		private function myScoreUpdate(mc:MovieClip):void
		{
			var num:Number = mc.x;
			
			$con.skinPoint0.text = int($score * (num / 100));
			$con.skinAge0.text = int($age * (num / 100));
			$con.skinPoint0.autoSize = TextFieldAutoSize.CENTER;
			$con.skinAge0.autoSize = TextFieldAutoSize.CENTER;
			$con.skinScoreTxt.x = int($con.skinPoint0.x + $con.skinPoint0.width);
			$con.skinAgeTxt.x = int($con.skinAge0.x + $con.skinAge0.width);
		}
		
		private function graphChange(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			$con.totalRank.y = 373;
			$con.storeRank.y = 373;
				
			for (var i:int = 0; i < 2; i++) 
			{
				if(target.no == i) TweenLite.to($btnArr[i].over, 0.5, {alpha:1});
				else TweenLite.to($btnArr[i].over, 0.5, {alpha:0});
			}
			
			switch (target.no)
			{
				case 0 : totalSetting();	break;
				case 1:	houseSetting(); break;
			}
		}
		
		private function showResult():void
		{
			var mc:MovieClip = new MovieClip();
			mc.x = 0;
			TweenLite.to(mc, 3, {x:100, onUpdate:scoreUpdate, onUpdateParams:[mc], ease:Quad.easeOut});
		}
		/**	점수 & 나이 & 그래프 트윈	*/
		private function scoreUpdate(mc:MovieClip):void
		{
			var num:Number = mc.x;
			
			var totalBarScaleY:Number =1 -  (($totalRank / $toalCnt) - (1 / $toalCnt));
			var ageBarScaleY:Number = 1 - (($storeRank / $storeCnt) - (1 / $storeCnt));
			/**	참가자가 혼자일 떄	*/
			if($toalCnt == 1) totalBarScaleY = 1;
			if($storeCnt == 1) ageBarScaleY = 1;
			/**	그래프 최저 높이	*/
			if(totalBarScaleY <= 0.05) totalBarScaleY = 0.05;
			if(ageBarScaleY <= 0.05) ageBarScaleY = 0.05;
			
			$con.totalWin.scaleY = (num / 100);
			$con.storeWin.scaleY = (num / 100);
			$con.totalGraph.scaleY = (num / 100) * totalBarScaleY;
			$con.storeGraph.scaleY = (num / 100) * ageBarScaleY;
			
			$con.totalRank.rank.text = int($totalRank * (num / 100));
			$con.storeRank.rank.text = int($storeRank * (num / 100));
			$con.totalRank.rank.autoSize = TextFieldAutoSize.LEFT;
			$con.storeRank.rank.autoSize = TextFieldAutoSize.LEFT;
			$con.totalRank.txt.x = int($con.totalRank.rank.x + $con.totalRank.rank.width);
			$con.storeRank.txt.x = int($con.storeRank.rank.x + $con.storeRank.rank.width);
			
//			$con.totalRank.x =$con.totalGraph.x + $con.totalGraph.width/2 - $con.totalRank.width/2;
//			$con.storeRank.x = $con.storeGraph.x + $con.storeGraph.width/2 - $con.storeRank.width/2;
			
			if($con.totalGraph.height > 30) $con.totalRank.y = int($con.totalGraph.y - $con.totalGraph.height - $con.totalRank.height);
			if($con.storeGraph.height > 30) $con.storeRank.y = int($con.storeGraph.y - $con.storeGraph.height - $con.storeRank.height);
		}
	}
}