package contents.guerilla
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.display.Remove;
	import com.sw.net.FncOut;
	import com.sw.net.list.BaseList;
	import com.sw.net.list.Page;
	import com.sw.utils.McData;
	import com.sw.utils.SetText;
	
	import flash.display.MovieClip;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**		
	 * SK2_Hersheys :: 다이어트 게릴라 이벤트 리스트
	 */
	public class GuerillaSeason4List extends BaseList
	{
		/**	리스트 각각 클래스	*/
		private var listClass:Class;
		/**	리스트 그래픽	*/
		private var mcList:MovieClip;
		
		/**	생성자
		 * @param $scope :: 그래픽
		 * @param $listClass :: 리스트 클래스
		 * @param $numClass  :: 페이지 버튼 클래스
		 */
		public function GuerillaSeason4List($scope:Object,$listClass:Class,$numClass:Class)
		{
			var url:String = Global.getIns().dataURL+"/Process/GetGuerillaEvent4PagingList.ashx";
			super($scope, url, {});
			init();
			
			pageSize = 8;
			listClass = $listClass;
			mcList = scope.mcList;
			McData.save(mcList);
			
			page = new Page(scope.mcPage,$numClass,{current:setCPageNum,click:onClickPage});
			load();
		}
		override protected function load($obj:Object=null, $method:String=""):void
		{
			super.load($obj,URLRequestMethod.GET);
		}
		/**	리스트 데이터 받아 옴	*/
		override protected function onNoneList():void
		{
			var xml:XML = getXML();
//			trace(xml);	
			pageNo = int(xml.pageNo.toString());
			pageCnt = int(xml.pageCount.toString());
			listTotal = int(xml.recordCount.toString());
			if(listTotal == 0)
			{
				FncOut.call("리스트가 없습니다.");
				return;
			}
			page.setPage(pageNo,pageCnt);
			
			var cnt:int = xml.dataList.EventInfo.length();
			
			TweenMax.killChildTweensOf(mcList);
			Remove.child(mcList);
			
			var i:int;
			var list:MovieClip;
			
			for(i = 0; i<cnt; i++)
			{
				var cXML:XML = xml.dataList.EventInfo[i];
				list = new listClass();
				list.name = "list"+i;
				list.alpha = 0;
				
				mcList.addChild(list);
				list.mcPaper.gotoAndStop(i+1)
					
				var align:int = 4;
				
				if(cnt == 4) align = 2;
				if(cnt == 5 || cnt == 6) align = 3;
				
				
				list.x = (Math.round(i%align)*188)+36;
				list.y = (Math.floor(i/align)*145)+8;
				
				McData.save(list);
				
				setComment(list.txtComment1,cXML.message.toString());
				setComment(list.txtComment2,cXML.message.toString());
				
				list.txtName1.text = cXML.name.toString();
				list.txtName2.text = list.txtName1.text+" 님의 다이어트 비법";
				
//				SetText.space(list.txtName1,{letter:-1});
//				SetText.space(list.txtName2,{letter:-1});
			}
			
			mcList.y = mcList.dy;
			mcList.x = 0;
			if(mcList.height < 250) mcList.y = mcList.dy+70;
			mcList.x = Math.round((830-mcList.width)/2)-40;
			
			//등장 모습
			for(i = 0; i<cnt; i++)
			{
				list = mcList.getChildByName("list"+i) as MovieClip;
				
				list.x -= 20;
				list.y -= 20;
				list.rotation = 10;
				
				TweenMax.to(list,0.8,{delay:i*0.1,rotation:0,ease:Expo.easeOut,overwrite:1});	
				TweenMax.to(list,0.7,{delay:i*0.1,x:list.dx,y:list.dy,alpha:1,ease:Expo.easeOut});	
			}
			
			//416
			//trace(xml);
			
			//#A43643
		}
		/**	리스트 본문 내용 적용	*/
		private function setComment(txt:TextField,str:String):void
		{
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.text = SetText.del(str);
			txt.y = Math.round((130-txt.height)/2);
			SetText.space(txt,{letter:-1});	
		}
		private function setCPageNum(mc:MovieClip):void
		{
			mc.txt.textColor = 0xA43643;
		}
		/**	페이지 이동 버튼	*/
		private function onClickPage(num:int):void
		{
			pageNo = num;
			load();
		}
		
	}//class
}//package