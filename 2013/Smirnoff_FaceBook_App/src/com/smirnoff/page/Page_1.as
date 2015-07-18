package com.smirnoff.page
{
	
	import com.adqua.util.ButtonUtil;
	import com.adqua.util.JavaScriptUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.DropShadowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.smirnoff.control.SndControl;
	import com.smirnoff.events.SmirnoffEvents;
	import com.smirnoff.model.Model;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	public class Page_1
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _sndControl:SndControl;
		private var _bulletArr:Array;
		private var _position:Number;
		private var _activeNum:int;
		private var _cdArr:Array;
		private var _direction:String = "left";
		private var _isChange:Boolean = false;
		private var _tmpNum:int;
		
		public function Page_1(con:MovieClip)
		{
			TweenPlugin.activate([ColorTransformPlugin, DropShadowFilterPlugin]);
			_con = con;
			_sndControl = new SndControl(_con.playBar);
			_model.addEventListener(SmirnoffEvents.PAGE_CHANGED, pageChanged);
			_model.addEventListener(SmirnoffEvents.GO_MAIN, goMain);
			
			cdImgLoad();
			makeBtn();
		}
		
		protected function goMain(event:Event):void
		{
			if(_con.visible == false) return;
			ButtonUtil.removeButton(_con.btnNext, btnNextHandler);
			_activeNum = 0;
			_sndControl.initSnd();
			_con.cover.visible = true;
			outMotion("main");
		}
		
		protected function pageChanged(e:SmirnoffEvents):void
		{
			if(int(e.value.pageNo) != 1) return;
			trace("1페이지 시작__!!");
			/**	트래킹	*/
			JavaScriptUtil.call("googleSender", "District", "step1");
			
			ButtonUtil.makeButton(_con.btnNext, btnNextHandler);
			
			_model.cdNum = 0;
			_con.alpha = 1;
			_con.visible = true;
			_direction = "left";
			_tmpNum = _model.sndList.original.cd.length()-1;
			activeBullet(0);
			for (var i:int = 0; i < _model.sndList.original.cd.length(); i++) 
			{
				_cdArr[i].rotation = 0;
				if(i == 0) _cdArr[i].x = 0;
				else _cdArr[i].x = 750;
			}
			
			_sndControl.initSnd();
			_sndControl.loadSnd();
			inMotion();
		}
		
		private function inMotion():void
		{
			_con.btnNext.alpha = 0;
			_con.playBar.alpha = 0;
			_con.cdCon.y = -502;
			_con.btnArrow0.x = 0;
			_con.btnArrow1.x = _con.stage.stageWidth;
			TweenLite.to(_con.btnNext, 1, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to(_con.playBar, 1, {alpha:1, ease:Cubic.easeOut});
			TweenLite.to(_con.cdCon, 1, {y:-70, ease:Cubic.easeOut});
			TweenLite.to(_con.btnArrow0, 1, {x:_con.btnArrow0.width, ease:Cubic.easeOut});
			TweenLite.to(_con.btnArrow1, 1, {x:_con.stage.stageWidth - _con.btnArrow1.width, ease:Cubic.easeOut});
			
			for (var i:int = 0; i < 3; i++) 
			{
				_bulletArr[i].alpha = 0;
				_bulletArr[i].scaleX = _bulletArr[i].scaleY = 1.1;
				TweenLite.to(_bulletArr[i], 1, {delay:0.15*i, alpha:1, scaleX:1, scaleY:1, ease:Cubic.easeOut});
				
				var txt:MovieClip = _con.getChildByName("txt" + i) as MovieClip;
				txt.alpha = 0;
				txt.scaleX = txt.scaleY = 1.1;
				TweenLite.to(txt, 1, {
					delay:0.15*i, alpha:1, scaleX:1, scaleY:1, 
					onCompleteParams:["in", i], onComplete:movEndChk, 
					ease:Cubic.easeOut});
			}
		}
		
		private function outMotion(type:String):void
		{
			TweenLite.to(_con.btnNext, 1, {alpha:0, ease:Cubic.easeOut});
			TweenLite.to(_con.playBar, 1, {alpha:0, ease:Cubic.easeOut});
			TweenLite.to(_con.cdCon, 1, {y:-502, ease:Cubic.easeOut});
			TweenLite.to(_con.btnArrow0, 1, {x:0, ease:Cubic.easeOut});
			TweenLite.to(_con.btnArrow1, 1, {x:_con.stage.stageWidth, ease:Cubic.easeOut});
			
			for (var i:int = 0; i < 3; i++) 
			{
				TweenLite.to(_bulletArr[i], 1, {alpha:0, scaleX:1.1, scaleY:1.1, ease:Cubic.easeOut});
				
				var txt:MovieClip = _con.getChildByName("txt" + i) as MovieClip;
				TweenLite.to(txt, 1, {delay:0.15*i, alpha:0, scaleX:1.1, scaleY:1.1, 
					onCompleteParams:[type, i], onComplete:movEndChk, 
					ease:Cubic.easeOut});
			}
		}
		
		private function movEndChk(type:String, endNum:int):void
		{
			if(type == "in" && endNum == 2)
			{
				_con.cover.visible = false;
			}
			else if(type == "out" && endNum == 2)
			{
				_con.alpha  =0;
				_con.visible = false;
				_model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:2}));
			}
			else if(type == "main" && endNum == 2)
			{
				_con.alpha  =0;
				_con.visible = false;
				_model.dispatchEvent(new SmirnoffEvents(SmirnoffEvents.PAGE_CHANGED, {pageNo:0}));
			}
		}
		
		private function cdImgLoad():void
		{
			_cdArr = [];
			for (var i:int = 0; i < _model.sndList.original.cd.length(); i++) 
			{
				var cd:cdClip = new cdClip();
				_cdArr.push(cd);
				TweenLite.to(cd, 0, {dropShadowFilter:{color:0x000000, alpha:0.15, blurX:2, blurY:2, distance:2}});
				
				var ldr:Loader = new Loader();
				ldr.load(new URLRequest(String(_model.defaultPath + _model.sndList.original.cd[i].@img)));
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, cdImgLoadComplete);
				cd.y = 251;
				cd.addChild(ldr);
				ldr.x = cd.plane.x;
				ldr.y = cd.plane.y;
				
				_con.cdCon.addChild(cd);
			}
		}
		
		private function cdImgLoadComplete(e:Event):void
		{
			var bmp:Bitmap = Bitmap(e.target.content);
			bmp.smoothing = true;
		}
		
		private function makeBtn():void
		{
			for (var i:int = 0; i < 2; i++) 
			{
				var btnsArrow:MovieClip = _con.getChildByName("btnArrow" + i) as MovieClip;
				btnsArrow.no = i;
				ButtonUtil.makeButton(btnsArrow, btnArrowHandler);
			}
			
			_bulletArr = [];
			for (var j:int = 0; j < 3; j++) 
			{
				var bullet:MovieClip = _con.getChildByName("bullet" + j) as MovieClip;
				bullet.no = j;
				_bulletArr.push(bullet);
				ButtonUtil.makeButton(bullet, bulletHandler);
			}
		}
		
		private function btnArrowHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(target.over, 0.5, {alpha:1});
					break;
				case MouseEvent.MOUSE_OUT :
					TweenLite.to(target.over, 0.5, {alpha:0});
					break;
				case MouseEvent.CLICK :
					if(_isChange == true) return;
					_isChange = true;
					_tmpNum = _activeNum;
					if(target.no == 0)
					{
						_activeNum--;
						_direction = "left"
					}
					else 
					{
						_activeNum++;
						_direction = "right";
					}
					
					if(_activeNum < 0) _activeNum = _model.sndList.original.cd.length() - 1;
					else if(_activeNum >= _model.sndList.original.cd.length()) _activeNum = 0;
					
					activeBullet(_activeNum);
					break;
			}
		}
		
		private function bulletHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.currentTarget as MovieClip;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : break;
				case MouseEvent.MOUSE_OUT : break;
				case MouseEvent.CLICK :
					if(_activeNum == target.no || _model.sndList.original.cd.length() - 1 < target.no) return;
					if(_isChange == true) return;
					_isChange = true;
					_tmpNum = _activeNum;
					
					if(_activeNum > target.no) _direction = "left";
					else _direction = "right";
					
					_activeNum = target.no;
					activeBullet(_activeNum);
					break;
			}
		}
		
		private function activeBullet(activeNum:int):void
		{
			if(_model.sndList.original.cd[activeNum].@original != "" && _model.sndList.original.cd[activeNum].@original != null)
			{
				_model.sndUrl = _model.defaultPath + _model.sndList.original.cd[activeNum].@original;
			}
			else
			{
				_model.sndUrl = "";
			}
			_sndControl.initSnd();
			_sndControl.selectedCD(_cdArr[activeNum]);
			trace(_activeNum, _model.sndUrl);
			
			cdChange(activeNum);
			
			for (var i:int = 0; i < _bulletArr.length; i++) 
			{
				if(i == activeNum) TweenLite.to(_bulletArr[i].over, 0.5, {alpha:1});
				else TweenLite.to(_bulletArr[i].over, 0.5, {alpha:0});
			}
		}
		
		private function cdChange(activeNum:int):void
		{
			if(_cdArr.length > 2)
			{
				for (var j:int = 0; j < _cdArr.length; j++) 
				{
					if(j == activeNum)
					{
						if(_direction == "right")
						{
							_cdArr[j].x = 750;
							_cdArr[j].rotation = 90;
							TweenLite.to(_cdArr[j], 0.75, {x:0, rotation:0, ease:Cubic.easeOut, onComplete:cdChangeComplete});
						}
						else
						{
							_cdArr[j].x = -750;
							_cdArr[j].rotation = -90;
							TweenLite.to(_cdArr[j], 0.75, {x:0, rotation:0, ease:Cubic.easeOut, onComplete:cdChangeComplete});
						}
					}
					else
					{
						if(_direction == "right") TweenLite.to(_cdArr[_tmpNum], 0.75, {x:-750, rotation:-90, ease:Cubic.easeOut});
						else TweenLite.to(_cdArr[_tmpNum], 0.75, {x:750, rotation:90, ease:Cubic.easeOut});
					}
				}
			}
		}
		
		private function cdChangeComplete():void
		{
			_isChange = false;
		}
		
		private function btnNextHandler(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER :
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1.1}});
					break;
				case MouseEvent.MOUSE_OUT : 
					TweenLite.to(e.target, 0.5, {colorTransform:{exposure:1}});
					break;
				case MouseEvent.CLICK :
					if(_model.sndUrl == "" || _model.sndUrl == null)
					{
						JavaScriptUtil.alert("오픈되지 않은 음원입니다.");
						return;
					}
					/**	트래킹	*/
					JavaScriptUtil.call("googleSender", "District", "step1btn");
					
					ButtonUtil.removeButton(_con.btnNext, btnNextHandler);
					_model.cdNum = _activeNum;
					_activeNum = 0;
					_sndControl.initSnd();
					_con.cover.visible = true;
					outMotion("out");
					trace("다음 페이지 이동");
					break;
			}
		}
	}
}