package kabam.rotmg.pets.data
{
   public class PetSkinGroupVO
   {
      
      public var textKey:String;
      
      public var icons:Array;
      
      public var petRarityEnum:PetRarityEnum;
      
      public var selectedPetSkinID:int;
      
      public function PetSkinGroupVO(param1:String, param2:Array, param3:PetRarityEnum, param4:int)
      {
         super();
         this.textKey = param1;
         this.icons = param2;
         this.petRarityEnum = param3;
         this.selectedPetSkinID = param4;
      }
   }
}

