package kabam.rotmg.text.view.stringBuilder
{
   import kabam.rotmg.language.model.StringMap;
   
   public class PatternBuilder implements StringBuilder
   {
      
      private const PATTERN:RegExp = /(\{([^\{]+?)\})/gi;
      
      private var pattern:String = "";
      
      private var keys:Array;
      
      private var provider:StringMap;
      
      public function PatternBuilder()
      {
         super();
      }
      
      public function setPattern(param1:String) : PatternBuilder
      {
         this.pattern = param1;
         return this;
      }
      
      public function setStringMap(param1:StringMap) : void
      {
         this.provider = param1;
      }
      
      public function getString() : String
      {
         var _loc2_:String = null;
         this.keys = this.pattern.match(this.PATTERN);
         var _loc1_:String = this.pattern;
         for each(_loc2_ in this.keys)
         {
            _loc1_ = _loc1_.replace(_loc2_,this.provider.getValue(_loc2_.substr(1,_loc2_.length - 2)));
         }
         return _loc1_.replace(/\\n/g,"\n");
      }
   }
}

