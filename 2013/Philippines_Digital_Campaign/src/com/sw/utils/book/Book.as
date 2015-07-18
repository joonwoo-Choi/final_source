package com.sw.utils.book
{
	//============================================================================//
	//									책장 넘기는 소스 클래스												//
	//============================================================================//
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.sw.display.SetBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Book extends Sprite
	{
		public var bookMove:BookMove;			//이동 내용
		public var bookNavi:BookNavi;			//제어 버튼
		public var scope_mc:MovieClip			//imgTotal 무비클립
		public var UI_mc:MovieClip;			//컨트롤 MovieClip
		public var pages:MovieClip;			//페이지 내용 MovieClip
		
		public var loader:ImageLoader;		//이미지 로드 해올 로더
		public var load_sp:Sprite;				//이미지 불러와서 임시로 가지고 있을 sprite
		public var load_fnc:Function;			//로딩중 호출할 함수
		public var init_fnc:Function;			//이미지 모두 로드후 호출 함수
		
		public var imgAry:Array;				//이미지 배열
		public var imgCnt:int;					//이미지 로드된 갯수
		
		public var TotalPages:int;				//총 이미지 갯수
		public var pw:Number;					//이미지 넓이
		public var ph:Number;					//이미지 높이
		public var cover:Boolean;				//표지 존재 여부
		
		public var pageAry:Array;				//보여지는 이미지 페이지 배열
		
		public function Book($scope_mc:MovieClip,$data:Object)
		{
			super();
			scope_mc = $scope_mc;
			pages = scope_mc.pages;
			load_fnc = ($data.ing_fnc) ? ($data.ing_fnc) : null;
			init_fnc = ($data.init_fnc) ? ($data.init_fnc) : null;
			imgAry = ($data.img) ? ($data.img) : null;
			UI_mc = ($data.UI) ? ($data.UI) : null;
			pw = ($data.pw) ? ($data.pw) : 467;	
			ph = ($data.ph) ? ($data.ph) : 588;	
			cover = ($data.cover) ? ($data.cover) : (false);
			
			imgCnt = 0;
			
			fN_init();
			
			bookMove = new BookMove(this);
			bookNavi = new BookNavi(this);
		}
		
		public function fN_init():void
		{
			TotalPages = imgAry.length;
			pages.alpha = 1;
			pages.visible = false;
			
			pageAry = [];
			pageAry.push(pages.mainpage);
			pageAry.push(pages.p0);
			pageAry.push(pages.p1);
			pageAry.push(pages.flip.p2);
			pageAry.push(pages.flip.p3);
			pageAry.push(pages.p4);
			
			loadImg();
			load_sp = new Sprite();
			scope_mc.addChild(load_sp);
			load_sp.visible = false;
		}
		//이미지 로드
		public function loadImg():void
		{
			loader = new ImageLoader(imgAry[imgCnt],{name:"loader",container:load_sp,onComplete:onComplete,onProgress:onProgress});
			loader.load();
		}
		//이미지 하나 로드완료
		public function onComplete(e:LoaderEvent):void
		{
			imgCnt++;
			var bitmap:Bitmap = loader.rawContent;
			
			//각각의 페이지 내용에 이미지 비트맵 적용
			for(var i:int=0 ;i<pageAry.length; i++)
			{
				var sp:Sprite = new Sprite();
				sp.name = "page"+imgCnt;
				var bmpData:BitmapData = new BitmapData(bitmap.width,bitmap.height,false,0x00ffffff);
				bmpData.draw(bitmap);
				sp.addChild(new Bitmap(bmpData));
				pageAry[i].page.pf.ph.addChild(sp);
				
				sp.visible = false;
			}
			//모든 이미지 로드 완료
			if(imgCnt >= TotalPages) 
			{	onInit();	return;	}
			
			loadImg();
		}
		//모든 이미지 로드
		public function onInit():void
		{
			if(init_fnc != null) init_fnc();
			scope_mc.removeChild(load_sp);
			scope_mc.pages.visible = true;
			
			bookMove.resetPages();
			bookMove.reset();
		}
		//이미지 로드중
		public function onProgress(e:LoaderEvent):void
		{
			var cData:Number = loader.progress;
			cData = cData+imgCnt;
			if(load_fnc == null) return;
			load_fnc(cData,TotalPages);
		}
	}
}