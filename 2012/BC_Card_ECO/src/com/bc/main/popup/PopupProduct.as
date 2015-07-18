package com.bc.main.popup
{
	
	import com.bc.model.Model;
	import com.bc.model.ModelEvent;
	import com.utils.NetUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class PopupProduct
	{
		
		private var $con:MovieClip;
		
		private var $model:Model;
		/**	상품 리스트 XML	*/
		private var $listXml:XML;
		/**	상품 이미지 수	*/
		private var $productLength:int;
		
		public function PopupProduct(con:MovieClip)
		{
			$con = con;
			
			$model = Model.getInstance();
			
			$model.addEventListener(ModelEvent.XML_LOADED, productImgLoad);
		}
		
		private function productImgLoad(e:Event):void
		{
			$listXml = $model.listXml;
			$productLength = $listXml.product.list.length();
			$model.itemLength = $productLength;
			
			/**	상품 이미지 로드	*/
			for (var i:int = 0; i < $productLength; i++) 
			{
				/**	이미지 갯수만큼 영역 가로값 분할	*/
				var areaNum:int;
				var areaWidth:Number = $con.itemCon.width / ($productLength * $model.repeatNum);
				var tagLdr:Loader = new Loader();
				if(NetUtil.isBrowser())
				{
					tagLdr.load(new URLRequest($model.webUrl + $listXml.product.list[i]));
				}
				else
				{
					tagLdr.load(new URLRequest($listXml.product.list[i]));
				}
				$model.productArr.push(tagLdr);
				$con.findPop.img.addChild(tagLdr);
				tagLdr.alpha = 0;
				tagLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, productLoadComplete);
				
				/**	물범	*/
				var moolbumMC:moolbumClip = new moolbumClip();
				$model.moolbumArr.push(moolbumMC);
				$con.itemCon.addChild(moolbumMC);
				moolbumMC.x = $con.itemCon.width/2-1500 + (1000 * i) + (1000 * Math.random());
				if(i ==0) moolbumMC.x = moolbumMC.x - 100;
				else if(i == $productLength - 1) moolbumMC.x = moolbumMC.x + 100;
				/**	X 좌표 재조정*/
				if(i > 0 && moolbumMC.x - $model.moolbumArr[i-1].x <= 100)
				{
					moolbumMC += 100;
				}
				if(moolbumMC.x - $con.itemCon.width/2 >= -300 && moolbumMC.x - $con.itemCon.width/2 <= 0)
				{
					moolbumMC.x -= 200;
				}
				else if(moolbumMC.x - $con.itemCon.width/2 <= 200 && moolbumMC.x - $con.itemCon.width/2 >= 0)
				{
					moolbumMC.x += 150;
				}
				moolbumMC.y = $con.itemCon.height - moolbumMC.height;
				
				/**	에코머니	*/
				var arr:Array = [];
				for (var j:int = 0; j < $model.repeatNum; j++) 
				{  
					var itemMC:itemClip = new itemClip();
					arr.push(itemMC);
					$con.itemCon.addChild(itemMC);
					itemMC.x = (areaWidth * areaNum) + areaWidth - 200 + (200 * Math.random());
					/**	X 좌표 재조정*/
					if(arr[j].x - $con.itemCon.width/2 >= -200 && arr[j].x - $con.itemCon.width/2 <= 0)
					{
						arr[j].x -= 150;
					}
					else if(arr[j].x - $con.itemCon.width/2 <= 200 && arr[j].x - $con.itemCon.width/2 >= 0)
					{
						arr[j].x += 150;
					}
					if(i > 0 && arr[j].x - $model.itemArr[i-1][$productLength-1].x <= 75)
					{
						arr[j].x += 75;
					}
					else if(j > 0 && arr[j].x - arr[j-1].x <= 75)
					{
						arr[j].x += 75;
					}
					itemMC.y = ($con.itemCon.height-itemMC.height-moolbumMC.height)*Math.random();
					areaNum++;
					trace("point: " + itemMC.x, itemMC.y);
				}
				$model.itemArr.push(arr);
				
				trace("$con.itemCon.height: " + $con.itemCon.height);
				
				/**	스탬프	*/
				var stampMC:stampClip = new stampClip();
				$model.stampArr.push(stampMC);
				stampMC.x = (stampMC.width + 10)*i;
				$con.mainCon.stampCon.addChild(stampMC);
				
				$con.mainCon.stampTxt.x = $con.mainCon.stampCon.x + $con.mainCon.stampCon.width + 30;
				
				/**	카트 스탬프	*/
				var cartStamp:MovieClip = $con.mainCon.character.getChildByName("eco" + i) as MovieClip;
				$model.cartStampArr.push(cartStamp);
			}
		}
		/**	상품 이미지 로드 완료	*/
		private function productLoadComplete(e:Event):void
		{
			e.target.content.smoothing = true;
			for (var i:int = 0; i <$productLength; i++) 
			{
				$model.productArr[i].x = -$model.productArr[i].width/2;
			}
			$model.dispatchEvent(new ModelEvent(ModelEvent.TAG_LOADED));
		}
	}
}