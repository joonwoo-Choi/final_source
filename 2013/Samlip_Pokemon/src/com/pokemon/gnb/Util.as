package com.pokemon.gnb
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.pokemon.model.Model;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Util
	{
		
		private var $con:MovieClip;
		
		private var $btnLength:int = 5;
		
		private var $loginLinkArr:Array = ["util01", "util02", "util03", "util04", "util08"];
		
		private var $logoutLinkArr:Array = ["util01", "util05", "util06", "util04", "util08"];
		
		public function Util(con:MovieClip)
		{
			TweenPlugin.activate([TintPlugin]);
			$con = con;
			
			makeButton();
		}
		
		private function makeButton():void
		{
			trace($con.currentFrame);
			
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btn:MovieClip = $con.getChildByName("btn" + i) as MovieClip;
				btn.no = i;
				btn.buttonMode = true;
				ButtonUtil.makeButton(btn, utilBtnHandler);
			}
		}
		
		private function utilBtnHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target, 0.5, {tint:0x1e1e1c});
					if(target.no < 4) TweenLite.to($con.triangle, 0.5, {rotation:0});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to(target, 0.5, {tint:null});
					if(target.no < 4) TweenLite.to($con.triangle, 0.5, {rotation:180});
					break;
				case MouseEvent.CLICK :
					if($con.currentFrame == 1)
					{
						JavaScriptUtil.call($loginLinkArr[target.no]);
					}
					else if($con.currentFrame == 2)
					{
						JavaScriptUtil.call($logoutLinkArr[target.no]);
					}
					break;
			}
		}
	}
}