package com.company.assembleegameclient.objects
{
   import kabam.rotmg.text.view.stringBuilder.PatternBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class PortalNameParser
   {
      
      public static const NAME_PARSER:RegExp = /(.+)\s\((.+)\)/;
      
      public function PortalNameParser()
      {
         super();
      }
      
      public function parse(param1:String) : String
      {
         var _loc2_:Array = param1.match(NAME_PARSER);
         if(_loc2_ == null)
         {
            return this.wrapNameWithBracesIfRequired(param1);
         }
         return this.makePatternFromParts(_loc2_);
      }
      
      private function wrapNameWithBracesIfRequired(param1:String) : String
      {
         if(param1.charAt(0) == "{" && param1.charAt(param1.length - 1) == "}")
         {
            return param1;
         }
         return "{" + param1 + "}";
      }
      
      private function makePatternFromParts(param1:Array) : String
      {
         var _loc2_:String = "{" + param1[1] + "}";
         if(param1.length > 1)
         {
            _loc2_ += " (" + param1[2] + ")";
         }
         return _loc2_;
      }
      
      public function makeBuilder(param1:String) : StringBuilder
      {
         return new PatternBuilder().setPattern(this.parse(param1));
      }
   }
}

