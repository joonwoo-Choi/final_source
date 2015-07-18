package microsite.Main
{
	
	import adqua.system.SecurityUtil;
	
	import com.adqua.utils.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.lumpens.utils.ButtonUtil;
	import com.sw.net.list.BaseList;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import microsite.InviteFriends.SiteFriendInviteList;
	
	public class HeritageCenterButton
	{
		
		private var $container:MovieClip;
		private var $global:Global;
		private var $btnAry:Array;
		/** 메뉴 수 **/
		private var $menuLength:int = 3;
		/** 활성화 번호 **/
		private var $activeNum:int;
		private var $ctrler:MainCtrler;
		
		private var $InviteList:SiteFriendInviteList;
		
		private var $mousetimeOut:uint;
		
		public function HeritageCenterButton( container:MovieClip )
		{
			$container = container;
			$global = Global.getIns();
			$ctrler = MainCtrler.getInstance();
			
			$container.btnContainer.alpha = 0;
			$container.btnContainer.visible = false;
			init();
		}
		
		private function init():void
		{
			btnsSetting();
			
			$container.stage.addEventListener( Event.RESIZE , resizeHandler );
			$global.addEventListener( GlobalEvent.ACTIVE_RESIZE , resizeHandler );
			$global.addEventListener( GlobalEvent.PAGE_CHANGED , centerBtnMouseFalse );
		}
		
		protected function centerBtnMouseFalse(e:Event):void
		{
			$btnAry[0].mouseEnabled = false;
			$btnAry[0].mouseChildren = false;
			clearTimeout( $mousetimeOut );
			$mousetimeOut = setTimeout( centerBtnMouseTrue , 1000 );
		}
		
		private function centerBtnMouseTrue():void
		{
			$btnAry[0].mouseEnabled = true;
			$btnAry[0].mouseChildren = true;
		}
		
		protected function resizeHandler(e:Event):void
		{
			var percentY:Number = ($container.stage.stageHeight-1 - 769) / 230;
			if( $container.stage.stageHeight < 1000 && $container.stage.stageHeight > 768 )
			{ $container.btnContainer.y = int(360 + percentY*210); }
			else if( $container.stage.stageHeight <= 768 )
			{ $container.btnContainer.y = 360; }
			else 
			{ $container.btnContainer.y = $global.centerBtnY + ($container.stage.stageHeight - 1000)/2; }
			
			var targetW:int = ($container.stage.stageWidth >=1280)?$container.stage.stageWidth:1280;
			$container.btnContainer.x = targetW/2 - $container.btnContainer.width/2;
		}
		
		private function btnsSetting():void
		{
			$btnAry = [];
			
			for (var i:int = 0; i < $menuLength; i++) 
			{
				var mcBtn:commonBtnClip = new commonBtnClip;
				
				mcBtn.gotoAndStop(i+1);
				mcBtn.btnArea.no = i;
				$container.btnContainer.addChild( mcBtn );
				$btnAry.push( mcBtn );
				
				if( i>0 ) mcBtn.x = $btnAry[i-1].x + $btnAry[i-1].width + 1;
				ButtonUtil.makeButton( mcBtn.btnArea , btnHandler );
			}
		}
		
		/** 버튼 이벤트 **/
		private function btnHandler( e:MouseEvent ):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : 
					for (var i:int = 0; i < $menuLength; i++) 
					{
						if( i == mc.no )
						{
							TweenLite.to($btnAry[i].btnOn,.5,{alpha:1});
							TweenLite.to($btnAry[i].btnOff,.5,{alpha:0});
						}
					}
					break;
				case MouseEvent.MOUSE_OUT : 
					for (i = 0; i < $menuLength; i++) 
					{
						TweenLite.to($btnAry[i].btnOn,.5,{alpha:0});
						TweenLite.to($btnAry[i].btnOff,.5,{alpha:1});
					}
					break;
				case MouseEvent.CLICK : 
					$activeNum = mc.no;
					activeMenu( $activeNum );
					trace( "$activeNum: ",$activeNum );
					break;
			}
		}
		
		/** 버튼 실행 **/
		private function activeMenu( activeNum:int ):void
		{
			switch( activeNum ) {
				case 0 :
					$global.centerBtnNum = activeNum;
					$global.dispatchEvent( new Event( GlobalEvent.CENTER_BUTTON ));
					if( $global.$playIs == "start" ) $global.dispatchEvent( new Event( GlobalEvent.VIDEO_PAUSE ));
					break;
				case 1 :
					$global.centerBtnNum = activeNum;
					if(SecurityUtil.isWeb()){
						JavaScriptUtil.call( "fbLoginStatus" );
					}
					else
					{
						$global.dispatchEvent( new Event( GlobalEvent.CENTER_BUTTON ));
					}
					break;
				case 2 :
					$global.centerBtnNum = activeNum;
					JavaScriptUtil.call( "piterawinner" );
					break;
			}
		}
	}
}