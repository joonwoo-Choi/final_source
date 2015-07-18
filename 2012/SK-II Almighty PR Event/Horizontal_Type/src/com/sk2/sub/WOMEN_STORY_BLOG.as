package com.sk2.sub
{
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.AlignMode;
	import com.greensock.loading.XMLLoader;
	import com.sk2.clips.BlogClip;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.ui.ImgView;
	import com.sw.utils.SetText;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * SK2	::	파워 블로거 페이지
	 * */
	public class WOMEN_STORY_BLOG extends BaseSub
	{
		private var xmlLoader:XMLLoader;
		private var xml:XML;
		
		
		private var list_imgView:ImgView;
		private var img_list:MovieClip;
		private var list_mc:MovieClip;
		
		private var imgView:ImgView;
		private var imgView_mc:MovieClip;
		private var img_mc:MovieClip;
		
		private var cList:BlogClip;
		private var btnAry:Array;
		
		/**	생성자	*/
		public function WOMEN_STORY_BLOG($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
		}
		/**
		 * 물결 효과 주기 전 셋팅
		 * */
		override public function setRipple():void
		{
			setBtn();
			imgView_mc = scope_mc.imgView_mc;
			img_list = scope_mc.img_list;
			
			/*
			scope_mc.txt1.autoSize = TextFieldAutoSize.LEFT;
			scope_mc.txt2.autoSize = TextFieldAutoSize.LEFT;
			scope_mc.txt1.text = "";
			scope_mc.txt2.text = "";
			*/
			
			list_mc = new MovieClip();
			img_list.addChild(list_mc);
			list_imgView = new ImgView(	img_list,[],
										{	scroll:img_list.scroll_mc,
											mask:img_list.mask_mc,
											img:list_mc,speed:0.1});
			
			xmlLoader = new XMLLoader(DataProvider.rootURL+"xml/blogList.xml",{name:"xmlDoc",onComplete:onLoadXml});
			xmlLoader.load();
		}
		/**
		 * 초기화
		 * */
		override public function init():void
		{
			onOverList(cList);
		}
		/**	xml 불러오고 난후	*/
		private function onLoadXml(e:LoaderEvent):void
		{
			xml = xmlLoader.content as XML;
			//trace(xml);
			
			var cnt:int = xml.blog.list.length();
			for(var i:int = 0; i<cnt; i++)
			{
				var cXml:XML = xml.blog.list[i];
				var list:BlogClip = new BlogClip();
				list.idx = i;
				list.link_name = cXml.@link.toString();
				list.img_name = cXml.@img.toString();
				list.scrap = cXml.@scrap.toString();
				list.setText(cXml.@name1.toString(),cXml.@name2.toString());
				
				list.y = (list.height-1)*i;
				
				list.plane_mc.alpha = 0;
				list.plane_mc.height = 5;
				list.plane_mc.y = 15;
				Button.setUI(list,{over:onOverList,out:onOutList,click:onClickList});
				
				if(i == 0) cList = list;
				list_mc.addChild(list);
				
			}
			list_imgView.doingScroll();
			
			onClickList(cList);
		}
		/**
		 * 리스트 버튼화	
		 * */
		private function onOverList($mc:MovieClip):void
		{	
			TweenMax.to(cList.plane_mc,0.5,{alpha:0,height:5,y:15});
			TweenMax.to($mc.plane_mc,0.5,{alpha:1,height:$mc.height,y:0});	
		}
		private function onOutList($mc:MovieClip):void
		{	
			TweenMax.to($mc.plane_mc,0.5,{alpha:0,height:5,y:15});	
			TweenMax.to(cList.plane_mc,0.5,{alpha:1,height:$mc.height,y:0});
		}
		private function onClickList($mc:BlogClip):void
		{
			//trace($mc);
			cList = $mc;
			
			if(bRipple == true)
			{	//물결등장 후에는 알파 값으로 모션 적용
				var dx:int = img_mc.x;
				TweenMax.to(img_mc,0.5,{alpha:0,x:dx+10,onComplete:setImg});
				//TweenMax.to(scope_mc.txt1,0.5,{alpha:0,onComplete:finishTxt});
				//TweenMax.to(scope_mc.txt2,0.5,{alpha:0});
				return;
			}
			//finishTxt();
			setImg();
		}
		private function finishTxt():void
		{
			scope_mc.txt1.text = cList.txt1.text;
			scope_mc.txt2.text = cList.txt2.text;
			SetText.space(scope_mc.txt1,{letter:-1});
			SetText.space(scope_mc.txt2,{letter:0});
			scope_mc.txt2.x = scope_mc.txt1.x + scope_mc.txt1.width;
			
			TweenMax.to(scope_mc.txt1,0.5,{alpha:1});
			TweenMax.to(scope_mc.txt2,0.5,{alpha:1});
			
		}
		/**	이미지 셋팅	*/	
		private function setImg():void
		{
			if(imgView != null) 
			{
				imgView.destroy();
				imgView = null;
			}
			
			var imgAry:Array = cList.img_name.split("||");
			
			for(var i:int =0; i<imgAry.length; i++)
			{	imgAry[i] = DataProvider.rootURL+"image/blog/"+imgAry[i];	}
			
			img_mc = new MovieClip();
			imgView_mc.addChild(img_mc);			
			
			imgView = new ImgView(	imgView_mc,imgAry,
										{	scroll:imgView_mc.scroll_mc,
											mask:imgView_mc.mask_mc,
											img:img_mc,
											speed:0.3,
											resize:"width",
											complete:onLoadImg});
			imgView.load();
		}
		/**		
		 * 이미지 로드 완료	
		 * */
		private function onLoadImg():void
		{
			imgView_mc.scroll_mc.alpha = 1;
			playRipple();
			if(bRipple == true)	
			{
				img_mc.alpha = 0;
				var dx:int = img_mc.x;
				img_mc.x = dx-10;
				TweenMax.to(img_mc,1,{alpha:1,x:dx});
			}
		}
		/**	버튼	*/
		private function setBtn():void
		{
			btnAry = ["scrap_btn1","scrap_btn2","scrap_btn3","link_btn"];
			for(var i:int = 0; i<btnAry.length; i++)
			{
				var btn:MovieClip = btnAry[i] = scope_mc[btnAry[i]];
				btn.idx = i;
				if(i==3) continue;
				Button.setUI(btn,{click:onClickBtn});
			}	
			setBaseBtn(btn,onClickBtn);
		}
		private function onClickBtn($mc:MovieClip):void
		{
			switch($mc.idx)
			{
			case 0:		//트위터
				FncOut.call("piteraMenu.scrapPiteraToTwitter","bloger",cList.scrap);
				break;
			case 1:		//페이스북
				FncOut.call("piteraMenu.scrapPiteraToFacebook","bloger",cList.scrap);
				break;
			case 2:		//미투데이
				FncOut.call("piteraMenu.scrapPiteraToMe2day","bloger",cList.scrap);
				break;
			case 3:		//원문 보러 가기
				FncOut.link(cList.link_name,"_blank");
				break;
			}
		}	
	}//class
}//package