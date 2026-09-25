package kabam.rotmg.pets.view
{
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.messaging.impl.PetUpgradeRequest;
   import kabam.rotmg.pets.controller.UpgradePetSignal;
   import kabam.rotmg.pets.data.FusePetRequestVO;
   import kabam.rotmg.pets.data.PetSlotsState;
   import kabam.rotmg.pets.view.dialogs.PetPickerDialog;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class FusePetMediator extends Mediator
   {
      
      [Inject]
      public var view:FusePetView;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var petSlotsState:PetSlotsState;
      
      [Inject]
      public var upgradePet:UpgradePetSignal;
      
      [Inject]
      public var injector:Injector;
      
      private const ERROR_DIALOG_STRING:String = "Pets.fuseError";
      
      public function FusePetMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.init(this.petSlotsState);
         this.view.openPetPicker.add(this.onOpenPetPicker);
         this.view.goldPurchase.add(this.onGoldPurchase);
         this.view.famePurchase.add(this.onFamePurchase);
         this.view.closed.addOnce(this.onClosed);
      }
      
      override public function destroy() : void
      {
         this.view.openPetPicker.remove(this.onOpenPetPicker);
         this.view.goldPurchase.remove(this.onGoldPurchase);
         this.view.famePurchase.remove(this.onFamePurchase);
      }
      
      private function onOpenPetPicker(param1:String) : void
      {
         this.petSlotsState.caller = FusePetView;
         this.petSlotsState.selected = param1;
         this.openDialog.dispatch(this.injector.getInstance(PetPickerDialog));
      }
      
      private function onFamePurchase(param1:int) : void
      {
         var _loc2_:FusePetRequestVO = null;
         if(this.petSlotsState.isAcceptableFuseState())
         {
            _loc2_ = new FusePetRequestVO(this.petSlotsState.leftSlotPetVO.getID(),this.petSlotsState.rightSlotPetVO.getID(),PetUpgradeRequest.FAME_PAYMENT_TYPE);
            this.onClosed();
            this.upgradePet.dispatch(_loc2_);
         }
         else
         {
            this.openDialog.dispatch(new ErrorDialog(this.ERROR_DIALOG_STRING));
         }
      }
      
      private function onGoldPurchase(param1:int) : void
      {
         var _loc2_:FusePetRequestVO = null;
         if(this.petSlotsState.isAcceptableFuseState())
         {
            _loc2_ = new FusePetRequestVO(this.petSlotsState.leftSlotPetVO.getID(),this.petSlotsState.rightSlotPetVO.getID(),PetUpgradeRequest.GOLD_PAYMENT_TYPE);
            this.onClosed();
            this.upgradePet.dispatch(_loc2_);
         }
         else
         {
            this.openDialog.dispatch(new ErrorDialog(this.ERROR_DIALOG_STRING));
         }
      }
      
      private function onClosed() : void
      {
         this.petSlotsState.clear();
      }
   }
}

