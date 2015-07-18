package com.ddoeng.text 
{
    import flash.text.*;
    
    public class TextFormatSet extends flash.text.TextFormat
    {
        public function TextFormatSet($fontname:String, $fontsize:Number=9, $fontcolor:uint=0, $fontspacing:Number=0, $fontalign:String="left", $fontbold:Boolean=false)
        {
            super();
            this.font = $fontname;
            this.color = $fontcolor;
            this.size = $fontsize;
            this.letterSpacing = $fontspacing;
            this.align = $fontalign;
            this.bold = $fontbold;
            return;
        }
    }
}
