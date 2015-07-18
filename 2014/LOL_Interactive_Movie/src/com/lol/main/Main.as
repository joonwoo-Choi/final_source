package com.lol.main
{
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.lol.events.LolEvent;
	import com.lol.model.Model;
	import com.lol.player.FlvPlayer;
	import com.lol.player.SwfPlayer;
	import com.lol.view.Dimmed;
	import com.lol.view.InteractionPopup;
	import com.lol.view.Popup;
	import com.lol.view.QuickMenu;
	import com.lol.view.ReactionPopup;
	import com.lol.view.SideButton;
	import com.lol.view.TalkPopup;
	import com.lol.view.TimeBar;
	import com.lol.view.VideoContainer;
	import com.lol.view.WallPop;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.Font;
	
	public class Main
	{
		
		private var _con:MovieClip;
		private var _model:Model = Model.getInstance();
		private var _flvPlayer:FlvPlayer;
		private var _swfPlayer:SwfPlayer;
		private var _videoCon:VideoContainer;
		private var _interPopup:InteractionPopup;
		private var _popup:Popup;
		private var _dimmed:Dimmed;
		private var _timer:TimeBar;
		private var _sideBtn:SideButton;
		private var _talkPopup:TalkPopup;
		private var _quickMenu:QuickMenu;
		private var _wallPop:WallPop;
		private var _reactionPopup:ReactionPopup;
		
		public function Main(con:MovieClip)
		{
			_con = con;
			
			init();
			initEventListener();
		}
		
		private function init():void
		{
			/**	폰트 설정	*/
			if(_model.verEng){
				_model.fontYgd = new Font_Rix;
				Font.registerFont(Font_Rix);
				_model.fontRix = new Font_Rix;
				Font.registerFont(Font_Rix);
			}else{
				_model.fontYgd = new Font_Ygd;
				Font.registerFont(Font_Ygd);
				_model.fontRix = new Font_Rix;
				Font.registerFont(Font_Rix);
			}
			
			_flvPlayer = new FlvPlayer(_con.videoCon);
			_swfPlayer = new SwfPlayer(_con.videoCon);
			_videoCon = new VideoContainer(_con.videoCon);
			_wallPop = new WallPop(_con.popup.popup14);
			_interPopup = new InteractionPopup(_con);
			_popup = new Popup(_con);
			_dimmed = new Dimmed(_con.dimmed);
			_timer = new TimeBar();
			_sideBtn = new SideButton(_con);
			_talkPopup = new TalkPopup(_con);
			_quickMenu = new QuickMenu(_con.quickMenu);
			_reactionPopup = new ReactionPopup(_con);
			
			_con.interPopup.visible = false;
			_con.popup.visible = false;
			_con.dimmed.visible = false;
			_con.talkPopup.visible = false;
			_con.blockMC.visible = false;
			_con.yellowMc.visible = false;
			
			stageResizeHandler();
		}
		
		private function initEventListener():void
		{
			_model.addEventListener(LolEvent.VIDEO_PLAY, removeBtnSkip);
			
			_con.btnSkip.addEventListener(MouseEvent.MOUSE_OVER, introSkip);
			_con.btnSkip.addEventListener(MouseEvent.MOUSE_OUT, introSkip);
			_con.btnSkip.addEventListener(MouseEvent.CLICK, introSkip);
			
			_con.stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function removeBtnSkip(e:Event):void
		{
			if(_con.btnSkip.visible == false) return;
			if(!_model.introChk){
				_con.btnSkip.removeEventListener(MouseEvent.MOUSE_OVER, introSkip);
				_con.btnSkip.removeEventListener(MouseEvent.MOUSE_OUT, introSkip);
				_con.btnSkip.removeEventListener(MouseEvent.CLICK, introSkip);
				TweenLite.to(_con.btnSkip, 0.5, {autoAlpha:0});
			}
		}
		
		private function introSkip(e:MouseEvent):void
		{
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER : _con.btnSkip.gotoAndStop(2); break;
				case MouseEvent.MOUSE_OUT : _con.btnSkip.gotoAndStop(1); break;
				case MouseEvent.CLICK :
					_model.introChk = false;
					_model.dispatchEvent(new LolEvent(LolEvent.DRAW_COVER));
					_model.dispatchEvent(new LolEvent(LolEvent.VIDEO_PLAY));
					break;
			}
		}
		
		private function stageResizeHandler(e:Event = null):void
		{
			if(_model.introChk)
			{
				_con.btnSkip.x = int(_con.stage.stageWidth/2);
				_con.btnSkip.y = int(_con.stage.stageHeight - 35);
			}
		}
	}
}