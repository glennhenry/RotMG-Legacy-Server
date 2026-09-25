package kabam.rotmg.account.core
{
   public interface Account
   {
      
      function getPlatformToken() : String;
      
      function setPlatformToken(param1:String) : void;
      
      function updateUser(param1:String, param2:String) : void;
      
      function getUserName() : String;
      
      function getUserId() : String;
      
      function getPassword() : String;
      
      function getSecret() : String;
      
      function getCredentials() : Object;
      
      function isRegistered() : Boolean;
      
      function clear() : void;
      
      function reportIntStat(param1:String, param2:int) : void;
      
      function getRequestPrefix() : String;
      
      function gameNetworkUserId() : String;
      
      function gameNetwork() : String;
      
      function playPlatform() : String;
      
      function getEntryTag() : String;
      
      function verify(param1:Boolean) : void;
      
      function isVerified() : Boolean;
      
      function getMoneyUserId() : String;
      
      function getMoneyAccessToken() : String;
   }
}

