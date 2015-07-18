package com.ddoeng.net 
{
    import com.ddoeng.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    
    public class FONTLoader extends flash.events.EventDispatcher
    {
        public function FONTLoader()
        {
            super();
            this._loader = new flash.display.Loader();
            return;
        }

        private function onProgress(e:flash.events.ProgressEvent):void
        {
            this._percent = Math.floor(e.bytesLoaded / e.bytesTotal * 100);
            var loc1:*;
            loc1 = new com.ddoeng.events.FONTLoaderProgressEvent(com.ddoeng.events.FONTLoaderProgressEvent.FONTLOAD_PROGRESS, this._percent);
            this.dispatchEvent(loc1);
            return;
        }

        private function onComplete(e:flash.events.Event):void
        {
            this._loader.contentLoaderInfo.removeEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
            this._loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
            e.currentTarget.removeEventListener(flash.events.Event.COMPLETE, this.onComplete);
            flash.text.Font.registerFont(e.target.applicationDomain.getDefinition(this._className) as Class);
            var loc1:*;
            loc1 = new com.ddoeng.events.FONTLoaderEvent(com.ddoeng.events.FONTLoaderEvent.FONTLOAD_COMPLETE);
            this.dispatchEvent(loc1);
            return;
        }

        private function ioError(e:flash.events.IOErrorEvent):void
        {
            trace(e.text);
            return;
        }

        public function load($fontFileName:String=null, $assetPath:String="assets/"):void
        {
            var $assetPath:String="assets/";
            var $fontFileName:String=null;
            var loaderContext:flash.system.LoaderContext;

            var loc1:*;
            loaderContext = null;
            $fontFileName = $fontFileName;
            $assetPath = $assetPath;
            try
            {
                if (!($fontFileName == null) && 0 == this._loader.contentLoaderInfo.bytesLoaded)
                {
                    this._fontName = $fontFileName;
                    this._className = this._fontName;
                    this._percent = 0;
                    if (!flash.system.ApplicationDomain.currentDomain.hasDefinition(this._className))
                    {
                        loaderContext = new flash.system.LoaderContext();
                        loaderContext.applicationDomain = flash.system.ApplicationDomain.currentDomain;
                        this._loader.load(new flash.net.URLRequest($assetPath + this._className + ".swf"), loaderContext);
                        this._loader.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
                        this._loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
                        this._loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
                    }
                }
            }
            catch (e:Error)
            {
                trace(undefined.message + "::: loader가 del()에 의해 삭제되었을 수 있습니다.");
            }
            return;
        }

        public function del():void
        {
            if (this._loader != null)
            {
                if (this._loader.content == null)
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

        public function get name():String
        {
            return this._fontName;
        }

        private var _loader:flash.display.Loader;

        private var _fontName:String;

        private var _className:String;

        private var _percent:Number;
    }
}
