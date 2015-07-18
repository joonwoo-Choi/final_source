package com.sw.utils
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 텍스트 관련 함수 클래스<br>
	 * ex : (자간,행간,볼드 적용) SetText.space(field,{letter:-1,leading:2,bold:true});<br>
	 * ex : ()
	 * */
	public class SetText extends Sprite
	{
		public var txt:TextField;
		/** 	생성자		*/
		public function SetText()
		{}
		/**	소멸자		*/
		public function destroy():void
		{		}
		/**  
		 * 기본 textField 생성
		 * */
		public function fN_Test():void
		{
			txt = new TextField();
			addChild(txt);
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.textColor = 0xffffff;
			txt.autoSize = "left";
			txt.width = 500;
			txt.height = 500;
			//txt.text = rootURL+"menuName.xml";
		}		
		/**
		 * 텍스트 자간,행간,볼드,사이즈 셋팅
		 * @param $txtField	:: 텍스트 필드
		 * @param $data		:: {letter,leading,bold,size}
		 * 
		 */
		static public function space($txtField:TextField,$data:Object):void
		{
			var my_txt:TextFormat = new TextFormat();
			
			if($data.size == null || $data.size < 48)
				$txtField.antiAliasType = AntiAliasType.ADVANCED;
			if($data.align != null) my_txt.align = $data.align;
			if($data.letter != null) my_txt.letterSpacing = $data.letter;		//자간
			if($data.leading != null) my_txt.leading = $data.leading;			//행간
			if($data.bold != null) my_txt.bold = $data.bold;					//굵기
			if($data.size != null) my_txt.size = $data.size;					//크기
			
			//폰트
			if($data.font != null)
				my_txt.font = $data.font;
			
			$txtField.defaultTextFormat = my_txt;
			$txtField.setTextFormat(my_txt);
			
			if($data.font != null)
				$txtField.embedFonts = true;
		}
		
		/**	숫자 내용 10보다 작으면 앞에 0붙인 문자열 반환		*/
		static public function plus0($num:Number):String
		{
			if($num < 10) return "0"+$num;
			return String($num);
		}
		/**	한줄 띄우는 내용 모두 지우기	*/
		static public function del($txt:String):String 
		{
			$txt = SetText.checkTxt($txt,"\n");
			$txt = SetText.checkTxt($txt,"\r");
			$txt = SetText.checkTxt($txt,"\t");
			
			return $txt;
		}
		/**
		 * <p>일정 문자 삭제
		 * @param $txt		:: 삭제전 원본 문자	(String)
		 * @param $txt2	:: 삭제할 문자 		(String)
		 * @return 			:: 삭제 완료 후 문자	(String) 
		 * 
		 */
		static public function checkTxt($txt:String,$txt2:String=""):String
		{
			var num:Number = 1;
			var tmpT:String = $txt;
			while(tmpT.indexOf($txt2)!=-1)
			{
				tmpT=tmpT.substr(0,tmpT.indexOf($txt2))+tmpT.substr(tmpT.indexOf($txt2)+1);
				if(num > 30) break;
				num++;
			}
			return tmpT;		
		}
		/**
		 * <p>일적 텍스트 내용 일정 다른 텍스트로 바꾸기	
		 * $txt2가 $txt3으로 변함
		 * @param $txt		::	변형전 원본 문자	(String)
		 * @param $txt2	::	변형될 문자			(String)
		 * @param $txt3	::	변형할  문자		(String)
		 * @return 			::	변형 완료 후 문자	(String) 
		 * 
		 */
		static public function change($txt:String,$txt2:String,$txt3:String):String
		{
			var num:Number = 1;
			var tmpT:String = $txt;
			while(tmpT.indexOf($txt2)!=-1)
			{
				tmpT=tmpT.substr(0,tmpT.indexOf($txt2))+$txt3+
					tmpT.substr(tmpT.indexOf($txt2)+$txt2.length);
				if(num > 30) break;
				num++;
			}
			return tmpT;
		}		
		/**
		 * 가격 등 숫자 3자리 단위 마다 ,찍기
		*/
		static public function setPrice($txt:Object):String
		{
			$txt = String($txt);
			var txt:String = String($txt);
			var num:Number = Math.floor($txt.length/3);
			if($txt.length%3 == 0) num--;
			
			for(var i:Number = 1; i<=num; i++)
			{
				var pos:Number = $txt.length-(i*3);
				txt = txt.substr(0,pos)+","+txt.substr(pos);
			}
			return txt;
		}
		
		/**
		 * 데이터 받아온 결과값의 내용 반환<br>
		 * @param $org			::		원본 글자<br>
		 * @param $front		::		앞쪽 글자<br>
		 * @param $back			::		뒷쪽 글자<br>
		 * @return 				::		앞과 뒤 사이 글자 반환
		 */
		static public function getPosText($org:String,$front:String,$back:String=""):String
		{
			var txt:String;
			var cnt1:int = $front.length;
			var cnt2:int = $back.length;
			
			if($back != "")
				txt = $org.substr($org.indexOf($front)+cnt1,$org.indexOf($back)-($org.indexOf($front)+cnt1));
			else txt = $org.substr($org.indexOf($front)+cnt1);
			
			return txt;
		}
	}//class
}//package