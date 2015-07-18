package net
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	
	import display.Layout;
	import display.Resize;
	
	import flash.display.Sprite;
	
	import util.popup.SubPopup;

	/**		
	 *	SK2_Hersheys :: 서브 페이지 로더
	 */
	public class SubConLoader extends SK2BaseConLoader
	{
		/**	인스턴스	*/
		static private var ins:SubConLoader = new SubConLoader();
		/**	1뎁스 위치	*/
		public var depth1:int;
		/**	2뎁스 위치	*/
		public var depth2:int;
		
		/**	생성자	*/
		public function SubConLoader()
		{
			super();
			if(ins != null) throw new Error("SubConLoader는 싱글톤임묘.");
			init();
		}
		/**	인스턴스 반환	*/
		static public function getIns():SubConLoader
		{	return ins;		}
		override public function load():void
		{
			super.load();
			var conPath:String = "";
			if(GlobalSub.getIns().depth1 == 5) conPath = "Gallery.swf";
			if(GlobalSub.getIns().depth1 == 4) conPath = "Story"+GlobalSub.getIns().depth2+".swf";
			
			loader.append(new SWFLoader(Global.getIns().rootURL+"SubLeftNavigation.swf",{name:"naviLeft"}));
			//loader.append(new SWFLoader(Global.getIns().rootURL+"SubNavigation.swf",{name:"navi"}));
			//loader.append(new SWFLoader(Global.getIns().rootURL+"SubTopNavigation.swf",{name:"naviTop"}));
			loader.append(new SWFLoader(Global.getIns().rootURL+"SubPopup.swf",{name:"popup"}));
			loader.append(new SWFLoader(Global.getIns().rootURL+conPath,{name:"con"}));
			
			loader.load();
		}
		/**	모든 내용 로드 완료	*/
		override protected function onLoadTotal(e:LoaderEvent):void
		{
			super.onLoadTotal(e);
			
			hideLoading();
			//중앙 컨텐츠 내용
			var subLoader:SWFLoader = loader.getLoader("con") as SWFLoader;
			Layout.getIns().container.addChild(subLoader.rawContent as Sprite);
			
			//좌측 헤더
			var leftLoader:SWFLoader = loader.getLoader("naviLeft") as SWFLoader;
			var leftSp:Sprite = leftLoader.rawContent as Sprite;
			leftSp.x = 12;
			leftSp.y = 100;
			Layout.getIns().container.addChild(leftSp);
			/*
			//상단 메뉴
			var topLoader:SWFLoader = loader.getLoader("naviTop") as SWFLoader;
			Layout.getIns().subSp.addChild(topLoader.rawContent as Sprite);
			//하단 메뉴
			var naviLoader:SWFLoader = loader.getLoader("navi") as SWFLoader;
			var naviSp:Sprite = naviLoader.rawContent as Sprite;
			naviSp.y = 498;
			Layout.getIns().subSp.addChild(naviSp);
			*/
			//팝업
			var popLoader:SWFLoader = loader.getLoader("popup") as SWFLoader;
			var pop:Sprite = popLoader.rawContent as Sprite;
			Layout.getIns().popSp.addChild(pop);
			Global.getIns().popup = new SubPopup(pop,{lock:Layout.getIns().lockPlane});
			
			Resize.getIns().doingResize();	
		}
		
	}//class
}//package