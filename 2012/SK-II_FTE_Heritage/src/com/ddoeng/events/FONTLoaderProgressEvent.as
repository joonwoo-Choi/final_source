package com.ddoeng.events 
{
    import flash.events.*;
    
    public class FONTLoaderProgressEvent extends flash.events.ProgressEvent
    {
        public function FONTLoaderProgressEvent($type:String, $percent:Number, $bubbles:Boolean=false, $cancelable:Boolean=false)
        {
            super($type, $bubbles, $cancelable);
            this.percent = $percent;
            return;
        }

        public static const FONTLOAD_PROGRESS:String="fontloadProgress";

        public var percent:Number;
    }
}
