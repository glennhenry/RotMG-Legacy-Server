package kabam.rotmg.account.kongregate.view
{
   import org.osflash.signals.Signal;
   
   public interface KongregateApi
   {
      
      function load(param1:String) : void;
      
      function get loaded() : Signal;
      
      function isGuest() : Boolean;
      
      function showRegistrationDialog() : void;
      
      function getAuthentication() : Object;
      
      function reportStatistic(param1:String, param2:int) : void;
      
      function getUserName() : String;
      
      function getUserId() : String;
      
      function purchaseItems(param1:Object) : void;
      
      function get purchaseResponse() : Signal;
   }
}

