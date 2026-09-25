package kabam.rotmg.language
{
   import flash.text.TextField;
   import kabam.rotmg.language.model.DebugStringMap;
   import kabam.rotmg.language.model.StringMap;
   import kabam.rotmg.text.model.TextAndMapProvider;
   import kabam.rotmg.text.view.DebugTextField;
   
   public class DebugTextAndMapProvider implements TextAndMapProvider
   {
      
      [Inject]
      public var debugStringMap:DebugStringMap;
      
      public function DebugTextAndMapProvider()
      {
         super();
      }
      
      public function getTextField() : TextField
      {
         var _loc1_:DebugTextField = new DebugTextField();
         _loc1_.debugStringMap = this.debugStringMap;
         return _loc1_;
      }
      
      public function getStringMap() : StringMap
      {
         return this.debugStringMap;
      }
   }
}

