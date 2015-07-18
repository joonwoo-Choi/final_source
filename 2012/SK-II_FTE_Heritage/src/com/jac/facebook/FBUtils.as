package com.jac.facebook 
{//Package
	import flash.net.URLVariables;
	
	public class FBUtils
	{//FBUtils Class
		
		static public function hashToToken(hash:String):String
		{//hashToToken
			if (hash != null)
			{//might be good
				try
				{//try
					hash = hash.substr(0, 1) == "#" ? hash.substr(1) : hash;
					var data:URLVariables = new URLVariables(hash);
					return data.access_token;
				}//try
				catch (error:Error)
				{//catch
					return "";
				}//catch
			}//might be good
			else
			{//bad
				return "";
			}//bad
            
			return "";
		}//hashToToken
		
	}//FBUtils Class

}//Package