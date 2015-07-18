package minimap
{
	import com.adqua.net.Debug;
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sw.buttons.Button;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import pEvent.PEventCommon;
	
	public class GalleryListConCtrl extends AbstractMCView
	{
		private var $totalPage:int;
		private var $pageBtnBank:Vector.<PageBtn> = Vector.<PageBtn>([]);
		private var $pageMCCon:Sprite;
		private var $id:uint;
		private var $delTime:Number = .3;
		private var $activePage:int =0;
		private var $activeNum:int = 0;
		private var $photoNum:int = 13;
		
		private var $listArr:Array;
		
		public function GalleryListConCtrl(mcView:MovieClip)
		{
			TweenPlugin.activate([FramePlugin,TintPlugin]);
			super(mcView);
			
//			Model.getInstance().addEventListener(PEventCommon.REMOVE_POPUP_EVENT, removeEvent);
			
			setting()
		}
		/**	이벤트 제거	*/
		public function removeEvent(e:Event = null):void
		{
//			Model.getInstance().removeEventListener(PEventCommon.REMOVE_POPUP_EVENT, removeEvent);
			
			/**	리스트 prev & next 버튼	*/
			for (var i:int = 1; i < 3; i++) 
			{
				var btn:MovieClip = _mcView["btnPage"+i] as MovieClip;
				Button.removeUI(btn);	
			}
			
			/**	섬네일	*/
			for (var j:int = 0; j < $listArr.length; j++) 
			{
				$listArr[j].mcImg.removeChildren(0, $listArr[j].mcImg.numChildren-1);
				Button.removeUI($listArr[j]);
			}
			removePrevList();
			$listArr = null;
			trace("겔러리 리스트 자식 수: " + GalleryListCon(_mcView).listCon.numChildren);
			
			/**	섬네일 페이지	*/
			for (var k:int = 0; k < $totalPage; k++) 
			{	$pageMCCon.removeChildAt(0);		}
			trace("섬네일 페이지 수 : " + $pageMCCon.numChildren);
			$pageBtnBank = null;
			$pageMCCon = null;
		}
		
		override public function setting():void
		{
			makPage();
			btnLRSetting();	
			changePage();
		}
		
		private function makPage():void
		{
			$totalPage = _model.galleryPhotXMLData.page.length();
			$pageMCCon = new Sprite;
			_mcView.addChild($pageMCCon);
			
			for (var i:int = 0; i < $totalPage; i++) 
			{
				var pageMC:PageBtn = new PageBtn;
				pageMC.y = 180;
				pageMC.x = i*20;
				pageMC.visible = false;
				pageMC.num = i;
				$pageMCCon.addChild(pageMC);
				$pageBtnBank.push(pageMC);
			}
			$pageMCCon.x = (_mcView.width-$pageMCCon.width)/2;
			$pageBtnBank[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			activePage(0);
		}
		
		private function btnLRSetting():void
		{
			for (var i:int = 1; i < 3; i++) 
			{
				var btn:MovieClip = _mcView["btnPage"+i] as MovieClip;
				btn.idx = i;
				Button.setUI(btn,{over:onOverPage,out:onOutPage,click:onClickPage});	
			}
		}
		
		private function onOverPage(mc:MovieClip):void
		{
			TweenLite.to(mc, .3,{alpha:1})
		}
		private function onOutPage(mc:MovieClip):void
		{
			TweenLite.to(mc, .3,{alpha:.7})
		}
		
		private function onClickPage(mc:MovieClip):void
		{
			if(mc.idx == 1) _model.pageNum--;
			if(mc.idx == 2) _model.pageNum++;
			
			if(_model.pageNum < 0){
				Debug.alert("처음 페이지 입니다.");
				_model.pageNum = 0;
				return;
			}
			if(_model.pageNum > $totalPage-1) {
				Debug.alert("마지막 페이지 입니다.");
				_model.pageNum = $totalPage-1;
				return;
			}
			changePage();
		}
		
		private function changePage():void
		{
			_mcView.mouseEnabled = false;
			_mcView.mouseChildren = false;
			
			removePrevList();
			if(GalleryListCon(_mcView).listCon.numChildren>1){
				TweenLite.delayedCall($delTime,makeList);
			}else{
				makeList();
			}	
			activePage(_model.pageNum);
		}
		
		private function activePage(activeNum:int):void
		{
			for (var i:int = 0; i < $pageBtnBank.length; i++) 
			{
				var pageBtn:PageBtn = $pageBtnBank[i];
				pageBtn.buttonMode = true; //pageNum button
				if(i==activeNum){
					TweenLite.to(pageBtn,.5,{tint:0x0d00065}); //pageNum color
				}else{
					TweenLite.to(pageBtn,.5,{tint:null});
				}
			}
		}
		
		private function makeList():void
		{
			$listArr = [];
			var num:int = _model.galleryPhotXMLData.page[_model.pageNum].list.length();
			var motionTime:Number = .2;
			TweenLite.delayedCall($delTime+motionTime,activeMouseEvent);
			for (var i:int = 0; i < num; i++) 
			{
				var listMC:GalleryListClip = new GalleryListClip;
				listMC.alpha = 1;
				listMC.num = i;
				listMC.buttonMode = true;
				listMC.x = i*70;
				$listArr.push(listMC);
				
				var url:String = Model.getInstance().prependURL+_model.galleryPhotXMLData.page[_model.pageNum].list[i].simg;
				var thumbLoader:ImageLoader = new ImageLoader(url,{
					container:listMC.mcImg, 
					smoothing:true,
					width:listMC.mcImg.width, height:listMC.mcImg.height,
					onComplete:imgShow,
					alpha:0
				});		
				thumbLoader.load(); 
				Button.setUI(listMC,{over:onOverList,out:onOutList,click:listClick});
				_mcView.listCon.addChild(listMC);
			}
		}
		
		private function activeMouseEvent():void
		{
			_mcView.mouseEnabled = true;
			_mcView.mouseChildren = true;
		}
		
		private function imgShow(evt:LoaderEvent):void
		{
			TweenLite.to(evt.target.content, .3,{alpha:1});		
		}
		
		
		/**	리스트 오버	*/
		private function onOverList(mc:MovieClip):void
		{
//			TweenMax.to(mc.mcMove,0.7,{rotation:mc.mcMove.or+2,ease:Expo.easeOut});
		}
		/**	리스트 아웃	*/
		private function onOutList(mc:MovieClip):void
		{
//			TweenMax.to(mc.mcMove,0.7,{rotation:mc.mcMove.or,ease:Expo.easeOut});
		}		
		protected function listClick(mc:MovieClip):void
		{
			var listMC:MovieClip = mc;
			_model.listNum = listMC.num;
			trace("_model.listNum : ", _model.listNum);
			_model.dispatchEvent(new PEventCommon(PEventCommon.GALLERY_MAIN));
		}
		
		private function removePrevList():void
		{
			var num:int = GalleryListCon(_mcView).listCon.numChildren;
			for (var i:int = 0; i < num; i++) 
			{
				var mc:DisplayObject = GalleryListCon(_mcView).listCon.getChildAt(i);
//				TweenLite.to(mc,.5,{alpha:0,delay:.05*i,onComplete:removeMC,onCompleteParams:[mc]});
				TweenLite.to(mc,.5,{alpha:0,onComplete:removeMC,onCompleteParams:[mc]});
			}
		}
		
		private function removeMC(mc:DisplayObject):void
		{
			GalleryListCon(_mcView).listCon.removeChild(mc);
			trace("겔러리 리스트 자식 수: " + GalleryListCon(_mcView).listCon.numChildren);
		}
	}
}