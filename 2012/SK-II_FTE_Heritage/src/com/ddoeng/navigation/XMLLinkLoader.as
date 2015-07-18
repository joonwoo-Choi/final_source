package com.ddoeng.navigation 
{
    import com.ddoeng.events.*;
    import flash.events.*;
    import flash.net.*;
    
    public class XMLLinkLoader extends flash.events.EventDispatcher
    {
        public function XMLLinkLoader(url:String)
        {
            this.linkArr = new Array();
            this.utilLinkArr = new Array();
            super();
            this._url = url;
            this._urlLoader = new flash.net.URLLoader();
            this._urlLoader.dataFormat = flash.net.URLLoaderDataFormat.TEXT;
            this._urlLoader.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
            this._urlLoader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
            this._urlLoader.load(new flash.net.URLRequest(url));
            return;
        }

        private function onComplete(e:flash.events.Event):void
        {
            var count1:int;
            var count2:int;
            var count3:int;
            var e:flash.events.Event;
            var element1:XML;
            var element2:XML;
            var element3:XML;
            var evt:com.ddoeng.events.XMLLoaderEvent;
            var example:XML;
            var utilcount:int;
            var utilelement:XML;
            var xml:XML;

            var loc1:*;
            xml = null;
            count1 = 0;
            count2 = 0;
            count3 = 0;
            utilcount = 0;
            example = null;
            element1 = null;
            utilelement = null;
            evt = null;
            element2 = null;
            element3 = null;
            e = e;
            try
            {
                xml = new XML(this._urlLoader.data);
                this._urlLoader = null;
                count1 = 0;
                count2 = 0;
                count3 = 0;
                utilcount = 0;
                example = new XML(e.target.data);
                this.homeLink = example.MainMenu.url;
                this.count = int(example.MainMenu.gnbcount);
                var loc2:*;
                loc2 = 0;
                var loc3:*;
                loc3 = example.MainMenu.elements();
                for each (element1 in loc3)
                {
                    this.linkArr.mlength = count1 + 1;
                    this.linkArr[count1] = {"name":element1.name, "url":element1.url, "target":element1.target, "menuxpos":element1.menuxpos};
                    var loc4:*;
                    loc4 = 0;
                    var loc5:*;
                    loc5 = element1.elements();
                    for each (element2 in loc5)
                    {
                        this.linkArr[count1].mlength = count2 + 1;
                        this.linkArr[count1][count2] = {"name":element2.name, "url":element2.url, "target":element2.target};
                        var loc6:*;
                        loc6 = 0;
                        var loc7:*;
                        loc7 = element2.elements();
                        for each (element3 in loc7)
                        {
                            this.linkArr[count1][count2].mlength = count3 + 1;
                            this.linkArr[count1][count2][count3] = {"name":element3.name, "url":element3.url, "target":element3.target};
                            count3 = (count3 + 1);
                        }
                        count2 = (count2 + 1);
                        count3 = 0;
                    }
                    count1 = (count1 + 1);
                    count2 = 0;
                }
                trace("\n");
                loc2 = 0;
                loc3 = example.UtilMenu.elements();
                for each (utilelement in loc3)
                {
                    this.utilLinkArr[utilcount] = {"name":utilelement.name, "url":utilelement.url, "target":utilelement.target};
                    utilcount = (utilcount + 1);
                }
                evt = new com.ddoeng.events.XMLLoaderEvent(com.ddoeng.events.XMLLoaderEvent.LOADXML_COMPLETE, xml, this._url);
                this.dispatchEvent(evt);
            }
            catch (e:TypeError)
            {
                trace("xml load Error\n" + undefined.message);
            }
            return;
        }

        private function ioError(e:flash.events.IOErrorEvent):void
        {
            trace(e.text);
            return;
        }

        public function get home():String
        {
            return this.homeLink;
        }

        public function get gnbCount():int
        {
            return this.count;
        }

        public function get link():Array
        {
            return this.linkArr;
        }

        public function get utilLink():Array
        {
            return this.utilLinkArr;
        }

        private var homeLink:String="";

        private var count:int=0;

        private var linkArr:Array;

        private var utilLinkArr:Array;

        private var _url:String;

        private var _urlLoader:flash.net.URLLoader;
    }
}
