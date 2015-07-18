package
{
	
	import com.adqua.system.SecurityUtil;
	import com.adqua.util.ButtonUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.proof.event.ModelEvent;
	import com.proof.microsite.flvPlayer.SubFlvPlayer2;
	import com.proof.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	[SWF(width="700", height="600", frameRate="30", backgroundColor="0xffffff")]
	
	public class FTE_SubContent extends Sprite
	{
		
		private var $main:AssetSubContent;
		
		private var $model:Model;
		
		private var $subFlvPlayer:SubFlvPlayer2;
		
		private var $btnLength:int = 5;
		
		public function FTE_SubContent()
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			
			$model = Model.getInstance();
			
			/**	기본 경로 설정	*/
			if(SecurityUtil.isWeb())
			{		$model.defaulfPath = SecurityUtil.getPath(this);		}
			else
			{		$model.defaulfPath = "";		};
			
			$main = new AssetSubContent();
			this.addChild($main);
			
			$subFlvPlayer = new SubFlvPlayer2($main.movCon);
			
			$main.maskMC.visible = false;
			$main.maskMC.alpha = 0;
			$main.maskMC.width = 0;
			$main.maskMC.height = 0;
			
			makeButton();
		}
		
		private function makeButton():void
		{
			for (var i:int = 0; i < $btnLength; i++) 
			{
				var btns:MovieClip = $main.getChildByName("btn" + i) as MovieClip;
				btns.no = i;
				ButtonUtil.makeButton(btns, movPlayHandler);
			}
		}
		
		private function movPlayHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					break;
				case MouseEvent.MOUSE_OUT :
					break;
				case MouseEvent.CLICK :
					$model.subMovNum = target.no;
					tweenMovMask(target);
					break;
			}
		}
		
		private function tweenMovMask(target:MovieClip):void
		{
			$main.maskMC.x = target.x;
			$main.maskMC.y = target.y;
			$main.maskMC.width = target.width;
			$main.maskMC.height = target.height;
			
			TweenLite.to($main.maskMC, 0.6, {autoAlpha:1, x:0, width:700, ease:Cubic.easeOut, onComplete:heightTween});
		}
		
		private function heightTween():void
		{
			TweenLite.to($main.maskMC, 0.6, {y:0, height:600, ease:Expo.easeOut, onComplete:videoPlay});
		}
		
		private function videoPlay():void
		{
			$model.dispatchEvent(new ModelEvent(ModelEvent.VIDEO_PLAY));
		}
	}
}