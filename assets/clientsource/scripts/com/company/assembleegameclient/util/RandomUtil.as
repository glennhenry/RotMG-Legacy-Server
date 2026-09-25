package com.company.assembleegameclient.util
{
   public class RandomUtil
   {
      
      public function RandomUtil()
      {
         super();
      }
      
      public static function plusMinus(param1:Number) : Number
      {
         return Math.random() * param1 * 2 - param1;
      }
   }
}

