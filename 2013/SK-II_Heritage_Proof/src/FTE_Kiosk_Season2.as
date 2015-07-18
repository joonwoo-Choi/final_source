package
{
	
	import com.adqua.system.SecurityUtil;
	import com.proof.model.Model;
	import com.season2.kiosk.KioskMain;
	import com.season2.kiosk.pageOne.Product;
	import com.season2.kiosk.pageOne.Rank;
	import com.season2.kiosk.pageOne.Result;
	import com.season2.kiosk.pageTwo.PageTwo;
	import com.season2.kiosk.popup.MainPopup;
	import com.season2.kiosk.sendImg.SendImg;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="1080", height="1920", frameRate="30", backgroundColor="#ffffff")]
	
	public class FTE_Kiosk_Season2 extends Sprite
	{
		
		private var $main:AssetKioskMainSeason2;
		
		private var $model:Model;
		
		private var $kioskMain:KioskMain;
		
		private var $page_One_Result:Result;
		private var $page_One_Rank:Rank;
		private var $page_One_Product:Product;
		
		private var $page_Two:PageTwo;
		
		private var $popup:MainPopup
		
		private var $sendImg:SendImg;
		
		public function FTE_Kiosk_Season2()
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
			
			$main = new AssetKioskMainSeason2();
			this.addChild($main);
			
			$kioskMain = new KioskMain($main.mainCon);
			
			$page_One_Result = new Result($main.pageOne);
			$page_One_Rank = new Rank($main.pageOne);
			$page_One_Product = new Product($main.pageOne);
			
			$page_Two = new PageTwo($main.pageTwo);
			
			$sendImg = new SendImg($main.evtFB);
			
			$popup = new MainPopup($main.popup);
		}
	}
}