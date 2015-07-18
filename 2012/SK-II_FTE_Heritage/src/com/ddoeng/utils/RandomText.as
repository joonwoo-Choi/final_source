package com.ddoeng.utils 
{
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    
    public class RandomText extends flash.events.EventDispatcher
    {
        public function RandomText($fid:flash.text.TextField, $str:String, $min:int, $max:int, $speed:int=30, $delay:int=0, $type:int=1)
        {
            this._tempTextArr = [];
            this._tempNumberArr = [];
            super();
            this._fid = $fid;
            this._str = $str;
            this._minCodeNumber = $min;
            this._maxCodeNumber = $max;
            this._changeTime = $speed;
            this._type = $type;
            this._code = this._minCodeNumber;
            this._fid.text = "";
            this._fid.restrict = "A-Z 0-9";
            this._fid.autoSize = flash.text.TextFieldAutoSize.LEFT;
            this._textLength = this._str.length;
            var loc1:*;
            loc1 = 0;
            while (loc1 < this._textLength) 
            {
                this._tempTextArr.push(String.fromCharCode(Math.floor(Math.random() * (this._maxCodeNumber - this._minCodeNumber + 1)) + this._minCodeNumber));
                this._tempNumberArr.push(loc1);
                loc1 = (loc1 + 1);
            }
            var loc2:*;
            loc2 = new flash.utils.Timer($delay, 1);
            loc2.start();
            loc2.addEventListener(flash.events.TimerEvent.TIMER, this.onTimer);
            return;
        }

        private function onTimer(e:flash.events.TimerEvent):void
        {
            if (this._type != 1)
            {
                if (this._type != 2)
                {
                    if (this._type != 3)
                    {
                        if (this._type == 4)
                        {
                            this._fid.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter4);
                        }
                    }
                    else 
                    {
                        this._tempNumberArr = this.randomArray(this._tempNumberArr);
                        this._fid.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter2);
                    }
                }
                else 
                {
                    this._fid.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter2);
                }
            }
            else 
            {
                this._fid.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter1);
            }
            return;
        }

        private function onEnter1(e:flash.events.Event):void
        {
            var loc1:*;
            loc1 = null;
            if (this._startNum != this._changeTime)
            {
                var loc2:*;
                var loc3:*;
                loc3 = ((loc2 = this)._startNum + 1);
                loc2._startNum = loc3;
            }
            else 
            {
                this._startNum = 0;
                this._tempTextArr[this._completeStr.length] = this._str.charAt(this._completeStr.length);
            }
            if (this._tempTextArr[this._completeStr.length] == this._str.charAt(this._completeStr.length))
            {
                if (this._completeStr.length < this._str.length - 1)
                {
                    this._completeStr = this._completeStr + this._tempTextArr[this._completeStr.length];
                    this._startNum = 0;
                }
                else 
                {
                    this._fid.removeEventListener(flash.events.Event.ENTER_FRAME, this.onEnter1);
                    loc1 = new flash.events.Event("randomTextComple");
                    this.dispatchEvent(loc1);
                }
            }
            else 
            {
                this._tempTextArr[this._completeStr.length] = String.fromCharCode(Math.floor(Math.random() * (this._maxCodeNumber - this._minCodeNumber + 1)) + this._minCodeNumber);
            }
            this._fid.text = this._completeStr + this._tempTextArr[this._completeStr.length];
            return;
        }

        private function onEnter2(e:flash.events.Event):void
        {
            var loc2:*;
            loc2 = null;
            var loc1:*;
            loc1 = 0;
            while (loc1 < this._textLength) 
            {
                if (this._tempTextArr[loc1] == this._str.charAt(loc1))
                {
                    this._tempTextArr[loc1] = this._str.charAt(loc1);
                }
                else 
                {
                    this._tempTextArr[loc1] = String.fromCharCode(Math.floor(Math.random() * (this._maxCodeNumber - this._minCodeNumber + 1)) + this._minCodeNumber);
                }
                loc1 = (loc1 + 1);
            }
            if (this._startNum != this._changeTime)
            {
                loc4 = ((loc3 = this)._startNum + 1);
                loc3._startNum = loc4;
            }
            else 
            {
                this._tempTextArr[this._tempNumberArr[this._checkLength]] = this._str.charAt(this._tempNumberArr[this._checkLength]);
                var loc3:*;
                var loc4:*;
                loc4 = ((loc3 = this)._checkLength + 1);
                loc3._checkLength = loc4;
                if (this._checkLength == this._textLength)
                {
                    this._fid.removeEventListener(flash.events.Event.ENTER_FRAME, this.onEnter2);
                    loc2 = new flash.events.Event("randomTextComple");
                    this.dispatchEvent(loc2);
                }
            }
            this._fid.text = this._tempTextArr.join("");
            return;
        }

        private function onEnter4(e:flash.events.Event):void
        {
            var loc1:*;
            loc1 = null;
            if (this._code == this._maxCodeNumber)
            {
                this._tempTextArr[this._completeStr.length] = this._str.charAt(this._completeStr.length);
            }
            if (this._startNum != this._changeTime)
            {
                var loc2:*;
                var loc3:*;
                loc3 = ((loc2 = this)._startNum + 1);
                loc2._startNum = loc3;
            }
            else 
            {
                this._startNum = 0;
                this._tempTextArr[this._completeStr.length] = this._str.charAt(this._completeStr.length);
            }
            if (this._tempTextArr[this._completeStr.length] == this._str.charAt(this._completeStr.length))
            {
                if (this._completeStr.length < this._str.length - 1)
                {
                    this._completeStr = this._completeStr + this._tempTextArr[this._completeStr.length];
                    this._code = this._minCodeNumber;
                    this._startNum = 0;
                }
                else 
                {
                    this._fid.removeEventListener(flash.events.Event.ENTER_FRAME, this.onEnter1);
                    loc1 = new flash.events.Event("randomTextComple");
                    this.dispatchEvent(loc1);
                }
            }
            else 
            {
                this._tempTextArr[this._completeStr.length] = String.fromCharCode(this._code);
                loc3 = ((loc2 = this)._code + 1);
                loc2._code = loc3;
            }
            this._fid.text = this._completeStr + this._tempTextArr[this._completeStr.length];
            return;
        }

        private function randomArray(array:Array):Array
        {
            var loc4:*;
            loc4 = NaN;
            var loc1:*;
            loc1 = new Array();
            var loc2:*;
            loc2 = array.length;
            var loc3:*;
            loc3 = 0;
            while (loc3 < loc2) 
            {
                loc4 = Math.floor(Math.random() * array.length);
                loc1.push(array[loc4]);
                array.splice(loc4, 1);
                loc3 = (loc3 + 1);
            }
            return loc1;
        }

        private var _fid:flash.text.TextField;

        private var _str:String;

        private var _tempTextArr:Array;

        private var _tempNumberArr:Array;

        private var _textLength:int;

        private var _checkLength:int=0;

        private var _startNum:int=0;

        private var _changeTime:int;

        private var _minCodeNumber:int;

        private var _maxCodeNumber:int;

        private var _completeStr:String="";

        private var _type:int;

        private var _code:Number;
    }
}
