package contents.guerilla
{
	import com.greensock.TweenMax;
	import com.sw.buttons.Button;
	
	import event.MovieEvent;
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	
	/**		
	 *	SK2_Hersheys :: 환절기 게릴라 이벤트 완료 모습
	 */
	public class GuerillaSeason2Complete extends BaseGuerilla
	{
		/**	생성자	*/
		public function GuerillaSeason2Complete($btnMc:MovieClip, $viewMc:MovieClip)
		{
			super($btnMc, $viewMc);
			init();
			
			var btn:MovieClip = btnMc.btn as MovieClip;
			btnMc.scaleX = 0.8;
			gapY = -20;
			
			btnMc.alpha = 0;
			if(btnMc.imgMc != null) btnMc.imgMc.visible = false;
			
			//btn.alpha = 1;
			btn.width += 20;
			btn.height += 20;
			btn.x -= 10;
			btn.y -= 10;
			
			btn.view = viewMc.btn;
			setButton(btn,onClickBtn);
		}
		private function onClickBtn(mc:MovieClip):void
		{
			playNextMovie();
		}
		
	}//class
}//package