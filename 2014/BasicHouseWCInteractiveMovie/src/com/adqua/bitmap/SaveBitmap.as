﻿package com.adqua.bitmap
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;

	import orpheus.system.SecurityUtil;	

	 * @author philip
	 */
	public class SaveBitmap extends EventDispatcher 


			if (bitmapData != null) save(bitmapData, serverURL, savefilename);
		}

			var url:String = serverURL + "?filename=" + savefilename;
			myRequest = new URLRequest(url);

			// JPEG 인코딩
			var myJPEGEnc:JPEGEncoder = new JPEGEncoder(100);
			var myByteData:ByteArray = myJPEGEnc.encode(bitmapData);

			// 서버로 전송.
			myRequest.data = myByteData;
			myRequest.method = URLRequestMethod.POST;
			myRequest.contentType = 'application/octet-stream';

				if (SecurityUtil.isWeb()) navigateToURL(myRequest, "_self"); 
			}
			catch (error:ArgumentError) 
				trace("An ArgumentError has occurred.");
			}
			catch (error:SecurityError) 
				trace("A SecurityError has occurred.");
			}
		}
	}
}