package com.sk2.net
{
	import com.adqua.net.FONTLoader;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.sk2.display.Layout;
	import com.sk2.display.Resize;
	import com.sk2.fonts.CreB;
	import com.sk2.sub.*;
	import com.sk2.ui.Navi;
	import com.sk2.ui.Popup;
	import com.sk2.utils.DataProvider;
	import com.sw.display.SetBitmap;
	import com.sw.net.BaseConLoader;
	import com.sw.utils.McData;
	import com.sw.utils.Rippler;
	import com.sw.utils.SetText;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	//[Frame(extraClass="com.sk2.sub.E_SHOP_STORY")]
	
	/**
	 * SK2 :: 전체 로드관리 클래스
	 * */
	public class ConLoader extends BaseConLoader
	{
		private var resize:Resize;
		private var layout:Layout;
		private var sub:LoaderMax;
		private var con:SWFLoader;
		private var bg:ImageLoader;
		
		private var ripple:Rippler;
		
		private var sub_mc:MovieClip;
		public var subObj:Object;
		public var navi:Navi;
		
		public var fileName:Array;
		private var cBg:int;
		/**	서브 내용 로드 중인지 여부	*/
		private var bSubLoad:Boolean;
		private var classAry:Array;
		
		/**
		 * 생성자
		 * */
		public function ConLoader()
		{
			super();
			init();
		}
		/**	소멸자	*/
		override public function destroy():void
		{	super.destroy();	}
		/**
		 * 초기화
		 * */
		override protected function init():void
		{
			/*
			trace(	PITERA_STORY_TOUR,
					PITERA_STORY_EPILOGUE,
					PITERA_STORY_EVENT,
					WOMEN_STORY_BLOG,
					WOMEN_STORY_TIP,
					PITERA_ESSENCE_PRODUCT,
					HOW_TO_USE,
					GALLERY,
					E_SHOP_STORY,
					CLEAR_FOR_LIFE);
			*/
			classAry = [PITERA_STORY_TOUR,
						PITERA_STORY_EPILOGUE,
						PITERA_STORY_EVENT,
						WOMEN_STORY_BLOG,
						WOMEN_STORY_TIP,
						PITERA_ESSENCE_PRODUCT,
						HOW_TO_USE,
						GALLERY,
						E_SHOP_STORY,
						CLEAR_FOR_LIFE,
						PUR_LIST,
						PITERA_STORY_EVENT1,
						PITERA_STORY_EVENT2];
			
			//var cla:Class = PITERA_ESSENCE_PRODUCT;
			//trace(getQualifiedClassName(cla));
			var baseSub:BaseSub = new BaseSub(DataProvider.stage);
			
			bSubLoad = false;
			cBg = -1;
			sub = new LoaderMax({name:"subDoc",auditSize:false,onProgress:loadingSub,onComplete:onLoadSub});
			sub.maxConnections = 1;
			
			fileName = [	["PITERA STORY","PITERA_STORY_TOUR","PITERA_STORY_EPILOGUE"],
							//["PITERA EVENT","PITERA_STORY_EVENT"],
							["PITERA EVENT","PITERA_STORY_EVENT","PITERA_STORY_EVENT1","PITERA_STORY_EVENT2"],
							["PITERA ESSENCE STORY","PITERA_ESSENCE_PRODUCT","HOW_TO_USE","WOMEN_STORY_BLOG","GALLERY"],
							["CLEAR FOR LIFE","CLEAR_FOR_LIFE","PUR_LIST","E-SHOP_STORY"]
							//["E-SHOP STORY","E-SHOP_STORY"]		
							];
			
			rootURL = DataProvider.rootURL;
			layout = DataProvider.layout;
			resize = DataProvider.resize;
			
			loader = new LoaderMax({name:"indexDoc",onComplete:onLoadIndex,auditSize:false,onProgress:loadingIndex});
			loader.maxConnections = 1;
			
			loader.append(new SWFLoader(rootURL+"indexObj.swf",{name:"indexObjDoc",onComplete:onLoadIndexObj}));
			var font:FONTLoader = new FONTLoader(rootURL+"font/CreMyungjo_L.swf");
			
			loader.append(font.getLoader());
			//loader.append(font2.getLoader());
			//loader.append(font1.getLoader());
			loader.append(new SWFLoader(rootURL+"Popup.swf",{name:"popDoc",container:layout.pop}));
			loader.append(new SWFLoader(rootURL+"Navi.swf",{name:"naviDoc",container:layout.navi}));
			
			loader.load();
		}
		/**
		 * 로딩바 표현
		 * */	
		override protected function viewLoading():void
		{	
			loading_mc.mask_mc.gotoAndStop(1);
			super.viewLoading();
			
		}
		/**	외부에서 로딩바 보여지기	*/
		public function viewOutLoading():void
		{	viewLoading();	}
		/**	
		 * 외부에서 로딩바 표현	
		 * @param $cData
		 * @param $tData
		 * @return ::로딩 정도 100으로 환산해서 반환
		 */
		public function doingOutLoading($cData:Number,$tData:Number):Number
		{
			var num:int = Math.round(($cData/$tData)*100);
			if(num < 1 || num > 100 || num == 0) return 0;
			loading_mc.mask_mc.gotoAndStop(num);
			//trace("doingOutLoading"+num);
			return num;
		}
		/**	외부에서 로딩바 사라지기	*/
		public function hideOutLoading():void
		{	hideLoading();	}
		
		/**	초기 네비게이션,팝업,등 내용 로딩 내용 표현	*/
		private function loadingIndex(e:LoaderEvent):void
		{
			if(loading_mc == null) return;
			var num:int = Math.round((loader.bytesLoaded/loader.bytesTotal)*50);
			if(num < 1 || num > 100 || num == 0) return;
			loading_mc.mask_mc.gotoAndStop(num);
			
			//trace("loadingIndex"+num);
		}
		/**	서브 내용 로딩 내용 표현	*/
		private function loadingSub(e:LoaderEvent):void
		{
			if(loading_mc == null) return;
			var numMax:int = 100;
			var numBase:int = 0;
			//초기에 로딩시 50부터 시작
			if(subObj == null){ numMax = 50;	numBase = 50;	}
			
			var num:int = Math.round((sub.bytesLoaded/sub.bytesTotal)*numMax);
			num += numBase;
			if(num < 1 || num > 100 || num == 0) return;
			loading_mc.mask_mc.gotoAndStop(num);
			//trace("loadingSub"+num);
		}
		/**
		 * 초기 이미지 로드 완료
		 * */
		private function onLoadIndexObj(e:LoaderEvent):void
		{
			var mc:MovieClip = loader.getLoader("indexObjDoc").rawContent as MovieClip;
			loading_mc = mc.loading_mc;
			layout.loading.addChild(loading_mc);
			resize.resizeBase();
			
			loader.maxConnections = 3;
			
			var font1:FONTLoader = new FONTLoader(rootURL+"font/YDIYSin.swf");
			var font2:FONTLoader = new FONTLoader(rootURL+"font/SDSeokPil.swf");
			font1.getLoader().load();
			font2.getLoader().load();
		}
		/**
		 * 로드 내용 모두 로드 완료
		 * */
		private function onLoadIndex(e:LoaderEvent):void
		{
			//hideLoading();
			//setFont();
			
			var navi_mc:MovieClip = loader.getLoader("naviDoc").rawContent as MovieClip;
			navi = new Navi(navi_mc);
			var pop_mc:MovieClip = loader.getLoader("popDoc").rawContent as MovieClip;
//			DataProvider.popup = new Popup(pop_mc,{lock:layout.lock_plane});
			
			resize.resizePop();
//			resize.resizeNavi();
		}
		/*
		//	폰트 등록
		private function setFont():void
		{
			Font.registerFont(CreB);
			
		}
		*/
		/**
		 * bitmap 적용
		 * */
		private function setBitmap($dirObj:DisplayObject,$bit:Bitmap,$dw:int=-1,$dh:int=-1):void
		{
			$dw = ($dw != -1) ? ($dw) : (resize.sw);
			$dh = ($dh != -1) ? ($dh) : (resize.sh);
			var bitData:BitmapData = new BitmapData($dw,$dh,true,0x00ffffff);
			bitData.draw($dirObj);
			if($bit.bitmapData != null)
			{	
				$bit.bitmapData.dispose();
				$bit.bitmapData = null;
			}
			$bit.bitmapData = bitData;
			TweenMax.to($bit,0,{alpha:1});
			$bit.visible = true;
		}
		/**	bg이미지 내용 모두 로드	*/
		private function onLoadBg(e:LoaderEvent):void
		{
			cBg = DataProvider.pos1;
			var bg_bit:Bitmap = ImageLoader(e.currentTarget).rawContent as Bitmap;
			if(bg_bit == null) return;
			layout.bg_mc.addChild(bg.content);
			
			var bg_mc:MovieClip = layout.bg_mc;
			
			bg_mc.alpha = 0;
			bg_mc.dw = bg_bit.width;
			bg_mc.dh = bg_bit.height;
			
			resize.resizeBg();
			var dirY:int = bg_mc.y;
			//bg_mc.y = dirY-30;
			TweenMax.to(bg_mc,0,{y:dirY-30,alpha:0});
			TweenMax.to(bg_mc,2,{alpha:1,y:dirY,onComplete:finishBg});
		}
		/**	서브 로드 중인지 여부 반환	*/
		public function getLoadSub():Boolean
		{	return bSubLoad;	}
		/**	서브 내용 로드	*/
		public function loadSub():void
		{	
			bSubLoad = true;
			var pos1:int = DataProvider.pos1;
			var pos2:int = DataProvider.pos2;

			//트래킹 체크
			if(pos1 == 2 && pos2 == 1) DataProvider.track.check("202");
			else if(pos1 == 2 && pos2 == 2) DataProvider.track.check("201");
			else DataProvider.track.check(pos1+"0"+pos2);
			
			if(pos1 == 1 && pos2 == 2) DataProvider.track.check2("103");
			
			if(pos1 > 1)
			{
				if(pos1 == 3 && pos2 == 3) DataProvider.track.check2("306");
				else if(pos1 == 3 && pos2 == 4) DataProvider.track.check2("303");
				else DataProvider.track.check2(pos1+"0"+pos2);
			}
			
			
			viewLoading();
			
			TweenMax.killDelayedCallsTo(setSubObj);
			TweenMax.to(layout.sub_in_bit,0,{alpha:layout.sub_in_bit.alpha});
			TweenMax.to(layout.sub_out_bit,0,{alpha:layout.sub_out_bit.alpha});
			
			TweenMax.to(layout.bg_mc,0,{alpha:layout.bg_mc.alpha});
			
			//로더 셋팅
			if(sub_mc != null) 
			{
				if(subObj != null) 
				{
					subObj.destroy();
				}
				setBitmap(layout.bg,layout.bg_bit);
				setBitmap(layout.sub,layout.sub_out_bit,resize.sw+400,resize.sh+400);
				layout.sub_mc.visible = false;
			}
			var txt:String = fileName[DataProvider.pos1-1][DataProvider.pos2];
			
			if(con != null)
			{
				layout.sub_mc.removeChild(con.content);
				con.unload();
				con.dispose();
				con = null;
			}
			
			con = new SWFLoader(rootURL+"sub/"+txt+".swf",{name:"conDoc",container:layout.sub_mc});
			
			sub.remove(bg);
			if(pos1 != cBg || pos1 == 2)
			{
				if(bg != null)
				{
					layout.bg_mc.removeChild(bg.content);
					bg.unload();
					bg.dispose();
					bg = null;
				}
				var bgNum:int = pos1;
				if(pos1 == 2 && pos2 != 1) bgNum = 20+(pos2-1);
				bg = new ImageLoader(rootURL+"image/bg/bg"+bgNum+".jpg",
									{name:"bgDoc",onComplete:onLoadBg});
				
				sub.append(bg);
			}
			
			sub.append(con);
			sub.load();
		}
		/**	con모두 로드 완료 후	*/
		/**	물결 파동 초기화	*/
		private function resetRipple():void
		{
			if(ripple != null)
			{
				ripple.destroy();
				ripple = null;
			}		
		}
		/**
		 * 서브 내용 로드 완료
		 * */
		private function onLoadSub(e:LoaderEvent):void
		{
			hideLoading();
			resize.resizeSub();
			
			var txt:String = fileName[DataProvider.pos1-1][DataProvider.pos2];
			txt = SetText.change(txt,"-","_");
			
			sub_mc = con.rawContent as MovieClip;
			
			if(sub_mc == null)
			{
				return;
				bSubLoad = false;
			}
			//서브 내용 인스 턴스화
			var conClass:Class = getDefinitionByName("com.sk2.sub."+txt) as Class;
			subObj = new conClass(sub_mc,{cbk_ripple:playRipple});
			
			//물결 효과 주기전 초기화 실행
			BaseSub(subObj).setRipple();
			
		}
		/**	파동 움직임 시작	*/
		private function playRipple():void
		{
			setBitmap(layout.sub_mc,layout.sub_in_bit,sub_mc.plane_mc.width,sub_mc.plane_mc.height);
			
			TweenMax.to(layout.sub_in_bit,0,{alpha:0});
			//물결 움직임
			resetRipple();
			ripple = new Rippler(layout.sub_in_bit,20,10);
			ripple.drawRipple(sub_mc.plane_mc.width/2,sub_mc.plane_mc.height/2,30,0.8);
			for(var i:int = 0; i<2; i++)
				ripple.drawRipple(Math.random()*sub_mc.plane_mc.width,Math.random()*sub_mc.plane_mc.height,(Math.random()*5)+14,0.8);
			
			var speed:int = 1;
			var finish_fnc:Function = finishSub;
			if(DataProvider.pos1 == 1 && DataProvider.pos2 == 1) 
			{
				speed = 0.5;
				finish_fnc = setSubObj;
			}
			TweenMax.to(layout.sub_in_bit,speed,{alpha:1,onComplete:finish_fnc,ease:Expo.easeIn});
			TweenMax.to(layout.sub_out_bit,1,{alpha:0,ease:Expo.easeOut});
		
			TweenMax.delayedCall(0.1,function bSubLoadFalse():void{bSubLoad = false;});
		}
		/**
		 * 서브 등장 모션 완료
		 * */
		private function finishSub():void
		{
			TweenMax.delayedCall(1,setSubObj);
			layout.sub_out_bit.visible = false;
		}
		private function setSubObj():void
		{	
			if(subObj != null) subObj.init();
			
			layout.sub_in_bit.visible = false;
			layout.sub_mc.visible = true;
			/**	파동 효과 지우기	*/
			resetRipple();
		}
		/**	배경 등장 모션 완료	*/
		private function finishBg():void
		{	layout.bg_bit.visible = false;	}
		
	}//class
}//package