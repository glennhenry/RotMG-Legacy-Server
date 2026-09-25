package kabam.rotmg.messaging.impl
{
   import com.company.assembleegameclient.game.AGameSprite;
   import com.company.assembleegameclient.objects.Pet;
   import com.company.assembleegameclient.util.ConditionEffect;
   import kabam.rotmg.messaging.impl.data.StatData;
   import kabam.rotmg.pets.data.AbilityVO;
   import kabam.rotmg.pets.data.PetVO;
   import kabam.rotmg.pets.data.PetsModel;
   
   public class PetUpdater
   {
      
      [Inject]
      public var petsModel:PetsModel;
      
      [Inject]
      public var gameSprite:AGameSprite;
      
      public function PetUpdater()
      {
         super();
      }
      
      public function updatePetVOs(param1:Pet, param2:Vector.<StatData>) : void
      {
         var _loc4_:StatData = null;
         var _loc5_:AbilityVO = null;
         var _loc6_:* = undefined;
         var _loc3_:PetVO = param1.vo || this.createPetVO(param1,param2);
         if(_loc3_ == null)
         {
            return;
         }
         for each(_loc4_ in param2)
         {
            _loc6_ = _loc4_.statValue_;
            if(_loc4_.statType_ == StatData.TEXTURE_STAT)
            {
               _loc3_.setSkin(_loc6_);
            }
            switch(_loc4_.statType_)
            {
               case StatData.PET_INSTANCEID_STAT:
                  _loc3_.setID(_loc6_);
                  break;
               case StatData.PET_NAME_STAT:
                  _loc3_.setName(_loc4_.strStatValue_);
                  break;
               case StatData.PET_TYPE_STAT:
                  _loc3_.setType(_loc6_);
                  break;
               case StatData.PET_RARITY_STAT:
                  _loc3_.setRarity(_loc6_);
                  break;
               case StatData.PET_MAXABILITYPOWER_STAT:
                  _loc3_.setMaxAbilityPower(_loc6_);
                  break;
               case StatData.PET_FIRSTABILITY_POINT_STAT:
                  _loc5_ = _loc3_.abilityList[0];
                  _loc5_.points = _loc6_;
                  break;
               case StatData.PET_SECONDABILITY_POINT_STAT:
                  _loc5_ = _loc3_.abilityList[1];
                  _loc5_.points = _loc6_;
                  break;
               case StatData.PET_THIRDABILITY_POINT_STAT:
                  _loc5_ = _loc3_.abilityList[2];
                  _loc5_.points = _loc6_;
                  break;
               case StatData.PET_FIRSTABILITY_POWER_STAT:
                  _loc5_ = _loc3_.abilityList[0];
                  _loc5_.level = _loc6_;
                  break;
               case StatData.PET_SECONDABILITY_POWER_STAT:
                  _loc5_ = _loc3_.abilityList[1];
                  _loc5_.level = _loc6_;
                  break;
               case StatData.PET_THIRDABILITY_POWER_STAT:
                  _loc5_ = _loc3_.abilityList[2];
                  _loc5_.level = _loc6_;
                  break;
               case StatData.PET_FIRSTABILITY_TYPE_STAT:
                  _loc5_ = _loc3_.abilityList[0];
                  _loc5_.type = _loc6_;
                  break;
               case StatData.PET_SECONDABILITY_TYPE_STAT:
                  _loc5_ = _loc3_.abilityList[1];
                  _loc5_.type = _loc6_;
                  break;
               case StatData.PET_THIRDABILITY_TYPE_STAT:
                  _loc5_ = _loc3_.abilityList[2];
                  _loc5_.type = _loc6_;
            }
            if(_loc5_)
            {
               _loc5_.updated.dispatch(_loc5_);
            }
         }
      }
      
      private function createPetVO(param1:Pet, param2:Vector.<StatData>) : PetVO
      {
         var _loc3_:StatData = null;
         var _loc4_:PetVO = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.statType_ == StatData.PET_INSTANCEID_STAT)
            {
               _loc4_ = this.petsModel.getCachedVOOnly(_loc3_.statValue_);
               param1.vo = _loc4_ ? _loc4_ : (this.gameSprite.map.isPetYard ? this.petsModel.getPetVO(_loc3_.statValue_) : new PetVO(_loc3_.statValue_));
               return param1.vo;
            }
         }
         return null;
      }
      
      public function updatePet(param1:Pet, param2:Vector.<StatData>) : void
      {
         var _loc3_:StatData = null;
         var _loc4_:* = undefined;
         for each(_loc3_ in param2)
         {
            _loc4_ = _loc3_.statValue_;
            if(_loc3_.statType_ == StatData.TEXTURE_STAT)
            {
               param1.setSkin(_loc4_);
            }
            if(_loc3_.statType_ == StatData.SIZE_STAT)
            {
               param1.size_ = _loc4_;
            }
            if(_loc3_.statType_ == StatData.CONDITION_STAT)
            {
               param1.condition_[ConditionEffect.CE_FIRST_BATCH] = _loc4_;
            }
         }
      }
   }
}

