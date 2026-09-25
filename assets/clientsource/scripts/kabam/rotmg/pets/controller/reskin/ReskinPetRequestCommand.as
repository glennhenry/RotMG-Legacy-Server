package kabam.rotmg.pets.controller.reskin
{
   import kabam.lib.net.api.MessageProvider;
   import kabam.lib.net.impl.SocketServer;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.messaging.impl.ReskinPet;
   import kabam.rotmg.pets.data.PetFormModel;
   import kabam.rotmg.pets.data.ReskinPetVO;
   import robotlegs.bender.bundles.mvcs.Command;
   
   public class ReskinPetRequestCommand extends Command
   {
      
      [Inject]
      public var vo:ReskinPetVO;
      
      [Inject]
      public var socketServer:SocketServer;
      
      [Inject]
      public var messages:MessageProvider;
      
      [Inject]
      public var reskinModel:PetFormModel;
      
      public function ReskinPetRequestCommand()
      {
         super();
      }
      
      override public function execute() : void
      {
         var _loc1_:ReskinPet = null;
         _loc1_ = this.messages.require(GameServerConnection.PET_CHANGE_FORM_MSG) as ReskinPet;
         _loc1_.petInstanceId = this.reskinModel.getSelectedPet().getID();
         _loc1_.pickedNewPetType = this.reskinModel.getpetTypeFromSkinID(this.reskinModel.getSelectedSkin());
         _loc1_.item = this.reskinModel.slotObjectData;
         this.socketServer.sendMessage(_loc1_);
      }
   }
}

