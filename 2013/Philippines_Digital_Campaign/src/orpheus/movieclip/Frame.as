package orpheus.movieclip 
{
	import flash.utils.Dictionary;		import flash.display.FrameLabel;	
	import flash.display.MovieClip;
	import flash.events.Event;	

	public class Frame 
	{
		public static var dic:Dictionary = new Dictionary(true);
		public static function control(mc:MovieClip, targetFrame:*, startFrame:* = null, onComplete:Function = null, onUpdate:Function = null, step:uint = 1):void 
		{
			var tg:int;
			if (startFrame != null) 
			{
				if (startFrame is int) 
				{
					mc.gotoAndStop(startFrame);
				}
				else if (startFrame is String)
				{
					tg = labelSearch(mc, startFrame);
					if (tg) mc.gotoAndStop(tg);
					else return;
				}
				else 
				{
					return;
				}
			}
			
			if (targetFrame is String) 
			{
				tg = labelSearch(mc, targetFrame);
				if (tg) targetFrame = tg;
				else return;
			}
			dic[mc] = {targetFrame:targetFrame, step:step, onComplete:onComplete, onUpdate:onUpdate};
			stopControl(mc);
			
			if (step == 1)
			{
				mc.addEventListener(Event.ENTER_FRAME, f_enterframeHandler);
			}
			else
			{
				mc.addEventListener(Event.ENTER_FRAME, f_enterframeHandlerStep);
			}
			mc.addEventListener(Event.REMOVED_FROM_STAGE, f_removeHandler);
		}

		private static function f_enterframeHandler(event:Event):void 
		{
			var target:MovieClip = event.currentTarget as MovieClip;
			if (target.currentFrame < dic[target].targetFrame) 
			{
				target.play();
				if (dic[target].onUpdate) dic[target].onUpdate();
			}
			else if (target.currentFrame > dic[target].targetFrame) 
			{
				target.prevFrame();
				if (dic[target].onUpdate) dic[target].onUpdate();
			}
			else
			{
				target.stop();
				target.removeEventListener(Event.ENTER_FRAME, f_enterframeHandler);
				target.removeEventListener(Event.REMOVED_FROM_STAGE, f_removeHandler);

				var func:* = dic[target].onComplete;
				delete dic[target];
				if (func) func( );
			}
		}

		private static function f_enterframeHandlerStep(event:Event):void 
		{
			var next:int;
			var target:MovieClip = event.currentTarget as MovieClip;
			if (target.currentFrame < dic[target].targetFrame)
			{
				next = target.currentFrame + dic[target].step;
				if (next > dic[target].targetFrame) next = dic[target].targetFrame;
				target.gotoAndStop(next);
				if (dic[target].onUpdate) dic[target].onUpdate();
			}
			else if (target.currentFrame > dic[target].targetFrame) 
			{
				next = target.currentFrame - dic[target].step;
				if (next < dic[target].targetFrame) next = dic[target].targetFrame;
				target.gotoAndStop(next);
				if (dic[target].onUpdate) dic[target].onUpdate();
			}
			else
			{
				target.removeEventListener(Event.ENTER_FRAME, f_enterframeHandlerStep);
				target.removeEventListener(Event.REMOVED_FROM_STAGE, f_removeHandler);
				
				var func:* = dic[target].onComplete;
				delete dic[target];
				if (func) func( );
			}
		}

		private static function f_removeHandler(event:Event):void 
		{
			var target:MovieClip = event.currentTarget as MovieClip;
			target.removeEventListener(Event.ENTER_FRAME, f_enterframeHandler);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, f_removeHandler);
			
			delete dic[target];
		}

		
		public static function stopControl(mc:MovieClip):void 
		{
			mc.removeEventListener(Event.ENTER_FRAME, f_enterframeHandlerStep);			mc.removeEventListener(Event.ENTER_FRAME, f_enterframeHandler);
			mc.removeEventListener(Event.REMOVED_FROM_STAGE, f_removeHandler);
		}

		public static function labelSearch(mc:MovieClip, str:String):Number 
		{
			var labelArray:Array = mc.currentLabels;
			var labelFrame:int = 0;
			for ( var i:uint = 0;i < labelArray.length; i++ ) 
			{
				var labels:FrameLabel = labelArray[i]; 
				if ( labels.name == str ) labelFrame = labels.frame;
			}
			return labelFrame;
		}
	}
}
