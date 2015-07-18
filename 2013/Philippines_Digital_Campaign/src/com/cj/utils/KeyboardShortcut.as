package com.cj.utils
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	public class KeyboardShortcut
	{
		static public function createInstance( stage: Stage ): void
		{
			instance = new KeyboardShortcut( stage );
		}
		
		static public function getInstance(): KeyboardShortcut
		{
			return instance;
		}
		
		static private var instance: KeyboardShortcut;
		
		private var stage: Stage;
		
		private const shortcuts: Array = new Array();
		private const table: Dictionary = new Dictionary();
		public var isTrace:Boolean;
		
		public function KeyboardShortcut( stage: Stage )
		{
			this.stage = stage;
			init();
		}
		
		public function remove():void
		{
			var st:Shortcut;
			for (var i:int = 0; i < shortcuts.length; i++) 
			{
				st = shortcuts[i];
				st = null;
			}
			shortcuts.length=0;
		}
		
		public function addShortcut( callback: Function, keys: Array, ...args ): void
		{
			var st:Shortcut = new Shortcut( callback, keys, args ); 
			shortcuts.push( st );
		}
		
		private function init(): void
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onStageKeyDown );
			stage.addEventListener( KeyboardEvent.KEY_UP, onStageKeyUp );
		}
		
		private function onStageKeyDown( event: KeyboardEvent ): void
		{
			var code: uint = event.keyCode;
			table[ code ] = true;
			if(isTrace) trace("[KEY CODE -" + code + "-]");
			check();
			table[ code ] = false;
		}
		
		private function onStageKeyUp( event: KeyboardEvent ): void
		{
			var code: uint = event.keyCode;
			table[ code ] = false;
		}
		
		private function check(): void
		{
			var found: Boolean;
			
			for each( var shortcut: Shortcut in shortcuts )
			{
				found = true;
				
				for each( var code: uint in shortcut.keys )
				{
					if( !table[ code ] )
					{
						found = false;
						break;
					}
				}
				if( found )
				{
					shortcut.callback.apply( null, shortcut.args );
				}
			}
		}
	}
}

class Shortcut
{
	public var callback: Function;
	public var keys: Array;
	public var args: Array;
	
	public function Shortcut( callback: Function, keys: Array, args: Array )
	{
		this.callback = callback;
		this.keys = keys;
		this.args = args;
	}
}