package com.sw.utils
{
	public class Delegate extends Object
	{
		public var fnc:Function;
		public function Delegate($fnc:Function)
		{
			super();
			fnc = $fnc;
		}
		public static function create(obj:Object,func:Function):Function
		{
			var fnc_n = function():Function
			{
				var mc = arguments.callee.target;
				var f_name = arguments.callee.func;
				var para = arguments.callee.args;
				return (f_name.apply(mc,para.concat(arguments)));
			};
			fnc_n.target = arguments.shift();
			fnc_n.func = arguments.shift();
			fnc_n.args = arguments;
			return(fnc_n);
		}
		public function createDelegate($obj:Object):Function
		{
			return (Delegate.create($obj,fnc));
		}
	}
}