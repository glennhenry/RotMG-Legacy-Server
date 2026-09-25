package com.company.util
{
   public class DateFormatterReplacement
   {
      
      public var formatString:String;
      
      private const months:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
      
      public function DateFormatterReplacement()
      {
         super();
      }
      
      public function format(param1:Date) : String
      {
         var _loc2_:String = this.formatString;
         _loc2_ = _loc2_.replace("D",param1.date);
         _loc2_ = _loc2_.replace("YYYY",param1.fullYear);
         return _loc2_.replace("MMMM",this.months[param1.month]);
      }
   }
}

