package contents.qnaevent.step
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.buttons.Button;
	import com.sw.net.list.Write;
	import com.sw.utils.McData;
	
	import contents.qnaevent.QnAGlobal;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import net.CallBack;

	/**		
	 *	SK2_Hersheys :: Q&A 메인 영상 리스트
	 */
	public class QnAMain extends BaseQnAStep
	{
		private var container:QnAListClip;
		/**	영상 플레이 횟수	*/
		private var count:Write;
		
		/**	생성자	*/
		public function QnAMain(mc:MovieClip=null)
		{
			container = new QnAListClip();
			init();
			
			super(container);
			
			Global.getIns().addEventListener(CallBack.QNA_LOGIN,onLogin);
			Global.getIns().addEventListener(CallBack.QNA_FACEBOOK,onLogin);
		}
		/**	로그인 콜백	*/
		private function onLogin(e:Event):void
		{
			Global.getIns().hidePop();
			QnAGlobal.getIns().moveStep(2);
			QnAGlobal.getIns().changeBtnB(-1);
		}
			
		/**	초기화	*/
		private function init():void
		{
			for(var i:int = 1; i<=5; i++)
			{
				var btn:MovieClip = container["btn"+i] as MovieClip;
				btn.idx = i;
				btn.mcImg.gotoAndStop(i);
				btn.mcPlane.width = btn.mcImg.width;
				btn.mcMask.width = btn.mcImg.width - 8;
				btn.mcCorner2.x = btn.mcImg.width;
			
				McData.save(btn.mcMask);
				
				btn.mcMask.x = btn.mcMask.width/2;
				btn.mcMask.width = 2;
				btn.mcCorner2.x = btn.mcMask.x+10;
				btn.mcCorner1.x = btn.mcMask.x-10;
				
				var delay:Number = i*0.1;
				var ease:Object = Expo.easeOut;
				
				TweenMax.to(btn.mcMask,1,{delay:delay,x:btn.mcMask.dx,width:btn.mcMask.dw,ease:ease});
				TweenMax.to(btn.mcCorner1,1,{delay:delay,x:0,ease:ease});
				TweenMax.to(btn.mcCorner2,1,{delay:delay,x:btn.mcImg.width,ease:ease});
				
				Button.setUI(btn,{over:onOver,out:onOut,click:onClick});
			}
			
			var url:String = Global.getIns().dataURL+"/Process/QnA/GetQnaEventTotalCount.ashx";
			count = new Write(url,onLoadCount,{});
			count.send();
		}
		
		/**	영상 플레이 횟수 카운트	*/
		private function onLoadCount(result:String):void
		{
			var xml:XML = new XML(count.getData());
			
			for(var i:int =0; i<5; i++)
			{
				var mcCount:MovieClip = container["btn"+(i+1)].mcCount as MovieClip;
				var str:String = xml.QnaEventAnswer["@answer"+(i+1)].toString();
				TweenMax.delayedCall((i*0.1)+0.5,setMcCount,[mcCount,str]);
			}
			
		}
		/**	리스트 오버	*/
		private function onOver(mc:MovieClip):void
		{
			TweenMax.to(mc.mcImg,0.5,{y:5,ease:Expo.easeOut});
			TweenMax.to(mc.mcCorner1,0.5,{x:5,tint:0x9D2622,ease:Expo.easeOut});
			TweenMax.to(mc.mcCorner2,0.5,{x:mc.mcImg.width-5,tint:0x9D2622,ease:Expo.easeOut});
		}
		/**	리스트 아웃	*/
		private function onOut(mc:MovieClip):void
		{
			TweenMax.to(mc.mcImg,0.5,{y:0,ease:Expo.easeOut});
			TweenMax.to(mc.mcCorner1,0.5,{x:0,tint:null,ease:Expo.easeOut});
			TweenMax.to(mc.mcCorner2,0.5,{x:mc.mcImg.width,tint:null,ease:Expo.easeOut});
		}
		/**	리스트 클릭	*/
		private function onClick(mc:MovieClip):void
		{
			QnAGlobal.getIns().qPos = mc.idx;
//			QnAGlobal.getIns().moveStep(2);
			
			Global.getIns().viewPop("qnaLogin");
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			
			Global.getIns().removeEventListener(CallBack.QNA_LOGIN,onLogin);
			Global.getIns().removeEventListener(CallBack.QNA_FACEBOOK,onLogin);
		}
	}//class
}//package