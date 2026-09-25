package kabam.rotmg.text.view.stringBuilder
{
   import kabam.rotmg.language.model.StringMap;
   
   public class TemplateBuilder implements StringBuilder
   {
      
      private var template:String;
      
      private var tokens:Object;
      
      private var postfix:String = "";
      
      private var prefix:String = "";
      
      private var provider:StringMap;
      
      public function TemplateBuilder()
      {
         super();
      }
      
      public function setTemplate(param1:String, param2:Object = null) : TemplateBuilder
      {
         this.template = param1;
         this.tokens = param2;
         return this;
      }
      
      public function setPrefix(param1:String) : TemplateBuilder
      {
         this.prefix = param1;
         return this;
      }
      
      public function setPostfix(param1:String) : TemplateBuilder
      {
         this.postfix = param1;
         return this;
      }
      
      public function setStringMap(param1:StringMap) : void
      {
         this.provider = param1;
      }
      
      public function getString() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:String = this.template;
         for(_loc2_ in this.tokens)
         {
            _loc3_ = this.tokens[_loc2_];
            if(_loc3_.charAt(0) == "{" && _loc3_.charAt(_loc3_.length - 1) == "}")
            {
               _loc3_ = this.provider.getValue(_loc3_.substr(1,_loc3_.length - 2));
            }
            _loc1_ = _loc1_.replace("{" + _loc2_ + "}",_loc3_);
         }
         _loc1_ = _loc1_.replace(/\\n/g,"\n");
         return this.prefix + _loc1_ + this.postfix;
      }
   }
}

