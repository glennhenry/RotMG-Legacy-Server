package kabam.rotmg.language.model
{
   public interface LanguageModel
   {
      
      function getLanguage() : String;
      
      function setLanguage(param1:String) : void;
      
      function getLanguageFamily() : String;
      
      function getLanguageNames() : Vector.<String>;
      
      function getLanguageCodeForName(param1:String) : String;
      
      function getNameForLanguageCode(param1:String) : String;
   }
}

