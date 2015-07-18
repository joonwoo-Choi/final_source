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
		
		private var $subBtnLength:int = 3;
		
		private var $btnArr:Array = [];
		
		public function ModelGNB(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			makeBtn();
			
			subMenuChange(1);
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
			
			$con.btnHome.addEventListener(MouseEvent.CLICK, goHomeHandler);
		}
		
		private function goHomeHandler(e:MouseEvent):void
		{
			$con.dispatchEvent( new ModelEvent(ModelEvent.KB_INDEX, true) );
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
//			var link:Array = [ModelEvent.KB_INTRO, ModelEvent.KB_MODEL, ModelEvent.KB_PHOTO];
//			$con.dispatchEvent( new ModelEvent(link[target.no], true) );
			
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
					TweenLite.to($btnArr[i].out, 0.5, {alpha:0, y:26, ease:Cubic.easeOut});
				}
				else
				{
					TweenLite.to($btnArr[i].over, 0.5, {alpha:0, y:10, ease:Cubic.easeOut});
					TweenLite.to($btnArr[i].out, 0.5, {alpha:1, y:16, ease:Cubic.easeOut});
				}
			}
		}
	}
}