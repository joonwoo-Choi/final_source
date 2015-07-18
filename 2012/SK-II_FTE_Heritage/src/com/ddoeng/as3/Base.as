package com.ddoeng.as3 
{
    import flash.display.*;
    import flash.events.*;
    
    public class Base extends flash.display.MovieClip
    {
        public function Base()
        {
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
            return;
        }

        private function onRemove(e:flash.events.Event=null):void
        {
            removeEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.onRemove);
            this.exRemove();
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
    }
}
