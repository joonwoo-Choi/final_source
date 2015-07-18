package 
{
	
	import com.adqua.net.FONTLoader;
	import com.adqua.system.SecurityUtil;
	import com.greensock.events.LoaderEvent;
	import com.proof.event.ModelEvent;
	import com.proof.kiosk.Kiosk_Main;
	import com.proof.kiosk.pageOne.Product;
	import com.proof.kiosk.pageOne.Rank;
	import com.proof.kiosk.pageOne.Result;
	import com.proof.kiosk.pageTwo.PageTwo;
	import com.proof.kiosk.popup.MainPopup;
	import com.proof.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	import flash.text.Font;
	
	[SWF(width="1080", height="1920", frameRate="30", backgroundColor="0xffffff")]
	
	public class FTE_Kiosk extends Sprite
	{
		
		private var $main:AssetKioskMain;
		
		private var $model:Model;
		
		private var $kioskMain:Kiosk_Main;
		private var $mainPopup:MainPopup;
		
		private var $page_One_Result:Result;
		private var $page_One_Rank:Rank;
		private var $page_One_Product:Product;
		
		private var $page_Two:PageTwo;
		
		public function FTE_Kiosk()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$model = Model.getInstance();
			
			/**	기본 경로 설정	*/
			$model.defaulfPath = SecurityUtil.getPath(this);
			
//			var font:FONTLoader = new FONTLoader($model.defaulfPath + "font/SinMun.swf");
//			font.load();
			
			$main = new AssetKioskMain();
			this.addChild($main);
			
			$kioskMain = new Kiosk_Main($main.mainCon);
			$mainPopup = new MainPopup($main.popup);
			
			$page_One_Result = new Result($main.pageOne);
			$page_One_Rank = new Rank($main.pageOne);
			$page_One_Product = new Product($main.pageOne);
			
			$page_Two = new PageTwo($main.pageTwo);
		}
	}
}