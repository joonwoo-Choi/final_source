package com.ddoeng.events 
{
    import flash.events.*;
    
    public class XMLLoaderEvent extends flash.events.Event
    {
        public function XMLLoaderEvent($type:String, $xml:XML, $url:String, $bubbles:Boolean=false, $cancelable:Boolean=false)
        {
            super($type, $bubbles, $cancelable);
            this.xml = $xml;
            this.url = $url;
            return;
        }

        public static const LOADXML_COMPLETE:String="loadxmlComplete";

        public var xml:XML;

        public var url:String;
    }
}
