package microsite.InviteFriends
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.lumpens.utils.ButtonUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class HeritageInviteComplete
	{
		/** 컨테이너 **/
		private var $container:MovieClip;
		/** 글로벌 클래스 **/
		private var $global:Global;
		
		public function HeritageInviteComplete( container:MovieClip )
		{
			$container = container;
			$global = Global.getIns();
			$global.addEventListener( GlobalEvent.FBEVENT_CLEAR , clearHandler )
			$global.addEventListener( GlobalEvent.FBEVENT_LOADING , loadingHandler );
			
			$container.visible = false;
			init();
		}
		
		protected function loadingHandler(e:Event):void
		{
			$container.loading.visible = true;
			$container.loading.play();
		}
		
		protected function clearHandler(e:Event):void
		{
			$container.loading.visible = false;
			$container.loading.gotoAndStop(1);
			$container.inviteComplete.visible = true;
//			for (var i:int = 0; i <$global.$movAry.length; i++) 
//			{
//				var stamp:MovieClip = $container.inviteComplete.getChildByName( "stamp" + ( $global.$movAry[i]-1 )) as MovieClip;
//				stamp.alpha = 1
//			}
		}
		
		private function init():void
		{
//			for (var i:int = 0; i < 5; i++) 
//			{
//				var stamp:MovieClip = $container.inviteComplete.getChildByName( "stamp" + i ) as MovieClip;
//				stamp.no = i;
//				stamp.gotoAndStop(i+1);
//			}
//			$container.inviteComplete.btnClose.addEventListener( MouseEvent.CLICK , btnCloseHandler );
//			$container.inviteComplete.btnClose.buttonMode = true;
			
			ButtonUtil.makeButton( $container.inviteComplete.btnCom , btnComHandler )
		}
		
		private function btnComHandler( e:MouseEvent ):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : TweenMax.to( mc , 0.4 , { colorTransform:{exposure:1.2} , ease:Quad.easeOut }); break;
				case MouseEvent.MOUSE_OUT : TweenMax.to( mc , 0.4 , { colorTransform:{exposure:1} , ease:Quad.easeOut }); break;
				case MouseEvent.CLICK : 
					$global.dispatchEvent( new Event( GlobalEvent.POPUP_CLOSE ));
					$container.inviteComplete.visible = false;
					break;
			}
			
		}
		
//		private function btnCloseHandler( e:MouseEvent ):void
//		{
//			$global.dispatchEvent( new Event( GlobalEvent.POPUP_CLOSE ));
//			$container.inviteComplete.visible = false;
//		}
	}
}