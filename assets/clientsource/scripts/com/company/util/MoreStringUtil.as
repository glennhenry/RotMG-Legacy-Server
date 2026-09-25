package com.company.util
{
   import flash.utils.ByteArray;
   
   public class MoreStringUtil
   {
      
      public function MoreStringUtil()
      {
         super();
      }
      
      public static function hexStringToByteArray(param1:String) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeByte(parseInt(param1.substr(_loc3_,2),16));
            _loc3_ += 2;
         }
         return _loc2_;
      }
      
      public static function cmp(param1:String, param2:String) : Number
      {
         return param1.localeCompare(param2);
      }
   }
}

