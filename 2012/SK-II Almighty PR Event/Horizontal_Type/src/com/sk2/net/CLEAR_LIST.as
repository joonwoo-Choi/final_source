package com.sk2.net
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sk2.clips.ClearClip;
	import com.sk2.utils.DataProvider;
	import com.sw.display.Remove;
	import com.sw.utils.SetText;
	
	import flash.display.MovieClip;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * SK2	::	CLEAR PER 리스트
	 * */
	public class CLEAR_LIST extends EPILOGUE_LIST
	{
		private var bGage:Boolean;
		private var selbox_mc:MovieClip;
		
		/**	생성자	*/
		public function CLEAR_LIST($scope:Object, $url:String, $data:Object)
		{
			super($scope, $url, $data);
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
			super.init(false);
			
			bGage = false;
			cbk_onLoad = onLoad;
			pageSize = 4;
			selbox_mc = scope.selbox;
			//selbox_mc.mouseEnabled = false;
			//selbox_mc.mouseChildren = false;
			selbox_mc.txt.text = "이름";
			selbox.setListText(["이름","전화번호","매장명"]);
			
			MovieClip(scope).mouseChildren = true;
			
			DataProvider.baseSub.setBaseBtn(scope.search_btn,onClickSearch);
			loadList();
		}
		/*
		override protected function onClickSel($mc:MovieClip):void
		{
			search_txt.text = "";
			if(selbox.cPos == 1) search_txt.restrict = "0-9";
				else search_txt.restrict = null;
		}
		*/
		/**	로드한 데이터가 없을때 수행	*/
		override protected function onNoneList():void
		{	
			if(scope.visible == false) return;
			super.onNoneList();
		}
		/**	리스트 내용 로드	*/
		override public function loadList():void
		{
			var txt:String = search_txt.text;
			if(txt == base_search) txt = "";
			var schType:String = "uid";
			if(selbox.cPos == 1 || selbox.cPos == 2) schType = "purtel";
			load({schType:schType,schString:txt,owner:"N"},URLRequestMethod.GET);
		}
		private function onClickSearch($mc:MovieClip):void
		{
			pageNo = 1;
			loadList();
		}
		/**	로드 완료 후 수행 함수	*/
		override protected function onLoad($xml:XML):void
		{
			if(scope.visible == false) return;
			//trace($xml);
			Remove.child(list_mc);
			var cnt:int = $xml.dataList.PurList.length();
			
			for(var i:int = 0; i<cnt; i++)
			{
				var cXml:XML = $xml.dataList.PurList[i];
				//trace(cXml.idx.toString());
				
				var list:ClearClip = new ClearClip();
				list.txt.autoSize = TextFieldAutoSize.LEFT;
				list.txt.text = cXml.uid.toString()+" 님";
				//trace(list.txt1);
				list.txt1.x = list.txt.x + list.txt.width+5;
				list.txt2.x = list.txt1.x + list.txt1.width-3;
				
				//var date:String = cXml.purdate.toString();
				list.txt3.autoSize = TextFieldAutoSize.RIGHT;
				list.txt3.text = cXml.purtel.toString();;
				list.mark_mc.x = list.txt3.x-list.mark_mc.width+3;
				//list.txt3.text = "MART현대백화점";
				if(list.txt3.text.substr(0,4) == "MART")
				{	
					list.txt3.text = list.txt3.text.substr(4);
					list.mark_mc.visible = false;
				}
					//list.txt3.text = date.substr(0,4)+"."+date.substr(5,2)+"."+date.substr(8,2);
				
				list.y = i*(list.height-1);
				list.alpha = 0;
				list_mc.addChild(list);
				TweenMax.to(list,1-(i*0.05),{delay:i*0.05,alpha:1});
			}
			if(bGage == false)
			{	setGage();	bGage = true;	}
		}
		/**
		 * 우측 물통 모션
		 * */
		public function setGage():void
		{
			var gage_mc:MovieClip = scope.gage_mc;
			var cNum:int = listTotal*100;
			trace(cNum);
			var max:int = 50000*2*7;
			if(cNum > max) cNum = max;
			var dirY:int = Math.round((cNum/max)*gage_mc.plane_mc.height);
			
			dirY = gage_mc.plane_mc.height - dirY;
			gage_mc.water_mc.height = gage_mc.plane_mc.height;
			
			gage_mc.point_mc.txt.text = SetText.setPrice(cNum)+"";
			
			TweenMax.to(gage_mc.line_mc,1,{y:dirY,ease:Expo.easeOut});
			TweenMax.to(gage_mc.point_mc,1.2,{y:dirY,ease:Expo.easeOut});
			TweenMax.to(gage_mc.water_mc,1,{y:dirY,ease:Expo.easeOut});
		}
	}//class
}//package