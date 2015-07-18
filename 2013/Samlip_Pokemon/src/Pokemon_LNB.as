package
{
	
	import com.adqua.system.SecurityUtil;
	import com.pokemon.lnb.LNBMenu;
	import com.pokemon.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="240", height="500", frameRate="30", backgroundColor="0xffffff")]
	
	public class Pokemon_LNB extends Sprite
	{
		
		private var $main:AssetLNB;
		
		private var $model:Model;
		
		private var $lnbMenu:LNBMenu;
		
		public function Pokemon_LNB()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$main = new AssetLNB();
			this.addChild($main);
			
			$model = Model.getInstance();
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = "";		}
			else
			{		$model.defaulfPath = "http://samlipgf.adqua.co.kr";		};
			
			/**	메뉴 활성번호 검사	*/
			var menuNum:int;
			var subNum:int;
			if(root.loaderInfo.parameters.pcode)
			{
				menuNum = int(root.loaderInfo.parameters.pcode.charAt(1));
				subNum = int(root.loaderInfo.parameters.pcode.charAt(3));
			}
			else
			{
				menuNum = 4;
				subNum = 1;
			}
			
			$lnbMenu = new LNBMenu($main, menuNum, subNum);
		}
	}
}