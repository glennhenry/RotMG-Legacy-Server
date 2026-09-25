package kabam.rotmg.account.steam.services
{
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import kabam.rotmg.account.steam.SteamApi;
   import org.osflash.signals.OnceSignal;
   import org.osflash.signals.Signal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class LiveSteamApi extends Sprite implements SteamApi
   {
      
      [Inject]
      public var logger:ILogger;
      
      private const _loaded:Signal = new Signal();
      
      private const _sessionReceived:Signal = new Signal(Boolean);
      
      private const _paymentAuthorized:Signal = new Signal(uint,String,Boolean);
      
      private var loader:Loader;
      
      private var api:*;
      
      private var steamID:String;
      
      private var sessionTicket:String;
      
      public function LiveSteamApi()
      {
         super();
      }
      
      public function load(param1:String) : void
      {
         this.logger.info("LiveSteamApi load");
         addChild(this.loader = new Loader());
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onAPILoaded);
         this.loader.load(new URLRequest(param1));
      }
      
      private function onAPILoaded(param1:Event) : void
      {
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onAPILoaded);
         this.api = param1.target.content;
         this.api.addEventListener("STEAM_MICRO_TXN_AUTH",this.onSteamMicroTxnAuthEvent);
         this.loaded.dispatch();
      }
      
      private function onSteamMicroTxnAuthEvent(param1:*) : void
      {
         this.logger.debug("LiveSteamApi onSteamMicroTxnAuthEvent: {0}",[this.sessionTicket]);
         var _loc2_:uint = uint(param1.appID);
         var _loc3_:String = String(param1.orderID);
         var _loc4_:Boolean = Boolean(param1.isAuthorized);
         this._paymentAuthorized.dispatch(_loc2_,_loc3_,_loc4_);
      }
      
      public function requestSessionTicket() : void
      {
         this.logger.debug("LiveSteamApi requestSessionTicket");
         this.api.requestSessionTicket(this.onSessionTicketResponse);
      }
      
      private function onSessionTicketResponse(param1:String) : void
      {
         var _loc2_:Boolean = param1 != null;
         _loc2_ && (this.sessionTicket = param1);
         this.logger.debug("LiveSteamApi sessionTicket: {0}",[this.sessionTicket]);
         this.sessionReceived.dispatch(_loc2_);
      }
      
      public function getSessionAuthentication() : Object
      {
         var _loc1_:Object = {};
         _loc1_.steamid = this.steamID = this.steamID || this.api.getSteamID();
         _loc1_.sessionticket = this.sessionTicket;
         return _loc1_;
      }
      
      public function getSteamId() : String
      {
         return this.api.getSteamID();
      }
      
      public function reportStatistic(param1:String, param2:int) : void
      {
         this.api.setStatFromInt(param1,param2);
      }
      
      public function get loaded() : Signal
      {
         return this._loaded;
      }
      
      public function get sessionReceived() : Signal
      {
         return this._sessionReceived;
      }
      
      public function get paymentAuthorized() : OnceSignal
      {
         return this._paymentAuthorized;
      }
      
      public function getPersonaName() : String
      {
         return this.api.getPersonaName();
      }
   }
}

