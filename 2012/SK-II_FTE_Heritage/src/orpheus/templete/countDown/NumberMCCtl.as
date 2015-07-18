package orpheus.templete.countDown
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class NumberMCCtl
	{
		protected var _con:Sprite;
		public var groupNum:int;//세자리씩 감싸고 있는 그룹의 번호 
		public var myLifeNum:int;//내 그룹의 번호개수 내 그룹의 번호가 123이면 3
		public var myNumber:int;//내 번호 내가 987중 세번째 자리면 7
		public var myNum:int;//내 위치셋팅번호 myNumber값이 7이면 2
		private var _model:CountDownModel;
		private var _ty:Number;
		public function NumberMCCtl(con:Sprite)
		{
			_model = CountDownModel.getInstance();
			_con = con;
			_con.addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			_model.addEventListener(CountDownEvent.NUMBER_CHANGED,onChanged);
			_model.addEventListener(CountDownEvent.NUMBER_CHANGED2,onChanged2);
		}
		public function setting(del:Number):void{
			if(TweenMax.isTweening(_con)){
				TweenMax.killTweensOf(_con);
				_con.y = _ty;
			}
			_ty= _model.moveTY[myNumber];
			TweenLite.to(_con,.8,{y:_ty,ease:Cubic.easeInOut,delay:del});			
		}
		
		protected function onRemoved(event:Event):void
		{
			// TODO Auto-generated method stub
			_model.removeEventListener(CountDownEvent.NUMBER_CHANGED,onChanged);
		}
		
		protected function onChanged(event:Event):void
		{
			// TODO Auto-generated method stub
			myNumber = int(String(_model.numBank[groupNum]).charAt(myNum));
			if(groupNum==2){
			}
			setting(0);
		}
		protected function onChanged2(event:Event):void
		{
			// TODO Auto-generated method stub
			myNumber = int(String(_model.numBank[groupNum]).charAt(myNum));
			if(groupNum==2){
			}
			setting(_model.delTime[groupNum]+myNum*100);
		}
		
	}
}