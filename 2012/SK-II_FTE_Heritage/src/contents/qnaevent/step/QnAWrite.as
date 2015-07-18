package contents.qnaevent.step
{
	import com.sw.net.FncOut;
	import com.sw.net.Location;
	import com.sw.net.list.Write;
	
	import contents.qnaevent.QnAGlobal;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import net.CallBack;
	import net.HersheysFncOut;
	
	import util.BtnHersheys;
	
	/**		
	 *  SK2_Hersheys :: Q&A 글 등록
	 */
	public class QnAWrite extends BaseQnAStep
	{
		/**	그래픽	*/
		private var container:QnAWriteClip;
		/**	영상 내용의 위치	*/
		private var pos:int;
		
		/**	글등록 기본 글자	*/
		private var baseTxt:String;
		
		/**	글 등록 데이터	*/
		private var write:Write;
		
		/**	글 리스트	*/
		private var list:QnAWriteList;
		
		/**	생성자	*/
		public function QnAWrite(mc:MovieClip=null)
		{
			container = new QnAWriteClip();
			
			init();
			list = new QnAWriteList(container.mcList);
			super(container);
			
			Global.getIns().addEventListener(CallBack.QNA_LOGIN,onLogin);
			Global.getIns().addEventListener(CallBack.QNA_FACEBOOK,onLogin);
		}
		/**	로그인 콜백*/
		private function onLogin(e:Event):void
		{
			onClickWrite();
		}
		/**	초기화	*/
		private function init():void
		{
			baseTxt = "50자 내로 입력해 주세요!";
			
			container.txt.maxChars = 50;
			container.txt.text = baseTxt;
			container.txtCnt1.text = "0";
			container.txtCnt2.text = "0";
			
			pos = QnAGlobal.getIns().qPos;
			
			container.mcTitle.gotoAndStop(pos);
			container.txt.addEventListener(FocusEvent.FOCUS_IN,onFocus);
			container.txt.addEventListener(Event.CHANGE,onChange);
			
			BtnHersheys.getIns().go(container.btnWrite,onClickWrite);
		
			var url:String = Global.getIns().dataURL+"/Process/QnA/QnaCommentSave.ashx";
			write = new Write(url,onWrite,{});
		}
		/**	텍스트 집중	*/
		private function onFocus(e:Event):void
		{		
			if(container.txt.text == baseTxt) container.txt.text = "";
		}
		/**	글 등록 중 갯수 출력	*/
		private function onChange(e:Event):void
		{
			container.txtCnt1.text = container.txt.length+"";
			container.txtCnt2.text = container.txt.length+"";
		}
		/**	글 등록	*/
		private function onClickWrite(mc:MovieClip=null):void
		{
			if(container.txt.text == baseTxt || container.txt.text == "") 
			{
				FncOut.call("alert","내용을 입력해 주세요.");
				return;
			}
			var obj:Object = new Object();
			var strComment:String = container.txt.text;
			obj.message = strComment;
			obj.eNum = pos;
			obj.loginType = "N";
			if(QnAGlobal.getIns().bFacebook == true) obj.loginType = "F";
			
			write.send(obj);	
		}
		
		/**	글 등록 완료 결과	*/
		private function onWrite(result:String):void
		{
//			trace(result);
//			trace(write.getData());
			result = write.getData() as String;
			
			if(Location.setURL("local","") == "local")
			{	//로컬 상에서 테스트 할시에는 자동으로 진행
				result = "1";
			}
			switch(result)
			{
			case "-9":
				FncOut.call("alert","데이터 베이스 오류 입니다.");
			break;
			case "-8":
				FncOut.call("alert","loginType이 지정되지 않았습니다.");
			break;
			case "-7":
				FncOut.call("alert","메시지가 50자 이상입니다.");
			break;
			case "-6":
				FncOut.call("alert","메시지가 없습니다.");
			break;
			case "-5"://페이스북 로그인이 필요
				HersheysFncOut.qnaLoginFB();
			break;
			case "-4"://페이스북 비로그인 필요
				HersheysFncOut.qnaLogin();
			break;
			case "0":
				FncOut.call("alert","등록 프로세스를 타지 않았습니다.");
			break;
			}
			
			if(result != "1") return;
			
			QnAGlobal.getIns().setComplete(QnAGlobal.getIns().qPos);
			QnAGlobal.getIns().moveStep(5);
			
		}
		/**	소멸자	*/
		override public function destroy():void
		{
			super.destroy();
			
			if(list != null)
			{
				list.destroy();
				list = null;
			}
			container.txt.removeEventListener(FocusEvent.FOCUS_IN,onFocus);
			container.txt.removeEventListener(Event.CHANGE,onChange);
			Global.getIns().removeEventListener(CallBack.QNA_LOGIN,onLogin);
			Global.getIns().removeEventListener(CallBack.QNA_FACEBOOK,onLogin);
		}
	}//class
}//package