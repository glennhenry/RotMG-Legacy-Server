package kabam.rotmg.pets.data
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.map.AbstractMap;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.pets.controller.NotifyActivePetUpdated;
   
   public class PetsModel
   {
      
      [Inject]
      public var notifyActivePetUpdated:NotifyActivePetUpdated;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      private var hash:Object = {};
      
      private var pets:Vector.<PetVO> = new Vector.<PetVO>();
      
      private var yardXmlData:XML;
      
      private var type:int;
      
      private var activePet:PetVO;
      
      public function PetsModel()
      {
         super();
      }
      
      public function getPetVO(param1:int) : PetVO
      {
         var _loc2_:PetVO = null;
         if(this.hash[param1] != null)
         {
            return this.hash[param1];
         }
         _loc2_ = new PetVO(param1);
         this.pets.push(_loc2_);
         this.hash[param1] = _loc2_;
         return _loc2_;
      }
      
      public function getCachedVOOnly(param1:int) : PetVO
      {
         return this.hash[param1];
      }
      
      public function getAllPets() : Vector.<PetVO>
      {
         return this.pets;
      }
      
      public function addPet(param1:PetVO) : void
      {
         this.pets.push(param1);
      }
      
      public function setActivePet(param1:PetVO) : void
      {
         this.activePet = param1;
         var _loc2_:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
         if(_loc2_)
         {
            _loc2_.setPetVO(this.activePet);
         }
         this.notifyActivePetUpdated.dispatch();
      }
      
      public function getActivePet() : PetVO
      {
         return this.activePet;
      }
      
      public function removeActivePet() : void
      {
         var _loc1_:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
         if(_loc1_)
         {
            _loc1_.setPetVO(null);
         }
         this.activePet = null;
         this.notifyActivePetUpdated.dispatch();
      }
      
      public function getPet(param1:int) : PetVO
      {
         var _loc2_:int = this.getPetIndex(param1);
         if(_loc2_ == -1)
         {
            return null;
         }
         return this.pets[_loc2_];
      }
      
      private function getPetIndex(param1:int) : int
      {
         var _loc2_:PetVO = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this.pets.length)
         {
            _loc2_ = this.pets[_loc3_];
            if(_loc2_.getID() == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function setPetYardType(param1:int) : void
      {
         this.type = param1;
         this.yardXmlData = ObjectLibrary.getXMLfromId(ObjectLibrary.getIdFromType(param1));
      }
      
      public function getPetYardRarity() : uint
      {
         return PetYardEnum.selectByValue(this.yardXmlData.@id).rarity.ordinal;
      }
      
      public function getPetYardType() : int
      {
         return this.yardXmlData ? PetYardEnum.selectByValue(this.yardXmlData.@id).ordinal : 1;
      }
      
      public function isMapNameYardName(param1:AbstractMap) : Boolean
      {
         return Boolean(param1.name_) && param1.name_.substr(0,8) == "Pet Yard";
      }
      
      public function getPetYardUpgradeFamePrice() : int
      {
         return int(this.yardXmlData.Fame);
      }
      
      public function getPetYardUpgradeGoldPrice() : int
      {
         return int(this.yardXmlData.Price);
      }
      
      public function getPetYardObjectID() : int
      {
         return this.type;
      }
      
      public function deletePet(param1:int) : void
      {
         this.pets.splice(this.getPetIndex(param1),1);
      }
      
      public function clearPets() : void
      {
         this.hash = {};
         this.pets = new Vector.<PetVO>();
         this.removeActivePet();
      }
   }
}

