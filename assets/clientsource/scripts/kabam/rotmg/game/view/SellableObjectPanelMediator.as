package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.objects.SellableObject;
   import com.company.assembleegameclient.util.Currency;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.ui.view.NotEnoughGoldDialog;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class SellableObjectPanelMediator extends Mediator
   {
      
      public static const TEXT:String = "SellableObjectPanelMediator.text";
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var gameModel:GameModel;
      
      [Inject]
      public var view:SellableObjectPanel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function SellableObjectPanelMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.setInventorySpaceAmount(this.gameModel.player.numberOfAvailableSlots());
         this.view.buyItem.add(this.onBuyItem);
      }
      
      override public function destroy() : void
      {
         this.view.buyItem.remove(this.onBuyItem);
      }
      
      private function onBuyItem(param1:SellableObject) : void
      {
         if(this.account.isRegistered())
         {
            if(param1.currency_ == Currency.GOLD && param1.getQuantity() * param1.price_ > this.gameModel.player.credits_)
            {
               this.openDialog.dispatch(new NotEnoughGoldDialog());
            }
            else
            {
               this.view.gs_.gsc_.buy(param1.objectId_,param1.getQuantity());
            }
         }
         else
         {
            this.openDialog.dispatch(this.makeRegisterDialog(param1));
         }
      }
      
      private function makeRegisterDialog(param1:SellableObject) : RegisterPromptDialog
      {
         return new RegisterPromptDialog(TEXT,{"type":Currency.typeToName(param1.currency_)});
      }
   }
}

