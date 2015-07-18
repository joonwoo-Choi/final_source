package com.sk2.net
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.utils.SetFont;
	import com.sw.utils.SetText;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * SK2 :: 후기 이베트 리스트 내용
	 * */
	public class EVT2_LIST extends EVT1_LIST
	{
		public var rmd:String;
		/**	리스트 모션 여부	*/
		public var bMotion:Boolean;
		
		/**	생성자	*/
		public function EVT2_LIST($scope:Object, $url:String, $data:Object)
		{
			super($scope, $url, $data);
			bMotion = true;
			//pageCnt = -1;
		}
		
		/**
		 * 초기화
		 * */
		override protected function init($bLoad:Boolean = true):void
		{
			super.init(false);
			pageSize = 7;
			//if(pageCnt > 0 && pageCnt != -1) 
				loadList();
		}
		/**	리스트 내용 로드	*/
		override public function loadList():void
		{
			var txt:String = search_txt.text;
			if(txt == base_search) txt = "";
			//if(rmd == "bn")
				load({schString:txt,rmd:rmd},URLRequestMethod.GET);
			//else
			//	load({schString:txt},URLRequestMethod.GET);
			
		}
		/**	로드 데이터 초기화	*/
		override public function resetData():void
		{
			super.resetData();
			rmd = "";
		}
		
		/**	로드 완료 후 수행 함수	*/
		override protected function onLoad($xml:XML):void
		{
			scope.list_mc.alpha = 1;
			if(bMotion == false)
			{	//모션 없이 리스트 내용 바로 보여지기
				viewList($xml);
				return;
			}
			var i:int;
			for(i =0; i<pageSize; i++)
			{
				var list:MovieClip = list_mc["list"+(i+1)];
				TweenMax.to(list,1,{alpha:0});
			}
			TweenMax.to(scope.list_mc,1,{x:-688,ease:Back.easeOut,onComplete:viewList,onCompleteParams:[$xml]});
			
			data.playRipple();
		}
		private function viewList($xml:XML):void
		{
			bMotion = true;
			
			scope.list_mc.x = 151;
			var listCnt:int = $xml.dataList.EventData.length();
			var i:int; 
			//trace($xml);
			for(i =0; i<pageSize; i++)
			{
				var cXml:XML = $xml.dataList.EventData[i];
				var list:MovieClip = list_mc["list"+(i+1)];
				
				if(i >= listCnt) 
				{	list.visible = false;	continue;	}
				
				//메달 설정
				if(pageNo == 1 && rmd != "bn" && i<3)
				{
					list.medal_mc.visible = true;
					list.medal_mc.gotoAndStop(i+1);
				}
				else list.medal_mc.visible = false;
				
				
				list.idx = cXml.idx.toString();
				
				//동감 적용
				var num:int = int(cXml.recommend.toString());
				var txt_idx:TextField = list.txt_idx as TextField;
				txt_idx.text = SetText.plus0(num);
				if(txt_idx.text.length < 3) txt_idx.text = "0"+txt_idx.text;
				txt_idx = SetFont.getIns().go(txt_idx,{font:"YDIYSin",size:15});
				
				//아이디 적용
				list.txt_id.text = String(cXml.uid.toString()).toLocaleUpperCase()+" 님의\n피테라 에센스 후기";
				SetFont.getIns().go(list.txt_id,{font:"YDIYSin",size:11,leading:3});
				var tf:TextFormat = new TextFormat();
				tf.color = 0x941E22;
				TextField(list.txt_id).setTextFormat(tf,0,String(cXml.uid.toString()).length);
				
				while(MovieClip(list.img_mc).numChildren != 1)
				{
					MovieClip(list.img_mc).removeChild(MovieClip(list.img_mc).getChildAt(1));
				}
				//썸네일 이미지 가져오기
				if(cXml.upimage.toString() != "")
				{
					var loader:ImageLoader = 
						new ImageLoader(DataProvider.dataURL+cXml.upimage.toString(),{container:list.img_mc,onComplete:onLoadThumb});
					loader.load();
				}
				//trace(MovieClip(list.img_mc).numChildren);
				
				//trace(DataProvider.dataURL+cXml.upimage.toString());
				Button.setUI(list,{over:onOverList,out:onOutList,click:onClickList});
				list.visible = true;
				TweenMax.killChildTweensOf(list);
				
				//list.addChild(list.plane_mc);
				
				//등장 모션
				TweenMax.to(list,0,{delay:0,alpha:0});
				TweenMax.to(list,1-(i*0.05),{delay:i*0.05,alpha:1});
			}
		}
		/**	썸네일 이미지 로드 완료	*/
		private function onLoadThumb(e:LoaderEvent):void
		{
			var loader:ImageLoader = e.target as ImageLoader;
			var bit:Bitmap = loader.rawContent as Bitmap;
			var mask_mc:MovieClip = list_mc.list1.mask_mc as MovieClip;
			//trace(mask_mc);
			var dw:Number = bit.width;		var dh:Number = bit.height;
			bit.smoothing = true;
			bit.width = mask_mc.width;
			bit.height = (dh/dw)*mask_mc.width;
			if(bit.height < mask_mc.height)
			{
				bit.height = mask_mc.height;
				bit.width = (dw/dh)*mask_mc.height;
			}
			bit.x = Math.round((mask_mc.width - bit.width)/2);
			bit.y = Math.round((mask_mc.height - bit.height)/2);
		}
		/**	리스트 마우스 오버	*/
		private function onOverList($mc:MovieClip):void
		{
			TweenMax.to($mc.img_mc,0.7,{scaleX:1.1,scaleY:1.1,x:7,y:75,ease:Expo.easeOut});
		}
		/**	리스트 마우스 아웃	*/
		private function onOutList($mc:MovieClip):void
		{
			TweenMax.to($mc.img_mc,0.7,{scaleX:1,scaleY:1,x:12,y:80,ease:Expo.easeOut});
		}
		/**	리스트 클릭	*/
		private function onClickList($mc:MovieClip):void
		{
			DataProvider.callBack.state = "none";
			FncOut.call("piteraMenu.postView",$mc.idx);
		}
		
	}//class
}//package