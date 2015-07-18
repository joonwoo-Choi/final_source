package util
{
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class FBTwitterTxt extends AbstractMCView
	{
		
		private var $con:HpCon;
		
		private var $btnLength:int = 2;
		
		public function FBTwitterTxt(mcView:MovieClip)
		{
			super(mcView);
			TweenPlugin.activate([ColorTransformPlugin]);
			
			$con = HpCon(mcView);
			
			makeBtn();
			trace(" FBTwitterTxt ------------------------- FBTwitterTxt ---------------------------------FBTwitterTxt ")
//			$con.hpTitle.snsCon.btn0	트위터
//			$con.hpTitle.snsCon.btn1	페이스북
		}
		
		public function makeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $con.hpTitle.snsCon.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, btnSnsHandler);
			}
		}
		
		private function btnSnsHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
//			- 페이스북 퍼가기  :  MovieScrap('F', movieNum);
//			- 트위터 퍼가기  :  MovieScrap('T', movieNum);
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target, 0.5, {colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to(target, 0.5, {colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK :
					var snsType:String;
					if(target.no == 0) snsType = "T";
					else snsType = "F";
					JavaScriptUtil.call("MovieScrap", snsType, _model.activeMenu);
					break;
			}
		}
		
		public function removeBtn():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $con.hpTitle.snsCon.getChildByName("btn" + i) as MovieClip;
				ButtonUtil.removeButton(btns, btnSnsHandler);
			}
		}
	}
}