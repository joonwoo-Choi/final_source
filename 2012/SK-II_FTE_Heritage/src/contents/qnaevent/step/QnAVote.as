package contents.qnaevent.step
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.sw.buttons.Button;
	import com.sw.display.AlignBitmap;
	import com.sw.display.PlaneClip;
	import com.sw.net.FncOut;
	import com.sw.net.Location;
	import com.sw.net.list.Write;
	
	import contents.qnaevent.QnAGlobal;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.CallBack;
	import net.HersheysFncOut;
	
	import util.BtnHersheys;
	
	/**		
	 *	SK2_Hersheys :: Q&A 투표 
	 */
	public class QnAVote extends BaseQnAStep
	{
		private var container:QnAVoteClip;
		/**	투표 위치	*/
		private var pos:int;
		/**	선택 내용 결과	*/
		private var arySelect:Array;
		/**	투표한 카운트	*/
		private var count:Write;
		/**	선택 최대 갯수	*/
		private var max:int;
		/**	선택 갯수	*/
		private var cnt:int;
		
		/**	등록 데이터	*/
		private var write:Write;
		
		/**	생성자	*/
		public function QnAVote(mc:MovieClip=null)
		{
			container = new QnAVoteClip();
			
			init();
			super(container);
			
			count.send({eNum:QnAGlobal.getIns().qPos});
			Global.getIns().addEventListener(CallBack.QNA_LOGIN,onLogin);
			Global.getIns().addEventListener(CallBack.QNA_FACEBOOK,onLogin);
		}
		/**	로그인 콜백*/
		private function onLogin(e:Event):void
		{
			onClickSelect();
		}
		/**	초기화	*/
		private function init():void
		{
			var url:String = Global.getIns().dataURL+"/Process/QnA/QnaPollSave.ashx";
			write = new Write(url,onWrite,{});	
			url = Global.getIns().dataURL+"/Process/QnA/GetQnaPollList.ashx";
			count = new Write(url,onLoadCount,{});
			
			arySelect = ["",false,false,false,false];
			
			cnt = 0;
			max = 3;
			
			pos = 1;
			if(QnAGlobal.getIns().qPos == 4)
			{
				pos = 2;
				max = 2;
			}
			
			container.mcTitle.gotoAndStop(pos);
			container.mcBtn.gotoAndStop(pos);
			
			for(var i:int = 1; i<=4; i++)
			{
				var btn:MovieClip = container["btnAnswer"+i] as MovieClip;
				btn.idx = i;
				var num:int = i+((pos-1)*4);
				btn.mcOver.gotoAndStop(num);
				btn.mcOut.gotoAndStop(num);
				btn.mcPlane.width = btn.width;
				btn.mcCheck.alpha = 0;
				
				Button.setUI(btn,{over:onOver,out:onOut,click:onClick});
			}
			BtnHersheys.getIns().go(container.btnSelect,onClickSelect);
		}
		/**	리스트 오버	*/
		private function onOver(mc:MovieClip):void
		{
			if(arySelect[mc.idx] == true) return;
			TweenMax.to(mc.mcCheck,0.5,{alpha:1,ease:Expo.easeOut});
			TweenMax.to(mc.mcMask,0.5,{width:mc.mcOver.width+5,ease:Expo.easeOut});
		}
		/**	리스트 아웃	*/
		private function onOut(mc:MovieClip):void
		{
			if(arySelect[mc.idx] == true) return;
			TweenMax.to(mc.mcCheck,0.5,{alpha:0,ease:Expo.easeOut});
			TweenMax.to(mc.mcMask,0.5,{width:2,ease:Expo.easeOut});
		}
		/**	리스트 클릭	*/
		private function onClick(mc:MovieClip):void
		{
			if(arySelect[mc.idx] == true)
			{
				arySelect[mc.idx] = false;
				onOut(mc);
				cnt--;
			}
			else if(cnt == max)
			{
				FncOut.call("alert",max+"개 까지 선택 할 수 있습니다.");	
			}
			else 
			{
				onOver(mc);
				arySelect[mc.idx] = true;	
				cnt++;
			}
			
		}
		
		/**	선택 완료	*/
		private function onClickSelect(mc:MovieClip = null):void
		{
			if(cnt == 0)
			{
				FncOut.call("alert","선택해 주세요");
				return;
			}
			
			var obj:Object = new Object();
			obj.eNum = QnAGlobal.getIns().qPos;
			obj.loginType = "N";
			if(QnAGlobal.getIns().bFacebook == true) obj.loginType = "F";
			
			for(var i:int = 1; i<arySelect.length; i++)
			{
				if(arySelect[i]	== true) obj["poll"+i] = "1";
				else obj["poll"+i] = "0";
			}
			write.send(obj);
		}
		/**	글 등록 완료	*/
		private function onWrite(result:String):void
		{
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
					FncOut.call("alert","메세지 길이를 체크 합니다.");
					break;
				case "-6":
					FncOut.call("alert","질문 4개중 하나가 null이거나 올바르지 않은값 입니다.");
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
		private function onLoadCount(result:String):void
		{
			var xml:XML = new XML(count.getData());
//			trace(xml);
			for(var i:int =0; i<4; i++)
			{
				var mcCount:MovieClip = container["mcCount"+(i+1)] as MovieClip;
				var str:String = xml.QnaPollThumList.QnaPollThum[i].@count.toString();
				if(str == "" || str == null) str = "0";
				setThumb(i);
				TweenMax.delayedCall((i*0.1)+0.5,onCountView,[mcCount,str]);
				
			}
		}
		/**	x위치 정렬	*/
		private function onCountView(mc:MovieClip,str:String):void
		{
			var num:int = setMcCount(mc,str);
			var pos:int = container.mcThumb1.x - num-5;
			TweenMax.to(mc,1,{x:pos,ease:Expo.easeOut});
		}
		/**	썸네일 구성	*/
		private function setThumb(num:int):void
		{
			var xml:XML = new XML(count.getData());
			var cXml:XML = xml.QnaPollThumList.QnaPollThum[num];
			var cnt:int = cXml.QnaPollThumData.length();
			
			var mcThumb:MovieClip = container["mcThumb"+(num+1)] as MovieClip;
			
			if(cnt == 0)
			{	//썸네일 갯수가 없을때
				TweenMax.to(mcThumb.mcDot,1,{alpha:0});
				return;
			}
			if(cnt > 3) cnt = 3;
			for(var i:int = 0; i<cnt; i++)
			{
				var spThumb:Sprite = new Sprite();
				spThumb.name = "thumb"+(num+1)+"_"+i;
				var plane:PlaneClip = new PlaneClip({color:0xffffff});
				plane.width = 32;
				plane.height = 32;
				spThumb.addChild(plane);
				spThumb.x = i*32;
				
				mcThumb.addChild(spThumb);
				
				var file:String = cXml.QnaPollThumData[i].QnaFbImg.toString();
				var loader:ImageLoader = new ImageLoader(file,{onComplete:onLoadThumb,name:spThumb.name});
				loader.load();
			}
			TweenMax.to(mcThumb.mcDot,1,{x:cnt*32,ease:Expo.easeOut});
		}
		/**	썸네일 로드 완료	*/
		private function onLoadThumb(e:LoaderEvent):void
		{
			var loader:ImageLoader = e.target as ImageLoader;
			var strName:String = "mcThumb"+loader.name.substr(5,1);
			//trace(strName);
			var mcThumb:MovieClip = container[strName] as MovieClip;
			var spThumb:Sprite = mcThumb.getChildByName(loader.name) as Sprite;
			var bit:Bitmap = loader.rawContent as Bitmap;
			bit = AlignBitmap.go(bit,31,31);
			bit.x = 1;
			bit.y = 1;
			bit.alpha = 0;
			spThumb.addChild(bit);
			TweenMax.to(bit,1,{alpha:1});
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			Global.getIns().removeEventListener(CallBack.QNA_LOGIN,onLogin);
			Global.getIns().removeEventListener(CallBack.QNA_FACEBOOK,onLogin);
		}
	}//class
}//package