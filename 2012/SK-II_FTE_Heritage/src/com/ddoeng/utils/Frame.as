package com.ddoeng.utils 
{
    import flash.display.*;
    import flash.events.*;
    
    public class Frame extends flash.events.EventDispatcher
    {
        public function Frame()
        {
            super();
            return;
        }

        private function onEnter(e:flash.events.Event):void
        {
            var loc1:*;
            loc1 = e.currentTarget as flash.display.MovieClip;
            if (loc1.state != "next")
            {
                if (loc1.state != "prev")
                {
                    if (loc1.state == "prev2")
                    {
                        if (1 == loc1.currentFrame)
                        {
                            loc1.removeEventListener(e.type, this.onEnter);
                        }
                        else 
                        {
                            loc1.prevFrame();
                            loc1.prevFrame();
                        }
                    }
                }
                else 
                {
                    if (1 == loc1.currentFrame)
                    {
                        loc1.removeEventListener(e.type, this.onEnter);
                    }
                    else 
                    {
                        loc1.prevFrame();
                    }
                }
            }
            else 
            {
                if (loc1.totalFrames == loc1.currentFrame)
                {
                    loc1.removeEventListener(e.type, this.onEnter);
                }
                else 
                {
                    loc1.nextFrame();
                }
            }
            return;
        }

        public function pf($mc:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = $mc;
            loc1.state = "next";
            if (!loc1.hasEventListener(flash.events.Event.ENTER_FRAME))
            {
                loc1.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            }
            return;
        }

        public function bf($mc:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = $mc;
            loc1.state = "prev";
            if (!loc1.hasEventListener(flash.events.Event.ENTER_FRAME))
            {
                loc1.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            }
            return;
        }

        public function bf2($mc:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = $mc;
            loc1.state = "prev2";
            if (!loc1.hasEventListener(flash.events.Event.ENTER_FRAME))
            {
                loc1.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            }
            return;
        }

        public function del($mc:flash.display.MovieClip):void
        {
            var loc1:*;
            loc1 = $mc;
            if (loc1.hasEventListener(flash.events.Event.ENTER_FRAME))
            {
                loc1.removeEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            }
            return;
        }
    }
}
