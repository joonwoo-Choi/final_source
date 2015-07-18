package com.cj.display
{
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CircleProgress extends Sprite 
	{
		protected static var _defaults:Object = {thickness:6, radius:38, color:0x91E600, trackColor:0x000000, trackAlpha:0.15, 
			hideText:false, textColor:0xFFFFFF, textFormat:new TextFormat("Verdana,tahoma", 10, 0xFFFFFF, null, null, null, null, null, "center")};
		protected var _config:Object;
		protected var _progress:Number = 0;
		protected var _resolution:Number;
		protected var _outerRadius:Number;
		protected var _innerRadius:Number;
		
		public var yHome:Number;
		public var track:Shape;
		public var circle:Sprite;
		public var progressRing:Shape;
		public var textField:TextField;
		
		public function CircleProgress(vars:Object) 
		{
			super();
			_config = {};
			for (var p:String in _defaults) {
				_config[p] = (p in vars) ? vars[p] : _defaults[p];
			}
			_config.trackThickness = ("trackThickness" in vars) ? vars.trackThickness : _config.thickness + 4;
			_resolution = ("resolution" in vars) ? (Math.PI * 2) / Number(vars.resolution) : Math.PI * 0.2; //default resolution is 10
			_outerRadius = _config.radius + (_config.thickness / 2);
			_innerRadius = _config.radius - (_config.thickness / 2);
			this.textField = new TextField();
			this.textField.defaultTextFormat = _config.textFormat;
			this.textField.textColor = _config.textColor;
			this.textField.selectable = false;
			this.textField.width = 200;
			this.textField.x = -99;
			this.textField.y = yHome = int(_config.textFormat.size / -2) - 3;
			//this.textField.autoSize = "center";
			if (_config.hideText != true) {
				this.addChild(this.textField);
			}
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			this.circle = new Sprite();
			this.addChild(this.circle);
			
			this.track = new Shape();
			this.track.graphics.lineStyle(_config.trackThickness, _config.trackColor, _config.trackAlpha, true, "normal", CapsStyle.NONE);
			this.track.graphics.drawCircle(0, 0, _config.radius);
			this.circle.addChild(this.track);
			
			this.progressRing = new Shape();
			this.progressRing.blendMode = "layer";
			this.circle.addChild(this.progressRing);
			
			this.progress = 0;
		}
		
		
		//---- GETTERS / SETTERS -------------------------------------------------------------------------
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		public function set progress(value:Number):void 
		{
			_progress = value;
			this.textField.text = int( _progress * 100 ) + "%";
			
			var angle:Number = (_progress * Math.PI * 2);
			var g:Graphics = this.progressRing.graphics;
			g.clear();
			g.beginFill(_config.color, 1);
			
			var numSegments:int = int((angle / _resolution) + 0.99999); //faster than Math.ceil()
			
			var segAngle:Number = angle / numSegments;
			var halfSegAngle:Number = segAngle / 2;
			var cFactor:Number = _outerRadius / Math.cos(halfSegAngle);
			var curAngle:Number = Math.PI * 1.5; //start at -90 degrees, or 270 in terms of a positive number.
			g.moveTo(Math.cos(curAngle) * _outerRadius, Math.sin(curAngle) * _outerRadius);
			
			var angleMid:Number;
			for (var i:int = 0; i < numSegments; i++) {
				curAngle += segAngle;
				angleMid = curAngle - halfSegAngle;
				g.curveTo(Math.cos(angleMid) * cFactor,
					Math.sin(angleMid) * cFactor,
					Math.cos(curAngle) * _outerRadius,
					Math.sin(curAngle) * _outerRadius);
			}
			
			cFactor = _innerRadius / Math.cos(halfSegAngle);
			g.lineTo(Math.cos(curAngle) * _innerRadius, Math.sin(curAngle) * _innerRadius);
			
			for (i = 0; i < numSegments; i++) {
				curAngle -= segAngle;
				angleMid =  curAngle + halfSegAngle;
				g.curveTo(Math.cos(angleMid) * cFactor,
					Math.sin(angleMid) * cFactor,
					Math.cos(curAngle) * _innerRadius,
					Math.sin(curAngle) * _innerRadius);
			}
			
			g.endFill();
		}
		
	}
}