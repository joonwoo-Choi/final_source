package orpheus.events
{
	public class Delegate extends Object
	{
		public static function create(func:Function, ...args):Function
		{
			var f:Function = function(...arg):void
			{
				func.apply(this, arg.concat(args));
			};
			return f;
		}
	}
}