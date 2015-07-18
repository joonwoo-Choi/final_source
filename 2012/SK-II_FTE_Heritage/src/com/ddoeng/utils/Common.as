package com.ddoeng.utils 
{
    import flash.display.*;
    
    public class Common extends Object
    {
        public function Common()
        {
            super();
            return;
        }

        public static function targetClear($mc:flash.display.DisplayObjectContainer):void
        {
            var $mc:flash.display.DisplayObjectContainer;
            var dis:flash.display.DisplayObject;

            var loc1:*;
            dis = null;
            $mc = $mc;
            try
            {
                while (true) 
                {
                    dis = $mc.getChildAt(0);
                    $mc.removeChild(dis);
                    dis = null;
                }
            }
            catch (e:Error)
            {
            };
            return;
        }
    }
}
