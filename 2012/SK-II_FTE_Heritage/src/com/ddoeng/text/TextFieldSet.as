package com.ddoeng.text 
{
    import com.ddoeng.events.*;
    import com.ddoeng.net.*;
    import com.ddoeng.utils.*;
    import flash.system.*;
    import flash.text.*;
    
    public class TextFieldSet extends flash.text.TextField
    {
        public function TextFieldSet($txtformat:flash.text.TextFormat, $embed:Boolean=false, $txt:String="default", $scalex:Number=1, $autosize:String="left", $selectable:Boolean=false)
        {
            this.replace = new com.ddoeng.utils.Replace();
            super();
            this.selectable = $selectable;
            this.text = $txt;
            this.defaultTextFormat = $txtformat;
            this.scaleX = $scalex;
            this.autoSize = $autosize;
            this.name = "fid";
            this.setTextFormat($txtformat);
            this.fontName = $txtformat.font;
            this.fontName = this.replace.replace(this.fontName, " ", "");
            this.fontName = this.replace.replace(this.fontName, "-", "");
            this.fontName = this.replace.replace(this.fontName, "_", "");
            if ($embed)
            {
                if (flash.system.ApplicationDomain.currentDomain.hasDefinition(this.fontName))
                {
                    this.onEmbed();
                }
            }
            return;
        }

        private function onEmbed(e:com.ddoeng.events.FONTLoaderEvent=null):void
        {
            this.embedFonts = true;
            return;
        }

        public function set runtimeEmbed($fontloader:com.ddoeng.net.FONTLoader):void
        {
            if (!flash.system.ApplicationDomain.currentDomain.hasDefinition(this.fontName))
            {
                $fontloader.addEventListener(com.ddoeng.events.FONTLoaderEvent.FONTLOAD_COMPLETE, this.onEmbed);
            }
            return;
        }

        private var replace:com.ddoeng.utils.Replace;

        private var fontName:String="";
    }
}
