package kabam.rotmg.pets.view.dialogs
{
   import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
   import kabam.rotmg.pets.data.PetSlotsState;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.data.PetsModel;
   import kabam.rotmg.pets.view.components.PetIconFactory;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PetPickerMediator extends Mediator
   {
      
      [Inject]
      public var view:PetPicker;
      
      [Inject]
      public var model:PetsModel;
      
      [Inject]
      public var petIconFactory:PetIconFactory;
      
      [Inject]
      public var petSlotsState:PetSlotsState;
      
      [Inject]
      public var openDialog:OpenDialogNoModalSignal;
      
      public function PetPickerMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.setPets(this.model.getAllPets());
         var _loc1_:PetVO = this.petSlotsState.selected == PetSlotsState.LEFT ? this.petSlotsState.rightSlotPetVO : this.petSlotsState.leftSlotPetVO;
         if(_loc1_)
         {
            this.view.filterFusible(_loc1_);
         }
         if(Boolean(this.petSlotsState.rightSlotPetVO) && this.view.doDisableUsed)
         {
            this.view.filterUsedPetVO(this.petSlotsState.rightSlotPetVO);
         }
         if(Boolean(this.petSlotsState.leftSlotPetVO) && this.view.doDisableUsed)
         {
            this.view.filterUsedPetVO(this.petSlotsState.leftSlotPetVO);
         }
         this.view.petPicked.addOnce(this.onPetPicked);
      }
      
      private function onPetPicked(param1:PetVO) : void
      {
         if(this.petSlotsState.selected == PetSlotsState.LEFT)
         {
            this.petSlotsState.leftSlotPetVO = param1;
         }
         else
         {
            this.petSlotsState.rightSlotPetVO = param1;
         }
         if(this.petSlotsState.caller)
         {
            this.openDialog.dispatch(new this.petSlotsState.caller());
         }
      }
   }
}

