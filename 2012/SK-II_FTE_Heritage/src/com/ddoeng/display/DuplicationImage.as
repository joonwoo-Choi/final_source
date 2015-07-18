package com.ddoeng.display 
{
    import flash.display.*;
    import flash.geom.*;
    
    public class DuplicationImage extends Object
    {
        public function DuplicationImage()
        {
            super();
            return;
        }

        private function visibleOff():void
        {
            var loc1:*;
            loc1 = this._source.numChildren;
            var loc2:*;
            loc2 = 0;
            while (loc2 < loc1) 
            {
                this._source.getChildAt(loc2).visible = false;
                loc2 = (loc2 + 1);
            }
            return;
        }

        private function visibleOn():void
        {
            var loc1:*;
            loc1 = this._source.numChildren;
            var loc2:*;
            loc2 = 0;
            while (loc2 < loc1) 
            {
                this._source.getChildAt(loc2).visible = true;
                loc2 = (loc2 + 1);
            }
            return;
        }

        public function draw($source:*, $align:String="left"):void
        {
            this._source = $source as flash.display.Sprite;
            var loc1:*;
            loc1 = $align;
            var loc2:*;
            loc2 = new flash.geom.Matrix();
            if (loc1 == "center")
            {
                loc2.tx = this._source.width / 2;
                loc2.ty = this._source.height / 2;
            }
            var loc3:*;
            loc3 = new flash.display.BitmapData(this._source.width, this._source.height, true, 0);
            loc3.draw(this._source, loc2);
            var loc4:*;
            loc4 = new flash.display.Bitmap(loc3, flash.display.PixelSnapping.AUTO, true);
            loc4.name = "clone";
            this.visibleOff();
            if (loc1 == "center")
            {
                loc4.x = -loc2.tx;
                loc4.y = -loc2.ty;
            }
            this._source.addChild(loc4);
            return;
        }

        public function clear($source:flash.display.DisplayObject):void
        {
            this._source = $source as flash.display.Sprite;
            this._source.removeChild(this._source.getChildByName("clone"));
            this.visibleOn();
            return;
        }

        private var _source:flash.display.Sprite;
    }
}
