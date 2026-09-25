package kabam.rotmg.pets.data
{
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
   import flash.utils.Dictionary;
   import kabam.rotmg.messaging.impl.data.SlotObjectData;
   import kabam.rotmg.text.model.TextKey;
   
   public class PetFormModel
   {
      
      private var Data:Class = PetFormModel_Data;
      
      private var petsXML:XML = XML(new this.Data());
      
      private var branches:Dictionary;
      
      private var selectedPet:PetVO;
      
      private var selectedSkin:int;
      
      public var slotObjectData:SlotObjectData;
      
      public function PetFormModel()
      {
         super();
      }
      
      public function get petSkinGroupVOs() : Array
      {
         var _loc1_:Array = [];
         _loc1_[0] = new PetSkinGroupVO(TextKey.PET_RARITY_COMMON,this.getIconGroup("Common"),PetRarityEnum.COMMON,this.selectedPet.getSkinID());
         _loc1_[1] = new PetSkinGroupVO(TextKey.PET_RARITY_RARE,this.getIconGroup("Rare"),PetRarityEnum.RARE,this.selectedPet.getSkinID());
         _loc1_[2] = new PetSkinGroupVO(TextKey.PET_RARITY_DIVINE,this.getIconGroup("Divine"),PetRarityEnum.DIVINE,this.selectedPet.getSkinID());
         return _loc1_;
      }
      
      public function createPetFamilyTree() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:XML = null;
         var _loc2_:uint = uint(this.petsXML.Object.length());
         this.branches = new Dictionary();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.petsXML.Object[_loc1_];
            if(this.petIsInFamilyTree(_loc3_))
            {
               this.addPetToAppropriateRarityList(_loc3_);
            }
            _loc1_++;
         }
      }
      
      private function addPetToAppropriateRarityList(param1:XML) : void
      {
         var _loc2_:String = XMLList(param1.Rarity).valueOf();
         var _loc3_:PetVO = this.convertXMLToPetVOForReskin(param1);
         if(this.branches[_loc2_])
         {
            this.branches[_loc2_].push(_loc3_);
         }
         else
         {
            this.branches[_loc2_] = [_loc3_];
         }
      }
      
      public function setSelectedPet(param1:PetVO) : void
      {
         this.selectedPet = param1;
      }
      
      private function convertXMLToPetVOForReskin(param1:XML) : PetVO
      {
         var _loc2_:PetVO = new PetVO();
         _loc2_.setType(param1.@type);
         _loc2_.setID(param1.@id);
         _loc2_.setSkin(this.fetchSkinTypeByID(param1.DefaultSkin[0]));
         return _loc2_;
      }
      
      private function fetchSkinTypeByID(param1:String) : int
      {
         var _loc2_:uint = 0;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc3_:uint = uint(this.petsXML.Object.length());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.petsXML.Object[_loc2_];
            _loc5_ = _loc4_.@id;
            if(this.petNodeIsSkin(_loc4_))
            {
               if(_loc5_ == param1)
               {
                  return int(_loc4_.@type);
               }
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function petIsInFamilyTree(param1:XML) : Boolean
      {
         return param1.hasOwnProperty("Pet") && param1.Family == this.selectedPet.getFamily();
      }
      
      private function petNodeIsSkin(param1:XML) : Boolean
      {
         return param1.hasOwnProperty("PetSkin");
      }
      
      public function getSelectedPet() : PetVO
      {
         return this.selectedPet;
      }
      
      public function getIconGroup(param1:String) : Array
      {
         return this.branches[param1];
      }
      
      public function setSlotObject(param1:InteractiveItemTile) : void
      {
         this.slotObjectData = new SlotObjectData();
         this.slotObjectData.objectId_ = param1.ownerGrid.owner.objectId_;
         this.slotObjectData.objectType_ = param1.getItemId();
         this.slotObjectData.slotId_ = param1.tileId;
      }
      
      public function getSelectedSkin() : int
      {
         return this.selectedSkin;
      }
      
      public function setSelectedSkin(param1:int) : void
      {
         this.selectedSkin = param1;
      }
      
      public function getpetTypeFromSkinID(param1:int) : int
      {
         var _loc2_:uint = 0;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc3_:uint = uint(this.petsXML.Object.length());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.petsXML.Object[_loc2_];
            _loc5_ = int(_loc4_.@type);
            if(_loc5_ == param1)
            {
               return this.fetchPetTypeBySkinID(_loc4_.@id);
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function fetchPetTypeBySkinID(param1:String) : int
      {
         var _loc2_:uint = 0;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc3_:uint = uint(this.petsXML.Object.length());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.petsXML.Object[_loc2_];
            _loc5_ = _loc4_.DefaultSkin;
            if(_loc5_ == param1)
            {
               return _loc4_.@type;
            }
            _loc2_++;
         }
         return -1;
      }
   }
}

