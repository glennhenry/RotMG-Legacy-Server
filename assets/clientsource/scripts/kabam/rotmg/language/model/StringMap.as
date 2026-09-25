package kabam.rotmg.language.model
{
   public interface StringMap
   {
      
      function clear() : void;
      
      function setValue(param1:String, param2:String, param3:String) : void;
      
      function hasKey(param1:String) : Boolean;
      
      function getValue(param1:String) : String;
      
      function getLanguageFamily(param1:String) : String;
   }
}

