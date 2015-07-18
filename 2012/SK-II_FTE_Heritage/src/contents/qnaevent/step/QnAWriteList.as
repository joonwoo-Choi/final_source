package contents.qnaevent.step
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.sw.display.AlignBitmap;
	import com.sw.net.list.BaseList;
	import com.sw.utils.McData;
	import com.sw.utils.SetText;
	
	import contents.qnaevent.QnAGlobal;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	
	/**		
	 *	SK2_Hersheys :: Q&A 글등록 이벤트 리스트
	 */
	public class QnAWriteList extends BaseList
	{
		private var mcScope:MovieClip;
		
		private var xml:XML;
		/**	페이스북 썸네일	*/
		private var loader:ImageLoader;
		/**	리스트 위치	*/
		private var listPos:int;
		/**	리스트 반복 루프 딜레이 시간	*/
		private var delaySec:int;
		/**	리스트 반복 루프 내용	*/
		private var delay:TweenMax;
		
		
		/**	생성자	*/
		public function QnAWriteList($scope:Object)
		{
			var url:String = Global.getIns().dataURL+"/Process/QnA/GetQnaPagingList.ashx";
			var obj:Object = new Object();
			
			super($scope, url, obj);
			
			mcScope = $scope as MovieClip;
			
			init();
			
			pageNo = 1;
			pageSize = 10;
			delaySec = 5;
			
			load();
		}
		/**	초기화	*/
		override protected function init($bLoad:Boolean=true):void
		{
			super.init($bLoad);
			//초기화
			for(var i:int = 1; i<=2; i++)
			{
				var list:MovieClip = mcScope["mcList"+i] as MovieClip;
				list.txtName1.text = "";
				list.txtName2.text = "";
				list.txtComment.text = "";
				
				list.alpha = 0;
				
				McData.save(list);
			}
		}
		override protected function load($obj:Object=null, $method:String=""):void
		{
			if($obj == null) $obj = new Object();
			$obj.schString = QnAGlobal.getIns().qPos+"";
			super.load($obj,$method);
		}
		/**	xml 데이터 로드 완료	*/
		override protected function onNoneList():void
		{
			xml = getXML();
			
			//페이지 갯수
			pageCnt = int(xml.pageCount.toString());
			//리스트 갯수
			listTotal = int(xml.recordCount.toString());
			//페이지 위치
			pageNo = int(xml.pageNo.toString());
			
			listPos = 0;
			
			moveList();
			
		}
		/**	다음 페이지 이동	*/
		private function loadNextPage():void
		{
			pageNo++;
			if(pageNo > pageCnt) pageNo = 1;
			load();
		}
		/**	롤링 시작	*/
		private function setRoll():void
		{
			listPos++;
			if(delaySec == -1) return;
			delay = TweenMax.delayedCall(delaySec,moveList);
		}
		/**	다음 리스트로 이동	*/
		private function moveList():void
		{
			var cList:XML = xml.dataList.QnaEventData[listPos];
			if(cList == null)
			{
				loadNextPage();
				return;
			}
			var list1:MovieClip = mcScope.mcList1 as MovieClip;
			var thumb1:MovieClip = list1.mcThumb as MovieClip;
			var list2:MovieClip = mcScope.mcList2 as MovieClip;
			var thumb2:MovieClip = list2.mcThumb as MovieClip;
			
			list1.idx = list2.idx;
			list1.txtName1.text = list2.txtName1.text;
			list1.txtName2.text = list2.txtName2.text;
			list1.txtComment.text = list2.txtComment.text;
			
			if(thumb1.numChildren > 1)
				thumb1.removeChild(thumb1.getChildAt(1));
			if(thumb2.numChildren > 1)
				thumb1.addChild(thumb2.getChildAt(1));
			
			thumb2.alpha = 1;
			
			//			trace(cList.idx.toString());
			list2.idx = int(cList.idx.toString());
			list2.txtName1.text = cList.fbname.toString();
			list2.txtName2.text = cList.fbname.toString() + " 님";
			list2.txtName1.autoSize = TextFieldAutoSize.LEFT;
			list2.txtName2.autoSize = TextFieldAutoSize.LEFT;
			var comment:String = cList.message.toString();
			
			comment = SetText.del(comment);
			if(comment.length > 50) comment = comment.substr(0,50)+"...";
			list2.txtComment.text = comment;
			
			//			trace(list1.dy)
			TweenMax.to(list1,0,{y:list1.dy,alpha:1});
			TweenMax.to(list2,0,{y:list2.dy,alpha:1});
			TweenMax.to(list1,0.6,{y:list1.dy-list1.height,alpha:0,ease:Expo.easeOut});
			TweenMax.to(list2,0.6,{y:list1.dy,alpha:1,ease:Expo.easeOut});
			
			//썸네일 로드
			var file:String = cList.fbimg.toString();
			if(file == "" || file == null)
			{
				setRoll();
				return;
			}
			//로더 초기화
			if(loader != null) 
			{
				loader.dispose();
				loader.unload();
				loader = null;
			}
			var obj:Object = new Object();
			
			obj.onComplte = onLoadThumb;
			obj.onIOError = 
			obj.onError = 
			obj.onHTTPStatus =
			obj.onSecurityError = onErrorLoadThumb;
			
			loader = new ImageLoader(file,{onComplete:onLoadThumb});
			loader.load();
		}
		
		/**	썸네일 로드 완료	*/
		private function onLoadThumb(e:LoaderEvent):void
		{
			var thumb:MovieClip = mcScope.mcList2.mcThumb as MovieClip;
			var bit:Bitmap = loader.rawContent as Bitmap;
			if(bit == null) 
			{
				onErrorLoadThumb(null);
				return;
			}
			bit = AlignBitmap.go(bit,thumb.width,thumb.height);
			
			bit.alpha = 0;
			thumb.addChild(bit);
			TweenMax.to(bit,1,{alpha:1,onComplete:setRoll});
		}
		private function onErrorLoadThumb(e:LoaderEvent):void
		{
			TweenMax.delayedCall(1,setRoll);
		}
		override public function destroy():void
		{
			super.destroy();
			delaySec = -1;
			
			if(delay == null) return;
			delay.kill();
			delay = null;
	
		}
	}//class
}//package