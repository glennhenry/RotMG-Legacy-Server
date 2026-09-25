package kabam.rotmg.account.web
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.GUID;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import kabam.rotmg.account.core.Account;
   
   public class WebAccount implements Account
   {
      
      public static const NETWORK_NAME:String = "rotmg";
      
      private static const WEB_USER_ID:String = "";
      
      private static const WEB_PLAY_PLATFORM_NAME:String = "rotmg";
      
      private var userId:String = "";
      
      private var password:String;
      
      private var entryTag:String = "";
      
      private var isVerifiedEmail:Boolean;
      
      private var platformToken:String;
      
      public var signedRequest:String;
      
      public var kabamId:String;
      
      public function WebAccount()
      {
         super();
         try
         {
            this.entryTag = ExternalInterface.call("rotmg.UrlLib.getParam","entrypt");
         }
         catch(error:Error)
         {
         }
      }
      
      public function getUserName() : String
      {
         return this.userId;
      }
      
      public function getUserId() : String
      {
         return this.userId = this.userId || GUID.create();
      }
      
      public function getPassword() : String
      {
         return this.password || "";
      }
      
      public function getCredentials() : Object
      {
         return {
            "guid":this.getUserId(),
            "password":this.getPassword()
         };
      }
      
      public function isRegistered() : Boolean
      {
         return this.getPassword() != "";
      }
      
      public function updateUser(param1:String, param2:String) : void
      {
         var _loc3_:SharedObject = null;
         this.userId = param1;
         this.password = param2;
         try
         {
            _loc3_ = SharedObject.getLocal("RotMG","/");
            _loc3_.data["GUID"] = param1;
            _loc3_.data["Password"] = param2;
            _loc3_.flush();
         }
         catch(error:Error)
         {
         }
      }
      
      public function clear() : void
      {
         this.updateUser(GUID.create(),null);
         Parameters.sendLogin_ = true;
         Parameters.data_.charIdUseMap = {};
         Parameters.save();
      }
      
      public function reportIntStat(param1:String, param2:int) : void
      {
      }
      
      public function getRequestPrefix() : String
      {
         return "/credits";
      }
      
      public function gameNetworkUserId() : String
      {
         return WEB_USER_ID;
      }
      
      public function gameNetwork() : String
      {
         return NETWORK_NAME;
      }
      
      public function playPlatform() : String
      {
         return WEB_PLAY_PLATFORM_NAME;
      }
      
      public function getEntryTag() : String
      {
         return this.entryTag || "";
      }
      
      public function getSecret() : String
      {
         return "";
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
         return this.signedRequest;
      }
      
      public function getMoneyUserId() : String
      {
         return this.kabamId;
      }
   }
}

