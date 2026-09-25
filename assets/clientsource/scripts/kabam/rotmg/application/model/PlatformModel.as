package kabam.rotmg.application.model
{
   import flash.display.DisplayObjectContainer;
   import flash.display.LoaderInfo;
   import flash.system.Capabilities;
   import kabam.rotmg.application.*;
   
   public class PlatformModel
   {
      
      private static var platform:PlatformType;
      
      [Inject]
      public var root:DisplayObjectContainer;
      
      private const DESKTOP:String = "Desktop";
      
      public function PlatformModel()
      {
         super();
      }
      
      public function isWeb() : Boolean
      {
         return Capabilities.playerType != this.DESKTOP;
      }
      
      public function isDesktop() : Boolean
      {
         return Capabilities.playerType == this.DESKTOP;
      }
      
      public function getPlatform() : PlatformType
      {
         return platform = platform || this.determinePlatform();
      }
      
      private function determinePlatform() : PlatformType
      {
         var _loc1_:Object = LoaderInfo(this.root.stage.root.loaderInfo).parameters;
         if(this.isKongregate(_loc1_))
         {
            return PlatformType.KONGREGATE;
         }
         if(this.isSteam(_loc1_))
         {
            return PlatformType.STEAM;
         }
         if(this.isKabam(_loc1_))
         {
            return PlatformType.KABAM;
         }
         return PlatformType.WEB;
      }
      
      private function isKongregate(param1:Object) : Boolean
      {
         return param1.kongregate_api_path != null;
      }
      
      private function isSteam(param1:Object) : Boolean
      {
         return param1.steam_api_path != null;
      }
      
      private function isKabam(param1:Object) : Boolean
      {
         return param1.kabam_signed_request != null;
      }
   }
}

