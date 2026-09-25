package kabam.rotmg.ui.commands
{
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import kabam.rotmg.servers.api.ServerModel;
   import kabam.rotmg.ui.noservers.NoServersDialogFactory;
   import kabam.rotmg.ui.view.AgeVerificationDialog;
   
   public class EnterGameCommand
   {
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var setScreenWithValidData:SetScreenWithValidDataSignal;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var servers:ServerModel;
      
      [Inject]
      public var noServersDialogFactory:NoServersDialogFactory;
      
      private const DEFAULT_CHARACTER:int = 782;
      
      public function EnterGameCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(!this.servers.isServerAvailable())
         {
            this.showNoServersDialog();
         }
         else if(!this.account.isRegistered())
         {
            this.launchGame();
         }
         else if(!this.model.getIsAgeVerified())
         {
            this.showAgeVerificationDialog();
         }
         else
         {
            this.showCurrentCharacterScreen();
         }
      }
      
      private function showCurrentCharacterScreen() : void
      {
         this.setScreenWithValidData.dispatch(new CharacterSelectionAndNewsScreen());
      }
      
      private function launchGame() : void
      {
         this.playGame.dispatch(this.makeGameInitData());
      }
      
      private function makeGameInitData() : GameInitData
      {
         var _loc1_:GameInitData = new GameInitData();
         _loc1_.createCharacter = true;
         _loc1_.charId = this.model.getNextCharId();
         _loc1_.keyTime = -1;
         _loc1_.isNewGame = true;
         return _loc1_;
      }
      
      private function showAgeVerificationDialog() : void
      {
         this.openDialog.dispatch(new AgeVerificationDialog());
      }
      
      private function showNoServersDialog() : void
      {
         this.openDialog.dispatch(this.noServersDialogFactory.makeDialog());
      }
   }
}

