package com.ddoeng.display 
{
    import com.ddoeng.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    public class BitmapControl extends flash.display.Sprite
    {
        public function BitmapControl()
        {
            super();
            return;
        }

        private function onEnter(e:flash.events.Event):void
        {
            var loc1:*;
            loc1 = this._speed;
            if (this._sw)
            {
                this._bitmapData.scroll(loc1, 0);
                if (loc1 < 0)
                {
                    this._bitmapData.copyPixels(this._bitmapDataCopy, new flash.geom.Rectangle(0, 0, Math.abs(loc1), this._bitmapDataCopy.height), new flash.geom.Point(this._bitmapDataCopy.width + loc1, 0));
                }
                else 
                {
                    this._bitmapData.copyPixels(this._bitmapDataCopy, new flash.geom.Rectangle(this._bitmapDataCopy.width - loc1, 0, Math.abs(loc1), this._bitmapDataCopy.height), new flash.geom.Point(0, 0));
                }
                this._bitmapDataCopy.draw(this._bitmap);
            }
            this._sw = !this._sw;
            return;
        }

        public function slide($source:flash.display.DisplayObjectContainer, $speed:int, $transparent:Boolean):void
        {
            var loc2:*;
            loc2 = 0;
            var loc1:*;
            loc1 = $source;
            this._speed = $speed;
            if ($transparent)
            {
                loc2 = 0;
            }
            else 
            {
                loc2 = 4294967295;
            }
            this._bitmapData = new flash.display.BitmapData(loc1.width, loc1.height, $transparent, loc2);
            this._bitmapData.draw(loc1);
            this._bitmapDataCopy = this._bitmapData.clone();
            com.ddoeng.utils.Common.targetClear(loc1);
            this._bitmap = new flash.display.Bitmap(this._bitmapData);
            loc1.addChild(this._bitmap);
            this._bitmap.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            return;
        }

        public static function reSize($bitmap:flash.display.Bitmap, $width:Number, $height:Number, $smooth:Boolean):flash.display.Bitmap
        {
            var loc1:*;
            loc1 = $bitmap;
            loc1.smoothing = $smooth;
            var loc2:*;
            loc2 = new com.ddoeng.utils.Calculation();
            var loc3:*;
            loc3 = loc2.linearFunction(0, loc1.width, 0, 1, $width);
            var loc4:*;
            loc4 = loc2.linearFunction(0, loc1.height, 0, 1, $height);
            var loc5:*;
            loc5 = new flash.geom.Matrix();
            loc5.scale(loc3, loc4);
            loc1.transform.matrix = loc5;
            return loc1;
        }

        private var _bitmap:flash.display.Bitmap;

        private var _bitmapData:flash.display.BitmapData;

        private var _bitmapDataCopy:flash.display.BitmapData;

        private var _speed:Number;

        private var _sw:Boolean=true;
    }
}
