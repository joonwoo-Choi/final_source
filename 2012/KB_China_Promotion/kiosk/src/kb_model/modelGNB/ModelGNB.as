package kb_model.modelGNB
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ModelGNB extends Sprite
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		
		private var $subBtnLength:int = 5;
		
		private var $btnArr:Array = [];
		/**	버튼 over Y값	*/
		private var $overY:Array = [];
		/**	버튼 out Y값	*/
		private var $outY:Array = [];
		
		public function ModelGNB(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.GO_TO_MAIN, activeSubMenu);
			
			makeBtn();
			
			subMenuChange(2);
		}
		
		protected function activeSubMenu(e:Event):void
		{
			subMenuChange($model.subNum);
		}
		
		private function makeBtn():void
		{
			/**	GNB 버튼	*/
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
			
			switch (target.no) 
			{
				case 0 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_INDEX, true) );
					break;
				case 1 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_INTRO, true) );
					break;
				case 2 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_MODEL, true) );
					break;
				case 3 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_PHOTO, true) );
					break;
				case 4 :
					$con.dispatchEvent( new ModelEvent(ModelEvent.KB_MODEL, true) );
					$model.dispatchEvent(new ModelEvent(ModelEvent.GO_TO_MODEL_MAIN));
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
	}
}