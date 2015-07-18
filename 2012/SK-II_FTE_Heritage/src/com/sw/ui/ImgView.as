package com.sw.ui
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.sw.display.Remove;
	import com.sw.net.FncOut;
	import com.sw.utils.McData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**	이미지 로드 후 스크롤해서 보는 클래스	*/
	public class ImgView
	{
		/**	호출 위치 스코프	*/
		private var scope:Object;
		/**	초기 데이터 내용	*/
		private var data:Object;
		/**	이미지 마스크	*/
		private var mask:MovieClip;
		/**	스크롤 mc	*/
		private var scroll:MovieClip;
		/**	스크롤 dot_mc	*/
		private var dot:MovieClip;
		
		
		/**	이미지 mc	*/
		private var img:MovieClip;
		/**	이미지 경로 내용 ary	*/
		private var imgAry:Array;
		/**	이미지 mc내용 ary	*/
		private var imgMcAry:Array;
		/**	이미지 정렬 방식	*/
		private var align:String;
		/**	이미지 부드럽게 처리여부	*/
		private var smooth:Boolean;
		
		/**	로딩 표현	*/
		private var loading:Object;
		
		/**	이미지 불러올 로더	*/
		private var loader:LoaderMax;
		/**	목표 위치	*/
		private var dirY:int;
		/**	드래그 스피스 0~1	*/
		private var speed:Number;
		/**	전체 이미지의 리사이즈	*/
		private var resize:String;
		/**	스크롤 최대 값	*/
		private var scrollMax:Number;
		/**	휠정도 정도	*/
		private var wheel:int;
		/**	윈도우 휠을 제어할지 여부	*/
		private var winWheel:Boolean;
		
		/**
		 * 생성자
		 * @param $scope		::		전체 내용이 있는 obj
		 * @param $imgAry			::		이미지 내용 array
		 * @param $data			::		<br>
		 * scroll :	스크롤 <br>
		 * img 	:	이미지 <br>
		 * mask	:	마스크<br>
		 * loading:	로딩 클래스<br>
		 * complete	: 로드 완료후 수행함수 ()<br>
		 * wheel :		휠 정도 <br>
		 * speed :		드래그 스피드 <br>
		 * ex : new ImgView(view,imgAry,{speed:0.5,<br>
		 * 								img:img_mc,mask:view.mask_mc,<br>
											loading:loading,<br>
											enter:checkView,<br>
											wheel:20,<br>
											complete:onLoadComplete});
		 */
		public function ImgView($scope:Object,$imgAry:Array,$data:Object)
		{
			scope = $scope;
			imgAry = $imgAry;
			if($data == null)
			{
				trace("오류 :ImgView의 $data가 없습니다");
				return;
			}
			data = $data;
			
			scroll = (data.scroll != null) ? (data.scroll) : (scope.scroll_mc);
			img = (data.img != null) ? (data.img) : (scope.img_mc);
			mask = (data.mask != null) ? (data.mask) : (scope.mask_mc);
			align = (data.align != null) ? (data.align) : ("down");
			resize = (data.resize != null) ? (data.resize) : ("none");
			loading = (data.loading != null) ? (data.loading) : (null);
			speed = (data.speed != null) ? (data.speed) : (1);
			wheel = (data.wheel != null) ? (data.wheel) : (20);
			smooth = (data.smooth != null) ? (data.smooth) : (true);
			winWheel = (data.winWheel != null) ? (data.winWheel): true;
			if(img == null || mask == null)
			{
				trace("오류 :ImgView의 데이터가 부족합니다.");
				return;
			}
			init();
		}
		/**	소멸자	*/
		public function destroy():void
		{	
			destroyScroll();
			destroyWheel();
			scope.removeEventListener(MouseEvent.MOUSE_OVER,onOverScope);
			scope.removeEventListener(MouseEvent.MOUSE_OUT,onOutScope);
			
			loader.unload();		
			if(loading != null) loading.hideLoading();
			Remove.all(img);
			
			//trace("ImgView 소멸자");
		}
		
		/**	목표 위치 값 반환	*/
		public function get dir():int
		{	return dirY;	}
		/**
		 * 초기화
		 * */
		private function init():void
		{
			img.mask = mask;
			dot = scroll.dot_mc;
			
			setDotHeight();
			
			//로딩바가 있을경우
			if(loading != null)
				loader = new LoaderMax({name:"imgLoader",onProgress:loading.onProgress,onComplete:onComplete});
			else loader = new LoaderMax({name:"imgLoader",onComplete:onComplete});
			
			for(var i:int=0; i<imgAry.length; i++)
			{
				loader.append(new ImageLoader(imgAry[i],{name:"img"+i,container:img}));
			}
		}
		
		/**	스크롤바 높이 설정	*/
		public function setDotHeight():void
		{
			scrollMax = Math.round(scroll.bg_mc.height - dot.height);			//스크롤 최대 값 적용
		}
		
		/**	로드 시작	*/
		public function load():void
		{
			//trace("ImgView imgAy:",imgAry);
			if(loading != null) loading.viewLoading();
			loader.load();	
		}	
			
		/**
		 * 이미지 로드 완료
		 * */
		private function onComplete(e:LoaderEvent):void
		{
			if(loading != null) loading.hideLoading();
			
			imgMcAry = [];
			for(var i:int=0; i<imgAry.length; i++)
			{
				imgMcAry.push(ImageLoader(loader.getLoader("img"+i)).rawContent);
			}
			alignImg();
			doingScroll();
		}
		/**
		 * 스크롤 적용 되서 움직이기
		 * */
		public function doingScroll():void
		{
			destroyScroll();
			destroyWheel();
			
			if(img.height <= mask.height)
			{
				//destroyScroll();
				//destroyWheel();
			}
			else 
			{
				setScroll();
				//setWheel();
				scope.addEventListener(MouseEvent.MOUSE_OVER,onOverScope);
				scope.addEventListener(MouseEvent.MOUSE_OUT,onOutScope);
			}
			if(data.complete != null) data.complete();		
		}
		/**
		 * 이미지 정렬
		 * */
		private function alignImg():void
		{
			var i:int;
			for(i=1; i<imgAry.length; i++)
			{
				switch(align)
				{
				case "down" :	//아래로 정렬
					imgMcAry[i].y = imgMcAry[i-1].y+imgMcAry[i-1].height;
				break;
				}
			}
			/*
			var myBit:BitmapData = new BitmapData(img.width,img.height,false,0x00ffffff);
			myBit.draw(img);
			var bit:Bitmap = new Bitmap(myBit);
			for(i=0; i<img.numChildren; i++)
				img.removeChild(img.getChildAt(i));
			loader.unload();
			img.addChild(bit);
			*/
			if(resize == "width")
			{
				McData.save(img);
				img.width = mask.width;
				img.height = (img.dh/img.dw)*img.width;
			}
			img.x = Math.round((mask.width - img.width)/2)+mask.x;
			img.mask = mask;
		}
		/**	해당 오브 젝트에 휠 적용	*/
		private function setWheel():void
		{
			if(winWheel == true)
				SWFWheel.initialize(scroll.stage);//.initialize(scroll.stage);
			destroyWheel();
			if(winWheel == true)
				SWFWheel.browserScroll = false;
			
			scroll.stage.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
		}
		/**	해당 오브 젝트에 휠 해제	*/
		private function destroyWheel():void
		{
			if(winWheel == true)
				SWFWheel.browserScroll = true;
			if(scroll == null || scroll.stage == null) return;
			
			//while(scroll.stage.hasEventListener(MouseEvent.MOUSE_WHEEL) == true)
			scroll.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
		}
		private function onOverScope(e:MouseEvent):void
		{	setWheel();			}
		private function onOutScope(e:MouseEvent):void
		{	destroyWheel();	}
		/**
		 * 휠 내용
		 * */
		private function onWheel(e:MouseEvent):void
		{
			if(img.height < mask.height) return;
			//FncOut.call("alert","휠");
			/*
			var scope_sp:Sprite = Sprite(scope);
			if(scope_sp.mouseX < 0 ||
				scope_sp.mouseX > scope_sp.width ||
				scope_sp.mouseY < 0 ||
				scope_sp.mouseY > scope_sp.height)
			{	//마우스가 자신 영역에 있지 않을때는 브라우져로 이벤트 넘김
				SWFWheel.browserScroll = true;
				return;
			}
			else SWFWheel.browserScroll = false;
			*/
			/*if(e.delta>0)
			{
			moveDot(dot.y-(scrollMax/wheel));
			}
			else
			{
			moveDot(dot.y+(scrollMax/wheel));
			}*/
			
			var num:Number = mask.height/3;
			var degreeWh:Number = (num/img.height)*scrollMax;
			if(e.delta>0)
			{
				moveDot(dot.y-degreeWh);
			}
			else
			{
				moveDot(dot.y+degreeWh);
			}
			onClick(new MouseEvent(MouseEvent.CLICK));
		}
		/**
		 * 스크롤 셋팅
		 * */
		private function setScroll():void
		{
			TweenMax.to(scroll,0.5,{alpha:1,ease:Expo.easeIn});
			var dot:MovieClip = scroll.dot_mc as MovieClip;
			dot.buttonMode = true;
			scroll.dot_mc.y=0;
			if(scroll.bar_mc != null) scroll.bar_mc.height = 1 ;
			scroll.dot_mc.addEventListener(MouseEvent.MOUSE_DOWN,onPress);
			scroll.dot_mc.addEventListener(MouseEvent.CLICK,onClick);
		}
		/**
		 * 스크롤 기능 삭제
		 * */
		private function destroyScroll():void
		{
			if(scroll == null) return;
			TweenMax.to(scroll,0.5,{alpha:0,ease:Expo.easeIn});
			scroll.dot_mc.removeEventListener(MouseEvent.MOUSE_DOWN,onPress);
			scroll.dot_mc.removeEventListener(MouseEvent.CLICK,onClick);
		}
		/**
		 * 스크롤 시작
		 * */
		private function onPress(e:MouseEvent):void
		{
			scroll.gapY = scroll.dot_mc.y - scroll.mouseY;
			scroll.removeEventListener(Event.ENTER_FRAME,onEnter);
			scroll.addEventListener(Event.ENTER_FRAME,onEnter);
			scroll.stage.addEventListener(MouseEvent.MOUSE_UP,onClick);
		}
		/**
		 * 스크롤 끝
		 * */
		private function onClick(e:MouseEvent):void
		{
			scroll.stage.removeEventListener(MouseEvent.MOUSE_UP,onClick);
			scroll.removeEventListener(Event.ENTER_FRAME,onEnter);
			TweenMax.to(img,0.5,{y:dirY});
			
			if(data.enter) data.enter();
		}
		/**	외부에서 스크롤 멈추기	*/
		public function stopScroll():void
		{
			scroll.stage.removeEventListener(MouseEvent.MOUSE_UP,onClick);
			scroll.removeEventListener(Event.ENTER_FRAME,onEnter);
		}
		/**
		 * 스크롤 중
		 * */
		private function onEnter(e:Event):void
		{
			moveDot(scroll.mouseY+scroll.gapY);
			img.y -= (img.y - dirY)*speed; 
			
			if(data.enter) data.enter();
		}
		/**	스크롤 dot 움직이고 이미지 목표 위치 값 적용	*/
		private function moveDot($num:Number):void
		{
			dot.y = $num;
			dot.y = limitPos(dot.y);
			var bar:MovieClip = scroll.bar_mc;
			if(bar != null) bar.height = dot.y;
			dirY = (dot.y/scrollMax)*-(img.height-mask.height);
		}
		/**
		 * 스크롤 최대, 최소 값에 의해서 결과 값 반환
		 * @param $num	:: 비교 대상 값
		 * @return 		:: 비교 후 값
		 */
		private function limitPos($num:Number):int
		{
			var num:Number = $num;
			if(num < 0) num =0;
			if(num > scrollMax) num = scrollMax;		
			return Math.round(num);		
		}
		/**
		 * 이미지 등장 모션
		 * */
		public function introImg():void
		{
			img.visible = true;
			img.alpha = 0;
			img.y=-200;
			TweenMax.to(img,0.4,{alpha:1,ease:Expo.easeIn,overwrite:2});
			TweenMax.to(img,0.7,{y:0,ease:Expo.easeOut});			
		}
	}//class
}//package