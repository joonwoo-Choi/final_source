package com.sk2.net
{
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.sk2.clips.E_Shop_listClip;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.display.Remove;
	import com.sw.net.FncOut;
	import com.sw.net.list.BaseList;
	import com.sw.utils.SetText;
	
	import flash.display.MovieClip;
	import flash.net.URLRequestMethod;

	/**
	 * SK2	::	E-shop리스트 내용
	 * */
	public class E_SHOP_LIST extends BaseList
	{
		private var listCnt:int;
		private var listAry:Array;
		private var bannerLoader:ImageLoader;
		private var banner_mc:MovieClip;
		
		/**	생성자	*/
		public function E_SHOP_LIST($scope:Object, $url:String, $data:Object)
		{
			super($scope, $url, $data);
			init();
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
		}
		/**
		 * 초기화
		 * */
		override protected function init($bLoad:Boolean = true):void
		{
			cbk_onLoad = onLoad;
			super.init();
			pageSize = 3;
			xml_listTotal = "recordCount";
			xml_pageCnt = "pageCount";
			banner_mc = data.banner;
			if(banner_mc == null) return;
			banner_mc.alpha = 0;
			/*
			var bannerImg:String = "image/eshop/banner.jpg";
			//	특정 날짜에 다른 링크
			var date:Date = new Date();
			if(date.getDate() == 17) bannerImg = "image/eshop/banner110117.jpg";
			*/
			var bannerImg:String = "image/eshop/banner110117.jpg";
			bannerLoader = new ImageLoader(	DataProvider.rootURL+bannerImg,
											{	name:"bannerDoc",
												container:banner_mc,
												onComplete:onLoadBanner});
			bannerLoader.load();
		}
		/**	banner이미지 로드 완료	*/
		private function onLoadBanner(e:LoaderEvent):void
		{
			banner_mc.alpha = 1;
			//TweenMax.to(banner_mc,0.5,{alpha:1});
			Button.setUI(banner_mc,{click:onClickBanner});
			if(data.playRipple != null) data.playRipple();
		}
		private function onClickBanner($mc:MovieClip):void
		{	/*
			var bannerLink:String = "http://www.lotte.com/planshop/viewPlanShopDetail.lotte?spdp_no=1722588";
			//	특정날짜에 다르게 링크	
			var date:Date = new Date();
			if(date.getDate() == 17) bannerLink = "http://mall.shinsegae.com/display/planshop.do?method=getTemplateShop&shop_id=10044715";
			*/
			//var bannerLink:String = "http://mall.shinsegae.com/display/planshop.do?method=getTemplateShop&shop_id=10044715";
			//var bannerLink:String = "http://www.lotteimall.com/proshop/emp_sk2/LgrpShop.jsp";
			var bannerLink:String =
				"http://www.lotte.com/goods/viewGoodsDetail.lotte?goods_no=769251&infw_disp_no_sct_cd=10&infw_disp_no=1331137&conr_no=77";
			FncOut.link(bannerLink,"_blank");
		}
		/**
		 * 리스트 내용 가져오기
		 * @param $date		:: 날짜 값
		 */
		public function loadList($date:String):void
		{
			load({dateDay:$date},URLRequestMethod.GET);
		}
		/**
		 * 리스트 내용 가져오고 난후
		 * */
		/**	리스트 내용이 없을때	*/
		override protected function onNoneList():void
		{	
//			DataProvider.popup.viewPop("alert",{txt:"진행중인 이벤트가 없습니다."});	
			Remove.child(scope);
		}
		/***/
		protected function onLoad($xml:XML):void
		{
			//FncOut.call("alert",$xml);
			Remove.child(scope);
			scope.alpha = 0;
			listAry = [];
			
			listCnt = $xml.dataList.EShopList.length();
			var i:int;
			for(i=0; i<listCnt; i++)
			{	
				var cXml:XML = $xml.dataList.EShopList[i];
				var date1:String = SetText.change(cXml.beginDate.toString(),"-",".");
				var date2:String = SetText.change(cXml.endDate.toString(),"-",".");
				
				var list:E_Shop_listClip = new E_Shop_listClip(cXml.linkUrl);
				listAry.push(list);
				list.txt1.text = cXml.eshopName.toString();
				list.txt2.text = date1+" ~ "+date2.substr(5);
				list.txt3.text = cXml.eshopContents.toString();
				
				if(list.txt3.text.length > 45) list.txt3.text = list.txt3.text.substr(0,45)+"...";
				SetText.space(list.txt3,{letter:-0.5});
				
				list.btn.visible = false;
				list.mask_mc.width = list.width;
				list.y = i*(list.height-1);
				/*
				list.alpha = 0;
				TweenMax.to(list,1-(i*0.3),{delay:i*0.05,alpha:1});
				TweenMax.to(list.mask_mc,1-(i*0.3),{delay:i*0.05,width:list.width,onComplete:finishList,onCompleteParams:[list]});
				*/
				scope.addChild(list);
			}
			DataProvider.baseSub.viewBlurObj(MovieClip(scope),finishList);
		}
		//private function finishList($list:E_Shop_listClip):void
		private function finishList():void
		{
			//$list.btn.visible = true;
			for(var i:int=0; i<listCnt; i++)
			{
				listAry[i].btn.visible = true;	
			}
		}
	}//class
}//package