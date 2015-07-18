package facebook.StoreBtn
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.sw.display.BaseIndex;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	[SWF(width = "220", height = "220", frameRate = "30")]
	
	public class FB_StoreBtn extends BaseIndex
	{
		
		private var $container:Asset_FB_Btn;
		
		public function FB_StoreBtn()
		{
			super();
		}
		
		override protected function onAdd(e:Event):void
		{
			super.onAdd(e);
			
			$container = new Asset_FB_Btn;
			addChild( $container );
			
			$container.btn.buttonMode = true;
			$container.btn.addEventListener( MouseEvent.MOUSE_OVER , btnHandler );
			$container.btn.addEventListener( MouseEvent.MOUSE_OUT , btnHandler );
			$container.btn.addEventListener( MouseEvent.CLICK , btnHandler );
		}
		
		protected function btnHandler(e:MouseEvent):void
		{
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to($container.btnOn,.5,{alpha:1, ease:Quad.easeOut});
					TweenLite.to($container.btnOut,.5,{alpha:0, ease:Quad.easeOut});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to($container.btnOn,.5,{alpha:0, ease:Quad.easeOut});
					TweenLite.to($container.btnOut,.5,{alpha:1, ease:Quad.easeOut});
					break;
				case MouseEvent.CLICK : 
					if( ExternalInterface.available ) ExternalInterface.call( "eventwinner" );
					break;
			}
		}
	}
}