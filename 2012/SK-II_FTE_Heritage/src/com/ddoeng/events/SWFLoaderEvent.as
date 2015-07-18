package com.ddoeng.events 
{
    import flash.display.*;
    import flash.events.*;
    
    public class SWFLoaderEvent extends flash.events.Event
    {
        public function SWFLoaderEvent($type:String, $target:Object, $url:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
        {
            super($type, $bubbles, $cancelable);
            this.timeline = $target.content as flash.display.MovieClip;
            this.url = $url;
            return;
        }

        public static const LOADSWF_COMPLETE:String="loadswfComplete";

        public var timeline:flash.display.MovieClip;

        public var url:String;
    }
}
