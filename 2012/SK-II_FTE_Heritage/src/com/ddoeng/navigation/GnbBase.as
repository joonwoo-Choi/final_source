package com.ddoeng.navigation 
{
    import flash.accessibility.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class GnbBase extends flash.display.MovieClip
    {
        public function GnbBase()
        {
            this.setId = [];
            this.over = this.active;
            this.subOver = this.subActive;
            this.menuContainer = new flash.display.MovieClip();
            this.subContainer = new flash.display.MovieClip();
            this.menuArr = [];
            this.subGroupArr = [];
            this.subMenuArr = [];
            super();
            if (stage)
            {
                this.onStage();
            }
            else 
            {
                addEventListener(flash.events.Event.ADDED_TO_STAGE, this.onStage);
            }
            return;
        }

        private function onStage(e:flash.events.Event=null):void
        {
            removeEventListener(flash.events.Event.ADDED_TO_STAGE, this.onStage);
            addEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.onRemove);
            stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
            stage.showDefaultContextMenu = false;
            this.exInit();
            addChild(this.menuContainer);
            addChild(this.subContainer);
            return;
        }

        private function onRemove(e:flash.events.Event=null):void
        {
            removeEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.onRemove);
            removeEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            this.exRemove();
            return;
        }

        protected function onMenu(e:*):void
        {
            var e:*;
            var mc:flash.display.MovieClip;

            var loc1:*;
            e = e;
            mc = e.currentTarget as flash.display.MovieClip;
            try
            {
                if (e.type == flash.events.MouseEvent.MOUSE_OVER || e.type == flash.events.FocusEvent.FOCUS_IN)
                {
                    if (!isNaN(this.subActive))
                    {
                        this.subMenuArr[this.active][this.subActive].off();
                    }
                    this.time = 1;
                    this.timeGo = false;
                    this.over = mc.id;
                    this.timer();
                    this.entStart();
                }
                else 
                {
                    if (e.type == flash.events.MouseEvent.MOUSE_OUT || e.type == flash.events.FocusEvent.FOCUS_OUT)
                    {
                        this.timeGo = true;
                    }
                    else 
                    {
                        if (e.type == flash.events.MouseEvent.MOUSE_DOWN || e.type == flash.events.KeyboardEvent.KEY_DOWN && e.keyCode == 13)
                        {
                            trace(mc.id);
                        }
                    }
                }
            }
            catch (e:Error)
            {
                trace(undefined.message);
            }
            return;
        }

        protected function onSubMenu(e:*):void
        {
            var e:*;
            var mc:flash.display.MovieClip;

            var loc1:*;
            e = e;
            mc = e.currentTarget as flash.display.MovieClip;
            try
            {
                if (e.type == flash.events.MouseEvent.MOUSE_OVER || e.type == flash.events.FocusEvent.FOCUS_IN)
                {
                    if (!(mc.id == this.subActive) && !isNaN(this.subActive))
                    {
                        this.subMenuArr[this.active][this.subActive].off();
                    }
                    this.timeGo = false;
                    this.subOver = mc.id;
                    this.subMenuArr[this.over][this.subOver].on();
                    this.entStart();
                }
                else 
                {
                    if (e.type == flash.events.MouseEvent.MOUSE_OUT || e.type == flash.events.FocusEvent.FOCUS_OUT)
                    {
                        this.timeGo = true;
                        this.subMenuArr[this.over][this.subOver].off();
                    }
                    else 
                    {
                        if (e.type == flash.events.MouseEvent.MOUSE_DOWN || e.type == flash.events.KeyboardEvent.KEY_DOWN && e.keyCode == 13)
                        {
                            trace(this.over, mc.id);
                        }
                    }
                }
            }
            catch (e:Error)
            {
                trace(undefined.message);
            }
            return;
        }

        private function timer():void
        {
            this.timeOut(this.over);
            this.setId[this.over] = flash.utils.setInterval(this.timerFun, 50);
            return;
        }

        private function timerFun():void
        {
            var loc1:*;
            loc1 = 0;
            while (loc1 < this._menuTotalNum) 
            {
                if (loc1 != this.over)
                {
                    this.menuArr[loc1].off();
                    this.subGroupArr[loc1].visible = false;
                }
                else 
                {
                    this.menuArr[loc1].on();
                    this.subGroupArr[loc1].visible = true;
                }
                this.timeOut(loc1);
                loc1 = (loc1 + 1);
            }
            return;
        }

        private function timeOut(num:Number):void
        {
            flash.utils.clearInterval(this.setId[num]);
            this.setId[num] = null;
            return;
        }

        private function entStart():void
        {
            this.entDel();
            addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            return;
        }

        private function onEnter(e:flash.events.Event):void
        {
            this.exEnter();
            if (this.timeGo)
            {
                var loc1:*;
                var loc2:*;
                loc2 = ((loc1 = this).time + 1);
                loc1.time = loc2;
                if (this.time >= 40)
                {
                    this.entDel();
                    if (this.over != this.active)
                    {
                        this.menuArr[this.over].off();
                    }
                    if (!isNaN(this.active))
                    {
                        this.over = this.active;
                        this.subOver = this.subActive;
                        this.menuArr[this.over].dispatchEvent(new flash.events.MouseEvent(flash.events.MouseEvent.MOUSE_OVER));
                        this.subMenuArr[this.over][this.subOver].dispatchEvent(new flash.events.MouseEvent(flash.events.MouseEvent.MOUSE_OVER));
                    }
                    else 
                    {
                        this.subGroupArr[this.over].visible = false;
                    }
                    this.exPageMemory();
                    this.time = 1;
                    this.timeGo = false;
                }
            }
            return;
        }

        private function entDel():void
        {
            if (hasEventListener(flash.events.Event.ENTER_FRAME))
            {
                removeEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            }
            return;
        }

        private function tabCountPlus():int
        {
            if (isNaN(this._tabCount))
            {
                this._tabCount = 0;
            }
            else 
            {
                var loc1:*;
                var loc2:*;
                loc2 = ((loc1 = this)._tabCount + 1);
                loc1._tabCount = loc2;
            }
            return this._tabCount;
        }

        protected function addInit(child:flash.display.MovieClip):void
        {
            child.id = this.count;
            this.menuContainer.addChild(child);
            this.menuArr.push(child);
            var loc1:*;
            loc1 = new flash.accessibility.AccessibilityProperties();
            loc1.name = child.txt.getChildByName("fid").text;
            child.accessibilityProperties = loc1;
            child.tabIndex = this.tabCountPlus();
            child.x = this._menuXPos;
            child.y = this._menuYPos;
            this._menuXPos = this._menuXPos + child.txt.width + this._menuOffset;
            child.bg.alpha = 0;
            var loc2:*;
            loc2 = new flash.display.MovieClip();
            loc2.visible = false;
            this.subContainer.addChild(loc2);
            this.subGroupArr.push(loc2);
            this.subCount = 0;
            this.subMenuArr[this.count] = [];
            var loc3:*;
            var loc4:*;
            loc4 = ((loc3 = this).count + 1);
            loc3.count = loc4;
            return;
        }

        protected function addSubInit(child:flash.display.MovieClip):void
        {
            child.id = this.subCount;
            var loc1:*;
            loc1 = new flash.accessibility.AccessibilityProperties();
            loc1.name = child.txt.getChildByName("fid").text;
            child.accessibilityProperties = loc1;
            child.tabIndex = this.tabCountPlus();
            child.x = this._subMenuXPos;
            child.y = this._subMenuYPos;
            this._subMenuXPos = this._subMenuXPos + child.txt.width + this._subMenuOffset;
            child.bg.alpha = 0;
            this.subGroupArr[(this.count - 1)].addChild(child);
            this.subMenuArr[(this.count - 1)].push(child);
            var loc2:*;
            var loc3:*;
            loc3 = ((loc2 = this).subCount + 1);
            loc2.subCount = loc3;
            return;
        }

        protected function pageMemory():void
        {
            if (!isNaN(this.active) && !isNaN(this.subActive))
            {
                this.timeGo = true;
                this.entStart();
            }
            return;
        }

        protected function setPageMemoryTest(one:int, two:int):void
        {
            this.active = one;
            this.subActive = two;
            this.over = this.active;
            this.subOver = this.subActive;
            return;
        }

        public function exInit():void
        {
            return;
        }

        public function exRemove():void
        {
            return;
        }

        public function exEnter():void
        {
            return;
        }

        public function exPageMemory():void
        {
            return;
        }

        private var time:int=20;

        private var timeGo:Boolean=false;

        private var setId:Array;

        public var active:Number=NaN;

        public var subActive:Number=NaN;

        protected var over:Number;

        protected var subOver:Number;

        protected var menuContainer:flash.display.MovieClip;

        protected var subContainer:flash.display.MovieClip;

        protected var menuArr:Array;

        protected var subGroupArr:Array;

        protected var subMenuArr:Array;

        private var count:int=0;

        private var subCount:int=0;

        protected var _tabCount:int=0;

        protected var _menuTotalNum:int=0;

        protected var _menuXPos:int=0;

        protected var _menuYPos:int=0;

        protected var _menuOffset:int=0;

        protected var _subMenuXPos:int=0;

        protected var _subMenuYPos:int=0;

        protected var _subMenuOffset:int=0;
    }
}
