package contents.qnaevent.step
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.net.list.Write;
	
	import contents.qnaevent.QnAGlobal;
	
	import event.UIEvent;
	
	import flash.display.MovieClip;
	
	import util.BtnHersheys;
	
	/**		
	 *  SK2_Hersheys :: Q&A 영상 하나 본후 결과 페이지
	 */
	public class QnAResult extends BaseQnAStep
	{
		/**	그래픽	*/
		private var container:QnAResultClip;
		
		/**	카운트 갯수 가져오기	*/
		private var count:Write;
		
		/**	생성자	*/
		public function QnAResult(mc:MovieClip=null)
		{
			var url:String = Global.getIns().dataURL+"/Process/QnA/GetQnaEventTotalCount.ashx";
			count = new Write(url,onLoad,{});
			container = new QnAResultClip();
			init();
			super(container);
			
			count.send({});
			
			//잠깐 우측 영상 리스트 텝 보여지기
			TweenMax.delayedCall(2,viewMovieList);
			TweenMax.delayedCall(3,hideMovieList);
		}
		private function viewMovieList():void
		{
			Global.getIns().dispatchEvent(new UIEvent(UIEvent.TAB_VIEW));
		}
		/**	우측 영상 리스트 안보이기	*/
		private function hideMovieList():void
		{	
			Global.getIns().dispatchEvent(new UIEvent(UIEvent.TAB_HIDE));
		}
		/**	초기화	*/
		private function init():void
		{
			var completeAry:Array = QnAGlobal.getIns().getComplete();
			var viewCnt:int = 0;
			for(var i:int = 1; i<=5; i++)
			{
				var btn:MovieClip = container["btn"+i] as MovieClip;
				btn.idx = i;
				btn.mcImg.gotoAndStop(i);
				btn.mcMask.y = 0;
				
				if(completeAry[i] == true)
				{
					btn.bPlay = true;
					btn.mcMask.y = btn.mcImg.height;
					viewCnt++;
				}
				Button.setUI(btn,{over:onOver,out:onOut,click:onClick});
			}
			container.txt.text = viewCnt+"";
			BtnHersheys.getIns().go(container.btnComplete,onClickComplete);
		}
		/**	버튼 오버	*/
		private function onOver(mc:MovieClip):void
		{
			if(mc.bPlay == true) return;
			TweenMax.to(mc.mcMask,0.5,{y:mc.mcImg.height,ease:Expo.easeOut});	
		}
		/**	버튼 아웃	*/
		private function onOut(mc:MovieClip):void
		{
			if(mc.bPlay == true) return;
			TweenMax.to(mc.mcMask,0.5,{y:0,ease:Expo.easeOut});
		}
		/**	버튼 클릭 */
		private function onClick(mc:MovieClip):void
		{
			QnAGlobal.getIns().qPos = mc.idx;
			QnAGlobal.getIns().moveStep(2);
		}
		/**	영상 당 이벤트 참여 데이터 결과		*/
		private function onLoad(result:String):void
		{
			var xml:XML = new XML(count.getData());
			
			for(var i:int =0; i<5; i++)
			{
				var btn:MovieClip = container["btn"+(i+1)] as MovieClip; 
				var str:String = xml.QnaEventAnswer["@answer"+(i+1)].toString();
				TweenMax.delayedCall((i*0.1)+0.5,viewCount,[btn.mcCount,str,"명 공감"]);
			}
		}
		/**	카운트 가운데 정렬	*/
		private function viewCount(mc:MovieClip,str:String,addStr:String):void
		{
			var num:int = setMcCount(mc,str,addStr);
			var btn:MovieClip = mc.parent as MovieClip;
			
			var pos:int = Math.round((btn.mcImg.width-num)/2)+2;
			TweenMax.to(btn.mcCount,0.5,{x:pos,ease:Expo.easeOut});
		}
		/**	이벤트 완료 버튼 클릭	*/
		private function onClickComplete(mc:MovieClip):void
		{
			QnAGlobal.getIns().moveStep(6);
		}
	}//class
}//package