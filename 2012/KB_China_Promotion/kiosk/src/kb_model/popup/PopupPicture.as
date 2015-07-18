package kb_model.popup
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	public class PopupPicture extends Sprite
	{
		/**	모델	*/
		private var $model:Model;
		/**	컨테이너	*/
		private var $con:MovieClip;
		
		private var $listLength:int;
		
		private var $listMaxNum:int;
		
		private var $listArr:Array = [];
		
		public function PopupPicture(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.MODEL_LIST_LOADED, loadImg);
			
			$model.addEventListener(ModelEvent.MODEL_POPUP, showPopup);
			
			makeButton();
		}
		
		protected function showPopup(e:Event):void
		{
			if($model.popupNum == 0) return;
			
			for (var i:int = 1; i < $listLength; i++) 
			{
				if($model.popupNum == i)
				{
					TweenLite.to($listArr[i], 0.5, {alpha:1, ease:Cubic.easeOut});
				}
				else
				{
					TweenLite.to($listArr[i], 0.5, {alpha:0, ease:Cubic.easeOut});
				}
			}
			trace("$model.popupNum: " + $model.popupNum);
		}
		
		private function loadImg(e:Event):void
		{
			$listLength = $model.ModelXml.list.length();
			$listMaxNum = $listLength - 1;
			
			for (var i:int = 0; i < $listLength; i++) 
			{
				if(i == 0)
				{
					$listArr.push(null);
				}
				else
				{
					var ldr:Loader = new Loader();
					ldr.load(new URLRequest($model.defaultURL + $model.ModelXml.list[i].@url));
					ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoadComplete);
					
					var container:MovieClip = new MovieClip;
					$listArr.push(container);
					container.alpha = 0;
					container.no = i;
					container.addChild(ldr);
					$con.img.addChild(container);
				}
			}
		}
		
		protected function contentLoadComplete(e:Event):void
		{
			/**	사이즈 맞추기	*/
			e.target.content.width = $con.maskMC.width;
			e.target.content.height = $con.maskMC.height;
			e.target.content.scaleX = e.target.content.scaleY = Math.max(e.target.content.scaleX, e.target.content.scaleY);
			trace("load complete");
		}
		
		private function makeButton():void
		{
			/**	닫기 버튼	*/
			$con.btnClose.buttonMode = true;
			$con.btnClose.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			$model.dispatchEvent(new ModelEvent(ModelEvent.LIST_ALPHA_1));
			TweenMax.to($con, 0.75, {autoAlpha:0, ease:Cubic.easeOut});
		}
	}
}