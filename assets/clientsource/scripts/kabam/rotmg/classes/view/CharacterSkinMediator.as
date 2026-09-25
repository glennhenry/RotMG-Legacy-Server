package kabam.rotmg.classes.view
{
   import com.company.assembleegameclient.screens.NewCharacterScreen;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CharacterSkinMediator extends Mediator
   {
      
      [Inject]
      public var view:CharacterSkinView;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var play:PlayGameSignal;
      
      public function CharacterSkinMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         var _loc1_:Boolean = this.model.hasAvailableCharSlot();
         this.view.setPlayButtonEnabled(_loc1_);
         if(_loc1_)
         {
            this.view.play.addOnce(this.onPlay);
         }
         this.view.back.addOnce(this.onBack);
      }
      
      override public function destroy() : void
      {
         this.view.back.remove(this.onBack);
         this.view.play.remove(this.onPlay);
      }
      
      private function onBack() : void
      {
         this.setScreen.dispatch(new NewCharacterScreen());
      }
      
      private function onPlay() : void
      {
         var _loc1_:GameInitData = new GameInitData();
         _loc1_.createCharacter = true;
         _loc1_.charId = this.model.getNextCharId();
         _loc1_.keyTime = -1;
         _loc1_.isNewGame = true;
         this.play.dispatch(_loc1_);
      }
   }
}

