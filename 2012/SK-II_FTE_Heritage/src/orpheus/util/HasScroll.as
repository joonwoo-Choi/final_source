package orpheus.util {
	import downy.AbstractMCCtl;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.alumican.as3.ui.justputplay.scrollbars.JPPScrollbar;

	/**
	 * @author yujango
	 */
	public class HasScroll extends AbstractMCCtl
	{
		protected var _body : Sprite;
		protected var _bodyMask : Sprite;
		protected var _base : Sprite;
		protected var _slider : Sprite;
		protected var _scrollbar : JPPScrollbar;
		protected var _upperBound : Number;
		protected var _lowerBound : Number;
		protected var _key : String;
		protected var _target : Sprite;

		public function HasScroll(con:Sprite) {
			super(con);
		}
		
		public function setting(contentName:String,maskName:String):void{
			_body = _con[contentName];
			_bodyMask = _con[maskName];
			_base = _con["scrollBox"]["base"];
			_slider = _con["scrollBox"]["slider"];	
			scrollSetting();
		}


		private function scrollSetting() : void {
			_upperBound = _body.y;
			_lowerBound = _body.y - (_con.height - _bodyMask.height);
			
			trace("_lowerBound: ",_lowerBound);
			_key= "y";
			_target = _body;
			_scrollbar = new JPPScrollbar(_con.stage);
			_scrollbar.base   = _base;      //スクロールエリアとしてバインドするインスタンスを設定します.
			_scrollbar.slider = _slider;
			_scrollbar.useFlexibleSlider = false;
			_scrollbar.setup(
				_target,      //スクロール対象となるオブジェクトです．
				_key,         //スクロール対象コンテンツが保持している, スクロールによって実際に変化させたいプロパティ名を表します.
				_body.height, //スクロール対象コンテンツの総計サイズを設定します.
				_bodyMask.height, //スクロール対象コンテンツの表示部分のサイズを設定します.
				_upperBound,  //スライダーが上限に達したときの変化対象プロパティの値を設定します.
				_lowerBound   //スライダーが下限に達したときの変化対象プロパティの値を設定します.
			);
		}
		
		protected function scrollReset(num:int):void{
			_upperBound = _body.y;
			_lowerBound = _body.y - (_con.height - _bodyMask.height+20);
			_scrollbar.setup(
				_target,      //スクロール対象となるオブジェクトです．
				_key,         //スクロール対象コンテンツが保持している, スクロールによって実際に変化させたいプロパティ名を表します.
				num, //スクロール対象コンテンツの総計サイズを設定します.
				_bodyMask.height, //スクロール対象コンテンツの表示部分のサイズを設定します.
				_upperBound,  //スライダーが上限に達したときの変化対象プロパティの値を設定します.
				_lowerBound   //スライダーが下限に達したときの変化対象プロパティの値を設定します.
			);
			
		}

	}
}
