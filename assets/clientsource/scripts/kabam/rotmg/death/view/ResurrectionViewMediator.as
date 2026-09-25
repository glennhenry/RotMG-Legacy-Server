package kabam.rotmg.death.view
{
   import flash.display.Sprite;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.death.model.DeathModel;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.game.signals.PlayGameSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ResurrectionViewMediator extends Mediator
   {
      
      [Inject]
      public var death:DeathModel;
      
      [Inject]
      public var view:ResurrectionView;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var playGame:PlayGameSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      public function ResurrectionViewMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.closed.add(this.onClosed);
         this.view.showDialog.add(this.onShowDialog);
         this.view.init(this.death.getLastDeath().background);
      }
      
      override public function destroy() : void
      {
         this.view.showDialog.remove(this.onShowDialog);
         this.view.closed.remove(this.onClosed);
      }
      
      private function onShowDialog(param1:Sprite) : void
      {
         this.openDialog.dispatch(param1);
      }
      
      private function onClosed() : void
      {
         this.closeDialogs.dispatch();
         var _loc1_:GameInitData = new GameInitData();
         _loc1_.createCharacter = false;
         _loc1_.charId = this.playerModel.currentCharId;
         _loc1_.isNewGame = true;
         this.playGame.dispatch(_loc1_);
      }
   }
}

