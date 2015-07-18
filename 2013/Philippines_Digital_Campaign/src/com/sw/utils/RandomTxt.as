package com.sw.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * 랜덤으로 텍스트 변형 되면서 보여지는 클래스<br>
	 * base		: 처음에 채워질 문자
	 * finish 	: 완료 후 수행 함수<br>
	 * space 	: 글자 자간<br>
	 * speed 	: 변하는 속도 (0~1) <br>
	 * <p> ex : new Random(txtField,"aaaa",{base:"0",space:-1,speed:0.7,finish:onFinish});
	 * */
	public class RandomTxt extends Sprite
	{
		private var data:Object;
		private var field:TextField;			//표시할 textField
		private var dirTxt:String;				//최종 보여질 문자
		private var cbk_finish:Function;		//완료후 수행 함수
		private var txtCnt:Number;				//글목표 글자수
		private var space:Number;				//자간
		private var txtAry:Array;				//랜덤으로 보여질 문자열
		private var speed:Number;				//움직임 속도 조절 위한 변수
		private var base:String;				//처음에 체워지는 문자열
		private var frameCnt:Number;			//
		
		/**
		 * 생성자
		 * @param $field 	::	모습이 보여질 텍스트 필드
		 * @param $dirTxt	::	최종적으로 보여질 텍스트
		 * @param $data		:: {increase:true<숫자하나씩 증가>,price:<숫자3개단위,찍기>}
		 */
		public function RandomTxt($field:TextField,$dirTxt:String,$data:Object)
		{
			super();
			field = $field;
			dirTxt = $dirTxt;
			data = $data;
			
			init();
			addEvent();
		}
		
		/**
		 * 초기화
		 * */
		private function init():void
		{
			frameCnt = 0;
			cbk_finish =	(data.finish) ? (data.finish) : null;
			space =		(data.space) ? (data.space) : (-1);
			speed =		(data.speed) ? (data.speed) : (0.7);	
			base =		(data.base) ? (data.base) : ("0");
			
			field.text = base;
			txtAry = new Array();
			txtCnt = dirTxt.length;
			
			for (var i:Number=0; i<txtCnt; i++) 
			{	
				txtAry.push(randomTxt());	
				if(data.increase == true) txtAry[i] = "0";
			}
		}
		/**
		 * 이벤트 등록
		 * */
		private function addEvent():void
		{
			this.addEventListener(Event.ENTER_FRAME,onEnter);
			onEnter(null);
		};
		/**
		 * 반복적으로 수행할 함수
		 * */
		private function onEnter(e:Event):void
		{
			frameCnt += speed;
			
			speed += 0.01;
			
			if(frameCnt <= 1) return;
			frameCnt = 0;
			if(txtCnt <= field.length)
			{
				for(var j:int=0; j<txtCnt; j++) 
				{
					if(data.increase == true)
					{	//하나씩 증가
						var num:int = (txtCnt-j)-1;
						if(txtAry[num] == dirTxt.charAt(num)) continue;
						
						txtAry[num] = (int(txtAry[num])+1)+"";
						break;
					}
					if(txtAry[j] != dirTxt.charAt(j)) txtAry[j] = randomTxt();
					else txtAry[j] = dirTxt.charAt(j);	
				}
				
				if(field.text == dirTxt)
				{	//완료
					if(data.price == true) field.text = SetText.setPrice(field.text);
					SetText.space(field,{letter:space});
					if(cbk_finish != null) cbk_finish();
					
					this.removeEventListener(Event.ENTER_FRAME,onEnter);
					return;
				}
				
				field.text = txtAry.join("");
				SetText.space(field,{letter:space});
				return;
			}
			if(txtCnt > field.length)
			{	//처음에는 초기 문자를 하나씩 쌓기
				field.text = base+field.text;
			}
		}
		
		/**	배열 섞기	*/
		private function randoma($array:Array):Array 
		{
			var return_a:Array = new Array();	
			var aryLength:Number = $array.length;
			
			for (var n:Number =0; n<aryLength; n++) 
			{
				var index:Number = Math.floor(Math.random()*$array.length);
				return_a.push($array[index]);
				$array.splice(index,1);
			}
			return return_a;
		}
		/**	랜덤으로 표시될 문자 내용	*/
		private function randomTxt():Object
		{	//0~9 반환
			return Math.round(Math.random()*9); 
			/*
			//0~9 , 를 표현
			k = random(10);
			if(k == 10) k = ",";
			return k;	
			//특수 문자를 표현
			return String.fromCharCode(Math.floor(Math.random()*(95-33+1))+33);
			*/
		}	
		/**	소멸자	*/
		public function destroy():void
		{	
			
		}
		
	}//class
}//package