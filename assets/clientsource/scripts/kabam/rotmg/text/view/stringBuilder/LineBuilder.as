package kabam.rotmg.text.view.stringBuilder
{
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.language.model.StringMap;
   
   public class LineBuilder implements StringBuilder
   {
      
      public var key:String;
      
      public var tokens:Object;
      
      private var postfix:String = "";
      
      private var prefix:String = "";
      
      private var map:StringMap;
      
      public function LineBuilder()
      {
         super();
      }
      
      public static function fromJSON(param1:String) : LineBuilder
      {
         var _loc2_:Object = JSON.parse(param1);
         return new LineBuilder().setParams(_loc2_.key,_loc2_.tokens);
      }
      
      public static function getLocalizedStringFromKey(param1:String, param2:Object = null) : String
      {
         var _loc3_:LineBuilder = new LineBuilder();
         _loc3_.setParams(param1,param2);
         var _loc4_:StringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
         _loc3_.setStringMap(_loc4_);
         return _loc3_.getString();
      }
      
      public static function getLocalizedStringFromJSON(param1:String) : String
      {
         var _loc2_:LineBuilder = null;
         var _loc3_:StringMap = null;
         if(param1.charAt(0) == "{")
         {
            _loc2_ = LineBuilder.fromJSON(param1);
            _loc3_ = StaticInjectorContext.getInjector().getInstance(StringMap);
            _loc2_.setStringMap(_loc3_);
            return _loc2_.getString();
         }
         return param1;
      }
      
      public static function returnStringReplace(param1:String, param2:Object = null, param3:String = "", param4:String = "") : String
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc5_:String = stripCurlyBrackets(param1);
         for(_loc6_ in param2)
         {
            _loc7_ = param2[_loc6_];
            _loc8_ = "{" + _loc6_ + "}";
            while(_loc5_.indexOf(_loc8_) != -1)
            {
               _loc5_ = _loc5_.replace(_loc8_,_loc7_);
            }
         }
         _loc5_ = _loc5_.replace(/\\n/g,"\n");
         return param3 + _loc5_ + param4;
      }
      
      public static function getLocalizedString2(param1:String, param2:Object = null) : String
      {
         var _loc3_:LineBuilder = new LineBuilder();
         _loc3_.setParams(param1,param2);
         var _loc4_:StringMap = StaticInjectorContext.getInjector().getInstance(StringMap);
         _loc3_.setStringMap(_loc4_);
         return _loc3_.getString();
      }
      
      private static function stripCurlyBrackets(param1:String) : String
      {
         var _loc2_:Boolean = param1 != null && param1.charAt(0) == "{" && param1.charAt(param1.length - 1) == "}";
         return _loc2_ ? param1.substr(1,param1.length - 2) : param1;
      }
      
      public function toJson() : String
      {
         return JSON.stringify({
            "key":this.key,
            "tokens":this.tokens
         });
      }
      
      public function setParams(param1:String, param2:Object = null) : LineBuilder
      {
         this.key = param1 || "";
         this.tokens = param2;
         return this;
      }
      
      public function setPrefix(param1:String) : LineBuilder
      {
         this.prefix = param1;
         return this;
      }
      
      public function setPostfix(param1:String) : LineBuilder
      {
         this.postfix = param1;
         return this;
      }
      
      public function setStringMap(param1:StringMap) : void
      {
         this.map = param1;
      }
      
      public function getString() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:String = stripCurlyBrackets(this.key);
         var _loc2_:String = this.map.getValue(_loc1_) || "";
         for(_loc3_ in this.tokens)
         {
            _loc4_ = this.tokens[_loc3_];
            if(_loc4_.charAt(0) == "{" && _loc4_.charAt(_loc4_.length - 1) == "}")
            {
               _loc4_ = this.map.getValue(_loc4_.substr(1,_loc4_.length - 2));
            }
            _loc5_ = "{" + _loc3_ + "}";
            while(_loc2_.indexOf(_loc5_) != -1)
            {
               _loc2_ = _loc2_.replace(_loc5_,_loc4_);
            }
         }
         _loc2_ = _loc2_.replace(/\\n/g,"\n");
         return this.prefix + _loc2_ + this.postfix;
      }
   }
}

