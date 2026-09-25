package kabam.rotmg.pets.view
{
   import kabam.rotmg.pets.controller.reskin.ReskinPetRequestSignal;
   import kabam.rotmg.pets.controller.reskin.UpdateSelectedPetForm;
   import kabam.rotmg.pets.data.PetFormModel;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.data.PetsModel;
   import kabam.rotmg.pets.data.ReskinPetVO;
   import kabam.rotmg.pets.data.ReskinViewState;
   import kabam.rotmg.pets.view.dialogs.PetPicker;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PetFormMediator extends Mediator
   {
      
      [Inject]
      public var view:PetFormView;
      
      [Inject]
      public var petFormModel:PetFormModel;
      
      [Inject]
      public var reskinPetRequest:ReskinPetRequestSignal;
      
      [Inject]
      public var updateSelectedPetForm:UpdateSelectedPetForm;
      
      [Inject]
      public var petsModel:PetsModel;
      
      [Inject]
      public var picker:PetPicker;
      
      private var skinGroups:Vector.<PetSkinGroup> = new Vector.<PetSkinGroup>();
      
      public function PetFormMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         var _loc1_:Vector.<PetVO> = this.petsModel.getAllPets();
         this.picker.petPicked.add(this.onPetPicked);
         this.view.skinGroupsInitialized.add(this.onSkinGroupsInitialized);
         this.view.reskinRequest.add(this.onPetReskinRequest);
         this.view.init();
         this.view.createPetPicker(this.picker,_loc1_);
         this.view.setState(ReskinViewState.PETPICKER);
      }
      
      private function onSkinGroupsInitialized() : void
      {
         this.updateSelectedPetForm.dispatch();
      }
      
      private function initSkinGroups() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            this.createPetSkinGroup(_loc1_);
            _loc1_++;
         }
      }
      
      private function createPetSkinGroup(param1:uint) : void
      {
         var _loc2_:PetSkinGroup = new PetSkinGroup(param1);
         _loc2_.skinSelected.add(this.onPetReskinSelected);
         this.skinGroups.push(_loc2_);
      }
      
      private function onPetReskinSelected(param1:int) : void
      {
      }
      
      private function onPetReskinRequest() : void
      {
         var _loc1_:ReskinPetVO = new ReskinPetVO();
         _loc1_.petInstanceId = this.petFormModel.getSelectedPet().getID();
         _loc1_.pickedNewPetType = this.petFormModel.getSelectedSkin();
         this.reskinPetRequest.dispatch(_loc1_);
      }
      
      private function onPetPicked(param1:PetVO) : void
      {
         this.petFormModel.setSelectedPet(param1);
         this.petFormModel.setSelectedSkin(param1.getSkinID());
         this.petFormModel.createPetFamilyTree();
         this.initSkinGroups();
         this.view.createSkinGroups(this.skinGroups);
         this.view.setState(ReskinViewState.SKINPICKER);
      }
   }
}

