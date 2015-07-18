package kb_introduction.introGNB
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SubGNB
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $subBtnLength:int = 4;
		
		private var $btnArr:Array = [];
		/**	버튼 over Y값	*/
		private var $overY:Array = [];
		/**	버튼 out Y값	*/
		private var $outY:Array = [];
		
		public function SubGNB(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.SELECTED_SUB_MENU, activeSubMenu);
			
			makeBtn();
		}
		
		protected function activeSubMenu(e:Event):void
		{
			subMenuChange($model.subNum + 1);
		}
		
		private function makeBtn():void
		{
			/**	서브메뉴 버튼	*/
			for (var i:int = 0; i < $subBtnLength; i++) 
			{
				var btn:MovieClip = $con.getChildByName("btn" + i) as MovieClip;
				$btnArr.push(btn);
				$overY.push(btn.over.y);
				$outY.push(btn.out.y);
				btn.no = i;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			if($model.subNum == target.no - 1) return;
			
			switch (target.no) 
			{
				case 0 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_INDEX, true) );
					break;
				case 1 :
					$model.subNum = target.no - 1;
					$model.dispatchEvent(new Event(ModelEvent.SELECTED_GNB_MENU));
					break;
				case 2 :
					$model.subNum = target.no - 1;
					$model.dispatchEvent(new Event(ModelEvent.SELECTED_GNB_MENU));
					break;
				case 3 :
					$model.dispatchEvent(new Event(ModelEvent.GO_TO_MAIN));
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
					TweenLite.to($btnArr[i].over, 0.5, {alpha:1, y:$overY[i], ease:Cubic.easeOut});
					TweenLite.to($btnArr[i].out, 0.5, {alpha:0, y:$outY[i] + 5, ease:Cubic.easeOut});
				}
				else
				{
					TweenLite.to($btnArr[i].over, 0.5, {alpha:0, y:$overY[i], ease:Cubic.easeOut});
					TweenLite.to($btnArr[i].out, 0.5, {alpha:1, y:$outY[i], ease:Cubic.easeOut});
				}
			}
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