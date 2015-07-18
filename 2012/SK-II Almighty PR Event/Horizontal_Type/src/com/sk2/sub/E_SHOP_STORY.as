package com.sk2.sub
{
	import com.greensock.TweenMax;
	import com.sk2.clips.DateClip;
	import com.sk2.net.E_SHOP_LIST;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.display.Remove;
	import com.sw.display.SetBitmap;
	import com.sw.utils.SetText;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.FullScreenEvent;

	/**
	 * SK2	::	E_SHOP_STORY
	 * */
	public class E_SHOP_STORY extends BaseSub
	{
		private var list:E_SHOP_LIST;
		private var date:Date;
		private var viewDate:Date;
		private var cDay:DateClip;
		private var date_mc:MovieClip;
		private var dayAry:Array;
		
		private var banner_mc:MovieClip;
		
		/**	생성자	*/
		public function E_SHOP_STORY($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
		}
		/**	소멸자	*/
		override public function destroy():void
		{	
			super.destroy();	
			list.destroy();
		}
		/**	물결 효과 주기 전 셋팅	*/
		override public function setRipple():void
		{
			date_mc = scope_mc.date_mc;
			viewDate = new Date();
			date = new Date();
			banner_mc = new MovieClip();
			scope_mc.addChild(banner_mc);
			banner_mc.x = 455; banner_mc.y = 257;
			
//			list = new E_SHOP_LIST(scope_mc.list_mc,DataProvider.dataURL+"/Xml/EShopList.aspx",{banner:banner_mc,playRipple:playRipple});
			
			scope_mc.day_txt.alpha = 1;
			//TweenMax.to(scope_mc.day_txt,0.5,{delay:0.1,alpha:1});
			
			setDate();
			setBtn();
		}
		/**
		 * 초기화
		 * */
		override public function init():void
		{
			
			onClickDate(dayAry[viewDate.date]);
		}
		/**
		 * 날짜 생성
		 * */
		private function setDate():void
		{
			scope_mc.txt.alpha = 0;
			scope_mc.txt.text = date.getFullYear()+"."+SetText.plus0(date.month+1);
			if(bRipple)
				TweenMax.to(scope_mc.txt,0.5,{alpha:1});
			else scope_mc.txt.alpha = 1;
			
			SetText.space(scope_mc.txt,{letter:-1});
			Remove.child(date_mc);
			dayAry = [""];
			
			var lastDate:Date = new Date(date.fullYear,date.month+1,0);
			var cnt:int = lastDate.date;
			var i:int;
			var start:int;
			cDay = null;
			for(i = 1; i<=cnt; i++)
			{
				date.date = i;
				
				var day:DateClip = new DateClip();
				dayAry.push(day);
				
				day.idx = i;
				day.x = (date.day*30)+7;
				if(i == 1) start = date.day;
				day.y = Math.floor((i+(start-2))/7)*25+10;
				if(date.day == 0) 
				{
					day.y += 25;
					day.txt.textColor = 0xF3F0A8;
				}
				//현제 보고 있는 날짜
				if(	date.fullYear == viewDate.fullYear &&
					date.date == viewDate.date &&
					date.month == viewDate.month)
				{
					cDay = day;
					moveBubble(day.bubble_mc,{scale:0.8});
				}
				Button.setUI(day,{over:onOverDate,out:onOutDate,click:onClickDate});
				
				day.alpha = 0;
				if(bRipple)
					TweenMax.to(day,1-(i*0.01),{delay:i*0.01,alpha:1});
				else day.alpha = 1;
				
				date_mc.addChild(day);			
			}
			date.date = 1;
		}
		/**
		 * 다음,이전 달 클릭
		 * */
		private function setBtn():void
		{
			for(var i:int = 1; i<=2; i++)
			{
				var btn:MovieClip = scope_mc["point_btn"+i];
				btn.alpha = 1;
				btn.idx = i;
				SetBitmap.go(btn.img,true);
				Button.setUI(btn,{over:onOverBtn,out:onOutBtn,click:onClickBtn});
				
				//TweenMax.to(btn,0.5,{delay:i*0.2,alpha:1});
			}
		}
		private function onOverBtn($mc:MovieClip):void
		{	TweenMax.to($mc.img,0.5,{x:-5});	}
		private function onOutBtn($mc:MovieClip):void
		{	TweenMax.to($mc.img,0.5,{x:0});	}
		private function onClickBtn($mc:MovieClip):void
		{
			if($mc.idx == 1) date.month--;	//이전
			if($mc.idx == 2) date.month++;	//다음
				
			setDate();
		}
		/**
		 * 날짜 버튼화
		 * */
		private function onOverDate($day:DateClip):void
		{	$day.txt.textColor = 0xffffff;	}
		private function onOutDate($day:DateClip):void
		{	$day.txt.textColor = 0xCECDB5;	}
		
		private function onClickDate($day:DateClip):void
		{
			if(cDay != null)
				moveBubble(cDay.bubble_mc,{dirScale:0.9});
			moveBubble($day.bubble_mc,{scale:0.9});
			cDay = $day;
			viewDate.fullYear = date.fullYear;
			viewDate.month = date.month;
			viewDate.date = $day.idx;
			list.loadList(viewDate.fullYear+"-"+SetText.plus0(viewDate.month+1)+"-"+SetText.plus0(viewDate.date));
		}
	}//class
}//package