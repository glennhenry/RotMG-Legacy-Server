package kabam.rotmg.text.view.stringBuilder
{
   import kabam.rotmg.language.model.StringMap;
   
   public class StaticStringBuilder implements StringBuilder
   {
      
      private var string:String;
      
      private var prefix:String;
      
      private var postfix:String;
      
      public function StaticStringBuilder(param1:String = "")
      {
         super();
         this.string = param1;
         this.prefix = "";
         this.postfix = "";
      }
      
      public function setString(param1:String) : StaticStringBuilder
      {
         this.string = param1;
         return this;
      }
      
      public function setPrefix(param1:String) : StaticStringBuilder
      {
         this.prefix = param1;
         return this;
      }
      
      public function setPostfix(param1:String) : StaticStringBuilder
      {
         this.postfix = param1;
         return this;
      }
      
      public function setStringMap(param1:StringMap) : void
      {
      }
      
      public function getString() : String
      {
         return this.prefix + this.string + this.postfix;
      }
   }
}

