package kabam.rotmg.language.model
{
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   
   public class CookieLanguageModel implements LanguageModel
   {
      
      public static const DEFAULT_LOCALE:String = "en";
      
      private var cookie:SharedObject;
      
      private var language:String;
      
      private var availableLanguages:Dictionary = this.makeAvailableLanguages();
      
      public function CookieLanguageModel()
      {
         super();
         try
         {
            this.cookie = SharedObject.getLocal("RotMG","/");
         }
         catch(error:Error)
         {
         }
      }
      
      public function getLanguage() : String
      {
         return this.language = this.language || this.readLanguageFromCookie();
      }
      
      private function readLanguageFromCookie() : String
      {
         return this.cookie.data.locale || DEFAULT_LOCALE;
      }
      
      public function setLanguage(param1:String) : void
      {
         this.language = param1;
         try
         {
            this.cookie.data.locale = param1;
            this.cookie.flush();
         }
         catch(error:Error)
         {
         }
      }
      
      public function getLanguageFamily() : String
      {
         return this.getLanguage().substr(0,2).toLowerCase();
      }
      
      public function getLanguageNames() : Vector.<String>
      {
         var _loc2_:String = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         for(_loc2_ in this.availableLanguages)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getLanguageCodeForName(param1:String) : String
      {
         return this.availableLanguages[param1];
      }
      
      public function getNameForLanguageCode(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         for(_loc3_ in this.availableLanguages)
         {
            if(this.availableLanguages[_loc3_] == param1)
            {
               _loc2_ = _loc3_;
            }
         }
         return _loc2_;
      }
      
      private function makeAvailableLanguages() : Dictionary
      {
         var _loc1_:Dictionary = new Dictionary();
         _loc1_["Languages.English"] = "en";
         _loc1_["Languages.French"] = "fr";
         _loc1_["Languages.Spanish"] = "es";
         _loc1_["Languages.Italian"] = "it";
         _loc1_["Languages.German"] = "de";
         _loc1_["Languages.Turkish"] = "tr";
         _loc1_["Languages.Russian"] = "ru";
         return _loc1_;
      }
   }
}

