package com.ddoeng.net 
{
    import com.ddoeng.events.*;
    import flash.events.*;
    import flash.net.*;
    
    public class XMLLoader extends flash.events.EventDispatcher
    {
        public function XMLLoader()
        {
            super();
            this._urlLoader = new flash.net.URLLoader();
            this._urlLoader.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
            this._urlLoader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
            return;
        }

        private function onComplete(e:flash.events.Event):void
        {
            var loc1:*;
            loc1 = new XML(this._urlLoader.data);
            var loc2:*;
            loc2 = new com.ddoeng.events.XMLLoaderEvent(com.ddoeng.events.XMLLoaderEvent.LOADXML_COMPLETE, loc1, this._url);
            this.dispatchEvent(loc2);
            return;
        }

        private function ioError(e:flash.events.IOErrorEvent):void
        {
            trace(e.text);
            return;
        }

        public function load($url:String):void
        {
            this._urlLoader.load(new flash.net.URLRequest($url));
            this._url = $url;
            return;
        }

        private var _urlLoader:flash.net.URLLoader;

        private var _url:String;
    }
}
