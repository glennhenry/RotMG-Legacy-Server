package kabam.rotmg.account.steam
{
   import org.osflash.signals.OnceSignal;
   import org.osflash.signals.Signal;
   
   public interface SteamApi
   {
      
      function load(param1:String) : void;
      
      function get loaded() : Signal;
      
      function requestSessionTicket() : void;
      
      function get sessionReceived() : Signal;
      
      function getSessionAuthentication() : Object;
      
      function getSteamId() : String;
      
      function reportStatistic(param1:String, param2:int) : void;
      
      function get paymentAuthorized() : OnceSignal;
      
      function getPersonaName() : String;
   }
}

