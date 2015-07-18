package com.ddoeng.net 
{
	import com.ddoeng.display.BitmapControl;
	import com.ddoeng.events.IMGLoaderEvent;
	import com.ddoeng.utils.Common;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
    
    public class IMGLoader extends flash.events.EventDispatcher
    {
		private var _loader:flash.display.Loader;
		private var _url:Array;
		private var _target:Array;
		private var _loaderArr:Array;
		private var _isAdd:Boolean;
		private var _clear:Boolean;
		
		private var _maxNum:int=0;
		private var _count:int=0;
		private var _width:Number=0;
		private var _height:Number=0;
		
		private var _smooth:Boolean=false;
		
        public function IMGLoader($add:Boolean, $clear:Boolean, $maxnum:int=0)
        {
            super();
            this._isAdd = $add;
            this._clear = $clear;
            this._maxNum = $maxnum;
            this._loaderArr = new Array();
            return;
        }

        private function onProgress(e:ProgressEvent):void
        {
            return;
        }

        private function onComplete(e:Event):void
        {
            var loc2:*;
            loc2 = 0;
            var loc1:*;
            loc1 = e.currentTarget.loader as DynamicLoader;
            if (this._target.length > 1)
            {
                loc2 = loc1.id;
            }
            else 
            {
                loc2 = 0;
            }
            if (!(this._width == 0) && !(this._height == 0))
            {
                com.ddoeng.display.BitmapControl.reSize(e.currentTarget.content, this._width, this._height, this._smooth);
            }
            if (this._clear)
            {
                com.ddoeng.utils.Common.targetClear(this._target[loc2]);
            }
            if (this._isAdd)
            {
                this._target[loc2].addChild(e.currentTarget.loader);
            }
            var loc4:*;
            var loc5:*;
            loc5 = ((loc4 = this)._count + 1);
            loc4._count = loc5;
            var loc3:*;
            loc3 = new IMGLoaderEvent(IMGLoaderEvent.IMAGELOAD_COMPLETE, this._target, this._loader);
            this.dispatchEvent(loc3);
            if (this._maxNum == this._count)
            {
                loc3 = new IMGLoaderEvent(IMGLoaderEvent.IMAGELOAD_ALLCOMPLETE, this._target, this._loader, true);
                this.dispatchEvent(loc3);
            }
            return;
        }

        private function ioError(e:flash.events.IOErrorEvent):void
        {
            trace(e.text);
            return;
        }

        public function load($target:Array, $url:Array, $width:Number=0, $height:Number=0, $smooth:Boolean=false):Array
        {
            var loc3:*;
            loc3 = null;
            this._target = $target;
            this._url = $url;
            this._width = $width;
            this._height = $height;
            this._smooth = $smooth;
            var loc1:*;
            loc1 = new flash.system.LoaderContext();
            loc1.applicationDomain = flash.system.ApplicationDomain.currentDomain;
            if (this._maxNum == 0)
            {
                this._maxNum = this._url.length;
            }
            var loc2:*;
            loc2 = 0;
            while (loc2 < this._maxNum) 
            {
                loc3 = new com.ddoeng.net.DynamicLoader();
                loc3.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, this.onProgress);
                loc3.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onComplete);
                loc3.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.ioError);
                loc3.load(new flash.net.URLRequest(this._url[loc2]), loc1);
                loc3.id = loc2;
                this._loaderArr.push(loc3);
                loc2 = (loc2 + 1);
            }
            return this._loaderArr;
        }

    }
}
