package kabam.rotmg.pets.view.components
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import kabam.rotmg.pets.data.PetFamilyKeys;
   import kabam.rotmg.pets.data.PetRarityEnum;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.util.PetsViewAssetFactory;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.ui.model.TabStripModel;
   
   public class PetsTabContentView extends Sprite
   {
      
      public var petBitmap:Bitmap;
      
      private var petsContent:Sprite = new Sprite();
      
      public var petRarityTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(11776947,13,false);
      
      private var tabTitleTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(11776947,15,true);
      
      private var petFamilyTextField:TextFieldDisplayConcrete = PetsViewAssetFactory.returnTextfield(11776947,13,false);
      
      private var petVO:PetVO;
      
      public function PetsTabContentView()
      {
         super();
      }
      
      public function init(param1:PetVO) : void
      {
         this.petVO = param1;
         this.petBitmap = param1.getSkin();
         this.addChildren();
         this.addAbilities();
         this.positionChildren();
         this.updateTextFields();
         this.petsContent.name = TabStripModel.PETS;
         param1.updated.add(this.onUpdate);
      }
      
      private function onUpdate() : void
      {
         this.updatePetBitmap();
         this.petRarityTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.getRarity()));
      }
      
      private function updatePetBitmap() : void
      {
         this.petsContent.removeChild(this.petBitmap);
         this.petBitmap = this.petVO.getSkin();
         this.petsContent.addChild(this.petBitmap);
      }
      
      private function addAbilities() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:PetAbilityDisplay = null;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc3_ = new PetAbilityDisplay(this.petVO.abilityList[_loc1_],171);
            _loc3_.x = 3;
            _loc3_.y = 72 + 17 * _loc1_;
            this.petsContent.addChild(_loc3_);
            _loc1_++;
         }
      }
      
      private function getNumAbilities() : uint
      {
         var _loc1_:Boolean = this.petVO.getRarity() == PetRarityEnum.DIVINE.value || this.petVO.getRarity() == PetRarityEnum.LEGENDARY.value;
         if(_loc1_)
         {
            return 2;
         }
         return 3;
      }
      
      private function updateTextFields() : void
      {
         this.tabTitleTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.getName()));
         this.petRarityTextField.setStringBuilder(new LineBuilder().setParams(this.petVO.getRarity()));
         this.petFamilyTextField.setStringBuilder(new LineBuilder().setParams(PetFamilyKeys.getTranslationKey(this.petVO.getFamily())));
      }
      
      private function addChildren() : void
      {
         this.petsContent.addChild(this.petBitmap);
         this.petsContent.addChild(this.tabTitleTextField);
         this.petsContent.addChild(this.petRarityTextField);
         this.petsContent.addChild(this.petFamilyTextField);
         addChild(this.petsContent);
      }
      
      private function positionChildren() : void
      {
         this.petBitmap.x -= 8;
         --this.petBitmap.y;
         this.petsContent.x = 7;
         this.petsContent.y = 6;
         this.tabTitleTextField.x = 45;
         this.tabTitleTextField.y = 20;
         this.petRarityTextField.x = 45;
         this.petRarityTextField.y = 33;
         this.petFamilyTextField.x = 45;
         this.petFamilyTextField.y = 47;
      }
   }
}

