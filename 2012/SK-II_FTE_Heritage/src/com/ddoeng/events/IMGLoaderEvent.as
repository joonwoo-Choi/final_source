package com.ddoeng.events 
{
	import flash.display.Loader;
	import flash.events.Event;
    
    public class IMGLoaderEvent extends flash.events.Event
    {
        public function IMGLoaderEvent(type:String, target:Array, loader:flash.display.Loader, all:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.loader = loader;
            this.mtarget = target;
            this.isAll = all;
            return;
        }

        public static const IMAGELOAD_COMPLETE:String="imageloadComplete";

        public static const IMAGELOAD_ALLCOMPLETE:String="imageloadAllcomplete";

        public var loader:flash.display.Loader;

        public var mtarget:Array;

        public var isAll:Boolean;
    }
}
