package com.ddoeng.net 
{
    import flash.display.*;
    
    public class DynamicLoader extends flash.display.Loader
    {
        public function DynamicLoader()
        {
            super();
            return;
        }

        public function set id(n:int):void
        {
            this._id = n;
            return;
        }

        public function get id():int
        {
            return this._id;
        }

        private var _id:int;
    }
}
