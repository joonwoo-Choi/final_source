package microsite.GNB
{
	
	import com.adqua.utils.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lumpens.utils.ButtonUtil;
	import com.sw.display.BaseIndex;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	[SWF(width="950",height="137",frameRate="30")]
	
	public class GNB_Essay extends BaseIndex
	{
		
		/** 컨테이너 **/
		private var $container:AssetsGNB_Essay;
		/** 활성 번호 **/
		private var $activNum:int;
		/** 메뉴 수 **/
		private var $menuLength:int = 4;
		private var $timeOut:uint;
		/** 버튼 배열 **/
		private var $btnAry:Array
		/** 버튼 담기 **/
		private var btnContainer:MovieClip
		/** 글로벌 클래스 **/
		private var $global:Global;
		
		public function GNB_Essay()
		{
			super();
		}
		
		override protected function onAdd(e:Event):void
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			super.onAdd(e);
			$global = Global.getIns();
			
			$activNum = root.loaderInfo.parameters.activNum;
			
			$container = new AssetsGNB_Essay();
			
			btnsSetting();
			stage.addEventListener( Event.RESIZE, resizeHandler );
			resizeHandler();
			addChild( $container );
			
			if( !$global.gnbVisible )
			{
				btnContainer.alpha = 0;
				btnContainer.visible = false;
			}
			else
			{
				btnContainer.alpha = 1;
				btnContainer.visible = true;
			}
			$global.addEventListener( GlobalEvent.PAGE_CHANGED , gnbHide );
			$global.addEventListener( GlobalEvent.XML_LOADED , gnbHideCenterBtn );
			$global.addEventListener( GlobalEvent.CENTER_BUTTON , gnbHideCenterBtn );
			$global.addEventListener( GlobalEvent.VIDEO_OFF , gnbShow );
		}
		
		/** GNB 숨기기 **/
		protected function gnbHide(e:Event):void
		{
			if( $global.essayNum <= 4) TweenLite.to(btnContainer,1,{autoAlpha:0 , y:23 , ease:Expo.easeOut , onComplete:visibleFalse});
		}
		/** GNB 숨기기 **/
		protected function gnbHideCenterBtn(e:Event):void
		{
			if( $global.centerBtnNum == 0) TweenLite.to(btnContainer,1,{autoAlpha:0 , y:23 , ease:Expo.easeOut , onComplete:visibleFalse});
		}
		
		protected function visibleFalse():void
		{
			btnContainer.visible = false;
			btnContainer.mouseEnabled = false;
			btnContainer.mouseChildren = false;
		}
		
		/** GNB 보이기 **/
		protected function gnbShow(e:Event):void
		{
			btnContainer.visible = true;
			btnContainer.mouseEnabled = true;
			btnContainer.mouseChildren = true;
			TweenLite.to(btnContainer,1,{delay:1, autoAlpha:1 , y:73, ease:Expo.easeOut});
		}
		
		protected function resizeHandler(e:Event=null):void
		{
			if( stage.stageWidth >= 1280 )
			{
				btnContainer.x = stage.stageWidth/2 - btnContainer.width/2;
				$container.btnQuickContainer.x = stage.stageWidth - $container.btnQuickContainer.width - 40;
			}
			else 
			{
				btnContainer.x = 1280/2 - btnContainer.width/2;
				$container.btnQuickContainer.x = 1280 - $container.btnQuickContainer.width - 40;
			}
		}
		
		/** 버튼 셋팅 **/
		private function btnsSetting():void
		{
			$btnAry = [];
			btnContainer = new MovieClip;
			$container.addChild( btnContainer );
			
			/** GNB 셋팅 **/
			for (var i:int = 0; i < $menuLength; i++) 
			{
				var MCmenu:menuClip = new menuClip;
				
				MCmenu.gotoAndStop(i+1);
				MCmenu.no = i;
				btnContainer.addChild( MCmenu );
				$btnAry.push( MCmenu );
				
				if( i>0 ) MCmenu.x = $btnAry[i-1].x + $btnAry[i-1].width + 100;
				ButtonUtil.makeButton( MCmenu , btnHandler );
			}
			
			/** 세로 나눔선 **/
			for (var j:int = 0; j < $menuLength-1; j++) 
			{
				var MCline:line = new line;
				
				MCline.x = $btnAry[j].x + $btnAry[j].width + 50;
				btnContainer.addChild( MCline );
			}
			
			/** 바로가기 버튼 **/
			for (var k:int = 1; k < 3; k++) 
			{
				var btnQuick:MovieClip = $container.btnQuickContainer.getChildByName( "btnQuick" + k ) as MovieClip;
				btnQuick.buttonMode = true;
				btnQuick.no = k;
				btnQuick.addEventListener( MouseEvent.CLICK , commonHandler );
			}
			
			$container.logo.addEventListener( MouseEvent.CLICK , commonHandler );
			$container.logo.buttonMode = true;
			$container.logo.no = 0;
			
			btnContainer.y = 73;
			activeMenu( $activNum );
		}
		
		protected function commonHandler(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip
			JavaScriptUtil.call( "commonLink" , mc.no );
		}
		
		/** 버튼 이벤트 **/
		private function btnHandler( e:MouseEvent ):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : clearTimeout( $timeOut ); activeMenu( mc.no ); break;
				case MouseEvent.MOUSE_OUT : $timeOut = setTimeout( activeMenu , 500 , $activNum ); break;
				case MouseEvent.CLICK : 
					if( $activNum != mc.no )
					{
						$activNum = mc.no;
						activeMenu( $activNum );
						JavaScriptUtil.call( "menuLink" , mc.no );
					}
					break;
			}
		}
		
		/** 버튼 실행 **/
		private function activeMenu( activeNum:int ):void
		{
			for (var i:int = 0; i < $menuLength; i++) 
			{
				if( i == activeNum ) 
				{
					TweenLite.to($btnAry[i].btnOn,.5,{alpha:1});
					TweenLite.to($btnAry[i].btnOff,.5,{alpha:0});
				}
				else
				{
					TweenLite.to($btnAry[i].btnOn,.5,{alpha:0});
					TweenLite.to($btnAry[i].btnOff,.5,{alpha:1});
				}
			}
		}
	}
}