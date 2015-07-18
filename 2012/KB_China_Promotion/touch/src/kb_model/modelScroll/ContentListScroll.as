package kb_model.modelScroll
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.kb_china.utils.MotionController;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class ContentListScroll extends Sprite
	{
		
		private var $con:MovieClip;
		/**	모델*/
		private var $model:Model;
		/**	모션 컨트롤	*/
		private var $moController:MotionController;
		/**	전체 리스트 배열	*/
		private var $allList:Array = [];
		/**	이승기 리스트 배열	*/
		private var $maleList:Array = [];
		/**	김연아 리스트 배열	*/
		private var $femaleList:Array = [];
		/**	전체 리스트 수	*/
		private var $allListLength:int;
		/**	이승기 리스트 수	*/
		private var $maleListLength:int;
		/**	김연아 리스트 수	*/
		private var $femaleListLength:int;
		/**	현재 리스트 번호	*/
		private var $listNum:int;
		/**	이전 리스트 번호	*/
		private var $prevNum:int;
		/**	다음 리스트 번호	*/
		private var $nextNum:int;
		/**	전체 리스트 마지막 번호	*/
		private var $allListMaxNum:int;
		/**	현재 리스트 마지막 번호	*/
		private var $currentListMaxNum:int;
		/**	현재 늘어 놓은 리스트	*/
		private var $currentList:Array = [];
		/**	현재 리스트 수	*/
		private var $currentListLength:int;
		/**	리스트 이동 좌표	*/
		private var $pos:Array;
		
		/**	y축 기본 값	*/
		private var $pointY:Number;
		/**	y축 이동 값	*/
		private var $moveY:Number;
		/**	다운 시 기준 Y값	*/
		private var $pageY:Number;
		/**	이동 할 방향	*/
		private var $direction:String;
		
		public function ContentListScroll(con:MovieClip)
		{
			$con = con;
			TweenPlugin.activate([AutoAlphaPlugin]);
			setting();
		}
		
		public function setting():void
		{
			$pos = [$con.pos0, $con.pos1, $con.pos2];
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.LIST_CHANGE, listChangeHandler);
			$model.addEventListener(ModelEvent.LIST_ALPHA_1, listAlpha1);
			
			xmlLoad();
			addEventListener(Event.REMOVED,onRemoved);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);			
		}
		
		protected function listAlpha1(event:Event):void
		{
			TweenLite.to($con,.5,{alpha:1});
		}
		
		protected function onRemoved(event:Event):void
		{
			$model.removeEventListener(ModelEvent.LIST_CHANGE, listChangeHandler);
			$model.removeEventListener(ModelEvent.LIST_ALPHA_1, listAlpha1);
			removeEventListener(Event.REMOVED,onRemoved);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
		}
		
		public function reset():void{
			$allList=[];
			$maleList=[];
			$femaleList=[];
			$currentList=[];
			$thumbLoadChk= 0
			$nextNum=0;
			$prevNum = 0;
			$listNum = 0;
			removeMC($con);
			onRemoved(null);			
		}
		
		private function removeMC($con:MovieClip):void
		{
			var num:int = $con.numChildren;
			for (var i:int = 0; i < num; i++) 
			{
				var mc:DisplayObject = $con.getChildAt(0);
				$con.removeChild(mc);
			}
		}
		
		protected function listChangeHandler(e:Event):void
		{
			switch ($model.listArrayNum)
			{
				case 0 : 
					$currentList = $femaleList;
					$listNum=0;
					trace("$femaleList: ",$femaleList);
					break;
				case 1 :
					$currentList = $maleList;
					$listNum=0;
					trace("$maleList: ",$maleList);
					break;
			}
			
			for (var i:int = 0; i < $allListLength; i++) 
			{
				TweenLite.to($allList[i], 0.5, {alpha:0, ease:Cubic.easeOut, onComplete:viewList});
			}
			$currentListLength = $currentList.length;
			$currentListMaxNum = $currentListLength - 1;
			
			trace($model.listArrayNum, $currentList, $currentListLength, $currentListMaxNum);
		}
		
		private var $resetCheckCnt:int = 0;
		private function viewList():void
		{
			for (var i:int = 0; i < $allListLength; i++) 
			{	
				$allList[i].y = $con.stage.stageHeight + $allList[i].height;
				$allList[i].x = $con.stage.stageWidth*Math.random();
			}
			$resetCheckCnt++;
			if($resetCheckCnt==$allListLength){
				listnumChange(0);
				$resetCheckCnt = 0;
			}
		}
		
		private function xmlLoad():void
		{
			var data:URLVariables = new URLVariables();
			data.rand = Math.random() * 10000;
			
			var xmlLdr:URLLoader = new URLLoader();
			xmlLdr.data = data;
			xmlLdr.load(new URLRequest($model.defaultURL + "xml/modelContentList.xml"));
			xmlLdr.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
		}
		
		protected function xmlLoadCompleteHandler(e:Event):void
		{
			$model.ModelXml = new XML(e.target.data);
			
			$model.dispatchEvent(new ModelEvent(ModelEvent.MODEL_LIST_LOADED));
			trace($model.ModelXml);
			
			$allListLength = $model.ModelXml.list.length();
			$allListMaxNum = $allListLength - 1; 
			
			/**	컨텐츠 이미지 로드	*/
			for (var i:int = 0; i < $allListLength; i++) 
			{
				
				var container:MovieClip = new MovieClip;
				container.alpha = 0;
				
				if($model.ModelXml.list[i].@type == "common")
				{
					$con.addChild(container);
					$moController = new MotionController(container);
					container.img1 = new Loader;
					container.img1.y= -150
					container.img1.x = -200;
					Loader(container.img1).alpha = 0;
					Loader(container.img1).load(new URLRequest($model.ModelXml.list[i].@thumb1));
					Loader(container.img1).contentLoaderInfo.addEventListener(Event.COMPLETE,imgLoaded);
					container.addChild(container.img1);
					container.img2 = new Loader;
					container.img2.x= -200
					container.img2.y = -200;
					Loader(container.img2).alpha = 0;
					Loader(container.img2).load(new URLRequest($model.ModelXml.list[i].@thumb2));
					Loader(container.img2).contentLoaderInfo.addEventListener(Event.COMPLETE,imgLoaded);
					container.addChild(container.img2);
					$moController.load($model.defaultURL +  $model.ModelXml.list[i].@thumb, true);
					container.no = i;
					
					/**	전체 배열에 넣기	*/
					$allList.push(container);
				}
				else if($model.ModelXml.list[i].@type == "male")
				{
					loadThumb(container,i);
					
					container.no = i;
					$con.addChild(container);
					
					/**	전체 배열에 넣기	*/
					$allList.push(container);
					/**	이승기 배열에 넣기	*/
					$maleList.push(container);
					/**	이승기 배열 전체 수	*/
					$maleListLength++;
				}
				else if($model.ModelXml.list[i].@type == "female")
				{
					loadThumb(container,i);
					container.no = i;
					$con.addChild(container);
					
					/**	전체 배열에 넣기	*/
					$allList.push(container);
					/**	김연아 배열에 넣기	*/
					$femaleList.push(container);
					/**	김연아 배열 전체 수	*/
					$femaleListLength++;
				}
				/**	팝업 버튼	*/
				container.addEventListener(MouseEvent.CLICK, popupContents);
				container.buttonMode = true;
			}
			/**	페이지 드래그	*/
			$con.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		protected function imgLoaded(event:Event):void
		{
			var imgLoader:LoaderInfo = event.target as LoaderInfo;
			Bitmap(imgLoader.loader.content).smoothing = true;			
		}
		
		private function loadThumb(container:MovieClip,i:int):void
		{
			for (var j:int = 0; j < 3; j++) 
			{
				var ldr:Loader = new Loader();
				var url:String = $model.defaultURL + $model.ModelXml.list[i].@["thumb"+j];
				ldr.load(new URLRequest(url));
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoadComplete);
				container.addChild(ldr);
				ldr.visible = false;
				ldr.alpha = 0;
				container["img"+j] = ldr;
			}			
		}
		
		protected function popupContents(e:MouseEvent):void
		{
			$con.alpha = .3;
			var container:MovieClip = e.currentTarget as MovieClip;
			$con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			$model.popupNum = container.no;
			$model.dispatchEvent(new ModelEvent(ModelEvent.MODEL_POPUP));
		}
		
		
		///////////////////////////////////////////
		
		
		private var $thumbLoadChk:int = 0;
		private function contentLoadComplete(e:Event):void
		{
			/**	배열의 좌표 중앙으로 정렬  	*/
			var movContent:Object = $allList[0].getChildAt(0) as Object;
//			if( $allList[0].numChildren > 1) $allList[0].removeChildAt(1) as Object;
			movContent.x = -movContent.width / 3;
			movContent.y = -movContent.height / 2+50;
			
			e.target.content.smoothing = true;
			e.target.content.x = -e.target.content.width/2;
			e.target.content.y = -e.target.content.height/2;
			
			/**	현재 선택 된 배열과 배열 수	*/
			$currentList = $allList;
			$currentListLength = $allListLength;
			$currentListMaxNum = $currentListLength - 1;
			
			/**	이동전 시작 좌표	*/
			for (var i:int = 0; i < $currentListLength; i++) 
			{
				$currentList[i].x = $con.stage.stageWidth * Math.random();
				$currentList[i].y = -$currentList.height;
			}
			
			/**	최초 실행	*/
			$thumbLoadChk++;
			trace("$thumbLoadChk: ",$thumbLoadChk);
			if($thumbLoadChk==int($model.ModelXml.list.length()-1)*3){
				listnumChange(0);
				$thumbLoadChk = 0;
			}
		}
		private function mouseDownHandler(e:MouseEvent):void
		{
			
			$con.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			/**	마우스 다운 시 기준 포인트 	*/
			$pointY = $con.stage.mouseY;
			/**	마우스 다운 시 기준 이미지 포인트	*/
			trace("$listNum: ",$listNum);
			$pageY = $currentList[$listNum].y;
		}
		
		/**	마우스 이동 값 계산	*/
		private function mouseMoveHandler(e:MouseEvent):void
		{
			$con.stage.addEventListener(MouseEvent.MOUSE_UP, removeDragHandler);
			/**	이동 할 거리 계산	*/
			$moveY = ($con.stage.mouseY - $pointY);
			/**	현재 Y값에 이동거리 합산	*/
			var imgMoveNum:Number = $pageY + $moveY;
			
			TweenLite.to($currentList[$listNum], 0.5, {y:imgMoveNum, ease:Cubic.easeOut});
		}
		
		private function removeDragHandler(e:MouseEvent):void
		{
			$con.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			$con.stage.removeEventListener(MouseEvent.MOUSE_UP, removeDragHandler);
			
			directionChange($moveY);
		}
		/**	리스트 이동 방향 설정	*/
		private function directionChange(moveY:Number):void
		{
			if(moveY >=10 )
			{
				for (var i:int = 0; i < $allListLength; i++) 
				{
					$allList[i].removeEventListener(MouseEvent.CLICK, popupContents);
				}
				$direction = "down";
				$listNum --;
			}
			else if(moveY <= -10)
			{
				for (i = 0; i < $allListLength; i++) 
				{
					$allList[i].removeEventListener(MouseEvent.CLICK, popupContents);
				}
				$direction = "up";
				$listNum ++;
			}
			listnumChange($listNum);
		}
		/**	현재 리스트 번호 설정	*/
		private function listnumChange(num:int):void
		{
			/**	현재 리스트 번호 순환	*/
			if(num < 0)
			{
				$listNum = $currentListMaxNum;
			}
			else if(num > $currentListMaxNum)
			{
				$listNum = 0;
			}
			
			/**	다음 리스트 번호 순환	*/
			$nextNum = $listNum + 1;
			if($nextNum < 0)
			{
				$nextNum = $currentListMaxNum;
			}
			else if($nextNum > $currentListMaxNum)
			{
				$nextNum = 0;
			}
			
			/**	이전 리스트 번호 순환	*/
			$prevNum = $listNum - 1;
			if($prevNum < 0)
			{
				$prevNum = $currentListMaxNum;
			}
			else if($prevNum > $currentListMaxNum)
			{
				$prevNum = 0;
			}
			
			listLocationChange($listNum, $nextNum, $prevNum);
		}
		
		private function listLocationChange(listNum:int, nextNum:int, prevNum:int):void
		{
			// 						썸네일 전체 배열개수
			for (var i:int = 0; i < $currentListLength; i++) 
			{
				if(i == listNum)
				{
					tweenChk($currentList[listNum]);
					targetSet($currentList[listNum],$pos[1].x,$pos[1].y,-10,1);
					TweenMax.to($currentList[listNum], 1, {
						x:$currentList[listNum].tx, 
						y:$currentList[listNum].ty, 
						rotation:$currentList[listNum].tr, 
						alpha:$currentList[listNum].ta, 
						onStart:showActiveThumb,
						onStartParams:[0,$currentList[listNum]],
						ease:Cubic.easeOut});
					trace($currentList[0].img1);
				}
				else if(i == nextNum)//아래
				{
					tweenChk($currentList[nextNum]);
					if($direction == "up") 
					{
						$currentList[i].x = $con.stage.stageWidth * Math.random();
						$currentList[i].y = $con.stage.stageHeight + $currentList[i].height;
					}
					targetSet($currentList[nextNum],$pos[2].x,$pos[2].y,8,1);
					TweenMax.to($currentList[nextNum], 1, {
						x:$currentList[nextNum].tx, 
						y:$currentList[nextNum].ty, 
						rotation:$currentList[nextNum].tr, 
						alpha:$currentList[nextNum].ta, 
						onStart:showActiveThumb,
						onStartParams:[1,$currentList[nextNum]],
						ease:Cubic.easeOut});
				}
				else if(i == prevNum)
				{
					tweenChk($currentList[prevNum]);
					if($direction == "down") 
					{
						$currentList[i].x = $con.stage.stageWidth * Math.random();
						$currentList[i].y = -$currentList[i].height;
					}
					targetSet($currentList[prevNum],$pos[0].x,$pos[0].y,8,1);
					TweenMax.to($currentList[prevNum], 1, {
						x:$currentList[prevNum].tx, 
						y:$currentList[prevNum].ty, 
						rotation:$currentList[prevNum].tr, 
						alpha:$currentList[prevNum].ta, 
						onStart:showActiveThumb,
						onStartParams:[2,$currentList[prevNum]],
						ease:Cubic.easeOut});
				}
				else
				{
					tweenChk($currentList[i]);
					if($direction == "up")
					{
						/**	위로	*/
						targetSet($currentList[i],$con.stage.stageWidth * Math.random(),- $currentList[i].height,0,0);
						TweenMax.to($currentList[i], 1, {
							x:$currentList[i].tx, 
							y:$currentList[i].ty, 
							rotation:$currentList[i].tr, 
							alpha:$currentList[i].ta, 
							onStart:showActiveThumb,
							onStartParams:[1,$currentList[i]],
							ease:Cubic.easeOut});
					}
					else
					{
						/**	아래로	*/
						targetSet($currentList[i],$con.stage.stageWidth * Math.random(),$con.stage.stageHeight + $currentList[i].height,0,0);
						TweenMax.to($currentList[i], 1, {
							x:$currentList[i].tx, 
							y:$currentList[i].ty, 
							rotation:$currentList[i].tr, 
							alpha:$currentList[i].ta, 
							onStart:showActiveThumb,
							onStartParams:[2,$currentList[i]],
							ease:Cubic.easeOut});
					}
				}
			}
		}
		
		private function showActiveThumb(param0:int,mc:MovieClip):void
		{
			for (var j:int = 0; j < $allListLength; j++) 
			{
				$allList[j].addEventListener(MouseEvent.CLICK, popupContents);
			}
			for (var i:int = 0; i < 3; i++) 
			{
				if(i==param0){
					if(mc["img"+i])TweenLite.to(mc["img"+i],.5,{autoAlpha:1});
				}else{
					if(mc["img"+i])TweenLite.to(mc["img"+i],.5,{autoAlpha:0});
				}
			}
			
		}
		private function targetSet(mc:MovieClip,tx:int,ty:int,tr:Number,ta:Number):void
		{
			mc.tx = tx;
			mc.ty = ty;
			mc.tr = tr;
			mc.ta = ta;
		}
		private function tweenChk(mc:MovieClip):void
		{
			if(TweenMax.isTweening(mc)){
				trace("XXXXXXXXXXXXXXXXXXXXXXXXXX");
				TweenMax.killTweensOf(mc);
				mc.x = mc.tx;
				mc.y = mc.ty;
				mc.rotation = mc.tr;
				mc.alpha = mc.ta;
			}				
		}
	}
}