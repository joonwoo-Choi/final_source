package com.adqua.ui {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
		
	public class AdquaContext {
		static private var _scope:DisplayObjectContainer;	
		static private var _contextMenu:ContextMenu;

		static public var CONTEXTMENU_NAME:String = "Create by AdQUA Interactive.";


		static public function addContextMenu( $scope:DisplayObjectContainer ):void {
			_scope = $scope;
			_scope.stage.showDefaultContextMenu = true;

			var item:ContextMenuItem = new ContextMenuItem( CONTEXTMENU_NAME );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler );

			_contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();
			_contextMenu.customItems.push( item );
			_contextMenu.addEventListener( ContextMenuEvent.MENU_SELECT, menuSelectHandler );
			_scope.contextMenu = _contextMenu;
		}

		static public function menuSelectHandler( $contextMenuEvt:ContextMenuEvent ):void {
			// menuSelectHandler
		}

		static public function menuItemSelectHandler( $contextMenuEvt:ContextMenuEvent ):void {
			if( $contextMenuEvt.currentTarget.caption == CONTEXTMENU_NAME ) {
				navigateToURL( new URLRequest( "http://www.adqua.co.kr/" ), "_blank" );
			}
		}
	}
}