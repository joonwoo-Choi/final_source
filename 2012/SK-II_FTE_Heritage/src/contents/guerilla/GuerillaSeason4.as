package contents.guerilla
{
	import com.greensock.TweenMax;
	import com.sw.net.FncOut;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import net.CallBack;
	import net.HersheysFncOut;
	
	/**		
	 *	SK2_Hersheys :: 다이어트 게릴라 이벤트
	 */
	public class GuerillaSeason4 extends BaseGuerilla
	{
		private var viewTxt:TextField;
		private var btnTxt:TextField;
		
		private var baseTxt:String;
		private var maxTxt:int;
		
		/**	생성자	*/
		public function GuerillaSeason4($btnMc:MovieClip, $viewMc:MovieClip)
		{
			super($btnMc, $viewMc);
			init();
			setMenu();
			
			btnTxt.addEventListener(Event.ENTER_FRAME,onChangeTxt);
			Global.getIns().addEventListener(CallBack.EVENT4_COMMENT,onCallback);
			btnTxt.addEventListener(FocusEvent.FOCUS_IN,onFocusTxt);
		}
		/**	글 입력 완료 후 다음 영상 진행	*/
		private function onCallback(e:Event):void
		{
			playNextMovie();
		}
		/**	초기화	*/
		override protected function init():void
		{
			super.init();
			maxTxt = 50;
			baseTxt = maxTxt+"자 이내로 입력해 주세요.";
			
			btnMc.scaleX = 0.77;
			btnMc.scaleY = 0.8;
			btnMc.rotation = -20;
		
			viewTxt = viewMc.mcImg2.btnTxt.txt as TextField;
			btnTxt = btnMc.mcImg2.btnTxt.txt as TextField;
			
			setText(viewMc);
			setText(btnMc);
		}
		private function onFocusTxt(e:Event):void
		{
			if(btnTxt.text == baseTxt) btnTxt.text = "";
		}
		/**	입력 텍스트 필드 구성	*/
		private function setText(mc:MovieClip):void
		{
			var txt:TextField = mc.mcImg2.btnTxt.txt as TextField;
			txt.width = 330;
			txt.height = 100;
			txt.x = 20;
			txt.y = 15;
			txt.text = baseTxt;
			txt.maxChars = maxTxt;
			var tf:TextFormat = new TextFormat();
			tf.size = 15;
			txt.defaultTextFormat = tf;
		}
		/**	메뉴 구성	*/
		private function setMenu():void
		{
			for(var j:int = 1; j<=2; j++)
			{
				var img:MovieClip = btnMc["mcImg"+j] as MovieClip;
				for(var i:int =0; i<img.numChildren; i++)
				{
					var obj:Object = img.getChildAt(i);
					if(obj is MovieClip == false) obj.visible = false;
					else 
					{
						if(obj.name.substr(0,3) != "btn") continue;
						var viewObj:MovieClip = viewMc[obj.parent.name][obj.name] as MovieClip;
						obj.view = viewObj;
						
						obj.alpha = 0;
						obj.y -= 10;
						obj.height += 20;
					}
				}
			}
			
			//첫페이지 (글 쓸지 여부)
			setButton(btnMc.mcImg1.btnWrite,onClick);
			setButton(btnMc.mcImg1.btnSkip,onClick);
			
			//두번째 페이지 (글 입력)
			setButton(btnMc.mcImg2.btnSend,onClick);
			
			viewMc.mcImg2.btnTxt.planeMc.visible = false;
			
			btnMc.mcImg1.visible = true;
			btnMc.mcImg2.visible = false;
		}
		/**	버튼 클릭	*/
		private function onClick(mc:MovieClip):void
		{
//			trace(mc.name);
			switch(mc.name)
			{
			case "btnWrite":
				btnMc.mcImg1.visible = false;
				btnMc.mcImg2.visible = true;
				TweenMax.to(viewMc.mcImg1,1,{alpha:0});
			break;
			case "btnSkip":
				playNextMovie();
			break;
			case "btnSend":
				if(viewTxt.text == baseTxt || viewTxt.text == "")
				{
					FncOut.call("alert","내용을 입력해 주세요.");
					return;
				}
				HersheysFncOut.sendEvent4(viewTxt.text);
			break;
			}
		}
		/**	텍스트 내용 view 보여지기	*/
		private function onChangeTxt(e:Event):void
		{
			viewTxt.text = btnTxt.text;
			viewTxt.scrollH = btnTxt.scrollH;
			viewTxt.scrollV = btnTxt.scrollV;
		}
		/**	소멸자	*/
		override public function destroy(e:Event=null):void
		{
			super.destroy(e);
			btnTxt.removeEventListener(Event.ENTER_FRAME,onChangeTxt);
			Global.getIns().removeEventListener(CallBack.EVENT4_COMMENT,onCallback);
			btnTxt.removeEventListener(FocusEvent.FOCUS_IN,onFocusTxt);
		}
	}//class
}//package