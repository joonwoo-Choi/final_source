package kb_introduction.introNavigation
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class IntroGNB
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $subBtnLength:int = 3;
		
		private var $btnArr:Array = [];
		
		public function IntroGNB(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			makeBtn();
			
			subMenuChange(0);
		}
		
		private function makeBtn():void
		{
			/**	서브메뉴 버튼	*/
			for (var i:int = 0; i < $subBtnLength; i++) 
			{
				var btn:MovieClip = $con.getChildByName("btn" + i) as MovieClip;
				$btnArr.push(btn);
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			/**	홈 버튼	*/
			$con.btnHome.buttonMode = true;
			$con.btnHome.addEventListener(MouseEvent.CLICK, goHomeHandler);
			
			/**	뒤로 가기 버튼	*/
			$con.btnPrev.buttonMode= true;
			$con.btnPrev.addEventListener(MouseEvent.CLICK, prevHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (target.no)
			{
				case 0 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_INTRO, true) );
					break;
				case 1 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_MODEL, true) );
					break;
				case 2 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_PHOTO, true) );
					break;
			}
			
			subMenuChange(target.no);
		}
		
		private function subMenuChange(num:int):void
		{
			for (var i:int = 0; i < $subBtnLength; i++) 
			{
				if(num == i)
				{
					TweenLite.to($btnArr[i].over, 0.5, {alpha:1, y:0, ease:Cubic.easeOut});
					TweenLite.to($btnArr[i].out, 0.5, {alpha:0, y:31, ease:Cubic.easeOut});
				}
				else
				{
					TweenLite.to($btnArr[i].over, 0.5, {alpha:0, y:10, ease:Cubic.easeOut});
					TweenLite.to($btnArr[i].out, 0.5, {alpha:1, y:21, ease:Cubic.easeOut});
				}
			}
		}
		
		private function goHomeHandler(e:MouseEvent):void
		{
			$con.dispatchEvent( new ModelEvent(ModelEvent.KB_INDEX, true) );
		}
		
		private function prevHandler(e:MouseEvent):void
		{
			
		}
	}
}