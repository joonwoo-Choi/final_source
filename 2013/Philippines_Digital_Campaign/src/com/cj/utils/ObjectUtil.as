package com.cj.utils
{
	public class ObjectUtil
	{
		public function ObjectUtil(){}
		
		public static function traceObject(obj:Object, indent:uint = 0):void
		{ 
			var indentString:String = ""; 
			var i:uint; 
			var prop:String; 
			var val:*; 
			for (i = 0; i < indent; i++) 
			{
				indentString += "\t";
			} 
			for (prop in obj) 
			{ 
				val = obj[prop]; 
				if (typeof(val) == "object") 
				{
					trace(indentString + " " + prop + ": [Object]");
					traceObject(val, indent + 1);
				} 
				else 
				{ 
					trace(indentString + " " + prop + ": " + val);
				} 
			} 
		}
	}
}