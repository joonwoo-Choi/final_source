package com.sk2.ui
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.Button;
	import com.sw.utils.SetText;
	import com.sw.utils.book.BookNavi;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * SK2	::	네비게이션
	 * */
	public class Navi
	{
		private var scope_mc:MovieClip;
		public var util:Util;
		
		private var menuName:Array;
		private var menuAry:Array;
		
		private var cMenu:MovieClip;
		private var cSub:MovieClip;
		
		private var sub_mc:MovieClip
		
		/**	생성자	*/
		public function Navi($scope_mc:MovieClip)
		{
			scope_mc = $scope_mc;
			sub_mc = scope_mc.sub_mc;
			init();
		}
		/**	소멸자	*/
		public function destroy():void
		{	
			sub_mc.removeEventListener(Event.ENTER_FRAME,onEnterSub);
		}
		/**
		 * 초기화
		 * */
		private function init():void
		{
			util = new Util(scope_mc);
			scope_mc.plane_mc.visible = false;
//			setMenu();
//			clickMenu(0,0);
			
			DataProvider.pos1 = 1;
			DataProvider.pos2 = 1;
			DataProvider.loader.loadSub();
		}
		
		/**	메뉴 클릭	
		 * @param $pos1	::	1뎁스 메뉴 위치 (0부터)
		 * @param $pos2	::	2뎁스 메뉴 위치 (0부터)
		 * 
		 */
		public function clickMenu($pos1:int,$pos2:int):void
		{
			var menu:MovieClip = menuAry[$pos1] as MovieClip;
			menu.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
			if(menuName[$pos1].length > 1)
			{
				var sub:MovieClip = sub_mc["sub"+($pos1+1)]["btn"+($pos2+1)] as MovieClip;
				sub.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
				sub.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else
			{
				menu.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		/**	메뉴 	*/
		private function setMenu():void
		{
			/*
			menuName = [	["PITERA STORY","PITERA STORY TOUR","PITERA STORY EPILOGUE","PITERA STORY EVENT"],
							["WOMEN STORY","파워블로거의 피테라 스토리","마니아들의 피테라 사용팁"],			
							["PITERA ESSENCE STORY","PITERA ESSENCE PRODUCT","HOW TO USE","GALLERY"],
							["E-SHOP STORY"],
							["CLEAR FOR LIFE"]];
			*/
			
			menuAry = [];
			sub_mc.line_mc.alpha = 0;
			sub_mc.line_mc.y = 0;
			
			var fileName:Array = DataProvider.loader.fileName;
			menuName = [];
			var i:int; var j:int;
			for(i = 0; i < fileName.length; i++)
			{
				menuName[i] = [];
				for(j = 0; j< fileName[i].length; j++)
				{
					menuName[i][j] = SetText.change(fileName[i][j],"_"," ");
				}
				if(menuName[i].length == 2) menuName[i].pop();
			}
			//menuName[1][1] = "이벤트안내";
			//menuName[1][2] = "PITERA ESSENCE 샘플신청";
			//menuName[1][3] = "PITERA ESSENCE 후기 등록";
			
			menuName[2][1] = "PITERA ESSENCE";
			menuName[2][3] = "PITERA REVIEW";
			
			menuName[3][1] = "CLEAR FOR LIFE란?";
			menuName[3][2] = "PUR 기부 리스트";
			
			//scope_mc.sub_mc.sub2.btn1.x += 15;
			
			for(i = 0; i < menuName.length; i++)
			{
				var menu:MovieClip = scope_mc["menu"+(i+1)];
				menuAry.push(menu);
				menu.idx = (i+1);
				menu.gotoAndStop(i+1);
				menu.alpha = 1;
				/*
				//var txt:TextField = menu.txt as TextField;
				var txt:TextField = new TextField();
				menu.addChild(txt);
				menu.addChild(menu.plane_mc);
				
				txt.selectable = false;
				txt.autoSize = TextFieldAutoSize.LEFT;
				
				txt.thickness = 200;
				txt.sharpness = -100;
				txt.text = menuName[i][0];
				
				//var tfm:TextFormat = new TextFormat("CreMyungjo",13.5);
				//txt.setTextFormat(tfm);
				//txt.embedFonts = true;
				
				//var embededfonts:Array = Font.enumerateFonts( false );
				//for each( var embededfont:Font in embededfonts )
				//	trace(  "fontName="+embededfont.fontName);
				SetText.space(txt,{letter:0,size:13.5,font:"CreMyungjo"});
				*/
				menu.plane_mc.width = 10;
				menu.plane_mc.width = menu.width;
				Button.setUI(menu,{over:onOverMenu,out:onOutMenu,click:onClickMenu});
				setSubMenu(i);
			}
			
			//이벤트 서브 메뉴는 안보이도록
			scope_mc.sub_mc.sub2.btn1.visible = false;
			scope_mc.sub_mc.sub2.btn2.visible = false;
			scope_mc.sub_mc.sub2.btn3.visible = false;
			
			/*
			for(i=0; i<menuName.length; i++)
			{
				for(j=0 ;j<fileName[i].length; j++)
				{
					
				}
			}
			*/
		}
		
		/**
		 * 서브 메뉴
		 * */
		private function setSubMenu(num:int):void
		{
			var sub:MovieClip = scope_mc.sub_mc["sub"+(num+1)];
			if(sub == null) return;
			sub.y = 0;
			var i:int;
			for(i = 1; i<menuName[num].length; i++)
			{
				var btn:MovieClip = sub["btn"+i];
				btn.idx = i;
				btn.mIdx = num;
				/*
				//var txt:TextField = btn.txt;
				var txt:TextField = new TextField();
				btn.addChild(txt);
				btn.addChild(btn.plane_mc);
				
				txt.selectable = false;
				//txt.x = -1; txt.y = -1;
				txt.thickness = 100;
				txt.sharpness = -50;
				
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = menuName[num][i];
				txt.textColor = 0x53534a;
				//txt.y = 2;
				SetText.space(txt,{letter:0.5,size:10,font:"CreMyungjo"});
				*/
				btn.gotoAndStop(((num+1)*10)+i);
				btn.plane_mc.width = btn.width+10;
				Button.setUI(btn,{over:onOverSub,out:onOutSub,click:onClickSub});
			}
		}
		/**	메뉴 움직임	*/
		private function moveMenu($menu:MovieClip,$dir:String):void
		{
			if($menu == null) return;
			if($dir == null) 
			{	trace("Navi : 에러, 메뉴 움직일 위치가 없습니다.");	return;	}
			//var col:uint = 0x6E6D5A;
			var col:uint = 0x53534a;
			$menu.filters = null;
			if($dir == "over") 
			{
				col = 0x8B0106;
				TweenMax.to($menu,0.6,{blurFilter:new BlurFilter(2,2),reversed:true,
							onReverseComplete:finishBlur,
							onReverseCompleteParams:[$menu]});
				//moveSub($menu.idx-1);
			}
			TweenMax.to($menu,0.5,{tint:col,overrite:1});
		}
		private function finishBlur($mc:MovieClip):void
		{	$mc.filters = null;	}
		/**	서브 메뉴 움직임 */
		private function moveSub($num:int,check:Boolean = true):void
		{
			resetMenu();
			addCheck(check);
			
			TweenMax.to(sub_mc.line_mc,0.5,{x:0,width:sub_mc.plane_mc.width,alpha:0.2});
			TweenMax.to(scope_mc.point_mc,1,{y:sub_mc.y+1,x:menuAry[$num].x+Math.round(menuAry[$num].width/2),ease:Expo.easeOut});
			
			if(menuName[$num].length <= 1) return;
			
			var sub:MovieClip = scope_mc.sub_mc["sub"+($num+1)];
			TweenMax.to(sub,0.6,{y:-sub.plane_mc.height});
			
		}
		/**	위치 체크이벤트 등록	*/
		private function addCheck(check:Boolean = true):void
		{
			sub_mc.removeEventListener(Event.ENTER_FRAME,onEnterSub);
			if(check == true)
				sub_mc.addEventListener(Event.ENTER_FRAME,onEnterSub);
		}
		/**	메뉴 내용 초기화	*/
		private function resetMenu():void
		{
			for(var i:int=0; i<menuName.length; i++)
			{
				var menu:MovieClip = menuAry[i];
				moveMenu(menu,"out");
				var sub:MovieClip = sub_mc["sub"+(i+1)];
				if(sub==null) continue;
				TweenMax.to(sub,0.3,{y:0});
			}
			TweenMax.to(scope_mc.point_mc,0.5,{y:sub_mc.y-scope_mc.point_mc.height});
			//TweenMax.to(sub_mc.line_mc,0.5,{x:(sub_mc.plane_mc.width-100)/2,width:100,alpha:0});
		}
		/**	서브 메뉴에 대한 마우스 위치 체크	*/
		private function onEnterSub(e:Event):void
		{
			//if(	scope_mc.mouseX < menuAry[0].x ||
			//		scope_mc.mouseX > menuAry[menuAry.length-1].x + menuAry[menuAry.length-1].width ||
			if(	scope_mc.mouseY < sub_mc.y - sub_mc.plane_mc.height ||
				scope_mc.mouseY > menuAry[0].y + menuAry[0].height )
			{	//마우스가 밖으로 나갔을시
				moveSub(cMenu.idx-1,false);
				moveMenu(cSub,"over");
				moveMenu(cMenu,"over");
			}	
		}
		/**	서브 오버	*/
		private function onOverSub($mc:MovieClip):void
		{
			addCheck();
			moveMenu(cSub,"out");
			moveMenu($mc,"over");
		}	
		/**	서브 아웃	*/
		private function onOutSub($mc:MovieClip):void
		{
			moveMenu($mc,"out");
			moveMenu(cSub,"over");
		}
		/**	서브 클릭	*/
		private function onClickSub($mc:MovieClip):void
		{
			//로드 중일때는 무시
			if(DataProvider.loader.getLoadSub() == true) return;
			/*
			if($mc.mIdx == 1 && $mc.idx == 2) 
			{
				DataProvider.popup.viewPop("alert",{txt:"준비중입니다."});
				return;
			}
			*/
			cSub = $mc;
			cMenu = menuAry[$mc.mIdx];
			DataProvider.pos1 = $mc.mIdx+1;
			DataProvider.pos2 = $mc.idx;
			DataProvider.loader.loadSub();
		}
		/**	메뉴 오버	*/
		private function onOverMenu($mc:MovieClip):void
		{
			moveSub($mc.idx-1);
			//moveMenu(cMenu,"out");
			moveMenu($mc,"over");
		}
		/**	메뉴 아웃	*/
		private function onOutMenu($mc:MovieClip):void
		{
			//moveMenu($mc,"out");
			//moveMenu(cMenu,"over");
		}
		/**	메뉴 클릭	*/
		private function onClickMenu($mc:MovieClip):void
		{
			trace(DataProvider.loader.getLoadSub());
			//로드 중일때는 무시
			if(DataProvider.loader.getLoadSub() == true) return;
			if($mc.idx == 2)
			{
				//DataProvider.popup.viewPop("alert",{txt:"죄송합니다. 이벤트 준비중입니다."});
//				DataProvider.popup.viewPop("holding",{});
				return;
			}
			cMenu = $mc;
			if(menuName[$mc.idx-1].length > 1)
			{
				MovieClip(sub_mc["sub"+$mc.idx].btn1).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
				MovieClip(sub_mc["sub"+$mc.idx].btn1).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				return;
			}
			moveMenu(cSub,"out");
			cSub = null;
			DataProvider.pos1 = $mc.idx;
			
			DataProvider.pos2 = 1;
			DataProvider.loader.loadSub();
		}
	}//class
}//package