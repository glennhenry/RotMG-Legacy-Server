package kabam.rotmg.account.kabam
{
   import flash.external.ExternalInterface;
   import kabam.lib.json.JsonParser;
   import kabam.rotmg.account.core.Account;
   
   public class KabamAccount implements Account
   {
      
      public static const NETWORK_NAME:String = "kabam.com";
      
      private static const PLAY_PLATFORM_NAME:String = "kabam.com";
      
      private var entryTag:String;
      
      private var userId:String = "";
      
      private var password:String = null;
      
      private var isVerifiedEmail:Boolean;
      
      private var platformToken:String;
      
      public var signedRequest:String;
      
      public var userSession:Object;
      
      [Inject]
      public var json:JsonParser;
      
      public function KabamAccount()
      {
         var _loc1_:String = null;
         super();
         try
         {
            _loc1_ = ExternalInterface.call("rotmg.UrlLib.getParam","entrypt");
            if(_loc1_ != null)
            {
               this.entryTag = _loc1_;
            }
         }
         catch(error:Error)
         {
         }
      }
      
      public function updateUser(param1:String, param2:String) : void
      {
         this.userId = param1;
         this.password = param2;
      }
      
      public function getRequestPrefix() : String
      {
         return "/credits";
      }
      
      public function getCredentials() : Object
      {
         return {
            "guid":this.getUserId(),
            "secret":this.getSecret(),
            "signedRequest":this.signedRequest
         };
      }
      
      public function getEntryTag() : String
      {
         return this.entryTag || "";
      }
      
      public function gameNetworkUserId() : String
      {
         if(this.userSession == null || this.userSession["kabam_naid"] == null)
         {
            return "";
         }
         return this.userSession["kabam_naid"];
      }
      
      public function gameNetwork() : String
      {
         return NETWORK_NAME;
      }
      
      public function getUserName() : String
      {
         if(this.userSession == null || this.userSession["user"] == null || this.userSession["user"]["email"] == null)
         {
            return "";
         }
         var _loc1_:String = this.userSession["user"]["email"];
         var _loc2_:Array = _loc1_.split("@",2);
         if(_loc2_.length != 2)
         {
            return "";
         }
         return _loc2_[0];
      }
      
      public function getUserId() : String
      {
         return this.userId;
      }
      
      public function isLinked() : Boolean
      {
         return false;
      }
      
      public function isRegistered() : Boolean
      {
         return true;
      }
      
      public function playPlatform() : String
      {
         return PLAY_PLATFORM_NAME;
      }
      
      public function getSecret() : String
      {
         return this.password || "";
      }
      
      public function getPassword() : String
      {
         return "";
      }
      
      public function clear() : void
      {
      }
      
      public function reportIntStat(param1:String, param2:int) : void
      {
      }
      
      public function verify(param1:Boolean) : void
      {
         this.isVerifiedEmail = param1;
      }
      
      public function isVerified() : Boolean
      {
         return this.isVerifiedEmail;
      }
      
      public function getPlatformToken() : String
      {
         return this.platformToken || "";
      }
      
      public function setPlatformToken(param1:String) : void
      {
         this.platformToken = param1;
      }
      
      public function getMoneyAccessToken() : String
      {
         return this.userSession["oauth_token"];
      }
      
      public function getMoneyUserId() : String
      {
         return this.gameNetworkUserId();
      }
   }
}

