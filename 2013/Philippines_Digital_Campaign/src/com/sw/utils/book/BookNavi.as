package com.sw.utils.book
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class BookNavi
	{
		public var book:Book;
		public var UI_mc:MovieClip;
		public var btnAry:Array;
		public var page:int;
		
		public function BookNavi($book:Book)
		{
			book = $book;
			UI_mc = book.UI_mc;
			page = book.bookMove.page;
			setBtn();	
		}
		
		public function setBtn():void
		{
			if(UI_mc == null) return;
			btnAry = [UI_mc.btn_next1,UI_mc.btn_prev1,UI_mc.btn_next2,UI_mc.btn_prev2];
			
			for(var i:Number=0; i<btnAry.length; i++)
			{
				var btn:MovieClip = btnAry[i];
				btn.buttonMode = true;
				btn.code = i;
				btn.addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		public function onClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			page = book.bookMove.page;
			switch(mc.code)
			{	
				case 0:	// 한장 다음
					page = page+2;
					break;
				case 1:	// 한장 이전
					page = page-2;
					break;
				case 2:	// 세장 다음
					page = page+6;
					break;
				case 3:	// 세장 이전
					page = page-6;
					break;
			}
			if(page <= book.bookMove.basePage) page = 1;
			if(page >= book.TotalPages) page = book.TotalPages;
			
			//book.bookMove.page = page;
			
			if(mc.code==2 || mc.code ==3) book.bookMove.gotoPage(page,true);
			else book.bookMove.gotoPage(page);
		}
	}
}