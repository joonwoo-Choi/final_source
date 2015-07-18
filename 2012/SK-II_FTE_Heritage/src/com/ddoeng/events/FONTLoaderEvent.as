package com.ddoeng.events 
{
    import flash.events.*;
    
    public class FONTLoaderEvent extends flash.events.Event
    {
        public function FONTLoaderEvent($type:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
        {
            super($type, $bubbles, $cancelable);
            return;
        }

        public static const FONTLOAD_COMPLETE:String="fontloadComplete";
    }
}
