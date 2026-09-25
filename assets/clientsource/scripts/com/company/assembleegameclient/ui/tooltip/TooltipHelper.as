package com.company.assembleegameclient.ui.tooltip
{
   public class TooltipHelper
   {
      
      public static const BETTER_COLOR:uint = 65280;
      
      public static const WORSE_COLOR:uint = 16711680;
      
      public static const NO_DIFF_COLOR:uint = 16777103;
      
      public function TooltipHelper()
      {
         super();
      }
      
      public static function wrapInFontTag(param1:String, param2:String) : String
      {
         return "<font color=\"" + param2 + "\">" + param1 + "</font>";
      }
      
      public static function getOpenTag(param1:uint) : String
      {
         return "<font color=\"#" + param1.toString(16) + "\">";
      }
      
      public static function getCloseTag() : String
      {
         return "</font>";
      }
      
      public static function getFormattedRangeString(param1:Number) : String
      {
         var _loc2_:Number = param1 - int(param1);
         return int(_loc2_ * 10) == 0 ? int(param1).toString() : param1.toFixed(1);
      }
      
      public static function getTextColor(param1:Number) : uint
      {
         if(param1 < 0)
         {
            return WORSE_COLOR;
         }
         if(param1 > 0)
         {
            return BETTER_COLOR;
         }
         return NO_DIFF_COLOR;
      }
   }
}

