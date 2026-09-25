package kabam.rotmg.application.impl
{
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.application.api.ApplicationSetup;
   
   public class PrivateSetup implements ApplicationSetup
   {
      
      private const SERVER:String = "rotmgtesting.appspot.com";
      
      private const UNENCRYPTED:String = "http://" + this.SERVER;
      
      private const ENCRYPTED:String = "https://" + this.SERVER;
      
      private const ANALYTICS:String = "UA-99999999-1";
      
      private const BUILD_LABEL:String = "<font color=\'#FFEE00\'>TESTING APP ENGINE, PRIVATE SERVER</font> #{VERSION}";
      
      public function PrivateSetup()
      {
         super();
      }
      
      public function getAppEngineUrl(param1:Boolean = false) : String
      {
         return param1 ? this.UNENCRYPTED : this.ENCRYPTED;
      }
      
      public function getAnalyticsCode() : String
      {
         return this.ANALYTICS;
      }
      
      public function getBuildLabel() : String
      {
         var _loc1_:String = Parameters.BUILD_VERSION + "." + Parameters.MINOR_VERSION;
         return this.BUILD_LABEL.replace("{VERSION}",_loc1_);
      }
      
      public function useLocalTextures() : Boolean
      {
         return true;
      }
      
      public function isToolingEnabled() : Boolean
      {
         return true;
      }
      
      public function isGameLoopMonitored() : Boolean
      {
         return true;
      }
      
      public function useProductionDialogs() : Boolean
      {
         return false;
      }
      
      public function areErrorsReported() : Boolean
      {
         return false;
      }
      
      public function areDeveloperHotkeysEnabled() : Boolean
      {
         return true;
      }
      
      public function isDebug() : Boolean
      {
         return true;
      }
   }
}

