package com.company.util
{
   public class MoreDateUtil
   {
      
      public function MoreDateUtil()
      {
         super();
      }
      
      public static function getDayStringInPT() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = _loc1_.getTime();
         _loc2_ += (_loc1_.timezoneOffset - 420) * 60 * 1000;
         _loc1_.setTime(_loc2_);
         var _loc3_:DateFormatterReplacement = new DateFormatterReplacement();
         _loc3_.formatString = "MMMM D, YYYY";
         return _loc3_.format(_loc1_);
      }
   }
}

