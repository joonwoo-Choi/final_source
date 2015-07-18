package kb_introduction.introNavigation
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class IntroSNB
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $subBtnLength:int = 4;
		
		private var $btnArr:Array = [];
		
		public function IntroSNB(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.SELECTED_SUB_MENU, activeSubMenu);
			
			makeBtn();
		}
		
		protected function activeSubMenu(e:Event):void
		{
			subMenuChange($model.subNum);
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
			
			if($model.subNum == target.no) return;
			
			$model.subNum = target.no;
			$model.dispatchEvent(new Event(ModelEvent.SELECTED_GNB_MENU));
			
			subMenuChange(target.no);
		}
		
		private function subMenuChange(num:int):void
		{
			$con.mouseEnabled = false;
			$con.mouseChildren = false;
			for (var i:int = 0; i < $subBtnLength; i++) 
			{
				if(num == i)
				{
					TweenLite.to($btnArr[i].over, 0.5, {alpha:1, y:0, ease:Cubic.easeOut});
					TweenLite.to($btnArr[i].out, 0.5, {alpha:0, y:26, ease:Cubic.easeOut, onComplete:addMouseEvent});
				}
				else
				{
					TweenLite.to($btnArr[i].over, 0.5, {alpha:0, y:10, ease:Cubic.easeOut});
					TweenLite.to($btnArr[i].out, 0.5, {alpha:1, y:16, ease:Cubic.easeOut});
				}
			}
		}
		
		private function addMouseEvent():void
		{
			$con.mouseEnabled = true;
			$con.mouseChildren = true;
		}
		
		private function goHomeHandler(e:MouseEvent):void
		{
			$con.dispatchEvent( new ModelEvent(ModelEvent.KB_INDEX, true) );
		}
		
		private function prevHandler(e:MouseEvent):void
		{
			$model.dispatchEvent(new Event(ModelEvent.GO_TO_MAIN));
		}
	}
}