package kabam.rotmg.account.steam
{
   import com.company.util.EmailValidator;
   import kabam.rotmg.account.core.Account;
   
   public class SteamAccount implements Account
   {
      
      public static const NETWORK_NAME:String = "steam";
      
      [Inject]
      public var api:SteamApi;
      
      private var userId:String = "";
      
      private var password:String = null;
      
      private var isVerifiedEmail:Boolean;
      
      private var platformToken:String;
      
      public function SteamAccount()
      {
         super();
      }
      
      public function updateUser(param1:String, param2:String) : void
      {
         this.userId = param1;
         this.password = param2;
      }
      
      public function getUserName() : String
      {
         return this.api.getPersonaName();
      }
      
      public function getUserId() : String
      {
         return this.userId = this.userId || "";
      }
      
      public function getPassword() : String
      {
         return "";
      }
      
      public function getSecret() : String
      {
         return this.password = this.password || "";
      }
      
      public function getCredentials() : Object
      {
         var _loc1_:Object = {};
         _loc1_.guid = this.getUserId();
         _loc1_.secret = this.getSecret();
         _loc1_.steamid = this.api.getSteamId();
         return _loc1_;
      }
      
      public function isRegistered() : Boolean
      {
         return this.getSecret() != "";
      }
      
      public function isLinked() : Boolean
      {
         return EmailValidator.isValidEmail(this.userId);
      }
      
      public function gameNetworkUserId() : String
      {
         return this.api.getSteamId();
      }
      
      public function gameNetwork() : String
      {
         return NETWORK_NAME;
      }
      
      public function playPlatform() : String
      {
         return "steam";
      }
      
      public function reportIntStat(param1:String, param2:int) : void
      {
         this.api.reportStatistic(param1,param2);
      }
      
      public function getRequestPrefix() : String
      {
         return "/steamworks";
      }
      
      public function getEntryTag() : String
      {
         return "steamworks";
      }
      
      public function clear() : void
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
         throw new Error("No current support for new Kabam offer wall on Steam.");
      }
      
      public function getMoneyUserId() : String
      {
         throw new Error("No current support for new Kabam offer wall on Steam.");
      }
   }
}

