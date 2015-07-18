package com.ddoeng.net 
{
    import com.ddoeng.events.*;
    import com.ddoeng.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    
    public class SWFLoader extends flash.events.EventDispatcher
    {
        public function SWFLoader()
        {
            super();
            this._loaderContext = new flash.system.LoaderContext();
            this._loaderContext.applicationDomain = flash.system.ApplicationDomain.currentDomain;
            return;
        }

        private function onProgress(e:flash.events.ProgressEvent):void
        {
            this._percent = Math.floor(e.bytesLoaded / e.bytesTotal * 100);
            var loc1:*;
            loc1 = new com.ddoeng.events.SWFLoaderProgressEvent(com.ddoeng.events.SWFLoaderProgressEvent.LOADSWF_PROGRESS, this._percent);
            this.dispatchEvent(loc1);
            return;
        }

        private function onComplete(e:flash.events.Event):void
        {
            if (this._clear)
            {
                com.ddoeng.utils.Common.targetClear(this._target);
            }
            var loc1:*;
            loc1 = new com.ddoeng.events.SWFLoaderEvent(com.ddoeng.events.SWFLoaderEvent.LOADSWF_COMPLETE, e.target, this._url);
            this.dispatchEvent(loc1);
            this._loader.contentLoaderInfo.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
            this._loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
            this._target.addChild(this._loader);
            return;
        }

        private function ioError(e:flash.events.IOErrorEvent):void
        {
            trace(e.text);
            return;
        }

        public function load($target:flash.display.DisplayObjectContainer, $url:String, $clear:Boolean=false):void
        {
            this._target = $target;
            this._url = $url;
            this._clear = $clear;
            this._percent = 0;
            this._loader = new flash.display.Loader();
            this._loader.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
            this._loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
            this._loader.load(new flash.net.URLRequest(this._url), this._loaderContext);
            return;
        }

        public function del():void
        {
            if (this._loader != null)
            {
                if (this._loader.content == null && this._loader.contentLoaderInfo.bytesLoaded > 0)
                {
                    this._loader.close();
                }
                if (this._loader.content != null)
                {
                    this._loader.unload();
                }
                if (this._loader.contentLoaderInfo.hasEventListener(flash.events.ProgressEvent.PROGRESS))
                {
                    this._loader.contentLoaderInfo.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
                }
                if (this._loader.contentLoaderInfo.hasEventListener(flash.events.Event.COMPLETE))
                {
                    this._loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
                }
                if (this._loader.contentLoaderInfo.hasEventListener(flash.events.IOErrorEvent.IO_ERROR))
                {
                    this._loader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
                }
                this._loader = null;
            }
            return;
        }

        public function set x(n:Number):void
        {
            this._loader.x = n;
            return;
        }

        public function get x():Number
        {
            return this._loader.x;
        }

        public function set y(n:Number):void
        {
            this._loader.y = n;
            return;
        }

        public function get y():Number
        {
            return this._loader.y;
        }

        private var _loader:flash.display.Loader;

        private var _url:String;

        private var _target:flash.display.DisplayObjectContainer;

        private var _clear:Boolean;

        private var _loaderContext:flash.system.LoaderContext;

        private var _percent:Number;
    }
}
