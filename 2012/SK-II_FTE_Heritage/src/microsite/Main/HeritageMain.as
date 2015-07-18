package microsite.Main
{
	
	import adqua.movieclip.Frame;
	import adqua.movieclip.TestButton;
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lumpens.utils.ButtonUtil;
	import com.lumpens.utils.JavaScriptUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import microsite.InviteFriends.HeritageInviteComplete;
	import microsite.InviteFriends.SiteFriendInviteMain;
	import microsite.Main.movie.HeritageCycleMovie;
	import microsite.Main.movie.HeritageMovClip;
	import microsite.Main.movie.HeritageTitleMovie;
	import microsite.Main.special.HeritageSpecialPage;
	
	import orpheus.templete.countDown.PiteraCount;

	public class HeritageMain
	{
		
		/** 전체 담기 **/
		private var $container:MovieClip;
		/** 영상 제어 클래스 **/
		private var $movContainer:HeritageMovClip;
		/** 에세이 버튼 클래스 **/
		private var $essayMenuContainer:HeritageEssayMenu;
		/** 중앙 버튼 클래스 **/
		private var $centerBtnContainer:HeritageCenterButton;
		/** 친구 초대 클래스 **/
		private var $SiteFriendInviteMain:SiteFriendInviteMain;
		/** 응모 완료 클래스 **/
		private var $HeritageInviteComplete:HeritageInviteComplete
		/** 사이클 무비 클래스 **/
		private var $HeritageCycleMovie:HeritageCycleMovie;
		/** 타이틀 클래스 **/
		private var $HeritageTitleMovie:HeritageTitleMovie;
		/** 이벤트 공유 방법 클래스 **/
		private var $HeritageSharePage:HeritageSharePage;
		/** 스페셜 페이지 클래스 **/
		private var $HeritageSpecialPage:HeritageSpecialPage;
		/** 타이틀 담기 **/
		private var $titleContainer:MovieClip;
		/** 타이틀 번호 **/
		private var $titleNum:int;
		/** Global **/
		private var $global:Global;
		/** 에세이 XML **/
		private var $essayXml:XML;
		/** 이미지 배열 **/
		private var $imgAry:Array = [];
		/** defaultImg 배열 **/
		private var $defaultAry:Array = [];
		/** movControl 숨기기 타임 아웃 **/
		private var $downtimeOut:uint;
		/** 센터 버튼 초기 Y좌표 **/
		private var $centerBtnY:int;
		/** 에세이 메뉴 초기 Y좌표 **/
		private var $essayBtnY:int;
		/** 카운트 초기 Y좌표 **/
		private var $countY:int;
		/** 에세이 메뉴 변동 Y좌표 **/
		private var $essayBtnMoveY:int = 672;
		/** VIEW 카운트 **/
		private var $countDown:PiteraCount;
		/** 이미지 로더 **/
		private var imgLdr:Loader = new Loader;
		/** 스페셜 페이지 오프 타임아웃 **/
		private var $specialTimeOut:uint;
		/** 타이틀 무비 알파 트윈 상태 **/
		private var $titleMovTween:Boolean;
		
		private var $showFront:uint;
		
		public function HeritageMain( container:MovieClip )
		{
			
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			$container = container;
			$model = MainModel.getInstance();
			
			/** 영상 제어 **/
			$movContainer = new HeritageMovClip( $container );
			
			
			/** 에세이 메뉴 **/
			$essayMenuContainer = new HeritageEssayMenu( $container.menuContainer );
			
			/** 중앙 버튼 **/
			$centerBtnContainer = new HeritageCenterButton( $container );
			
			
			/** 친구 초대 **/
			$SiteFriendInviteMain = new SiteFriendInviteMain( $container.friendInvite,null, "W" );
			
			/** 응모 완료 **/
			$HeritageInviteComplete = new HeritageInviteComplete( $container.friendInvite );
			
			/** 공유 방법 **/
			$HeritageSharePage = new HeritageSharePage( $container );
			
			
			/** 디폴트 반복 영상 **/
			$HeritageCycleMovie = new HeritageCycleMovie( $container );
			
			/** 타이틀 영상 **/
			$HeritageTitleMovie = new HeritageTitleMovie( $container );
			
			
			/** 스페셜 페이지 **/
			$HeritageSpecialPage = new HeritageSpecialPage( $container );
			
			$container.menuContainer.viewCount.y = $container.menuContainer.viewCount.y+100;
			$countDown = new PiteraCount($model.movieCount);
			$container.menuContainer.viewCount.count.addChild($countDown);
			$container.menuContainer.viewCount.visible = false;
			$container.menuContainer.viewCount.alpha=0;
			TweenLite.delayedCall(1,function():void{
				$container.menuContainer.viewCount.visible = true;
				TweenLite.to($container.menuContainer.viewCount,.5,{alpha:1,y:$container.menuContainer.viewCount.y-100});
			});
			$model.addEventListener(GlobalEvent.PLUS_FLIP_COUNT,plusFlipCount);
			init();
		}
		
		protected function plusFlipCount(event:Event):void
		{
			$countDown.newCount($model.movieCount);
		}
		
		private function init():void
		{
			$global = Global.getIns();
			$global.addEventListener( GlobalEvent.XML_LOADED , xmlLoaded );
			$global.addEventListener( GlobalEvent.PAGE_CHANGED , pageChanged );
			$global.addEventListener( GlobalEvent.VIDEO_PAUSE , videoPause );
			$global.addEventListener( GlobalEvent.VIDEO_STOP , videoStop );
			$global.addEventListener( GlobalEvent.CENTER_BUTTON , selectFn );
			$global.addEventListener( GlobalEvent.POPUP_CLOSE , popupClose );
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_OFF , specialPageOff );
			$global.addEventListener( GlobalEvent.PAGE_SPECIAL_ON , specialPageOn );
			
			btnsSetting();
//			arrowBtnVisibleChk($global.essayNum);
			
			/** 영상 전체 버튼 **/
			$container.movContainer.btnStop.visible = false;
			TweenLite.to( $container.movContainer.mcBtn , 0 , { autoAlpha:0 });
			TweenLite.to( $container.friendInvite , 0 , { autoAlpha:0 });
			$container.popupBG.visible = false;
			
			$container.stage.addEventListener( Event.RESIZE, resizeHandler );
			resizeHandler();
		}
		
		protected function specialPageOn(e:Event):void
		{
			clearTimeout( $specialTimeOut );
			defaultImg();
		}
		
		protected function specialPageOff(event:Event):void
		{
//			$showFront = setTimeout( showFront , 500 );
			TweenLite.to( $container.menuContainer.viewCount , 0.5 , { y:-35 });
			TweenLite.to( $container.defaultImg , 0.5 , { autoAlpha:0 , ease:Cubic.easeOut });
		}
		
		protected function popupClose(event:Event):void
		{ popupCloseHandler(); }
		
		protected function videoStop(e:Event):void
		{
			$showFront = setTimeout( showFront , 1000 );
			$container.movContainer.btnStop.visible = false;
			$container.stage.dispatchEvent( new Event( Event.MOUSE_LEAVE ));
			$container.stage.removeEventListener( MouseEvent.MOUSE_MOVE , moveHandler );
			$container.stage.removeEventListener( Event.MOUSE_LEAVE , leaveHandler );
		}
		
		/** 에세이 페이지 변환 시 실행 **/
		protected function pageChanged(e:Event):void
		{
//			defaultImg();
			clearTimeout($showFront);
			hideFront();
			$titleMovTween = false;
			arrowBtnVisibleChk( $global.essayNum );
			JavaScriptUtil.call( "gTracking" , $model.essayAry[$global.essayNum] );
			JavaScriptUtil.call( "realTracking" , 2+$global.essayNum*4 );
		}
		
		/** XML 로드 **/
		protected function xmlLoaded(e:Event):void
		{
//			showFront();
			$essayXml = $global.essayXml;
			$container.defaultImg.addChild( imgLdr );
//			defaultImg();
			$global.dispatchEvent( new Event( GlobalEvent.PAGE_CHANGED ));
			$global.dispatchEvent( new GlobalEvent( GlobalEvent.ACTIVE_RESIZE ));
		}
		
		/** default 이미지 로드 **/
		private function defaultImg():void
		{
			TweenLite.killTweensOf( imgLdr );
			TweenLite.to( $container.defaultImg , 0.75 , { autoAlpha:0 , ease:Cubic.easeOut , onComplete:defaultLoadComplete });
		}
		
		/** default 이미지 로드 완료 **/
		protected function defaultLoadComplete():void
		{
			imgLdr.unloadAndStop();
			imgLdr.load( new URLRequest( SecurityUtil.getPath($container.root)+$essayXml.essay[$global.essayNum].default ));
			imgLdr.contentLoaderInfo.addEventListener( Event.COMPLETE , defaultChangeComplete );
		}
		
		/** default 이미지 체인지 완료 **/
		private function defaultChangeComplete(e:Event):void
		{
			resizeHandler();
			TweenLite.to( $container.defaultImg , 0.75 , { autoAlpha:1 , ease:Quad.easeOut });
		}
		
		/** 중앙 버튼 function 선택 **/
		protected function selectFn(e:Event):void
		{
			switch ( $global.centerBtnNum ) {
				case 0 : 
					hideFront();
					JavaScriptUtil.call( "gTracking" , $model.playAry[$global.essayNum] );
					break;
				case 1 : facebookShow(); break;
				case 2 : break;
			}
		}
		
		protected function resizeHandler(e:Event = null):void
		{
			var percentY:Number = ($container.stage.stageHeight-1 - 769) / 230;
			$essayBtnMoveY = int(440 + percentY*230);
			$global.essayBtnMoveY = $essayBtnMoveY;
			
			/** X축 정렬 **/
			var targetW:int = ($container.stage.stageWidth >=1280)?$container.stage.stageWidth:1280;
			$container.defaultImg.x = targetW/2 - $container.defaultImg.width/2;
			$container.menuContainer.x = int(targetW/2 - $container.menuContainer.width/2);
			$container.btnArrow1.x = targetW;
			$container.friendInvite.x = targetW/2 - $container.friendInvite.width/2;
			
			/** btnNext 위치 **/
			for (var i:int = 0; i < 2; i++) $arrowAry[i].y = $container.stage.stageHeight/2 - $arrowAry[i].height/2;
			
			/** Y축 정렬 **/
			if( $container.stage.stageHeight < 1000 && $container.stage.stageHeight > 768 )
			{
				$container.menuContainer.y = int(440 + percentY*230+$model.imgConADDGap);
				$container.friendInvite.y = int(132 + percentY*90);
			}
			else if( $container.stage.stageHeight <= 768 )
			{
				$container.menuContainer.y = int(440+$model.imgConADDGap);
				$container.friendInvite.y = 132;
			}
			else
			{
				$container.menuContainer.y = int($container.stage.stageHeight-328+$model.imgConADDGap);
			}
			
			/** 무비 플레이에 따른 정렬 **/
			if( $global.playIs ) $container.menuContainer.y = $container.stage.stageHeight+62;
			/** 스페셜 페이지 정렬 **/
			if( $model.specialIs )
			{
				if( $container.stage.stageHeight > 768 ) $container.menuContainer.y = $container.stage.stageHeight-76;
				else $container.menuContainer.y = 768-76;
			}
			
			/** blackBar 위치 **/
			$container.blackBar.width = $container.stage.stageWidth;
			$container.blackBar.height = $container.stage.stageHeight;
			$container.blackBar.x = $container.stage.stageWidth/2 - $container.blackBar.width/2;
			$container.blackBar.y = $container.menuContainer.y + $model.imgConDefaultY;
			
			$container.popupBG.width = $container.stage.stageWidth;
			$container.popupBG.height = $container.stage.stageHeight;
			
			$global.titleMovX = $container.menuContainer.x+980;
			$global.stageH = $container.stage.stageHeight;
			$global.dispatchEvent( new GlobalEvent( GlobalEvent.ACTIVE_RESIZE ));
		}
		
		private var $timeOut:uint;
		
		/** 화살표 버튼 배열 **/
		private var $arrowAry:Array
		private var $model:MainModel;
		
		/** 메뉴 셋팅 **/
		private function btnsSetting():void
		{
			$arrowAry = [ $container.btnArrow0 , $container.btnArrow1 ];
			
			for (var j:int = 0; j < 2; j++) 
			{
				$arrowAry[j].no = j;
				ButtonUtil.makeButton( $arrowAry[j] , btnNextHandler );
			}
			
			$global.titleY = $container.titleContainer.y;
			$global.centerBtnY = $container.btnContainer.y;
			$essayBtnY = $container.menuContainer.y;
			
			$container.movContainer.btnStop.addEventListener( MouseEvent.CLICK , pauseVideo );
			$container.movContainer.btnStop.buttonMode = true;
			$container.movContainer.mcBtn.imgStop.addEventListener( MouseEvent.CLICK , pauseVideo );
			$container.movContainer.mcBtn.imgStop.buttonMode = true;
			
			ButtonUtil.makeButton($container.movContainer.mcBtn.btnEvt, pauseVideoAndEvent);
			
			$container.movContainer.controllClip.movControl.addEventListener( MouseEvent.ROLL_OVER , movControlHandler );
			$container.movContainer.controllClip.movControl.addEventListener( MouseEvent.ROLL_OUT , movControlHandler );
		}
		
		private function pauseVideoAndEvent( e:MouseEvent ):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to($container.movContainer.mcBtn.btnEvt.Off, 0.5, { alpha:0 });
					TweenLite.to($container.movContainer.mcBtn.btnEvt.On, 0.5, { alpha:1 });
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to($container.movContainer.mcBtn.btnEvt.Off, 0.5, { alpha:1 });
					TweenLite.to($container.movContainer.mcBtn.btnEvt.On, 0.5, { alpha:0 });
					break;
				case MouseEvent.CLICK : 
					pauseVideo();
					setTimeout( fbLoginStatus , 2000 );
					break;
			}
		}
		
		private function fbLoginStatus():void
		{
			$global.centerBtnNum = 1;
			JavaScriptUtil.call( "fbLoginStatus" );		
		}
		
		private function movControlHandler( e:MouseEvent ):void
		{
			switch ( e.type ) {
				case MouseEvent.ROLL_OVER : 
					$container.stage.removeEventListener( MouseEvent.MOUSE_MOVE , moveHandler );
					clearTimeout( $downtimeOut );
					TweenLite.to( $container.movContainer.controllClip.movControl , 0.5, { y:0 });
					break;
				case MouseEvent.ROLL_OUT : 
					$container.stage.addEventListener( MouseEvent.MOUSE_MOVE , moveHandler );
					break;
			}
		}
		
		private var $cnt:int;
		
		/** btnArrows 버튼 이벤트 **/
		private function btnNextHandler( e:MouseEvent ):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : mc.gotoAndStop( 2 ); break;
				case MouseEvent.MOUSE_OUT : mc.gotoAndStop( 1 ); break;
				case MouseEvent.CLICK : 
					$cnt = $global.essayNum;
					if( mc.no == 0 ) 
						if( $cnt <= 0 ) { $cnt = 0; }
						else { $cnt--; }
					else
						if( $cnt >= $model.lastPageNum ) $cnt = $model.lastPageNum;
						else { $cnt++; }
					$global.essayNum = $model.truePageAry[$cnt];
					$global.dispatchEvent( new GlobalEvent( GlobalEvent.PAGE_CHANGED ));
					break;
			}
		}
		
		/** btnArrows 보기/숨김 체크 **/
		private function arrowBtnVisibleChk( param:int ):void
		{
			if( $global.maxNum > 1 )
			{
				if( param <= 0 )
				{
					$global.essayNum = 0;
					$arrowAry[0].visible = false;
					$arrowAry[1].visible = true;
				}
				else if( param >= $model.lastPageNum )
				{
					$global.essayNum = $model.lastPageNum;
					$arrowAry[0].visible = true;
					$arrowAry[1].visible = false;
				}
				else
				{
					for (var i:int = 0; i < 2; i++) $arrowAry[i].visible = true;
				}
			}
			else
			{
				for (i = 0; i < 2; i++) $arrowAry[i].visible = false;
			}
		}
		
		/** 타이틀/메뉴 숨김 **/
		private function hideFront():void
		{
			for (var i:int = 0; i < 2; i++) 
			{
				$arrowAry[i].mouseEnabled = false;
				TweenLite.to( $arrowAry[i] , 0.75 , { alpha:0 , ease:Cubic.easeOut });
			}
			TweenLite.killTweensOf( $container.titleContainer );
			TweenLite.killTweensOf( $container.btnContainer );
			TweenLite.killTweensOf( $container.blackBar );
			TweenLite.killTweensOf( $container.menuContainer );
			TweenLite.to( $container.titleContainer , 0.75 , { autoAlpha:0 , ease:Cubic.easeOut });
			TweenLite.to( $container.btnContainer , 0.75 , { autoAlpha:0 , ease:Cubic.easeOut , onComplete:btnSet });
			TweenLite.to( $container.blackBar , 0.75 , { y:$container.stage.stageHeight+97 , ease:Cubic.easeOut});
			TweenLite.to( $container.menuContainer , 0.75 , { y:$container.stage.stageHeight+62 , ease:Cubic.easeOut});
		}
		
		/** 타이틀/메뉴 보이기 **/
		private function showFront( e:Event = null ):void
		{
//			if( $model.specialIs ) { $model.specialIs = false;	}
			$global.playIs = false;
			for (var i:int = 0; i < 2; i++) 
			{
				$arrowAry[i].mouseEnabled = true;
				TweenLite.to( $arrowAry[i] , 0.75 , { alpha:1 , ease:Cubic.easeOut });
			}
			TweenLite.killTweensOf( $container.titleContainer );
			if( $titleMovTween ) TweenLite.to( $container.titleContainer , 0.75 , { autoAlpha:1 });
			else TweenLite.to( $container.titleContainer , 0 , { delay:0.75 , autoAlpha:1 });
			TweenLite.to( $container.btnContainer , 0.75 , { autoAlpha:1 , ease:Cubic.easeOut });
			if( $container.stage.stageHeight > 768 && $container.stage.stageHeight < 1000 )
			{
				TweenLite.to( $container.blackBar , 0.5 , { y:$essayBtnMoveY+$model.imgConDefaultY+$model.imgConADDGap , ease:Expo.easeOut});
				TweenLite.to( $container.menuContainer , 0.5 , { y:$essayBtnMoveY+$model.imgConADDGap , ease:Expo.easeOut });
			}
			else if( $container.stage.stageHeight <= 768 )
			{
				TweenLite.to( $container.blackBar , 0.5 , { y:440+$model.imgConDefaultY+$model.imgConADDGap , ease:Expo.easeOut});
				TweenLite.to( $container.menuContainer , 0.5 , { y:440+$model.imgConADDGap , ease:Expo.easeOut });
			}
			else
			{
				TweenLite.to( $container.blackBar , 0.5 , { y:$container.stage.stageHeight - 268+$model.imgConDefaultY , ease:Expo.easeOut});
				TweenLite.to( $container.menuContainer , 0.5 , { y:$container.stage.stageHeight - 268 , ease:Expo.easeOut });
			}
		}
		
		private function facebookShow():void
		{
			$container.popupBG.visible = true;
			TweenLite.to( $container.friendInvite , 0.75 , { autoAlpha:1 , ease:Cubic.easeOut });
			$container.friendInvite.inviteComplete.visible = false;
			$container.friendInvite.loading.visible = false;
		}
		
		private function popupCloseHandler( e:MouseEvent = null ):void
		{
			$container.popupBG.visible = false;
			TweenLite.to( $container.friendInvite , 0.75 , { autoAlpha:0 , ease:Cubic.easeOut });
			$global.dispatchEvent( new Event( GlobalEvent.RESET_BUTTON ));
		}
		
		/** 영상 버튼 무비 컨트롤 활성화 **/
		private function btnSet():void
		{
			$global.dispatchEvent( new Event( GlobalEvent.VIDEO_ON ));
			$container.movContainer.btnStop.visible = true;
			$container.stage.addEventListener( MouseEvent.MOUSE_MOVE , moveHandler );
			$container.stage.addEventListener( Event.MOUSE_LEAVE , leaveHandler );
			if( $global.$playIs == "reset" ) playVideo();
		}
		
		/** 영상 플레이 **/
		private function playVideo():void
		{
			$global.dispatchEvent( new GlobalEvent( GlobalEvent.VIDEO_PLAY ));
		}
		
		/** VIDE_PAUSE 디스패치 이벤트 **/
		protected function pauseVideo(e:MouseEvent = null):void
		{
			$global.dispatchEvent( new GlobalEvent( GlobalEvent.VIDEO_PAUSE ));
			$global.dispatchEvent( new GlobalEvent( GlobalEvent.VIDEO_OFF ));
		}
		
		/** 비디오 일시정지 **/
		protected function videoPause(e:Event):void
		{
			if( $global.playIs == true )
			{
				$showFront = setTimeout( showFront , 1000 );
				$container.movContainer.btnStop.visible = false;
//				$global.dispatchEvent( new GlobalEvent( GlobalEvent.VIDEO_OFF ));
				$container.stage.dispatchEvent( new Event( Event.MOUSE_LEAVE ));
				$container.stage.removeEventListener( MouseEvent.MOUSE_MOVE , moveHandler );
				$container.stage.removeEventListener( Event.MOUSE_LEAVE , leaveHandler );
				$global.playIs = false;
				$titleMovTween = true;
			}
			else if( $global.playIs == false )
			{
				$container.stage.dispatchEvent( new Event( Event.MOUSE_LEAVE ));
				$container.stage.addEventListener( MouseEvent.MOUSE_MOVE , moveHandler );
				$container.stage.addEventListener( Event.MOUSE_LEAVE , leaveHandler );
				$global.playIs = true;
			}
		}
		
		/** 마우스 무브 **/
		protected function moveHandler(e:MouseEvent):void
		{
			clearTimeout( $downtimeOut );
			$downtimeOut = setTimeout( hideMovcontrol , 1000 )
			TweenLite.to( $container.movContainer.mcBtn , 0.85 , { autoAlpha:1 , ease:Expo.easeOut });
			TweenLite.to( $container.movContainer.controllClip.movControl , 0.5, { y:0 });
			
		}
		
		private function hideMovcontrol():void
		{
			TweenLite.to( $container.movContainer.controllClip.movControl , 0.5, { y:40 });
			TweenLite.to( $container.movContainer.mcBtn , 0.85 , { autoAlpha:0 , ease:Expo.easeOut });
		}
		
		/** 마우스 리브 **/
		protected function leaveHandler(e:Event):void
		{
			TweenLite.to( $container.movContainer.mcBtn , 0.85 , { autoAlpha:0 , ease:Expo.easeOut });
			TweenLite.to( $container.movContainer.controllClip.movControl , 0.5, { y:40 });
		}
	}
}