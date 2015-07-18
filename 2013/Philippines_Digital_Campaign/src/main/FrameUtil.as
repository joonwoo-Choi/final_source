/**
* @author mae
* @email devmae@gmail.com
* @since 071101
* @usage frame utility
*/


package main {
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	public class FrameUtil{
		//--------------------------------------------------------------------------------//
		//------------------------------------METHOD------------------------------------//
		//--------------------------------------------------------------------------------//
		/**
		 * 원하는 프레임에 도착했을 때 함수 실행시키기
		 * @param	mc : 프레임 이동이 일어날 무비클립
		 * @param	frame : 도착할 프레임
		 * @param func : frame에 도착해서 실행할 함수
		 * @param ...arg : func에 넘길 파라미터들
		 */
		public static function arriveFrame(mc:MovieClip, frame:int, func:Function, ...arg):void {
			if (frame <= 0) {
				throw new Error("mae.utils.FrameUtil.arriveFrame :: frame을 1 이상으로 지정해 주십시오");
			}
			
			mc.vars = 0;
			
			
			//목표 프레임 중 가장 뒤의 프레임 설정하기
			if (mc.lastFrame == undefined || mc.lastFrame < frame) {
				mc.lastFrame = frame;
			}
			
			//dynamic property 설정하기
			if(!FrameUtil.existDynamicProperty(mc, "frame", frame)){
				FrameUtil.addDynamicProperty(mc, "frame", frame);
				FrameUtil.addDynamicProperty(mc, "func", func);
				FrameUtil.addDynamicProperty(mc, "arg", arg);
			}
			
			mc.addEventListener(Event.ENTER_FRAME, FrameUtil.onEnterMc);
		}
		
		//무비클립에 다이나믹 속성 추가하기
		private static function addDynamicProperty(mc:MovieClip, propName:String, arg:Object) :void{
			if (mc[propName] == undefined) {
				mc[propName] = [arg];			//각 속성을 배열로 만들기
			}else {
				mc[propName].push(arg);
			}
		}
		
		//목표 프레임이 이미 설정되어 있는지 아닌지 체크하기
		private static function existDynamicProperty(mc:MovieClip, propName:String, frame:int):Boolean {
			var result:Boolean = false;
			
			if (mc[propName] != undefined) {
				var arr:Array = mc[propName];
				var leng:int = arr.length;
				for (var i:int = 0; i < leng; i++) {
					//이미 설정된 프레임이면 추가하지 않기
					if (arr[i] == frame) {
						result = true;
					}
				}
			}
			
			return result;
		}
		
		//매 프레임 목표 프레임에 도착했는지 체크하기
		private static function onEnterMc(e:Event):void {
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			var leng:int = mc.frame.length;
			
			//목표프레임에 모두 도달했거나, 목표 프레임 중 가장 뒤의 프레임에 도착하면 enter frame event 지워주기
			if (leng == 0 || mc.vars++ > mc.lastFrame) {
				mc.removeEventListener(Event.ENTER_FRAME, onEnterMc);
				delete mc.frame;
				delete mc.func;
				delete mc.arg;
				delete mc.vars;
				
				return;
			}
			
			var currFrame:int = mc.currentFrame;
			for (var i:int = 0; i < leng; i++) {
				if (currFrame == mc.frame[i]) {
					if (mc.arg[i].length > 0) {
						setTimeout(mc.func[i].apply, 1, null, mc.arg[i]);
					}else {
						setTimeout(mc.func[i], 1);
					}
					
					//이미 도착한 프레임은 체크 안하도록 배열에서 지워주기
					mc.frame.splice(i, 1);
					mc.func.splice(i, 1);
					mc.arg.splice(i, 1);
				}
			}
		}
	}
}