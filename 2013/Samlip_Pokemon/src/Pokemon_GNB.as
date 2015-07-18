package 
{
	
	import com.adqua.system.SecurityUtil;
	import com.pokemon.gnb.GNBMenu;
	import com.pokemon.gnb.Util;
	import com.pokemon.model.Model;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	[SWF(width="760", height="124", frameRate="30", backgroundColor="0xffffff")]
	
	public class Pokemon_GNB extends Sprite
	{
		
		private var $main:AssetGNB;
		
		private var $util:Util;
		
		private var $model:Model;
		
		private var $gnbMenu:GNBMenu;
		
		public function Pokemon_GNB()
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
			
			$main = new AssetGNB();
			this.addChild($main);
			
			$main.bg.x = -240;
			
			$model = Model.getInstance();
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = "";		}
			else
			{		$model.defaulfPath = "http://samlipgf.adqua.co.kr";		};
			
			/**	로그인 검사	*/
			if(root.loaderInfo.parameters.flagLogin)
			{
				if(root.loaderInfo.parameters.flagLogin == "y")
				{
					$main.util.gotoAndStop(2);
				}
			}
			else
			{
				if($model.isLogin == true) $main.util.gotoAndStop(2);
				else $main.util.gotoAndStop(1);
			}
			
			/**	메뉴 활성번호 검사	*/
			var menuNum:int;
			var subNum:int;
			if(root.loaderInfo.parameters.pcode)
			{
				menuNum = int(root.loaderInfo.parameters.pcode.charAt(1)) - 1;
				subNum = int(root.loaderInfo.parameters.pcode.charAt(3)) - 1;
			}
			else
			{
				menuNum = -1;
				subNum = -1;
			}
			
			$util = new Util($main.util);
			$gnbMenu = new GNBMenu($main, menuNum, subNum);
			
			stageResize();
			$main.stage.addEventListener(Event.RESIZE, stageResize);
		}
		
		private function stageResize(e:Event = null):void
		{
			$main.bg.width = $main.stage.stageWidth + 240;
//			if($main.stage.stageWidth < 760 )
//			{
//				$main.bg.width = 760;
//				$main.bg.x = 0;
//			}
//			else if($main.stage.stageWidth > 760 && $main.stage.stageWidth <= 1000)
//			{
//				$main.bg.width = $main.stage.stageWidth;
//				$main.bg.x = 760 - $main.stage.stageWidth;
//			}
//			else
//			{
//				$main.bg.width = 1000;
//				$main.bg.x = 760 - 1000;
//			}
		}
	}
}