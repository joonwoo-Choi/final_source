package com.ddoeng.utils 
{
    public class Replace extends Object
    {
        public function Replace()
        {
            super();
            return;
        }

        public function stringToCharacter($str:String):String
        {
            if ($str.length == 1)
            {
                return $str;
            }
            return $str.slice(0, 1);
        }

        public function replace($str:String, $oldSubStr:String, $newSubStr:String):String
        {
            return $str.split($oldSubStr).join($newSubStr);
        }

        public function trim($str:String, $char:String):String
        {
            return this.trimBack(this.trimFront($str, $char), $char);
        }

        public function trimFront($str:String, $char:String):String
        {
            $char = this.stringToCharacter($char);
            if ($str.charAt(0) == $char)
            {
                $str = this.trimFront($str.substring(1), $char);
            }
            return $str;
        }

        public function trimBack($str:String, $char:String):String
        {
            $char = this.stringToCharacter($char);
            if ($str.charAt($str.length - 1) == $char)
            {
                $str = this.trimBack($str.substring(0, $str.length - 1), $char);
            }
            return $str;
        }
    }
}
