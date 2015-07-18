package eventPop.keyBoardMain
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import hansune.events.HangleTextEvent;
	import hansune.text.HangleUnicodeComposer;
	
	public class VirtualKeyboardMain
	{
		protected var hangleComposer:HangleUnicodeComposer = new HangleUnicodeComposer();
		
		/**	한글인지 여부 **/
		protected var isKorean:Boolean = true;
		
		private var _container:MovieClip;
		
		private const koreanLower:Array = [
			"1","2","3","4","5","6","7","8","9","0",
			"ㅂ","ㅈ","ㄷ","ㄱ","ㅅ","ㅛ","ㅕ","ㅑ","ㅐ","ㅔ",
			"ㅁ","ㄴ","ㅇ","ㄹ","ㅎ","ㅗ","ㅓ","ㅏ","ㅣ",
			"ㅋ","ㅌ","ㅊ","ㅍ","ㅠ","ㅜ","ㅡ"];
		private const koreanUpper:Array = [
			"!","@","#","$","%","^","&","*","(",")",
			"ㅃ","ㅉ","ㄸ","ㄲ","ㅆ","ㅛ","ㅕ","ㅑ","ㅒ","ㅖ",
			"ㅁ","ㄴ","ㅇ","ㄹ","ㅎ","ㅗ","ㅓ","ㅏ","ㅣ",
			"ㅋ","ㅌ","ㅊ","ㅍ","ㅠ","ㅜ","ㅡ"];
		
		private const englishLower:Array = [
			"1","2","3","4","5","6","7","8","9","0",
			"q","w","e","r","t","y","u","i","o","p",
			"a","s","d","f","g","h","j","k","l",
			"z","x","c","v","b","n","m"];
		
		private const englishUpper:Array = [
			"!","@","#","$","%","^","&","*","(",")",
			"q","w","e","r","t","y","u","i","o","p",
			"a","s","d","f","g","h","j","k","l",
			"z","x","c","v","b","n","m"];
		
		
		public function VirtualKeyboardMain($clip:MovieClip)
		{
			super();
			
			_container = $clip;
			setEvent();
		}
		
		/**	키보드 키 변경	*/
		private function setKeyText(btn:MovieClip, str:String):void
		{
			var txt:TextField = btn.txt as TextField;
			txt.text = str;
		}
		
		/**	버튼 이벤트 등록	*/
		private function setEvent():void
		{
			var btn:MovieClip;
			for(var i:int=0; i<36; ++i)
			{
				btn = _container.getChildByName("key_"+i) as MovieClip;
				btn.idx = i;
				btn.mouseChildren = false;
				btn.buttonMode = true;
				btn.addEventListener(MouseEvent.MOUSE_DOWN, onButton);
			}
			
			_container.key_shift.selected = false;
			_container.key_shift.addEventListener(MouseEvent.MOUSE_DOWN, onShiftButton);
			
			_container.key_caps.selected = false;
			_container.key_caps.addEventListener(MouseEvent.MOUSE_DOWN, onCapsButton);
			
			_container.key_space.mouseChildren = false;
			_container.key_enter.mouseChildren = false;
			_container.key_del.mouseChildren = false;
			_container.key_kor.mouseChildren = false;
			_container.key_hi.mouseChildren = false;
			
			_container.key_space.addEventListener(MouseEvent.MOUSE_DOWN, onSpaceButton);
			_container.key_enter.addEventListener(MouseEvent.MOUSE_DOWN, onEnterButton);
			_container.key_del.addEventListener(MouseEvent.MOUSE_DOWN, onBackButton);
			_container.key_kor.addEventListener(MouseEvent.MOUSE_DOWN, onHanButton);
			_container.key_hi.addEventListener(MouseEvent.MOUSE_DOWN, onHiButton);
			
			hangleComposer.addEventListener(HangleTextEvent.UPDATE, onHangleComposite);
			stateUpdate();
		}		
		
		private function stateUpdate():void 
		{
			var keyAry:Array;
			
			if(isKorean)
			{	//한글 입력상황
				if(_container.key_shift.selected){
					keyAry = koreanUpper;	//shift키가 눌려져 있을때
				}else{
					keyAry = koreanLower; 	//shift키가 눌려져 있지 않을때
				}
			}
			else
			{	//영문 입력 상황
				if(_container.key_shift.selected){
					keyAry = englishUpper;	//shift키가 눌려져 있을때
				}else{
					keyAry = englishLower; 	//shift키가 눌려져 있지 않을때			
				}
			}
			
			var btn:MovieClip;
			var keyStr:String;
			for(var i:int = 0; i<36; i++)
			{
				btn = _container.getChildByName("key_"+i) as MovieClip;
				keyStr = keyAry[i];
				
				// 영문 대문자일때
				if(!isKorean){
					if(_container.key_caps.selected){
						keyStr = keyStr.toUpperCase();
					}
				}
				setKeyText(btn, keyStr);
			}
			
			if(isKorean) setKeyText(_container.key_kor,"영어");
			else setKeyText(_container.key_kor,"한글");
		}
		
		/**	텍스트 필드에 해당 내용 출력	*/
		protected function onHangleComposite(e:HangleTextEvent):void
		{
			var tf:TextField = _container.txt;
			var value1:String;
			var value2:String;
			var str:String;
			
			// 글자수 제한
			var limitLen:int = 400;
			var orijinStr:String;
			
			value1 = hangleComposer.compositionString;
			value2 = hangleComposer.extra;
			str = "<font color='#343434'>" + value1 + "</font><font color='#A30606'>"+ value2 +"</font>";
			
			orijinStr = value1 + value2;
			if(orijinStr.length > limitLen) return;
			
			tf.htmlText = str;
		}
		
		private function tweenTextColor(dop:DisplayObject):void
		{
			if(dop.parent != null) TweenMax.killChildTweensOf(dop.parent);
			
			TweenMax.to(dop, 0.6, {tint:0xc10003});
			TweenMax.delayedCall(0.6, delayTweenComplete, [dop]);
		}
		
		private function delayTweenComplete(dop:DisplayObject):void
		{
			TweenMax.to(dop, 0.6, {removeTint:true});
		}
		
		
		/**	숫자1~0,특수기호, 일반 자판 클릭	*/
		private function onButton(event:MouseEvent):void
		{
			var btn:MovieClip = event.currentTarget as MovieClip;
			var txt:TextField = btn.txt as TextField;
			var char:String = txt.text;
			
			// tween
			tweenTextColor(txt);
			
			// 숫자 / 기호
			if(btn.idx < 10) 
			{
				hangleComposer.addSpacialChar(char);
				return;
			}
			
			if(isKorean) hangleComposer.addJamo(char);
			else hangleComposer.addSpacialChar(char);
		}
		
		/**	대소문자 변환 키	*/
		private function onCapsButton(event:MouseEvent):void
		{
			_container.key_caps.selected = (_container.key_caps.selected)? false:true;
			
			if(_container.key_caps.selected){
				TweenMax.to(_container.key_caps.txt, 0.4, {tint:0xc10003});
			}else{
				TweenMax.to(_container.key_caps.txt, 0.4, {removeTint:true});
			}
			stateUpdate();
		}
		
		/**	Shift 키	*/
		private function onShiftButton(event:MouseEvent):void
		{
			_container.key_shift.selected = (_container.key_shift.selected)? false:true;
			
			if(_container.key_shift.selected){
				TweenMax.to(_container.key_shift.txt, 0.4, {tint:0xc10003});
			}else{
				TweenMax.to(_container.key_shift.txt, 0.4, {removeTint:true});
			}
			stateUpdate();
		}
		
		/**	스페이스바	*/
		private function onSpaceButton(event:MouseEvent):void
		{
			tweenTextColor(event.target.txt);
			
			hangleComposer.space();
		}
		
		/**	엔터	*/
		protected function onEnterButton(event:MouseEvent):void
		{
			tweenTextColor(event.target.txt);
			
			hangleComposer.addSpacialChar("\n");
		}
		
		/**	특수 기호 - 버튼	*/
		private function onHiButton(event:MouseEvent):void
		{
			tweenTextColor(event.target.txt);
			
			hangleComposer.addSpacialChar("-");
		}
		
		/**	글자 지우기 버튼	*/
		protected function onBackButton(event:MouseEvent):void
		{
			tweenTextColor(event.target.txt);
			
			var tf:TextField = _container.txt;
			hangleComposer.backSpace(tf.text.length);
		}
		
		/**	한영 교체 버튼	*/
		private function onHanButton(event:MouseEvent):void
		{
			tweenTextColor(event.target.txt);
			
			isKorean = (isKorean)? false:true;
			stateUpdate();
		}
		
		
		
	}
}