package com.ddoeng.navigation 
{
    import com.ddoeng.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class FrameButtons extends flash.display.Sprite
    {
        public function FrameButtons($className:Object, $txt:Array, $direct:String, $overColor:uint=0)
        {
            super();
            this.Clip = flash.utils.getDefinitionByName(flash.utils.getQualifiedClassName($className)) as Class;
            this.txtArr = $txt;
            this.direct = $direct;
            this.overColor = $overColor;
            addEventListener(flash.events.Event.ADDED_TO_STAGE, this.create);
            return;
        }

        private function create(e:flash.events.Event):void
        {
            var btn:com.ddoeng.navigation.FrameButton;
            var e:flash.events.Event;
            var i:int;
            var textMc:flash.display.MovieClip;

            var loc1:*;
            btn = null;
            i = 0;
            textMc = null;
            e = e;
            try
            {
                removeEventListener(flash.events.Event.ADDED_TO_STAGE, this.create);
                this.btnArr = [];
                i = 0;
                while (i < this.txtArr.length) 
                {
                    btn = new com.ddoeng.navigation.FrameButton(new this.Clip());
                    btn.id = i;
                    addChild(btn);
                    this.btnArr.push(btn);
                    textMc = flash.display.MovieClip(btn.clip.getChildAt(btn.clip.numChildren - 1));
                    textMc.gotoAndStop(i + 1);
                    this.outColor = textMc.transform.colorTransform.color;
                    if (this.direct == com.ddoeng.navigation.FrameButtonAlign.HORIZONTAL)
                    {
                        btn.x = btn.width * i;
                    }
                    if (this.direct == com.ddoeng.navigation.FrameButtonAlign.VERTICAL)
                    {
                        btn.y = btn.height * i;
                    }
                    btn.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onDown);
                    i = (i + 1);
                }
            }
            catch (e:Error)
            {
                trace(undefined.getStackTrace());
            }
            return;
        }

        private function onDown(e:flash.events.MouseEvent):void
        {
            if (this.sel != e.currentTarget as com.ddoeng.navigation.FrameButton)
            {
                if (this.sel != null)
                {
                    this.sel.onDefualt();
                }
                this.sel = e.currentTarget as com.ddoeng.navigation.FrameButton;
                this.dispatchEvent(new com.ddoeng.events.FrameButtonsEvent(com.ddoeng.events.FrameButtonsEvent.BUTTONSET_DOWN, this.sel.id));
            }
            var loc1:*;
            loc1 = 0;
            while (loc1 < this.btnArr.length) 
            {
                this.btnArr[loc1].selected = this.sel;
                loc1 = (loc1 + 1);
            }
            return;
        }

        public function setDown(index:int):void
        {
            this.btnArr[index].clip.dispatchEvent(new flash.events.MouseEvent(flash.events.MouseEvent.MOUSE_OVER));
            this.btnArr[index].dispatchEvent(new flash.events.MouseEvent(flash.events.MouseEvent.MOUSE_DOWN));
            return;
        }

        public function getClip(index:int):flash.display.MovieClip
        {
            return getChildAt(index) as flash.display.MovieClip;
        }

        private var Clip:Class;

        private var txtArr:Array;

        private var direct:String;

        private var overColor:uint;

        private var outColor:uint;

        private var sel:com.ddoeng.navigation.FrameButton;

        private var btnArr:Array;
    }
}
