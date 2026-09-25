package kabam.rotmg.language.model
{
   public class StringMapConcrete implements StringMap
   {
      
      private var valueMap:Object = {};
      
      private var languageFamilyMap:Object = {};
      
      public function StringMapConcrete()
      {
         super();
      }
      
      public function clear() : void
      {
         this.valueMap = {};
         this.languageFamilyMap = {};
      }
      
      public function setValue(param1:String, param2:String, param3:String) : void
      {
         this.valueMap[param1] = param2;
         this.languageFamilyMap[param1] = param3;
      }
      
      public function hasKey(param1:String) : Boolean
      {
         return this.valueMap[param1] != null;
      }
      
      public function getValue(param1:String) : String
      {
         return this.valueMap[param1];
      }
      
      public function getLanguageFamily(param1:String) : String
      {
         return this.languageFamilyMap[param1];
      }
   }
}

