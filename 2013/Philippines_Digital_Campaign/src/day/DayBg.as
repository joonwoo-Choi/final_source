package day
{
	import com.adqua.system.SecurityUtil;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	
	[SWF(width="1280",height="850",frameRate="30")]
	public class DayBg extends AbstractMain
	{
		private var $dayBg:DayBackBg;
		private var keyMovNum:int;
		public function DayBg()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		override protected function onAdded(event:Event):void
		{
			//Day 배경이미지
			$dayBg = new DayBackBg;
			addChild($dayBg);
			//랜덤bg
			bgChange();
			
//			var url:String = SecurityUtil.getPath(root)+_model.xmlData.daybg[0].list[keyMovNum].@img;
			var url:String = _model.xmlData.daybg[0].list[keyMovNum].@img;
			var thumbLoader:ImageLoader = new ImageLoader(url,{
				container:$dayBg.bgCon, 
				smoothing:true,
				x:0,
				width: 1280, height: 850,
				onComplete:imgShow,
				alpha:1
			});
			thumbLoader.load(); 
		}
		
		protected function imgShow(evt:LoaderEvent):void
		{
//			TweenLite.to(evt.target.content, .5,{alpha:1});
		}
		
		protected function bgChange():void
		{
			//시간대별 DayBg 랜덤배경
			var now:Date = new Date();
			var prNum:int
			
//			밤 keyMovNum = 2 (7)
			if(now.hours < 6){
				keyMovNum = 7;
				
//			아침 keyMovNum = 0 (0,1,2)
			}else if(now.hours < 12){
				prNum = Math.ceil(Math.random()*4)-1; 
				keyMovNum = prNum;
				
				
//			낮 keyMovNum = 1 (3,4,5,6)
			}else if(now.hours < 18){
				prNum = Math.ceil(Math.random()*5) - 1 + 3; 
				keyMovNum = prNum;
				
				
//			저녁 keyMovNum = 2 (7)
			}else if(now.hours < 24){
				keyMovNum = 7;
			}
			
			/** 하단 타이틀 컬러 셋팅 */
			switch (keyMovNum)
			{
				case 0 :
					_model.underTitleFrameSrtting = 1; //어두울때
					break;
				case 1 :
					_model.underTitleFrameSrtting = 1; 
					break;
				case 6 :
					_model.underTitleFrameSrtting = 1; 
					break;
				case 7 :
					_model.underTitleFrameSrtting = 1; 
					break;
				case 2 :
					_model.underTitleFrameSrtting = 1; 
					break;
				case 3 :
					_model.underTitleFrameSrtting = 2; 
					break;
				case 4 :
					_model.underTitleFrameSrtting = 2; 
					break;
				case 5 :
					_model.underTitleFrameSrtting = 1; 
					break;
			}
		}
	}
}