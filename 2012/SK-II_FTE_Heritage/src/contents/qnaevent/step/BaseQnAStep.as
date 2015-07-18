package contents.qnaevent.step
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sw.display.Remove;
	import com.sw.utils.SetText;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**		
	 *	SK2_Hersheys :: Q&A 서브 Step 공통 내용
	 */
	public class BaseQnAStep extends Sprite
	{
		protected var mcBase:MovieClip;
		
		/**	생성자	*/
		public function BaseQnAStep(mc:MovieClip=null)
		{
			mcBase = mc;
			mcBase.alpha = 0;
			addChild(mcBase);
			
			view();
		}
		/**	보여지기	*/
		public function view():void
		{
			TweenMax.to(mcBase,1,{alpha:1});
		}
		/**	가려지기	*/
		public function hide():void
		{
			TweenMax.to(mcBase,1,{alpha:0,onComplete:destroy});
		}
		/**	카운트 내용 적용
		 * @param mc	:: 그래픽
		 * @param str	:: 카운트 문자
		 * @param speed :: 등장 속도
		 * @return :: 넓이
		 */
		protected function setMcCount(mc:MovieClip,str:String,addTxt:String="명이 참여 중",speed:Number=0.7):int
		{
			var txt:TextField = mc.txt as TextField;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = SetText.setPrice(str)+addTxt;
			
			TweenMax.to(mc.mcMask,speed,{width:txt.width,ease:Expo.easeOut});
			TweenMax.to(mc.mcPlane,speed,{width:txt.width,ease:Expo.easeOut});
			TweenMax.to(mc.mcMark,speed,{x:txt.width+2,ease:Expo.easeOut});
			
			return txt.width+mc.mcMark.width+2;
		}
		
		/**	소멸자	*/
		public function destroy():void
		{
			Remove.all(this);
		}
	}//class
}//package