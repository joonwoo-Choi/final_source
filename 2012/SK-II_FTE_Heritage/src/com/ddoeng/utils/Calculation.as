package com.ddoeng.utils 
{
    public class Calculation extends Object
    {
        public function Calculation()
        {
            super();
            return;
        }

        public function linearFunction($a:Number, $b:Number, $c:Number, $d:Number, $x:Number):Number
        {
            return ($d - $c) / ($b - $a) * ($x - $a) + $c;
        }
    }
}
