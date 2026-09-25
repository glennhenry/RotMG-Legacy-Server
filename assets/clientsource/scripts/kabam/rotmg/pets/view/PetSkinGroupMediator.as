package kabam.rotmg.pets.view
{
   import kabam.rotmg.pets.controller.reskin.UpdateSelectedPetForm;
   import kabam.rotmg.pets.data.PetFormModel;
   import kabam.rotmg.pets.data.PetRarityEnum;
   import kabam.rotmg.pets.data.PetSkinGroupVO;
   import kabam.rotmg.pets.data.PetVO;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PetSkinGroupMediator extends Mediator
   {
      
      [Inject]
      public var view:PetSkinGroup;
      
      [Inject]
      public var petFormModel:PetFormModel;
      
      [Inject]
      public var updateSelectedPetForm:UpdateSelectedPetForm;
      
      public function PetSkinGroupMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         var _loc1_:PetSkinGroupVO = this.petFormModel.petSkinGroupVOs[this.view.index];
         var _loc2_:PetRarityEnum = _loc1_.petRarityEnum;
         this.updateSelectedPetForm.add(this.onUpdateSelectedPetForm);
         this.view.skinSelected.add(this.onSkinSelected);
         this.view.disabled = this.isSelectedPetRarerThan(_loc2_);
         this.view.init(_loc1_);
      }
      
      private function onSkinSelected(param1:PetVO) : void
      {
         this.petFormModel.setSelectedSkin(param1.getSkinID());
         this.updateSelectedPetForm.dispatch();
      }
      
      private function onUpdateSelectedPetForm() : void
      {
         this.view.onSlotSelected(this.petFormModel.getSelectedSkin());
      }
      
      private function isSelectedPetRarerThan(param1:PetRarityEnum) : Boolean
      {
         var _loc2_:PetVO = this.petFormModel.getSelectedPet();
         var _loc3_:PetRarityEnum = PetRarityEnum.selectByValue(_loc2_.getRarity());
         var _loc4_:int = _loc3_.ordinal;
         return param1.ordinal > _loc4_;
      }
   }
}

