package com.sw.utils
{
	/**		
	 *	오브젝트 안의 내용 모두 trace
	 */
	public class TraceObject
	{
		/**	생성자	*/
		public function TraceObject()
		{
		}
		/**	오브젝트 안의 내용 모두 trace*/
		static public function go(obj:Object, indent:uint = 0):void
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
					TraceObject.go(val, indent + 1);
				} 
				else 
				{ 
					trace(indentString + " " + prop + ": " + val);
				} 
			}
		}
		
	}//class
}//package