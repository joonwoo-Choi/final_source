package com.ddoeng.navigation 
{
    import flash.display.*;
    import flash.events.*;
    
    public class FrameButton extends flash.display.MovieClip
    {
        public function FrameButton($source:flash.display.MovieClip)
        {
            super();
            this.asset = $source;
            this.asset.stop();
            this.asset.buttonMode = true;
            this.asset.mouseChildren = false;
            this.addEvent();
            this.setLayout();
            return;
        }

        private function onBtn(e:flash.events.MouseEvent):void
        {
            var loc1:*;
            loc1 = e.type;
        }

        private function onEnter(e:flash.events.Event):void
        {
            var loc1:*;
            loc1 = e.currentTarget as flash.display.MovieClip;
            if (loc1.state != "next")
            {
                if (loc1.state == "prev")
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

        private function addEvent():void
        {
            this.asset.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.onBtn);
            this.asset.addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.onBtn);
            this.asset.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onBtn);
            return;
        }

        private function setLayout():void
        {
            addChild(this.asset);
            return;
        }

        private function pf():void
        {
            this.asset.state = "next";
            if (!this.asset.hasEventListener(flash.events.Event.ENTER_FRAME))
            {
                this.asset.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            }
            return;
        }

        private function bf():void
        {
            this.asset.state = "prev";
            if (!this.asset.hasEventListener(flash.events.Event.ENTER_FRAME))
            {
                this.asset.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            }
            return;
        }

        public function onDefualt():void
        {
            this.bf();
            return;
        }

        public function get clip():flash.display.DisplayObjectContainer
        {
            return this.asset;
        }

        public function set selected($obj:com.ddoeng.navigation.FrameButton):void
        {
            this.sel = $obj;
            return;
        }

        public function get selected():com.ddoeng.navigation.FrameButton
        {
            return this.sel;
        }

        public function set id($n:int):void
        {
            this.num = $n;
            return;
        }

        public function get id():int
        {
            return this.num;
        }

        private var asset:flash.display.MovieClip;

        private var sel:com.ddoeng.navigation.FrameButton;

        private var num:int;
    }
}
