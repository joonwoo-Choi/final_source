package net
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	
	import display.Layout;
	import display.Resize;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import util.popup.Popup;
	
	/**		
	 *	SK2_Hershys :: 메인 페이지 전체 로더 (싱글톤)
	 */
	public class ConLoader extends SK2BaseConLoader
	{
		/**	인스턴스	*/
		static private var ins:ConLoader;
		
		/**	생성자	*/
		public function ConLoader($loadingMc:MovieClip=null,$lockPlane:Object=null)
		{
			super($loadingMc,$lockPlane);
			if(ins != null) throw new Error("ConLoader는 싱글톤 임묘");
			
			init();	
		}
		/**	인스턴스 반환	*/
		static public function getIns($loadingMc:MovieClip=null,$lockPlane:Object=null):ConLoader
		{	
			
			if(ins == null) ins = new ConLoader($loadingMc,$lockPlane);
			return ins;	
		}
		
		/**	초기화	*/
		override protected function init():void
		{	super.init();	}
		/**	데이터 로드	*/
		override public function load():void
		{
			super.load();
			
			loader.append(new SWFLoader(Global.getIns().rootURL+"MainNavigation.swf",{name:"navi"}));
			loader.append(new SWFLoader(Global.getIns().rootURL+"Popup.swf",{name:"popup",onComplete:onLoadPop}));
			loader.append(new SWFLoader(Global.getIns().rootURL+"MainMovie.swf",{name:"movie"}));
			loader.load();
			
			
		}
		/**	팝업 셋팅	*/
		private function onLoadPop(e:LoaderEvent):void
		{
			trace("onLoadPop팝업 셋팅	");
			var popLoader:SWFLoader = loader.getLoader("popup") as SWFLoader;
			Layout.getIns().popSp.addChild(popLoader.rawContent as Sprite);
			
			Global.getIns().popup = new Popup(popLoader.rawContent,{lock:Layout.getIns().lockPlane});
		}
		/**	초기 로드 내용 모두 로드	*/
		override protected function onLoadTotal(e:LoaderEvent):void
		{
			super.onLoadTotal(e);
			
			//hideLoading();
			setLoadingTxt(0);
			
			var naviLoader:SWFLoader = loader.getLoader("navi") as SWFLoader;
			trace("naviLoader: ",naviLoader);
			trace("naviLoader.rawContent: ",naviLoader.rawContent);
			Layout.getIns().naviSp.addChild(naviLoader.rawContent as Sprite);
			
			var movieLoader:SWFLoader = loader.getLoader("movie") as SWFLoader;
			Layout.getIns().movieSp.addChild(movieLoader.rawContent as Sprite);
			
			Resize.getIns().doingResize();
		}
		
	}//class
}//package