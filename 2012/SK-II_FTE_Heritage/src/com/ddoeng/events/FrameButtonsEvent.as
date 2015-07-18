package com.ddoeng.events 
{
    import flash.events.*;
    
    public class FrameButtonsEvent extends flash.events.MouseEvent
    {
        public function FrameButtonsEvent($type:String, $id:int, $bubbles:Boolean=false, $cancelable:Boolean=false)
        {
            super($type, $bubbles, $cancelable);
            this.id = $id;
            return;
        }

        
        {
            BUTTONSET_DOWN = "buttonsetDown";
        }

        public var id:int;

        public static var BUTTONSET_DOWN:String="buttonsetDown";
    }
}
