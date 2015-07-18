package com.sw.pv3d
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.cameras.DebugCamera3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;

	/**
	 * PV3D 기본 클래스
	 * */
	public class Base3D extends Sprite
	{
		protected var scope:Object;
		protected var scene:Scene3D;
		protected var viewPort:Viewport3D;
		
		protected var camera:Camera3D;
		//protected var camera:DebugCamera3D;
		
		protected var render:BasicRenderEngine;
		/***/
		protected var keyEvt:KeyboardEvent;
		/**	눌러진 키	*/
		protected var keyAry:Array;
		/**	카메라 이동 속도	(50)*/
		public var cam_speed:int;
		
		/**	렌더링 여부 체크	*/
		private var bRender:Boolean;
		
		/**
		 * 생성자
		 * @param $scope	::	scene붙일 DisplayObject
		 */
		public function Base3D($scope:Object)
		{
			super();
			scope = $scope;
			init();
		}
		
		/**	
		 * 초기화	
		 * */
		private function init():void
		{
			viewPort = new Viewport3D();
			scope.addChild(viewPort);
			scene = new Scene3D();
			setCamera();
			
			render = new BasicRenderEngine();
			startRender();
			this.addEventListener(Event.ENTER_FRAME,onEnter);
		}
		/**
		 * 카메라 셋팅
		 * */
		protected function setCamera():void
		{
			camera = new Camera3D();
			
			
			camera.fov = 20;
			camera.z = -500;
			cam_speed = 50;
		}
		
		/**	렌더링 시작	*/
		public function startRender():void
		{	
			if(bRender != true)
				render.renderScene(scene,camera,viewPort);
			bRender = true;
		}
		/**	렌더링 멈춤	*/
		public function stopRender():void
		{	
			bRender = false;	
			render.renderScene(scene,camera,viewPort);
		}
		/**	
		 * 화면에 계속 그려줌	
		 * */
		protected function onEnter(e:Event):void
		{
			if(keyAry != null && keyAry != []) onEnterKey();
			if(bRender == false) return;
			render.renderScene(scene,camera,viewPort);
		}
		
		/**	
		 * 키체크		
		 * */
		public function startKey():void
		{	
			keyAry = [];
			scope.stage.addEventListener(KeyboardEvent.KEY_DOWN,onDownKey);	
			scope.stage.addEventListener(KeyboardEvent.KEY_UP,onUpKey);
		}
		/**	키체크 안함	*/
		public function stopKey():void
		{	
			if(keyAry == null) return;
			if(keyAry.length == 0)
			{
				scope.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onDownKey);	
				scope.stage.removeEventListener(KeyboardEvent.KEY_UP,onUpKey);
			}
		}
		/**
		 * 키보드 이벤트
		 * */
		protected function onDownKey(e:KeyboardEvent):void
		{	
			keyEvt = e;
			var check:Boolean = false;
			for(var i:int = 0; i<keyAry.length; i++)
			{	if(e.keyCode == keyAry[i]) check = true;	}
			
			if(check == false) keyAry.push(e.keyCode);	
			//trace(keyAry);
		}
		
		protected function onUpKey(e:KeyboardEvent):void
		{	
			for(var i:int = 0; i<keyAry.length; i++)
			{	if(e.keyCode == keyAry[i]) keyAry.splice(i,1);	}
		}
		
		protected function onEnterKey():void
		{
			var speed:int = cam_speed;
			
			//trace(viewPort.mouseX);
			//trace(viewPort.viewportWidth);
			
			//camera.rotationY = ((viewPort.mouseX/viewPort.viewportWidth)*180)-90;
			//camera.rotationX = ((viewPort.mouseY/viewPort.viewportHeight)*180)-90;
			for(var i:int=0 ; i<keyAry.length; i++)
			{
				switch(keyAry[i])
				{
				case 87:		//앞	(W)
					camera.moveForward(speed);
				break;
				case 83:		//뒤 (S)
					camera.moveBackward(speed);
				break;			//좌	(A)
				case 65:
					camera.moveLeft(speed);
				break;
				case 68:		//우	(D)
					camera.moveRight(speed);
				break;
				case 70:		//위	(G)
					//camera.moveUp(speed);
					camera.y += speed;
				break;
				case 86:		//아래	(B)
					//camera.moveDown(speed);
					camera.y -= speed;
				break;
				case 81:		//자회전 (Q)
				camera.rotationY -= (speed/100);
				break;
				case 69:		//우회전 (E)
				camera.rotationY += (speed/100);
				break;
				case 71:		//상회전 (F)
				camera.rotationX -= (speed/100);
				break;
				case 66:		//하회전 (V)
				camera.rotationX += (speed/100);
				break;
				case 82:		//모든속성값 초기화 (R)
					camera.x = 0;
					camera.y = 0;
					camera.z = 0;
					camera.rotationY = 0;
				break;
				case 84:		//모든속성값 출력 (T)
					trace("x",camera.x);
					trace("y",camera.y);
					trace("z",camera.z);
					trace("rotationX",camera.rotationX);
					trace("rotationY",camera.rotationY);
					trace("rotationZ",camera.rotationZ);
				break;
				}
				//trace(keyAry);
			}
			
		}
		/**	소멸자	*/
		public function destroy():void
		{
			if(viewPort != null) 
			{
				render.destroy();
				
				scope.removeChild(viewPort);
				viewPort.destroy();
				
				render = null;
				scene = null;
				viewPort = null;
			}
			this.removeEventListener(Event.ENTER_FRAME,onEnter);
			stopKey();
		}
		
	}//class
}//package