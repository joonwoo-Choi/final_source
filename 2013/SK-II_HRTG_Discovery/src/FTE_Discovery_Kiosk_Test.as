package
{
	
	import com.adqua.system.SecurityUtil;
	import com.kiosk.KioskMain_Test;
	import com.kiosk.model.Model;
	import com.kiosk.pageOne.Product;
	import com.kiosk.pageOne.Rank;
	import com.kiosk.pageOne.Result;
	import com.kiosk.pageTwo.PageTwo;
	import com.kiosk.popup.MainPopup;
	import com.kiosk.sendImg.SendImg_Test;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="1080", height="1920", frameRate="30", backgroundColor="#ffffff")]
	
	public class FTE_Discovery_Kiosk_Test extends Sprite
	{
		
		private var $main:AssetKioskMain;
		
		private var $model:Model;
		
		private var $kioskMain:KioskMain_Test;
		
		private var $page_One_Result:Result;
		private var $page_One_Rank:Rank;
		private var $page_One_Product:Product;
		
		private var $page_Two:PageTwo;
		
		private var $popup:MainPopup
		
		private var $sendImg:SendImg_Test;
		
		public function FTE_Discovery_Kiosk_Test()
		{
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
			
			$main = new AssetKioskMain();
			this.addChild($main);
			
			$kioskMain = new KioskMain_Test($main.mainCon);
			
			$page_One_Result = new Result($main.pageOne);
			$page_One_Rank = new Rank($main.pageOne);
			$page_One_Product = new Product($main.pageOne);
			
			$page_Two = new PageTwo($main.pageTwo);
			
			$sendImg = new SendImg_Test($main.evtFB);
			
			$popup = new MainPopup($main.popup);
		}
	}
}