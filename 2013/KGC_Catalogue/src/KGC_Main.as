package
{
	
	import com.adqua.system.SecurityUtil;
	import com.kgc.event.KGCEvent;
	import com.kgc.main.Main;
	import com.kgc.model.Model;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[SWF(width="1038", height="737", frameRate="30", backgroundColor="0xffffff")]
	
	public class KGC_Main extends Sprite
	{
		
		private var $main:AssetMain;
		
		private var $model:Model;
		
		private var $mainControl:Main;
		
		public function KGC_Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetMain();
			this.addChild($main);
			
			$mainControl = new Main($main);
			
			$model = Model.getInstance();
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb()) 
			{	$model.defaultPath = SecurityUtil.getPath(this);		}
			else
			{	$model.defaultPath = "";		}
			/**	XML 로드	*/
			var urlLdr:URLLoader = new URLLoader();
			urlLdr.load(new URLRequest($model.defaultPath + "xml/catalogueList.xml"));
			urlLdr.addEventListener(Event.COMPLETE, catalogueListLoadComplete);
		}
		
		private function catalogueListLoadComplete(e:Event):void
		{
			$model.listXml = new XML(e.target.data);
			
			$model.listLength = $model.listLength + $model.listXml.list.length();
			
			var i:int;
			var btnTab0Length:int;
			var btnTab1Length:int;
			var btnTab2Length:int;
			var btnTab3Length:int;
			var btnTab4Length:int;
			
			for (i = 0; i < $model.listLength; i++) 
			{
				if($model.listXml.list[i].@menuNum == "0") btnTab0Length++;
				else if($model.listXml.list[i].@menuNum == "1") btnTab1Length++;
				else if($model.listXml.list[i].@menuNum == "2") btnTab2Length++;
				else if($model.listXml.list[i].@menuNum == "3") btnTab3Length++;
				else if($model.listXml.list[i].@menuNum == "4") btnTab4Length++;
			}
			/**	컨텐츠별 리스트 시작 번호 배열	*/
			$model.listStartNumArr  = [0, 
													btnTab0Length, 
													btnTab0Length + btnTab1Length, 
													btnTab0Length + btnTab1Length + btnTab2Length, 
													btnTab0Length + btnTab1Length + btnTab2Length + btnTab3Length];
			
			/**	마지막 페이지 번호	*/
			$model.lastPageNum = $model.listLength - 1;
			
			$model.dispatchEvent(new KGCEvent(KGCEvent.CATALOGUE_LIST_LOADED));
//			trace($model.listLength, $model.lastPageNum);
//			trace($model.listXml);
		}
	}
}