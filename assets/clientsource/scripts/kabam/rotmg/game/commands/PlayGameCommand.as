package kabam.rotmg.game.commands
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.utils.ByteArray;
   import kabam.lib.net.impl.SocketServerModel;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.rotmg.account.core.services.GetCharListTask;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.pets.data.PetsModel;
   import kabam.rotmg.servers.api.Server;
   import kabam.rotmg.servers.api.ServerModel;
   
   public class PlayGameCommand
   {
      
      public static const RECONNECT_DELAY:int = 2000;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var data:GameInitData;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var petsModel:PetsModel;
      
      [Inject]
      public var servers:ServerModel;
      
      [Inject]
      public var task:GetCharListTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var socketServerModel:SocketServerModel;
      
      public function PlayGameCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(!this.data.isNewGame)
         {
            this.socketServerModel.connectDelayMS = PlayGameCommand.RECONNECT_DELAY;
         }
         this.recordCharacterUseInSharedObject();
         this.makeGameView();
         this.updatePet();
      }
      
      private function updatePet() : void
      {
         var _loc1_:SavedCharacter = this.model.getCharacterById(this.model.currentCharId);
         if(_loc1_)
         {
            this.petsModel.setActivePet(_loc1_.getPetVO());
         }
         else
         {
            if(Boolean(this.model.currentCharId) && Boolean(this.petsModel.getActivePet()) && !this.data.isNewGame)
            {
               return;
            }
            this.petsModel.setActivePet(null);
         }
      }
      
      private function recordCharacterUseInSharedObject() : void
      {
         Parameters.data_.charIdUseMap[this.data.charId] = new Date().getTime();
         Parameters.save();
      }
      
      private function makeGameView() : void
      {
         var _loc1_:Server = this.data.server || this.servers.getServer();
         var _loc2_:int = this.data.isNewGame ? this.getInitialGameId() : this.data.gameId;
         var _loc3_:Boolean = this.data.createCharacter;
         var _loc4_:int = this.data.charId;
         var _loc5_:int = this.data.isNewGame ? -1 : this.data.keyTime;
         var _loc6_:ByteArray = this.data.key;
         this.model.currentCharId = _loc4_;
         this.setScreen.dispatch(new GameSprite(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,this.model,null,this.data.isFromArena));
      }
      
      private function getInitialGameId() : int
      {
         var _loc1_:int = 0;
         if(Parameters.data_.needsTutorial)
         {
            _loc1_ = Parameters.TUTORIAL_GAMEID;
         }
         else if(Parameters.data_.needsRandomRealm)
         {
            _loc1_ = Parameters.RANDOM_REALM_GAMEID;
         }
         else
         {
            _loc1_ = Parameters.NEXUS_GAMEID;
         }
         return _loc1_;
      }
   }
}

