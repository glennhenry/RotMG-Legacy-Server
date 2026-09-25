package kabam.rotmg.pets.controller
{
   import kabam.lib.net.api.MessageProvider;
   import kabam.lib.net.impl.SocketServer;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.messaging.impl.outgoing.ActivePetUpdateRequest;
   import kabam.rotmg.pets.util.PetsConstants;
   import robotlegs.bender.bundles.mvcs.Command;
   
   public class ActivatePetCommand extends Command
   {
      
      [Inject]
      public var instanceID:uint;
      
      [Inject]
      public var messages:MessageProvider;
      
      [Inject]
      public var server:SocketServer;
      
      public function ActivatePetCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         var _loc1_:ActivePetUpdateRequest = this.messages.require(GameServerConnection.ACTIVE_PET_UPDATE_REQUEST) as ActivePetUpdateRequest;
         _loc1_.instanceid = this.instanceID;
         _loc1_.commandtype = PetsConstants.INTERACTING;
         this.server.sendMessage(_loc1_);
      }
   }
}

