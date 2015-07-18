package com.sw.buttons
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.sw.display.SetBitmap;
	import com.sw.utils.McData;
	import com.sw.utils.Sum;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	
	/**
	 * 버튼 오버시 크기 조절 클래스 <br>
	 * ## 버튼은 instance name이 "img"이어야 하며, 좌표는 좌측 상단<br>
	 * speed : 움직임 속도 <br>
	 * scale : 오버시 변하는 크기  : 0~1<br>
	 * over : 오버시 수행 함수 <br>
	 * out : 아웃시 수행 함수<br>
	 * click : 클릭시 수행 함수<br>
	 * <p> ex : new BtnScale(mc,{speed:0.4,scale:0.9,over:onOver,out:onOut,click:onClick});
	 * <p> ex : (img 이미지 중앙에 포인트가 있을시 ) BtnScale.center(mc,{speed:0.4,scale:0.9,over:onOver,out:onOut,click:onClick,ease:Expo.easeOut});
	 * */
	public class BtnScale extends Sprite
	{
		public var scope_mc:MovieClip;
		public var dataObj:Object;
		public var numScale:Number;
		
		public var bmp:Bitmap;
		
		static public var data:Object;
		/**	생성자  img 포인트가 좌상단에 있을 경우	*/
		public function BtnScale($scope_mc:MovieClip,$dataObj:Object)
		{
			super();
			scope_mc = $scope_mc;
			setBtn($dataObj);
		}
		/**	소멸자	*/
		public function destroy():void
		{	}	
		
		/**	버튼 셋팅	*/
		private function setBtn($dataObj:Object):void
		{
			dataObj = new Object();
			
			if(!scope_mc) return;
			scope_mc.buttonMode = ($dataObj.mode) ? ($dataObj.mode):(true);
			scope_mc.mouseChildren = ($dataObj.child) ? ($dataObj.child):(false);
			
			dataObj.cbk_click = ($dataObj.click) ? ($dataObj.click):(null);
			dataObj.cbk_over = ($dataObj.over) ? ($dataObj.over):(null);
			dataObj.cbk_out = ($dataObj.out) ? ($dataObj.out):(null);
			
			if(!scope_mc.img) return;
			McData.save(scope_mc.img);
			bmp = SetBitmap.go(scope_mc.img);
			bmp.smoothing = true;
			
			dataObj.scale = ($dataObj.scale)?($dataObj.scale):(0.9);
			dataObj.speed = ($dataObj.speed)?($dataObj.speed):(0.4);
			
			scope_mc.addEventListener(MouseEvent.ROLL_OVER,fN_onOver);
			scope_mc.addEventListener(MouseEvent.ROLL_OUT,fN_onOut);
			scope_mc.addEventListener(MouseEvent.CLICK,fN_onClick);		
		}
		/**	좌상단 오버시	함수	*/
		private function fN_onOver($e:MouseEvent):void
		{	
			bmp.smoothing = true;
			var ary:Array = Sum.center(bmp,dataObj.scale);
			TweenLite.to(	bmp,dataObj.speed,
							{	x:ary[0],y:ary[1],
								scaleX:dataObj.scale,scaleY:dataObj.scale,
								ease:Expo.easeOut});
			if(dataObj.cbk_over != null) dataObj.cbk_over($e);
		}
		/**	좌상단 아웃시 함수		*/
		private function fN_onOut($e:MouseEvent):void
		{	
			//var ary:Array = Sum.center(bmp,1);
			TweenLite.to(	bmp,dataObj.speed,
							{	x:scope_mc.img.dx,y:scope_mc.img.dy,
								scaleX:1,scaleY:1,
								ease:Expo.easeOut});	
			if(dataObj.cbk_out != null) dataObj.cbk_out($e);
		}
		/**	좌상단 클릭시 함수		*/
		private function fN_onClick($e:MouseEvent):void
		{
			if(dataObj.cbk_click != null) dataObj.cbk_click($e);
		}
		
		/**
		*			img 포인트가 중앙에 있는 버튼
		* */
		static public function center($scope_mc:MovieClip,$data:Object):void
		{
			$scope_mc.data = $data;
			var data:Object = $scope_mc.data;
			
			data.scale = data.scale ?  data.scale : (0.9);
			data.speed = data.speed ? data.speed : (0.4);
			data.ease = data.ease ?  data.ease : (Expo.easeOut);
			data.hand = data.hand ? data.hand : (true);	
			$scope_mc.buttonMode = data.hand;
			Button.setUI($scope_mc,{over:BtnScale.onOver,out:BtnScale.onOut,click:BtnScale.onClick});
		}
		/**	center 오버시	*/
		static public function onOver($mc:MovieClip):void
		{
			if(!$mc.img) return;
			SetBitmap.go($mc.img,true);
			TweenMax.to($mc.img,
								$mc.data.speed,
							{	scaleX:$mc.data.scale,
								scaleY:$mc.data.scale,
								ease:$mc.data.ease,
								onComplete:BtnScale.finishBtn,
								onCompleteParams:[$mc]
							});
			
			if($mc.data.over) $mc.data.over($mc);
		}
		/**	center 아웃시	*/
		static public function onOut($mc:MovieClip):void
		{
			if(!$mc.img) return;
			SetBitmap.go($mc.img,true);
			TweenMax.to($mc.img,
				$mc.data.speed,
				{	scaleX:1,scaleY:1,
					ease:$mc.data.ease,
					onComplete:BtnScale.finishBtn,
					onCompleteParams:[$mc]
				});
			if($mc.data.out) $mc.data.out($mc);
		}
		/**	center 버튼 움직임 완료	*/
		static public function finishBtn($mc:MovieClip):void
		{
			if($mc.img.scaleX == 1) SetBitmap.go($mc.img,false);
		}
		/**	center 클릭 	*/
		static public function onClick($mc:MovieClip):void
		{
			if(!$mc) return;
			if($mc.data.click) $mc.data.click($mc);
		}
	}//class
}//package