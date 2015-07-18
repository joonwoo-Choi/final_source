package util.popup
{
	import com.sw.buttons.Button;
	import com.sw.net.FncOut;
	import com.sw.net.Location;
	import com.sw.ui.ImgView;
	import com.sw.utils.SetText;
	
	import event.MovieEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.setTimeout;
	
	import net.CallBack;
	import net.ConLoader;
	import net.HersheysFncOut;
	import net.Track;
	
	import util.BtnHersheys;
	import util.Clock;
	
	
	/**		
	 *	SK2_Hersheys :: 메인 팝업
	 */
	public class Popup extends BaseHersheysPopup
	{
		private var infoImgView:ImgView;
		
		/**	생성자	*/
		public function Popup($scope:Object, $data:Object=null)
		{
			super($scope, $data);
			init();
		}
		
		/**	영상 플레이 완료 후 뜨는 팝업	*/
		public function finishPop():void
		{
			BtnHersheys.getIns().go(body_mc.btn,onClickFinish);
			for(var i:int = 0; i<=2; i++)
			{
				var txt:TextField = body_mc["txt"+i] as TextField;
				txt.text = "";
				txt.autoSize = TextFieldAutoSize.LEFT;
			}
			Clock.getIns().getSeasonDay(setFinishPopDay);
		}
		/**	다음 시즌 내용 안내 적용	*/
		private function setFinishPopDay(ary:Array):void
		{
			var date:Date = ary[4] as Date;
			trace("ary[3]:"+ary[3]);
			var txtAry:Array = [""];
			var dayAry:Array = [1,5,10,14];
			
			var dayTxtAry:Array = 
			[
				"2월1일","2월5일","2월10일","2월14일",
				"2월15일","2월19일","2월24일","2월28일",
				"2월29일","3월4일","3월9일","3월14일",
				"3월14일","3월18일","3월23일","3월27일"
			]
			
			var i:int;
			var pos:int;
			body_mc.txt0.text = "다음 생방송";
			body_mc.txt2.text = "많이 기대해 주세요!";
			for( i=0; i<dayAry.length; i++)
			{
				if(ary[2] <= dayAry[i])
				{
					pos = i;
					//body_mc.txt1.text = "Day "+dayAry[i];
					body_mc.txt1.text = "Day "+dayAry[i]+"("+dayTxtAry[ary[3]]+")";
					break;
				}
			}
			if(ary[2] == 1 || ary[2] == 5 || ary[2] == 10 ||ary[2] == 14)
			{	//시즌 당일 날
				if(date.getHours() >= 14)
				{	//생방송 후
					if(ary[2] == 14) 
					{	//14일째 날
						body_mc.txt0.text = "다음 시즌 생방송을 많이 기대해 주세요!";
						body_mc.txt1.text = "";
						body_mc.txt2.text = "";
					}
					else
					{	//
						body_mc.txt1.text = "Day "+dayAry[pos+1]+"("+dayTxtAry[ary[3]]+")";
					}
				}
			}
			SetText.space(body_mc.txt0,{letter:-1});
			SetText.space(body_mc.txt1,{letter:-1});
			SetText.space(body_mc.txt2,{letter:-1});
			body_mc.txt1.x = body_mc.txt0.width+body_mc.txt0.x+2;
			body_mc.txt2.x = body_mc.txt1.width+body_mc.txt1.x+2;		
		}
		
		public function finishPop_destroy():void{}
		/**	이벤트 페이지 가기 버튼 클릭	*/
		private function onClickFinish(mc:MovieClip):void
		{
			Track.go("46","04");
			HersheysFncOut.link(2,0);
		}
		/**	이벤트 정보 팝업	*/
		public function evtInfo():void {}
		public function evtInfo_destroy():void{}
		
		/**	재방송 팝업	*/
		public function review():void 
		{
			BtnHersheys.getIns().go(body_mc.btn,onPlayMovie);
		}
		/**	영상 플레이	*/
		private function onPlayMovie(mc:MovieClip):void
		{
			hidePop();
			Global.getIns().playMovie();	
		}
		public function review_destroy():void{}
		
		public function loginPop():void
		{
			BtnHersheys.getIns().go(body_mc.btn,onClickNext);
		}
		/**	페이스북 로그인 하지 않고 다음 영상 내용으로 넘어가기	*/
		private function onClickNext(mc:MovieClip):void
		{
			trace("hidePop");
			hidePop();
			Global.getIns().nextMovie();
		}
		public function loginPop_destroy():void{}
		
		
		/**	개릴라 이벤트 친구초대 취소 팝업	*/
		public function cancelPop():void
		{
			BtnHersheys.getIns().go(body_mc.btn,onClickNext);
		}
		public function cancelPop_destroy():void{}
		
		
		/**	게릴라 이벤트 참여 시간 후 팝업 표시 	*/
		public function evtAlert():void
		{
			BtnHersheys.getIns().go(body_mc.btn,onClickEvtAlertBtn);
		}
		private function onClickEvtAlertBtn(mc:MovieClip):void
		{	hidePop();	}
		public function evtAlert_destroy():void{}
		
		
		/**	초기 진입시 팝업	*/
		public function firstPop():void
		{
			ConLoader.getIns().setHideLoading();
			BtnHersheys.getIns().go(body_mc.btn1,onClickFirst);
			BtnHersheys.getIns().go(body_mc.btn2,onClickFirst);
			Button.setUI(body_mc.btn3,{click:onClickFirst});
			setTimeout(function():void{body_mc.btn3.dispatchEvent(new MouseEvent(MouseEvent.CLICK));},500);
		}
		/**	초기 버튼 내용 클릭	*/
		private function onClickFirst(mc:MovieClip):void
		{
			if(mc.name == "btn1" || mc.name == "btn3")
			{
				hidePop();
				ConLoader.getIns().setViewLoading();
				Global.getIns().dispatchEvent(new MovieEvent(MovieEvent.FIRST));
			}
			if(mc.name == "btn2")
			{	//후기 이벤트 페이지
				HersheysFncOut.link(2,0);
			}
		}
		public function firstPop_destroy():void{}
		
		/**	2차 이벤트 전 광고 팝업	*/
		public function infoFB():void
		{
			ConLoader.getIns().setHideLoading();
			Button.setUI(body_mc.btn3,{click:onClickFirst});
			/*
			$scope :: 전체 내용이 있는 obj
			$imgAry :: 이미지 내용 array
			$data :: 
			scroll : 스크롤 
			img : 이미지 
			mask : 마스크
			loading: 로딩 클래스
			complete : 로드 완료후 수행함수 ()
			wheel : 휠 정도 
			speed : 드래그 스피드 
			ex : new ImgView(view,imgAry,{speed:0.5,
			img:img_mc,mask:view.mask_mc,
			loading:loading,
			enter:checkView,
			wheel:20,
			complete:onLoadComplete});
			*/
			var obj:Object = new Object();
			obj.mask = body_mc.mcList.mcMask;
			obj.img = body_mc.mcList.mcImg;
			obj.scroll = body_mc.mcList.mcScroll;
			obj.speed = 0.3;
			
			infoImgView = new ImgView(body_mc.mcList,[],obj);
			infoImgView.doingScroll();
		}
		
		public function infoFB_destroy():void
		{
			infoImgView.destroy();
			infoImgView = null;
		}
		
		/**	Q&A 로그인 팝업	*/
		public function qnaLogin():void
		{
			
			BtnHersheys.getIns().go(body_mc.btnLogin,onClickQnALogin);
			BtnHersheys.getIns().go(body_mc.btnFB,onClickQnALogin);
		}
		
		private function onClickQnALogin(mc:MovieClip):void
		{
			if(Location.setURL("local","") == "local")
			{	//로컬 상에서 테스트 할시에는 자동으로 진행
				Global.getIns().dispatchEvent(new Event(CallBack.QNA_LOGIN));
				return;
			}
			
			if(mc.name == "btnLogin") HersheysFncOut.qnaLogin();
			if(mc.name == "btnFB") HersheysFncOut.qnaLoginFB();
		}
		
		public function qnaLogin_destroy():void
		{}
	}//class
}//package