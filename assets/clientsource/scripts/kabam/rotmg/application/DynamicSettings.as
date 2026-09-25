package kabam.rotmg.application
{
   public class DynamicSettings
   {
      
      private static var _xml:XML;
      
      public function DynamicSettings()
      {
         super();
      }
      
      public static function get xml() : XML
      {
         return _xml;
      }
      
      public static function set xml(param1:XML) : void
      {
         _xml = param1;
      }
      
      public static function settingExists(param1:String) : Boolean
      {
         return _xml != null && _xml.hasOwnProperty(param1);
      }
      
      public static function getSettingValue(param1:String) : Number
      {
         return Number(_xml.child(param1).toString());
      }
   }
}

