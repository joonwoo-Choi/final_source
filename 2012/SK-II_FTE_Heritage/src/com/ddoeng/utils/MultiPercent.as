package com.ddoeng.utils 
{
    import flash.events.*;
    
    public class MultiPercent extends flash.events.EventDispatcher
    {
        public function MultiPercent($totalcount:int)
        {
            super();
            this._totalCount = $totalcount;
            return;
        }

        public function calculation($percent:Number, $counter:int):void
        {
            var loc1:*;
            loc1 = NaN;
            if (this._totalCount >= $counter)
            {
                loc1 = Math.round($counter * 100 / this._totalCount);
                this._percent = Math.round($percent * 100 / this._totalCount * 0.01) + loc1;
            }
            return;
        }

        public function get percent():Number
        {
            return this._percent;
        }

        public function get totalCounter():int
        {
            return this._totalCount;
        }

        private var _percent:Number=0;

        private var _totalCount:int=0;
    }
}
