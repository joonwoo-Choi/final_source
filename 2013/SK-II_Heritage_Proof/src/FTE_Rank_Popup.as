package
{
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.StringUtil;
	import com.proof.event.ModelEvent;
	import com.proof.microsite.rank.Data_No;
	import com.proof.microsite.rank.Data_Yes;
	import com.proof.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="450", height="450", frameRate="30", backgroundColor="0xffffff")]
	
	public class FTE_Rank_Popup extends Sprite
	{
		
		private var $main:AssetRankPopup;
		
		private var $model:Model;
		
		private var $dataYes:Data_Yes;
		
		private var $dataNo:Data_No;
		
		private var $client:String;
		
		public function FTE_Rank_Popup()
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
			
			$main = new AssetRankPopup();
			this.addChild($main);
			
			$model = Model.getInstance();
			
			$dataNo = new Data_No($main.dataNo);
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{
				$model.defaulfPath = SecurityUtil.getPath(this);
				/**	테스트 or 실서버 확인	*/
				if(StringUtil.ereg($model.defaulfPath, "test", "g"))
				{	$model.magicRingPath = "http://test.piterahouse.com/process/GetMicroMagicRingData.ashx";	}
				else
				{	$model.magicRingPath = "http://www.piterahouse.com/process/GetMicroMagicRingData.ashx"; }
			}
			else
			{
				$model.defaulfPath = "";
				$model.magicRingPath = "http://test.piterahouse.com/process/GetMicroMagicRingData.ashx";
			};
			
			/**	데이터 있는지 없는지 체크	*/
			if(root.loaderInfo.parameters.client)
			{		
				$client = root.loaderInfo.parameters.client;
				$dataYes = new Data_Yes($main.dataYes, $client);
			}
			else
			{
//				$client = root.loaderInfo.parameters.client;
//				$dataYes = new Data_Yes($main.dataYes, "C1302080016");
				$model.dispatchEvent(new ModelEvent(ModelEvent.DATA_NO));
			}
		}
	}
}