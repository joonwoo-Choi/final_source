package microsite.Main
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class HeritageSharePage
	{
		
		private var $container:MovieClip
		private var $global:Global;
		
		public function HeritageSharePage( container:MovieClip )
		{
			$container = container
			
			$global = Global.getIns();
			$global.addEventListener( GlobalEvent.POPUP_CLOSE , popupClose );
//			$global.addEventListener( GlobalEvent.CENTER_BUTTON , popupCuide );
			
			init();
		}
		
		private function init():void
		{
			TweenLite.to( $container.evtGuide , 0 , { autoAlpha:0 });
			
			$container.evtGuide.addEventListener( MouseEvent.MOUSE_MOVE , imgScrollHandler );
			$container.evtGuide.btnClose.addEventListener( MouseEvent.CLICK , popupCloseHandler );
			$container.evtGuide.btnClose.buttonMode = true;
			
			$container.stage.addEventListener( Event.RESIZE, resizeHandler );
			resizeHandler();
		}
		
		/** 리사이즈 **/
		protected function resizeHandler(e:Event = null):void
		{
			$container.evtGuide.x = $container.stage.stageWidth/2 - $container.evtGuide.width/2;
			
			var imgY:int
			
			if( $container.stage.stageHeight >= 768 ) 
			{
				$container.evtGuide.pageMask.height = $container.stage.stageHeight - 130;
				imgY = -($container.evtGuide.img.height - $container.evtGuide.pageMask.height);
				
				if( imgY <= 0 )
				{
					trace("$container: ",$container);
					trace("$container.evtGuide: ",$container.evtGuide);
					TweenLite.killTweensOf( $container.evtGuide.img );
					TweenLite.to( $container.evtGuide.img , 0.5 , { y:imgY ,ease:Cubic.easeOut });
				}
				else
				{
					TweenLite.killTweensOf( $container.evtGuide.img );
					TweenLite.to( $container.evtGuide.img , 0.5 , { y:0 ,ease:Cubic.easeOut });
				}
			}
			else
			{
				$container.evtGuide.pageMask.height = 768 - 130;
				imgY = -($container.evtGuide.img.height - $container.evtGuide.pageMask.height);
					TweenLite.killTweensOf( $container.evtGuide.img );
					TweenLite.to( $container.evtGuide.img , 0.5 , { y:imgY ,ease:Cubic.easeOut });
			}
		}
		
		/** 페이지 보이기 **/
		protected function popupCuide(e:Event):void
		{
			if( $global.centerBtnNum == 1 ) popupGuide();
		}
		
		/** 페이지 숨기기 **/
		protected function popupClose(event:Event):void
		{
			popupCloseHandler();
		}
		
		/** 이벤트 안내 페이지 팝업 **/
		private function popupGuide():void
		{
			$container.popupBG.visible = true;
			TweenLite.to( $container.evtGuide , 0.75 , { autoAlpha:1 , ease:Cubic.easeOut });
		}
		
		/** 이벤트 안내 페이지 닫기 **/
		private function popupCloseHandler( e:MouseEvent = null ):void
		{
			$container.popupBG.visible = false;
			TweenLite.to( $container.evtGuide , 0.75 , { autoAlpha:0 , ease:Cubic.easeOut });
			TweenLite.to( $container.friendInvite , 0.75 , { autoAlpha:0 , ease:Cubic.easeOut });
			$global.dispatchEvent( new Event( GlobalEvent.RESET_BUTTON ));
		}
		
		/** 마우스 무브 / 이미지 스크롤 **/
		private function imgScrollHandler( e:MouseEvent ):void
		{
			var imgY:int
			if( $container.evtGuide.pageMask.height < $container.evtGuide.img.height )
			{
				imgY = -($container.evtGuide.pageMask.mouseY/100)*($container.evtGuide.img.height - $container.evtGuide.pageMask.height );
				TweenLite.killTweensOf( $container.evtGuide.img );
				TweenLite.to( $container.evtGuide.img , .5 , { y:imgY });
			}
		}
	}
}