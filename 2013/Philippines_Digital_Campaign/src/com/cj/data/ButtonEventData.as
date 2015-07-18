package com.cj.data
{
	public class ButtonEventData
	{

		public function get downListener():Function
		{
			return _downListener;
		}

		public function get rollOutListenrer():Function
		{
			return _rollOutListenrer;
		}

		public function get rollOverListener():Function
		{
			return _rollOverListener;
		}

		public function get outListener():Function
		{
			return _outListener;
		}

		public function get overListener():Function
		{
			return _overListener;
		}

		public function get clickListener():Function
		{
			return _clickListener;
		}

		private var _downListener:Function;
		private var _clickListener:Function;
		private var _overListener:Function;
		private var _outListener:Function;
		private var _rollOverListener:Function;
		private var _rollOutListenrer:Function;
		
		public function ButtonEventData( $click:Function, $over:Function=null, $out:Function=null, 
										 $rollOver:Function=null, $rollOut:Function=null, $down:Function=null)
		{
			_clickListener = $click;
			_overListener = $over;
			_outListener = $out;
			
			_rollOverListener = $rollOver;
			_rollOutListenrer = $rollOut;
			_downListener = $down;
		}
	}
}