package com.sk2.sub
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.sk2.net.EVT1_LIST;
	import com.sk2.utils.DataProvider;
	import com.sw.buttons.BtnEnter;
	import com.sw.net.list.BaseList;
	import com.sw.utils.McData;
	import com.sw.utils.SetText;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class PITERA_STORY_EVENT extends BaseSub
	{
		private var dirEvt:int;
		private var dir:int;
		private var loader1:URLLoader;
		private var loader2:URLLoader;
		
		public function PITERA_STORY_EVENT($scope:DisplayObjectContainer, $data:Object=null)
		{
			super($scope, $data);
			scope_mc.door2.label.nextFrame();
			scope_mc.door2.label_org.nextFrame();
			scope_mc.door2.cnt_mc.nextFrame();
			scope_mc.door2.cnt_mc.txt.text = "";
			scope_mc.door1.cnt_mc.txt.text = "";
			scope_mc.door.mc.gotoAndStop(1);
			
			MovieClip(scope_mc.door).addFrameScript(scope_mc.door.totalFrames-1,function():void{ scope_mc.door.stop();});	
			
			//if(loader1 != null) loader1.dispose();
			//if(loader2 != null) loader2.dispose();
//			loader1 = new URLLoader(new URLRequest(DataProvider.dataURL+"/Xml/SampleRequestList.aspx"));
//			loader2 = new URLLoader(new URLRequest(DataProvider.dataURL+"/Xml/PostList.aspx"));
//			loader1.addEventListener(Event.COMPLETE,onLoadList1);
//			loader2.addEventListener(Event.COMPLETE,onLoadList2);
			/*
			loader1 = new DataLoader(DataProvider.dataURL+"/Xml/SampleRequestList.aspx",{onComplete:onLoadList1});
			loader2 = new DataLoader(DataProvider.dataURL+"/Xml/PostList.aspx",{onComplete:onLoadList2});
			loader1.load();
			loader2.load();
			*/
		}
		override public function destroy():void
		{
			super.destroy();
			scope_mc.bg.visible = false;
			
			//if(loader1 != null) loader1.dispose();
			//if(loader2 != null) loader2.dispose();
			//var bg:MovieClip = DataProvider.layout.bg_mc;
			//McData.re(bg);
			//scope_mc.light_mc.visible = false;
		}
		//private function onLoadList1(e:LoaderEvent):void
		private function onLoadList1(e:Event):void
		{
			var xml:XML = XML(loader1.data);// as XML;
			scope_mc.door1.cnt_mc.txt.text = SetText.setPrice(xml.recordCount.toString());
		}
		//private function onLoadList2(e:LoaderEvent):void
		private function onLoadList2(e:Event):void
		{
			var xml:XML = XML(loader2.data);
			scope_mc.door2.cnt_mc.txt.text = SetText.setPrice(xml.recordCount.toString());
		}
		/**
		 * 물결 모습 끝나고 난 후 초기화
		 * */
		override public function init():void
		{
			//TweenMax.to(scope_mc.light_mc,1,{alpha:1});
			//setBaseBtn(scope_mc.btn,onClickBtn);
			//setBaseBtn(scope_mc.btn_winner,onClickWinner);
			//scope_mc.light_mc.mouseEnabled = false;
			//MovieClip(scope_mc.light_mc).mouseChildren = false;
			
			scope_mc.root.transform.perspectiveProjection.fieldOfView = 35;
			scope_mc.root.transform.perspectiveProjection.projectionCenter = 
				new Point(DataProvider.resize.sw/2,DataProvider.resize.sh/2);
			
			TweenMax.to(scope_mc.bg,1,{alpha:1});
			scope_mc.bg.mouseEnabled = false;
			MovieClip(scope_mc.bg).mouseChildren = false;
			scope_mc.door.visible = false;
			
			for(var i:int=1; i<=2; i++) 
			{
				var btn:MovieClip = scope_mc["btn"+i];
				btn.idx = i;
				btn.label = scope_mc["door"+i].label;
				btn.label_org = scope_mc["door"+i].label_org;
				btn.cnt_mc = scope_mc["door"+i].cnt_mc;
				btn.label.visible = false;
				btn.label.alpha = 1;
				btn.label_org.alpha = 0;
				btn.label_org.rotation = 30;
				TweenMax.to(btn.label_org,0.7,{delay:0.2*i,rotation:0,alpha:1,ease:Back.easeOut});
				var be:BtnEnter = new BtnEnter(btn,{over:onOverBtn,out:onOutBtn,click:onClickBtn});
			}
		}
		/**	버튼 오버	*/
		private function onOverBtn($mc:MovieClip = null):void
		{
			$mc.label.visible = true;
			$mc.label_org.visible = false;
			TweenMax.to($mc.label,0.7,{rotationX:15,ease:Back.easeOut});
		}
		/**	버튼 아웃	*/
		private function onOutBtn($mc:MovieClip = null):void
		{
			TweenMax.to($mc.label,0.7,{rotationX:0,ease:Back.easeOut,onComplete:finishOut,onCompleteParams:[$mc]});
		}
		private function finishOut($mc:MovieClip):void
		{
			if(scope_mc.door.visible == true) return;
			$mc.label.visible = false;
			$mc.label_org.visible = true;
		}
		/**	버튼 클릭	*/
		private function onClickBtn($mc:MovieClip = null):void
		{	
			dirEvt = $mc.idx;
			TweenMax.to($mc.cnt_mc,1,{alpha:0});
			TweenMax.to($mc.label,1,{y:$mc.label.y+20,alpha:0,rotationX:0,ease:Expo.easeIn,onComplete:finishLabel});
			scope_mc.door.visible = true;
		}
		/**	라벨 떨어 뜨리고 난후 움직임	*/
		private function finishLabel():void
		{
			//DataProvider.loader.navi.clickMenu(1,dirEvt);
			
			//TweenMax.to(inDoor,1,{x:640,y:264,scaleX:1.53,scaleY:1.53,onComplete:finishCenterDoor});
			dir = 1;
			var outDoor:MovieClip = scope_mc.door2;
			var inDoor:MovieClip = scope_mc["door"+dirEvt];
			//scope_mc.addChild(inDoor);
			if(dirEvt == 2) 
			{
				dir = -1;
				outDoor = scope_mc.door1;
			}
			
			//TweenMax.to(scope_mc.txt_mc,2,{delay:0.3,x:scope_mc.txt_mc.x+(150*dir),rotationY:20,scaleX:0.8,scaleY:0.8,alpha:0,ease:Expo.easeOut});
			//TweenMax.to(outDoor,2,{delay:0.3,x:outDoor.x+(100*dir),rotationY:0,scaleX:0.7,scaleY:0.7,alpha:0,ease:Expo.easeOut});
			
			//TweenMax.to(scope_mc.bg,0.5,{alpha:0});
			
			scope_mc.door.scaleX = 0.65*dir;
			scope_mc.door.scaleY = 0.65;
			scope_mc.door.x = inDoor.x;
			scope_mc.door.y = inDoor.y;
			scope_mc.door.bg_mc.alpha = 0;
			scope_mc.door.bg_mc.gotoAndStop(dirEvt);
			
			scope_mc.door.mc.play();
			TweenMax.to(inDoor,0.4,{alpha:0,ease:Expo.easeIn});
			TweenMax.to(scope_mc.door,0.4,{alpha:1,ease:Expo.easeOut,onComplete:finishCenterDoor});
			
			//var bg:MovieClip = DataProvider.layout.bg_mc;
			//trace(bg.x);
			//trace(bg.y);
			//McData.save(bg);
			//TweenMax.to(bg,2,{width:bg.width+100,height:bg.height+100,x:bg.x-50,y:bg.y-50});
		}
		private function finishCenterDoor():void
		{
			scope_mc.door.bg_mc.alpha = 1;
			TweenMax.delayedCall(0.5,function():void
			{	
				DataProvider.loader.navi.clickMenu(1,dirEvt);	
			});
			/*
			TweenMax.to(scope_mc.door,0.8,
					{	
						x:664,y:77,scaleX:2*dir,scaleY:2,ease:Expo.easeIn,override:2
					});
			TweenMax.to(scope_mc.door,0.8,
			{	
				alpha:0,ease:Expo.easeIn,
				onComplete:function():void
				{	
					DataProvider.loader.navi.clickMenu(1,dirEvt);	
				}
			}
			);
			*/
			//var inDoor:MovieClip = scope_mc["door"+dirEvt];
			//TweenMax.to(inDoor,0.5,{alpha:0,ease:Expo.easeIn});
			//TweenMax.to(scope_mc.door,1,{alpha:1,ease:Expo.easeOut});
			
			//MovieClip(scope_mc.door).addEventListener(Event.ENTER_FRAME,onEnterDoor);
		}
		/*
		private function onEnterDoor(e:Event):void
		{
			if(scope_mc.door.currentFrame == 30)
			{
				MovieClip(scope_mc.door).removeEventListener(Event.ENTER_FRAME,onEnterDoor);
				scope_mc.door.stop();
				DataProvider.loader.navi.clickMenu(1,dirEvt);
			}
		}
		*/
		
		/*
		//**	이벤트 참여	
		private function onClickBtn($mcw:MovieClip):void
		{
			DataProvider.loader.navi.clickMenu(0,0);
		}
		//**	당첨자 보기	
		private function onClickWinner($mc:MovieClip):void
		{
			FncOut.call("piteraMenu.evtWinner1");
		}
		*/
	}//class
}//package