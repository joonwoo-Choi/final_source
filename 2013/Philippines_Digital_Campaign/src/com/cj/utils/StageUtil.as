package com.cj.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class StageUtil
	{
		static public function setDefault(displayObject:DisplayObject):void
		{
			if( displayObject.stage == null ) return;
			
			displayObject.stage.scaleMode = StageScaleMode.NO_SCALE;
			displayObject.stage.align = StageAlign.TOP_LEFT;
			displayObject.stage.quality = StageQuality.BEST;
			displayObject.stage.stageFocusRect = false;
			//displayObject.stage.tabChildren = false;
		}
		
		static public function setContextMenu( container:DisplayObjectContainer, contextName:String="", 
											   	link:String="", target:String="_blank" ):void
		{
			var cm:ContextMenu = new ContextMenu;
			cm.hideBuiltInItems();
			
			if(contextName != ""){
				var item:ContextMenuItem = new ContextMenuItem(contextName);
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:ContextMenuEvent):void
				{
					navigateToURL( new URLRequest(link), target );
				});
			}
			
			cm.customItems.push(item);
			container.contextMenu = cm;
		}
	}
}