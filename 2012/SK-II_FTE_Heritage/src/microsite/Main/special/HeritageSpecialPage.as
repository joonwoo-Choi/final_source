package microsite.Main.special
{
	import com.adqua.utils.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lumpens.utils.ButtonUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import microsite.Main.MainModel;

	public class HeritageSpecialPage
	{
		/** 전체 담기 **/
		private var $container:MovieClip;
		/** 싱글톤 클래스 **/
		private var $model:MainModel;
		/** 싱글톤 클래스 **/
		private var $global:Global;
		/** 애로우 버튼 배열 **/
		private var $arrowAry:Array;
		/** 썸네일 배열 **/
		private var $thumbAry:Array;
		/** 썸네일 Y값 배열 **/
		private var $thumbYAry:Array;
		/** 썸네일 X값 배열 **/
		private var $thumbXAry:Array;
		/** 타이틀 배열 **/
		private var $titleAry:Array;
		/** 타이틀 X값 배열 **/
		private var $titleXAry:Array;
		
		private var $thumbTimeOut:uint;
		
		public function HeritageSpecialPage( container:MovieClip )
		{
			$container = container;
			TweenPlugin.activate([AutoAlphaPlugin]);
			init();
		}

		
		private function init():void
		{
			$thumbAry = [ $container.specialContainer.thumb0 , $container.specialContainer.thumb1 , $container.specialContainer.thumb2 ,
				$container.specialContainer.thumb3 , $container.specialContainer.thumb4 , $container.specialContainer.thumb5 ];
			$titleAry = [ $container.specialContainer.txt0 , $container.specialContainer.txt1 ];
			$titleXAry = [];
			
			for (var i:int = 0; i < 2; i++) 
			{
				$titleAry[i].visible = false;
				$titleXAry.push( $titleAry[i].x );
			}
			$global = Global.getIns();
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_ON , pageOn );
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_OFF , pageOff );
			
			$model = MainModel.getInstance();
			
			btnSetting();
			$container.stage.addEventListener( Event.RESIZE, resizeHandler );
			resizeHandler();
		}
		
		/** 스페셜 페이지 온 **/
		protected function pageOn(e:Event):void
		{
			$model.specialIs = true;
			TweenLite.killTweensOf( $container.specialContainer );
			TweenLite.killTweensOf( $container.btnContainer );
			for (var i:int = 0; i < 2; i++) 
			{
				TweenLite.killTweensOf( $arrowAry[i] );
				TweenLite.killTweensOf( $titleAry[i] );
			}
			for (var j:int = 0; j < $thumbAry.length; j++)  TweenLite.killTweensOf( $thumbAry[j] );
			
			if( $global.stageH > 768 )
			{
				TweenLite.to( $container.menuContainer ,0.75 ,{ y:$container.stage.stageHeight-76, ease:Expo.easeOut });
				TweenLite.to( $container.blackBar ,0.75 ,{ y:$container.stage.stageHeight-41, ease:Expo.easeOut });
			}
			else
			{
				TweenLite.to( $container.menuContainer ,0.75 ,{ y:768-76, ease:Expo.easeOut });
				TweenLite.to( $container.blackBar ,0.75 ,{ y:768-41, ease:Expo.easeOut });
			}
			TweenLite.to( $container.titleContainer ,0.75 ,{ autoAlpha:0, ease:Cubic.easeOut });
			TweenLite.to( $container.btnContainer ,0.75 ,{ autoAlpha:0, ease:Cubic.easeOut });
			TweenLite.to( $container.menuContainer.viewCount , 0.75 , { y:60 });
			for (i = 0; i < 2; i++) TweenLite.to( $arrowAry[i] ,0.75 ,{ alpha:0, ease:Cubic.easeOut });
			$thumbTimeOut = setTimeout( arrowVisibleOff , 1500 );
		}
		
		/** 화살표 버튼 & 섬네일 **/
		protected function arrowVisibleOff():void
		{
			for (var j:int = 0; j < $thumbAry.length; j++) 
			{
				TweenMax.fromTo( $thumbAry[j], 0.65, {y:$thumbAry[j].y+40}, { delay:0.05*j, y:$thumbAry[j].y, autoAlpha:1, ease:Cubic.easeOut , onComplete:mouseMoveOn });
				trace( "$thumbAry[j]: ",$thumbAry[j].y );
			}
			for (var i:int = 0; i < 2; i++) 
			{
				TweenMax.fromTo( $titleAry[i] ,0.65 ,{x:$titleAry[i].x+50} ,{ delay:0.1*i, x:$titleAry[i].x, autoAlpha:1, ease:Cubic.easeOut});
				$arrowAry[i].visible = false;
			}
			$container.stage.dispatchEvent( new Event( Event.RESIZE ));
		}
		
		/** 섬네일 마우스 이동 이벤트 등록 **/
		protected function mouseMoveOn():void
		{
			$container.stage.addEventListener( MouseEvent.MOUSE_MOVE , thumbMoveHandler );
		}
		
		/** 스페셜 페이지 오프 **/
		protected function pageOff(e:Event):void
		{
			clearTimeout( $thumbTimeOut );
			if( $model.specialIs )
			{
//				TweenLite.killTweensOf( $container.btnContainer );
				for (var j:int = 0; j < $thumbAry.length; j++) TweenLite.killTweensOf( $thumbAry[j] );
				for (var i:int = 0; i < 2; i++) TweenLite.killTweensOf( $titleAry[i] );
				$container.stage.removeEventListener( MouseEvent.MOUSE_MOVE , thumbMoveHandler );
				for (j = 0; j < $thumbAry.length; j++) 
				{ TweenLite.to( $thumbAry[j], 0.65, { delay:0.05*j, y:$thumbAry[j].y-40, autoAlpha:0, ease:Cubic.easeOut, onComplete:defaultY }); }
				for (i = 0; i < 2; i++) TweenLite.to( $titleAry[i], 0.65, { delay:0.1*i, x:$titleAry[i].x-50, autoAlpha:0, ease:Cubic.easeOut });
				
//				TweenLite.to( $container.btnContainer ,1 ,{ autoAlpha:1, ease:Cubic.easeOut });
				
				$model.specialIs = false;
			}
		}
		
		/** 섬네일 Y값 초기화 **/
		private function defaultY():void
		{
			for (var j:int = 0; j < $thumbAry.length; j++) 
			{
				$thumbAry[j].y = $thumbYAry[j];
				$thumbAry[j].x = $thumbXAry[j];
			}
			for (var i:int = 0; i < 2; i++) $titleAry[i].x = $titleXAry[i];
//			TweenLite.to( $thumbAry[j], 0.7, { y:$thumbAry[j].y-40, autoAlpha:0, ease:Cubic.easeOut });
		}
		
		/** 리사이즈 **/
		protected function resizeHandler( e:Event = null ):void
		{
			var targetW:int = ($container.stage.stageWidth >=1280)?$container.stage.stageWidth:1280;
			
			$container.specialContainer.x = targetW/2 - $container.specialContainer.width/2;
		}
		
		/** 버튼 만들기 **/
		private function btnSetting():void
		{
			$thumbYAry = [];
			$thumbXAry = [];
			for (var i:int = 0; i < $thumbAry.length; i++) 
			{
				var btns:MovieClip = $container.specialContainer.getChildByName( "thumb" + i ) as MovieClip;
				btns.no = i;
				btns.alpha = 0;
				btns.visible = false;
				/** 썸네일 초기 X,Y값 **/
				$thumbYAry.push( btns.y );
				$thumbXAry.push( btns.x );
				ButtonUtil.makeButton( btns , btnHandler );
			}
			$arrowAry = [ $container.btnArrow0 , $container.btnArrow1 ];
			
		}
		
		/** 마우스 위치에 따른 섬네일 X 이동 **/
		protected function thumbMoveHandler(e:MouseEvent):void
		{
			var num:int = $container.stage.stageWidth/2 - $container.stage.mouseX;
			for (var i:int = 0; i < $thumbAry.length; i++) 
			{
				TweenLite.killTweensOf( $thumbAry[i] );
				if( i%2 == 0 ) TweenLite.to( $thumbAry[i], 0.4+0.2*Math.random(), { x:$thumbXAry[i]+num/30, ease:Cubic.easeOut });
				else TweenLite.to( $thumbAry[i], 0.4+0.2*Math.random(), { x:$thumbXAry[i]-num/30, ease:Cubic.easeOut });
			}
		}
		
		/** 버튼 핸들러 **/
		private function btnHandler( e:MouseEvent ):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to( mc.btnOn ,1 ,{ alpha:1 }); 
					TweenLite.killTweensOf( mc.white );
					mc.white.alpha = 0.65;
					TweenLite.to( mc.white ,1 ,{ alpha:0 });
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to( mc.btnOn ,1 ,{ alpha:0 }); 
					break;
				case MouseEvent.CLICK : 
					trace( mc.no ); 
					JavaScriptUtil.call( "gTracking" , $model.specialBtnClickShareG[mc.no] );
					JavaScriptUtil.call( "realTracking" , $model.specialBtnClickShareR[mc.no] );										
					$model.activeSpecialNum = mc.no;
					$model.dispatchEvent(new GlobalEvent(GlobalEvent.SPECIAL_BTN_CLICK));
					break;
			}
		}
	}
}