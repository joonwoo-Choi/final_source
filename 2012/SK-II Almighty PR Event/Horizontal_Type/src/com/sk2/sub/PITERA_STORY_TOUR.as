package com.sk2.sub
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.easing.Expo;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.BtnAlpha;
	import com.sw.buttons.BtnEnter;
	import com.sw.buttons.Button;
	import com.sw.display.Remove;
	import com.sw.display.SetBitmap;
	import com.sw.net.list.Write;
	import com.sw.utils.McData;
	import com.sw.utils.SetText;
	import com.sw.utils.VideoPlayer;
	
	import errorPopup.ErrorPopup;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.BlurFilter;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * SK2	::	영상 보는 메뉴
	 * */
	public class PITERA_STORY_TOUR extends BaseSub
	{
		private var rootURL:String;
		
		private var movAry:Array;
		private var posAry:Array;
		private var popAry:Array;
		private var movPos:int;
		
		private var mov_mc:MovieClip;
		private var ctl_mc:MovieClip;
		private var player:VideoPlayer;
		private var mov_btn:MovieClip;
		private var pop_mc:MovieClip;
		
		private var mov_bit:Bitmap;
		private var dot_mc:MovieClip;
		private var title_mc:MovieClip;
		
		private var $model:Model;
		
		/**	영상 멈추고 난 후 조절 mc	*/
		private var sceneAry:Array;
		/**	인터넷 오류 체크	*/
		private var $chk:Boolean = true;
		
//		private var write:Write;
		
		/**	생성자	 */
		public function PITERA_STORY_TOUR($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.ERROR_POPUP, errorPopHandler);
			
			scope_mc.errorPop.visible = false;
			scope_mc.errorPop.btnClose.buttonMode = true;
			scope_mc.errorPop.btnClose.addEventListener(MouseEvent.CLICK, errorCloseHandler);
		}
		
		protected function errorPopHandler(e:Event):void
		{
			scope_mc.setChildIndex(scope_mc.errorPop,scope_mc.numChildren - 1);
			TweenMax.to(scope_mc.errorPop, 1, {autoAlpha:1, ease:Cubic.easeOut});
		}
		
		protected function errorCloseHandler(e:MouseEvent):void
		{
			TweenMax.to(scope_mc.errorPop, 1, {autoAlpha:0, ease:Cubic.easeOut});
		}
		
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			setBit();
			if(player != null) player.remove();
			mov_btn.removeEventListener(Event.ENTER_FRAME,onEnterBtn);
			scope_mc.removeEventListener(Event.ENTER_FRAME,onLoadingVideo);
			DataProvider.stage.removeEventListener(KeyboardEvent.KEY_UP,onTestKey);
		}
		/**	테스트 용 	*/
		private function onTestKey(e:KeyboardEvent):void
		{
			//trace(e.keyCode);
			if(e.keyCode == 78 && movPos < movAry.length-1)
			{
				viewBlurObj(pop_mc,null,null,0);
				playNextMov();
			}
			if(e.keyCode == 77 && player.loader.paused == false)
			{
				player.loader.videoTime += 1;
			}
		}
		/**
		 * 초기화
		 * */
		override public function init():void
		{
			trace(" ////////////////  @@@@@@@@@@@@@@@@@@@@@@@")
			//테스트 키 테스트 (n을 누르면 바로 다음 영상으로)
			DataProvider.stage.addEventListener(KeyboardEvent.KEY_UP,onTestKey);
			//이벤트 등록
//			write = new Write(DataProvider.dataURL+"/Event/TourEvent.ashx",onWrite,{});
		
			movPos = 0;
			posAry = ["","사케 양조장 피테라의 발견","SK-II 연구소 SK-II의 기적","헤리티지 룸 피테라 원액","파우더 룸 피부의 기적"];
			popAry = ["","사케 양조장","SK-II 연구소","헤리티지룸","파우더룸"];
			movAry = [	"intro",
						"Brewery_Tour_1","Brewery_Tour_1_2","Brewery_Tour_2",
						"Lab_Tour_1","Lab_Tour_1_2","Lab_Tour_2",
						"Heritage_Tour_1","Heritage_Tour_1_2","Heritage_Tour_2",
						"Powder_Tour_1","Powder_Tour_1_2","Powder_Tour_2"];
			
			sceneAry = ["light_mc","img_mc"];
			
			ctl_mc = scope_mc.control_mc;
			mov_btn = scope_mc.mov_btn;
			pop_mc = scope_mc.pop_mc;
			title_mc = scope_mc.title_mc;
			
			mov_mc = new MovieClip();
			mov_bit = new Bitmap();
			
			mov_btn.img.alpha = 0;
			mov_btn.alpha = 1;
			pop_mc.visible = false;
			pop_mc.alpha = 0;
			mov_btn.plane_mc.visible = false;
			
			for(var i:int = 1; i<posAry.length; i++)
			{
				var txt:TextField = ctl_mc.txt_mc["txt"+i];
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = posAry[i];
			}
			Button.setUI(mov_btn.img,{over:onOverBtn,out:onOutBtn,click:onClickBtn});
			
			mov_mc.alpha = 0;
			
			/**	영상 위치 조절	*/
			mov_bit.x = mov_mc.x = 42;
			mov_bit.y = mov_mc.y = 170;
			
			setVideo();
			
			setLayout();
			setPop();
		}
		/**
		 * 화면 구성
		 * */
		private function setLayout():void
		{
			scope_mc.addChild(mov_mc);
			scope_mc.addChild(mov_bit);
			scope_mc.addChild(mov_btn);
			scope_mc.addChild(title_mc);
			scope_mc.addChild(ctl_mc);
			scope_mc.addChild(pop_mc);
		}
		/**
		 *	영상에 대한 bitmap 생성
		 * */
		private function setBit($mc:MovieClip = null):void
		{
			if($mc == null) $mc = mov_mc;
			var myBit:BitmapData = new BitmapData($mc.width,$mc.height,true,0x00ffffff);
			myBit.draw($mc);
			if(mov_bit.bitmapData != null)
			{
				mov_bit.bitmapData.dispose();
				mov_bit.bitmapData = null;
			}
			mov_bit.bitmapData = myBit;
			mov_bit.alpha = 1;
		}
		/**
		 * 영상 다 멈췄을때 수행 내용
		 * */
		private function finishMov():void
		{
			setBit();
			if( movPos == movAry.length-1)
			{	//이벤트 응모
//				sendWrite();
				viewPop();
				trace("sendWrite()");
				return;
			}
			if(	movPos%3 == 0 && movPos != 0)
			{
				//TweenMax.delayedCall(3,viewPop);
				viewPop();
				trace("viewPop()");
				//return;	
			}
			viewBtn();
		}
		/**
		 * 다음 영상 플레이
		 * */
		private function playNextMov():void
		{
			setBit();
			mov_btn.removeEventListener(Event.ENTER_FRAME,onEnterBtn);
			mov_btn.mouseChildren = false;
			mov_btn.mouseEnabled = false;

			if((movPos-1)%3 == 1 && movPos != 0 && mov_btn.bg_mc != null)
			{
				//mov_btn.bg_mc.img.rotati
				TweenMax.to(mov_btn.bg_mc,0.5,{scaleX:1,scaleY:1,rotationY:0,x:512});
				TweenMax.to(mov_btn.img_mc,0.5,{x:0,onComplete:finishNextMov});
				return;
			}
			finishNextMov();
		}
		private function finishNextMov():void
		{
			
			mov_bit.alpha = 1;
			
			//다음 영상 플레이
			movPos++;
			
			setVideo();
			mov_mc.alpha = 0;
			
			//사람 안보이는 부분
			if(movPos != 3) 
			{
				TweenMax.to(mov_btn,0.5,{alpha:0,onComplete:finishBtn});
			}
			else
			{
				finishBtn();
				mov_btn.alpha = 0;
			}
			
		}
		private function setVideo():void
		{
			Remove.child(mov_mc);
			var obj:Object = new Object();
			
			if(player != null) player.remove();
			
			obj.url = DataProvider.defaultURL + "flv/"+movAry[movPos]+".flv";
			obj.width=940;
			obj.height=400;
			obj.color=0xffffff;
			obj.finish=finishMov;
			obj.enter=onEnterMov;
			obj.fnc_play = onPlayVideo;
			obj.smoothing = false;
			obj.autoPlay = false;
			player = new VideoPlayer(mov_mc,obj);
			
			DataProvider.loader.viewOutLoading();
			scope_mc.addEventListener(Event.ENTER_FRAME,onLoadingVideo);
		}
		/**	영상 로드딩바 표현 데이터	*/
		private function onLoadingVideo(e:Event):void
		{
			if(movPos == 0) DataProvider.layout.loading.visible = false;
			else DataProvider.layout.loading.visible = true;
			
			var num:Number = DataProvider.loader.doingOutLoading(player.loader.bytesLoaded,player.loader.bytesTotal);
			if(num >= 100) 
			{
				DataProvider.loader.hideOutLoading();
				player.loader.videoPaused = false;
				scope_mc.removeEventListener(Event.ENTER_FRAME,onLoadingVideo);
			}
		}
		private function onPlayVideo():void
		{
			if(movPos == 0) TweenMax.to(mov_mc,1,{delay:0.2,alpha:1});
			else mov_mc.alpha = 1;
			
			viewBlurObj(title_mc,null,null,0);
			TweenMax.to(mov_bit,1,{alpha:0});
		}
		/**
		 * 플레이어 바 
		 * */
		private function onEnterMov():void
		{
			var degree:int = Math.round(ctl_mc.plane_mc.width/(movAry.length-1));
			var posX:int = ((movPos-1)*degree)+Math.round((player.loader.videoTime/player.loader.duration)*degree)+3;	
			
			ctl_mc.bar_mc.x -= (ctl_mc.bar_mc.x - posX)*0.3;
		}
		/**	버튼,인터렉션 보여지기	*/
		private function viewBtn():void
		{
			mov_btn.gotoAndStop(movPos+1);
			Button.setUI(mov_btn.img,{over:onOverBtn,out:onOutBtn,click:onClickBtn});
			//trace(movPos);
			
			if( movPos%3 == 2 )
			{	//인터렉션
				var num:int = (movPos+1)/3;
				for(var i:int=0; i<sceneAry.length; i++)
					mov_btn[sceneAry[i]].gotoAndStop(num);
				mov_btn.bg_mc.img.gotoAndStop(num);
				scope_mc.title_mc.gotoAndStop(num);
				
				viewBlurObj(title_mc);
				title_mc.mouseChildren = false;
				title_mc.mouseEnabled = false;
				
				mov_btn.img_mc.x = 0;
				mov_btn.img_mc.rotationY = 0;
				mov_btn.bg_mc.rotationY = 0;
				mov_btn.bg_mc.alpha = 0;
				
				//버튼
				dot_mc = mov_btn.dot_mc;
				McData.save(mov_btn.img);
				McData.save(dot_mc);
				dot_mc.scaleX = 0.5;
				dot_mc.scaleY = 0.5;
				dot_mc.alpha = 0;
				TweenMax.to(dot_mc,0.5,{scaleX:1,scaleY:1,alpha:1});		
				
				mov_btn.alpha = 1;
				finishBtn();
				
				mov_btn.next_img.alpha = 0;
			}
			else if(movPos != 0)
			{
				var nextAry:Array = [0,208,0,190,210,0,190,210,0,173,190,0,0];
				
				mov_btn.next_img.alpha = 1;
				mov_btn.img.y = mov_btn.next_img.y = nextAry[movPos];
				TweenMax.to(mov_btn,0.5,{alpha:1,onComplete:finishBtn});
				setBaseBtn(mov_btn.img,onClickBtn);
				Button.setUI(mov_btn.img,{over:onOverBtn,out:onOutBtn,click:onClickBtn});
			}
			mov_btn.visible = true;
			mov_btn.mouseEnabled = true;
			mov_btn.mouseChildren = true;
		}
		private function finishBtn():void
		{
			if(mov_btn.alpha == 1) 
			{
				if(mov_btn.bg_mc != null &&  movPos%3 == 2 )
				{
					TweenMax.to(mov_btn.bg_mc,0.5,{alpha:1,override:1});
					TweenMax.to(mov_btn.bg_mc,3,{delay:0.5,scaleX:1.1,scaleY:1.1});
					
					mov_btn.addEventListener(Event.ENTER_FRAME,onEnterBtn);
				}
			}
			if(mov_btn.alpha == 0) mov_btn.visible = false;
		}
		
		/**	버튼 오버	*/
		private function onOverBtn($mc:MovieClip):void
		{
			if(movPos == 0) TweenMax.to($mc,0.3,{alpha:0.5});
			
			if(	movPos%3 == 2 )
			{
				if(dot_mc==null) return;
				dot_mc.removeEventListener(Event.ENTER_FRAME,onEnterBtnPrev);
				if(dot_mc.currentFrame != dot_mc.totalFrames) dot_mc.play();
			}
		}
		/**	버튼 아웃	*/
		private function onOutBtn($mc:MovieClip):void
		{
			if(movPos == 0) TweenMax.to($mc,0.3,{alpha:0});
			
			if( movPos%3 == 2  )
			{
				if(dot_mc == null) return;
				dot_mc.addEventListener(Event.ENTER_FRAME,onEnterBtnPrev);
			}
		}
		/**	버튼 아이콘 따라가기,마우스 위치에 따라 인터렉션	*/
		private function onEnterBtn(e:Event):void
		{
			if(mov_btn.alpha != 1) return;
			
			if(	mov_btn.mouseX > 0 &&
				mov_btn.mouseX < mov_btn.width &&
				mov_btn.mouseY > 0 &&
				mov_btn.mouseY < mov_btn.height)
			{
				mov_btn.mx = mov_btn.mouseX;
				mov_btn.my = mov_btn.mouseY;
			}
			if(mov_btn.mx == null || !mov_btn.mx) mov_btn.mx = dot_mc.dx;
			if(mov_btn.my == null || !mov_btn.my) mov_btn.my = dot_mc.dy;
			//trace(mov_btn.mx);
			//trace(dot_mc.dx);
			var dirX:Number; var dirY:Number;
			//img
			dirX = (mov_btn.mx/mov_btn.plane_mc.width)*20; 
			mov_btn.img_mc.x -= (mov_btn.img_mc.x - dirX)*0.1;
			
			mov_btn.img.x -= (mov_btn.img.x - (mov_btn.img.dx+dirX))*0.2;
			//마우스 위치에 ㅁ따라 가기
			dirX = dot_mc.dx+dirX;
			dirY = dot_mc.dy;
			
			if(	mov_btn.mx > mov_btn.img.x &&
				mov_btn.mx < mov_btn.img.x + mov_btn.img.width &&
				mov_btn.my > mov_btn.img.y &&
				mov_btn.my < mov_btn.img.y + mov_btn.img.height)
			{
				dirX = mov_btn.mx; 
				dirY = mov_btn.my;
			}
			mov_btn.dot_mc.x -= (mov_btn.dot_mc.x-dirX)*0.2;
			mov_btn.dot_mc.y -= (mov_btn.dot_mc.y-dirY)*0.2;
			
			//bg
			if(mov_btn.bg_mc.scaleX != 1.1) return;
			dirY = (mov_btn.mx/mov_btn.plane_mc.width)*14;
			dirY -= 7;
			mov_btn.bg_mc.rotationY -= (mov_btn.bg_mc.rotationY-dirY)*0.05;
			dirX = (mov_btn.mx/mov_btn.plane_mc.width)*20; 
			dirX += (940/2)+30;
			mov_btn.bg_mc.x -= (mov_btn.bg_mc.x - dirX)*0.05;
		}
		
		/**	버튼 뒤로 가기	*/
		private function onEnterBtnPrev(e:Event):void
		{
			dot_mc.prevFrame();
			if(dot_mc.currentFrame == 1) dot_mc.removeEventListener(Event.ENTER_FRAME,onEnterBtnPrev);
		}
		/**	버튼 클릭	*/
		private function onClickBtn($mc:MovieClip):void
		{
			/**	인터넷 접속 상태 검사	*/
			var errorPop:ErrorPopup = new ErrorPopup();
			
			onOutBtn($mc);
			if(movPos == 0)
			{
				DataProvider.track.check2("101");
				TweenMax.to(ctl_mc.bar_mc,0.5,{y:0});
				TweenMax.to(ctl_mc.txt_mc,0.5,{y:0});
			}
			if(movPos%3 == 0 )
			{
				viewBlurObj(pop_mc,null,null,0);
			}
			playNextMov();
		}
		/**
		 * 팝업 	(완료 팝업만 수행)
		 * */
		private function setPop():void
		{
			// ExternalInterface.call( "alert", "2 setPop" );
			if(movPos != movAry.length-1) return;
			
			// ExternalInterface.call( "alert", "21 setPop" );
			
			var menuName:Array = ["btnX","btn","btn_evt"];
			for(var i:int = 0; i<menuName.length; i++)
			{
				var btn:MovieClip = pop_mc[menuName[i]];
				if(btn == null) continue;
				btn.idx = i;
				btn.alpha = 0;
				trace( " btn "+btn )
				trace( "//////////////////   setPop  ////////" );
				if(i == 0) var ba:BtnAlpha = new BtnAlpha(btn,{alpha:0.7,click:onClickPop});
				else setBaseBtn(btn,onClickPop);
				
			}
		}
		private function viewPop():void
		{
			pop_mc.alpha = 0;
			pop_mc.plane_mc.visible = true;
			if(movPos == movAry.length-1)
			{	//완료 팝업
				pop_mc.gotoAndStop("complete");	
				pop_mc.btn.alpha = 0;
				// ExternalInterface.call( "alert", "0 complete" );
				viewBlurObj(pop_mc,finishPop);
//				DataProvider.track.check2("102");
			}
			else
			{	//스텝 부분 팝업 
				var bubble:MovieClip = pop_mc.bubble_mc as MovieClip;
				bubble.txt1.text = popAry[movPos/3]+" 미션 성공";
				bubble.txt2.autoSize = TextFieldAutoSize.LEFT;
				bubble.txt2.text = Math.round((movPos/(movAry.length-1))*100)+"%";
				
				SetText.space(bubble.txt1,{letter:-1});
				SetText.space(bubble.txt2,{letter:0});
				
				var dirX:int = Math.round((pop_mc.plane_mc.width/(movAry.length-1))*movPos);
				bubble.x = dirX-50;
				TweenMax.to(bubble,0.5,{x:dirX});
				pop_mc.plane_mc.visible = false;
				pop_mc.alpha = 1;
				pop_mc.filters = null;
				bubble.alpha = 0;
				pop_mc.visible = true;
				TweenMax.to(bubble,0.5,{alpha:1,onComplete:finishPop});
			}
		}
		private function finishPop():void
		{
			
			// ExternalInterface.call( "alert", "1 finishPop" );
			setPop();
			
			
			/*
			if(movPos == movAry.length-1) return;
			var dirW:int = Math.round((movPos/8)*pop_mc.bar_bg.width);
			TweenMax.to(pop_mc.bar_mc,0.5,{width:dirW,alpha:1});
			*/
		}
		private function onClickPop($mc:MovieClip):void
		{
//			if(movPos == movAry.length-1 && $mc.name == "btn")
//			{
////				DataProvider.loader.navi.clickMenu(0,1);
//				trace($mc.name);
//			}
//			else if($mc.name == "btn_evt")
//			{
////				DataProvider.loader.navi.clickMenu(1,0);
//				trace($mc.name);
////				DataProvider.popup.viewPop("holding",{});
//			}
//			else 
//			{
				DataProvider.pos1 = 1;
				DataProvider.pos2 = 1;
				DataProvider.loader.loadSub();
				
//				playNextMov();
				viewBlurObj(pop_mc,null,null,0);
//			}
		}
		/**
		 * 이벤트 등록
		 * */
		public function sendWrite():void
		{
//			write.send(null,URLRequestMethod.GET);
		}
		private function onWrite($result:String):void
		{
			switch($result)
			{
			case "-2" :	//로그인 필요
				DataProvider.callBack.state = DataProvider.callBack.EVT1;
				DataProvider.callLogin("evt1");
				break;
			case "-9" :	//시스템 오류
//				DataProvider.popup.viewPop("alert",{txt:"시스템 오류."});
				break;
			case "1" :	//등록 완료
				viewPop();
				break;
			}
		}
		
	}//class
}//package