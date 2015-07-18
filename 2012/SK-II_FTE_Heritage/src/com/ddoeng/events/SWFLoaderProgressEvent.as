package com.ddoeng.events 
{
    import flash.events.*;
    
    public class SWFLoaderProgressEvent extends flash.events.ProgressEvent
    {
        public function SWFLoaderProgressEvent($type:String, $percent:Number, $bubbles:Boolean=false, $cancelable:Boolean=false)
        {
            super($type, $bubbles, $cancelable);
            this.percent = $percent;
            return;
        }

        public static const LOADSWF_PROGRESS:String="loadswfProgress";

        public var percent:Number;
    }
}
