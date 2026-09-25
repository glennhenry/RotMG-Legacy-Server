package kabam.rotmg.game.view
{
   import kabam.rotmg.account.core.signals.OpenMoneyWindowSignal;
   import kabam.rotmg.core.model.PlayerModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class CreditDisplayMediator extends Mediator
   {
      
      [Inject]
      public var view:CreditDisplay;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var openMoneyWindow:OpenMoneyWindowSignal;
      
      public function CreditDisplayMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.model.creditsChanged.add(this.onCreditsChanged);
         this.model.fameChanged.add(this.onFameChanged);
         this.model.tokensChanged.add(this.onTokensChanged);
         this.view.openAccountDialog.add(this.onOpenAccountDialog);
      }
      
      override public function destroy() : void
      {
         this.model.creditsChanged.remove(this.onCreditsChanged);
         this.model.fameChanged.remove(this.onFameChanged);
         this.view.openAccountDialog.remove(this.onOpenAccountDialog);
      }
      
      private function onCreditsChanged(param1:int) : void
      {
         this.view.draw(param1,this.model.getFame());
      }
      
      private function onFameChanged(param1:int) : void
      {
         this.view.draw(this.model.getCredits(),param1);
      }
      
      private function onTokensChanged(param1:int) : void
      {
         this.view.draw(this.model.getCredits(),this.model.getFame(),param1);
      }
      
      private function onOpenAccountDialog() : void
      {
         this.openMoneyWindow.dispatch();
      }
   }
}

