package orpheus.utils
{
	import orpheus.utils.Tracer;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.jumpeye.flashEff2.symbol.squareEffect.FESSquareExplode;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;

	public class Atracer
	{
		private static var _tracerCon:Sprite;
		public function Atracer()
		{
			
		}
		
		public static function apply(mc:Sprite,makeObj:Boolean = false,stageW:int=-1,stageH:int=-1):void{
			if(_con)return;
			_con = mc;
			_makeObj = makeObj;
			_stageW = stageW;
			_stageH=stageH;
			if(_makeObj){
				_atracerMC = new AtracerMC;
				_atracerMC.name="atracerMC";
				_atracerMC.mouseEnabled = false;
				_atracerMC.mouseChildren = false;
				_con.addChild(_atracerMC);
				_tracerCon = _atracerMC.con;
				_tracerCon.stage.stageFocusRect = false;
				TweenPlugin.activate([AutoAlphaPlugin]);
				TextField(_tracerCon["txt"]).autoSize = TextFieldAutoSize.LEFT;
				TextField(_tracerCon["txt"]).wordWrap = true;
				Tracer.setting(_tracerCon["txt"]);
				defaultSetting();
			}
		}
		
		private static function defaultSetting():void
		{
			// TODO Auto Generated method stub
			if(_stageW==-1){
				_atracerMC.x = -600;
				_atracerMC.y = (_atracerMC.stage.stageHeight-_atracerMC.height)/2;	
			}else{
				_atracerMC.x = (_stageW-_atracerMC.stage.stageWidth)/2-600;
				_atracerMC.y = (_stageH-_atracerMC.stage.stageHeight)/2+(_atracerMC.stage.stageHeight-500)/2;
			}
			_tracerCon.visible = false;
			_tracerCon.stage.addEventListener(MouseEvent.CLICK,onClick);
			_tracerCon.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_tracerCon.stage.addEventListener( Event.RESIZE, stageResizeHandler );
		}	
		
		protected static function stageResizeHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			if(_tracerCon.visible==true){
				var tx:int;
				var ty:int;
				if(_stageW==-1){
					tx = (_atracerMC.stage.stageWidth-_atracerMC.width)/2;	
					ty = (_atracerMC.stage.stageHeight-_atracerMC.height)/2;	
				}else{
					tx= (_stageW-_atracerMC.stage.stageWidth)/2+(_atracerMC.stage.stageWidth-_atracerMC.width)/2;
					ty = (_stageH-_atracerMC.stage.stageHeight)/2+(_atracerMC.stage.stageHeight-500)/2;
				}
				TweenLite.to(_atracerMC,2,{x:tx,y:ty,ease:Elastic.easeInOut});				
			}
		}
		
		public static function alert(...obj):void{
			if(_makeObj){
				if(obj.length==1)Tracer.trace(obj[0]);
				if(obj.length==2)Tracer.trace(obj[0],obj[1]);
				if(obj.length==3)Tracer.trace(obj[0],obj[1],obj[2]);
				if(obj.length==4)Tracer.trace(obj[0],obj[1],obj[2],obj[3]);
				if(obj.length==5)Tracer.trace(obj[0],obj[1],obj[2],obj[3],obj[4]);
				for (var i:int = 0; i < _con.numChildren; i++) 
				{
					var mc:DisplayObject = _con.getChildAt(i);
					if(mc.width==503)_con.setChildIndex(mc,_con.numChildren-1);
				}
				
			}else{
				if(obj.length==1)trace(obj[0]);
				if(obj.length==2)trace(obj[0],obj[1]);
				if(obj.length==3)trace(obj[0],obj[1],obj[2]);
				if(obj.length==4)trace(obj[0],obj[1],obj[2],obj[3]);
				if(obj.length==5)trace(obj[0],obj[1],obj[2],obj[3],obj[4]);
			}
		}
		
		private static function onClick(event:MouseEvent):void{
			_tracerCon.stage.focus = _con;
		}
		
		private static var cnt:int =0;
		private static var strBank:Array = [];
		
		private static var chkValue:Array =[68,79,69,77,90,78,68,75,65,75,83,84,80];
		private static var killValue:Array =[87,78,82,68,74];
		private static var reBornValue:Array =[84,75,70,68,74];
		
		private static var _con:Sprite;
		private static var _atracerMC:AtracerMC;
		private static var _makeObj:Boolean;
		private static var _stageW:int;
		private static var _stageH:int;
		private static var _effect:FlashEff2Code;
		
		private static function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				submit();
				strBank= [];
			}else{
				strBank.push(event.keyCode);
				if(strBank.length==chkValue.length){
					valueChk();
				}
				if(strBank.length==killValue.length && _atracerMC.visible==true){
					reBornChk();
					killChk();
				}
			}
		}
		
		private static function reBornChk():void
		{
			// TODO Auto Generated method stub
			var tfChk:Boolean=tfChkFn(reBornValue);
			if(tfChk){
				_atracerMC.mouseEnabled = true;
				_atracerMC.mouseChildren = true;
				_effect.mouseEnabled = true;
				_effect.mouseChildren = true;				
			}
		}
		
		private static function killChk():void
		{
			// TODO Auto Generated method stub
			var tfChk:Boolean=tfChkFn(killValue);
			if(tfChk){
				_atracerMC.mouseEnabled = false;
				_atracerMC.mouseChildren = false;
				_effect.mouseEnabled = false;
				_effect.mouseChildren = false;				
			}
			
		}
		
		private static function submit():void{
			alert("reset");
		}
		private static function valueChk():void{
			var tfChk:Boolean=tfChkFn(chkValue);
			if(tfChk){
				_tracerCon.visible = true;
				var tx:int;
				if(_stageW==-1){
					tx = (_atracerMC.stage.stageWidth-_atracerMC.width)/2;	
				}else{
					tx= (_stageW-_atracerMC.stage.stageWidth)/2+(_atracerMC.stage.stageWidth-_atracerMC.width)/2;
				}
				_atracerMC.x = tx;
				// Create the FlashEff2Code instance and add it to the stage. The FlashEff2Code 
				// component must be in the display list in order for it to work. 
				_effect = new FlashEff2Code(); 
				_effect.mouseEnabled = false;
				_effect.mouseChildren = false;
				_con.addChild(_effect);
				var explode:FESSquareExplode = new FESSquareExplode();
				explode.squareWidth=50;
				explode.squareHeight =50;
				// Add the filter to the FlashEff2Code instance.
				_effect.showTransition=explode;
				_effect._targetInstanceName="atracerMC";
				
				_effect.show();
				// Set the target object to the FlashEff2Code instance. Once you do this, 
				// the filter will be applied immediately. 
//				TweenLite.to(_atracerMC,2,{x:tx,ease:Elastic.easeInOut});
			}
		}
		
		private static function tfChkFn(ary:Array):Boolean
		{
			// TODO Auto Generated method stub
			var tfChk:Boolean = false;
			for(var i:int = 0; i<ary.length; i++){
				if(strBank[i]==ary[i]){
					tfChk=true;
				}else{
					tfChk = false;
					return tfChk;
				}
			}			
			return tfChk;
		}
		
	}
}