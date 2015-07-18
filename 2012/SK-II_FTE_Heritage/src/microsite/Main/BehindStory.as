package microsite.Main
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BehindStory
	{
		
		private var $container:MovieClip;
		/** Global **/
		private var $global:Global;
		/** Model **/
		private var $model:MainModel;
		
		public function BehindStory(container:MovieClip)
		{
			$container = container;
			$global = Global.getIns();
			$model = MainModel.getInstance();
			
			btnSetting();
		}
		
		private function btnSetting():void
		{
			$global.addEventListener( GlobalEvent.ADD_MOUSE_MOVE , makeMouseMove );
			$container.btnClose.addEventListener( MouseEvent.CLICK , btnCloseHandler );
			$container.btnClose.buttonMode = true;
			
			$container.stage.addEventListener( Event.RESIZE , resizeHandler );
			resizeHandler();
		}
		
		protected function resizeHandler(event:Event = null):void
		{
			var percentY:Number = ($container.stage.stageHeight-1 - 769) / 230;
			
			if( $container.stage.stageHeight < 1000 && $container.stage.stageHeight > 768 )
			{
				/** 에세이 메뉴 정렬 **/
				$container.pageMask.y = int(-305 - percentY*230 - $model.imgConADDGap);
				$container.pageMask.height =  int(760 - (230 - percentY*230) + $model.imgConADDGap)+1;
				$global.maskY = $container.pageMask.y;
				
				if( $container.imgContainer.height >= $container.pageMask.height-60 || $container.imgContainer.y >= $container.pageMask.y )
				{ $container.imgContainer.y = $container.pageMask.y }
				/** 에세이 메뉴 Y값 저장 **/
			}
			else if( $container.stage.stageHeight <= 768 )
			{
				$container.pageMask.y = -305 - $model.imgConADDGap;
				$container.pageMask.height =  531 + $model.imgConADDGap;
				$global.maskY = $container.pageMask.y;
				
				if( $container.imgContainer.height >= $container.pageMask.height )
				{ $container.imgContainer.y = $container.pageMask.y }
			}
			else 
			{
				$container.pageMask.y = -536 - ( $container.stage.stageHeight - 999 ) - $model.imgConADDGap;
				$container.pageMask.height = 760 + ( $container.stage.stageHeight - 999 ) + $model.imgConADDGap;
				$global.maskY = $container.pageMask.y;
				
				if($global.imgOpen)	$container.imgContainer.y = $container.pageMask.y;
			}
			$container.btnClose.y = $global.maskY;
		}
		
		/** 클로즈 버튼 이벤트 **/
		private function btnCloseHandler( e:MouseEvent ):void
		{
			$container.imgContainer.removeEventListener( MouseEvent.MOUSE_MOVE , imgScrollHandler );
			
			TweenLite.to( $container.imgContainer , 0.75 , { autoAlpha:0, ease:Cubic.easeOut });
			TweenLite.to( $container.planBG , 0.75 , { autoAlpha:0, ease:Cubic.easeOut });
			TweenLite.to( $container.btnClose , 0.75 , { autoAlpha:0, ease:Cubic.easeOut });
			$container.btnFull.gotoAndStop(1);
			$global.imgOpen = false;			
		}
		
		private function makeMouseMove(e:Event):void
		{ $container.imgContainer.addEventListener( MouseEvent.MOUSE_MOVE , imgScrollHandler );	}
		
		/** 마우스 무브 / 이미지 스크롤 **/
		private function imgScrollHandler( e:MouseEvent ):void
		{
			var imgY:int
			if( $container.pageMask.height < $container.imgContainer.height )
			{
				imgY = -($container.pageMask.mouseY/100)*($container.imgContainer.height - $container.pageMask.height) + $global.maskY ;
				TweenLite.killTweensOf( $container.imgContainer );
				TweenLite.to( $container.imgContainer , .5 , { y:imgY });
			}
			else
			{
				TweenLite.killTweensOf( $container.imgContainer );
				TweenLite.to( $container.imgContainer , .5 , { y:$global.maskY });
			}
		}
	}
}