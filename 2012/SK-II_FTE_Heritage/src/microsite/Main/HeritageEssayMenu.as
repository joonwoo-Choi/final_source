package microsite.Main
{
	
	import adqua.system.SecurityUtil;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.lumpens.utils.ButtonUtil;
	import com.lumpens.utils.JavaScriptUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class HeritageEssayMenu
	{
		/** 컨테이너 **/
		private var $container:MovieClip;
		/** 활성화 번호 **/
		private var $activeNum:int = 0;
		/** 메뉴 수 **/
		private var $menuLength:int = 6;
		private var $timeOut:uint;
		/** 버튼 배열 **/
		private var $btnAry:Array;
		/** open 푯말 배열 **/
		private var $openAry:Array;
		/** Global **/
		private var $global:Global;
		/** MainModel **/
		private var $model:MainModel;
		/** 에세이 XML **/
		private var $essayXml:XML;
		/** 이미지 로더 **/
		private var imgLdr:Loader = new Loader;
		/** 타이틀 이미지 로더 **/
		private var $mcCloseShowMC:MCCloseShowMC;
		private var $viewMCCloseShow:ViewMCCloseShowMC;
		/** 타이틀 배열 **/
		private var $titleAry:Array;
		/** 이전 페이지 번호 저장 **/
		private var $savePageNum:int;
		/** 비하인드 스토리 **/
		private var $behindStory:BehindStory;
		
		public function HeritageEssayMenu( container:MovieClip )
		{
			TweenPlugin.activate([TintPlugin,AutoAlphaPlugin]);
			$container = container;
			$mcCloseShowMC = MCCloseShowMC($container.mcCloseShowMC);
			mcCloseShowMCSet();
			init();
		}
		
		private function mcCloseShowMCSet():void
		{
			$mcCloseShowMC.mcBtn1.addEventListener(MouseEvent.CLICK,btnFullHandler);
			$viewMCCloseShow = new ViewMCCloseShowMC($mcCloseShowMC);
			$behindStory = new BehindStory( $container );
		}
		
		private function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			$global = Global.getIns();
			$model = MainModel.getInstance();
			btnsSetting();
			
			$activeNum = $global.essayNum
			$global.addEventListener( GlobalEvent.XML_LOADED , xmlLoaded );
			$global.addEventListener( GlobalEvent.PAGE_CHANGED , essayPageChanged );
		}
		
		/** XML 로드 **/
		protected function xmlLoaded(e:Event):void
		{
			$essayXml = $global.essayXml;
			$openAry = [];
			$titleAry = [];
			
			/** 버튼 활성화 true/false **/
			for (var i:int = 0; i < $menuLength; i++) 
			{
				var mcOpen:openClip = new openClip;
				
				mcOpen.gotoAndStop(i+1);
				mcOpen.no = i;
				mcOpen.mouseEnabled = false;
				mcOpen.mouseChildren = false;
				mcOpen.alpha = 0;
				$container.btnContainer.addChild( mcOpen );
				
				mcOpen.x = $btnAry[i].x + 10;
				mcOpen.y = $btnAry[i].y - 45;
				$openAry.push( mcOpen );
				/** 에세이 무비 메뉴 버튼 **/
				if( i < $menuLength -1 )
				{
					if( $essayXml.essay[i].@active == "true" )
					{
						ButtonUtil.makeButton( $btnAry[i] , btnHandler );
						$model.truePageAry.push( i );
						$model.lastPageNum = i;
						var essayTitle:MovieClip = $mcCloseShowMC.mcEssayCon.getChildByName( "mc"+i ) as MovieClip;
						$titleAry.push( essayTitle );
					}
					else
					{
						ButtonUtil.makeButton( $btnAry[i] , closedBtnHandler );
					}
				}
				else /** 스페셜 페이지 버튼 **/
				{
					ButtonUtil.makeButton( $btnAry[i] , btnHandler );
				}
				$btnAry[i].mcNewIcon.visible = false;
				$btnAry[$model.lastPageNum].mcNewIcon.alpha=0;
			}
			$btnAry[$model.lastPageNum].mcNewIcon.alpha=1;
			$btnAry[$model.lastPageNum].mcNewIcon.visible = true;
			$global.maxNum = $model.truePageAry.length;
			
			$container.imgContainer.img.addChild( imgLdr );
		}
		
		private function closedBtnHandler( e:MouseEvent ):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : 
					TweenLite.to($openAry[mc.no],.5,{alpha:1});
					clearTimeout( $timeOut ); activeMenu( mc.no ); 
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to($openAry[mc.no],.5,{alpha:0});
					$timeOut = setTimeout( activeMenu , 500 , $activeNum ); 
					break;
			}
		}
		
		/** 에세이 페이지 체인지 **/
		private function essayPageChanged( e:Event ):void
		{
			TweenLite.killTweensOf( imgLdr );
			$container.btnClose.dispatchEvent( new MouseEvent( MouseEvent.CLICK ));
			TweenLite.to( imgLdr , 0.75 , { alpha:0 , ease:Quad.easeOut , onComplete:pageImgSetting });
			$activeNum = $global.essayNum
			activeMenu( $activeNum );
			if( $activeNum != $savePageNum )
			{
				for (var i:int = 0; i < $titleAry.length; i++) 
				{
					TweenLite.killTweensOf( $titleAry[i] );
					if( i == $activeNum ) 
					{
						$titleAry[i].y = $titleAry[i].height;
						TweenLite.to( $titleAry[i] , 0.5 , { y:0 , ease:Cubic.easeOut });
					}else
					{
						TweenLite.to( $titleAry[i] , 0.5 , { y:-$titleAry[i].height , ease:Cubic.easeOut });
					}
				}
				$savePageNum = $activeNum;
			}
			trace( "$activeNum: ",$activeNum );
		}
		
		/** 에세이 이미지 로드 **/
		private function pageImgSetting():void
		{
			imgLdr.unloadAndStop();
			imgLdr.load( new URLRequest( SecurityUtil.getPath($container.root)+$essayXml.essay[$activeNum].img ));
			
			imgLdr.contentLoaderInfo.addEventListener( Event.COMPLETE , imgLoadComplete );
		}
		
		/** 에세이 이미지 로드 완료 **/
		protected function imgLoadComplete(e:Event):void
		{
			imgLdr.alpha = 1;
		}
		
		/** 메뉴 셋팅 **/
		private function btnsSetting():void
		{
			$btnAry = [];
			trace("$model.newIconShowNum: ",$model.newIconShowNum);
			for (var i:int = 0; i < $menuLength; i++) 
			{
				var mcBtn:essayBtnClip = new essayBtnClip;
				mcBtn.gotoAndStop(i+1);
				mcBtn.no = i;
				$container.btnContainer.addChild( mcBtn );
				$btnAry.push( mcBtn );
				
				if( i>0 ) mcBtn.x = $btnAry[i-1].x + $btnAry[i-1].width + 1;
			}
			$container.btnFull.addEventListener( MouseEvent.CLICK , btnFullHandler );
			$container.btnFull.buttonMode = true;
			
			activeMenu( $activeNum );
		}
		
		/** 전체보기 버튼 이벤트 **/
		private function btnFullHandler( e:MouseEvent ):void
		{
			
			if( $container.imgContainer.alpha == 0 ) 
			{
				$global.imgOpen = true;
				$container.imgContainer.y = $global.maskY;
				TweenLite.to( $container.imgContainer , 0.75 , { autoAlpha:1, onComplete:makeMouseMove , ease:Cubic.easeOut });
				TweenLite.to( $container.planBG , 0.75 , { autoAlpha:0.6, ease:Cubic.easeOut });
				
				TweenLite.to( $container.btnClose , 0.5 , { delay:1 ,autoAlpha:1 });
				$container.btnFull.gotoAndStop(2);
				
				JavaScriptUtil.call( "gTracking" , $model.behindAry[$global.essayNum] );
				JavaScriptUtil.call( "realTracking" , $model.realfullAry[$global.essayNum] );
			}
			else
			{
				$global.imgOpen = false;
				TweenLite.killTweensOf( $container.imgContainer.img );
				TweenLite.killTweensOf( $container.imgContainer );
				TweenLite.killTweensOf( $container.btnClose );
				var targetMC:Array = [$container.imgContainer,$container.planBG,$container.btnClose];
				TweenMax.allTo(  targetMC, 0.75 , { autoAlpha:0, ease:Cubic.easeOut });
				$container.btnFull.gotoAndStop(1);
			}
		}
		
		private function makeMouseMove():void
		{
			$global.dispatchEvent( new GlobalEvent( GlobalEvent.ADD_MOUSE_MOVE ));
		}
		
		/** 버튼 이벤트 핸들러 **/
		private function btnHandler( e:MouseEvent ):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			switch ( e.type ) {
				case MouseEvent.MOUSE_OVER : clearTimeout( $timeOut ); activeMenu( mc.no ); break;
				case MouseEvent.MOUSE_OUT : $timeOut = setTimeout( activeMenu , 500 , $activeNum ); break;
				case MouseEvent.CLICK : 
					if( $activeNum != mc.no ){
						for (var i:int = 0; i < $menuLength; i++) $btnAry[i].mouseEnabled = false;
						setTimeout( mouseAddEvt , 1000 );
						$activeNum = mc.no;
						$global.essayNum = $activeNum;
						if( $activeNum < $menuLength-1 )
						{
							$global.dispatchEvent( new GlobalEvent( GlobalEvent.PAGE_CHANGED ));
							$global.dispatchEvent( new GlobalEvent( GlobalEvent.PAGE_SPECIAL_OFF ));
						}
						else
						{
							JavaScriptUtil.call( "gTracking" , $model.essayAry[$global.essayNum] );
							JavaScriptUtil.call( "realTracking" , $model.realpageAry[$global.essayNum*4] );
							$global.dispatchEvent( new GlobalEvent( GlobalEvent.PAGE_SPECIAL_ON ));
						}
						trace( "$global.essayNum: ",$global.essayNum );
					}
					break;
			}
		}
		
		private function mouseAddEvt():void
		{ for (var i:int = 0; i < $menuLength; i++) $btnAry[i].mouseEnabled = true; }
		
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