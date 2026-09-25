package kabam.rotmg.pets.data
{
   public class FusionCalculator
   {
      
      private static var ranges:Object = makeRanges();
      
      public function FusionCalculator()
      {
         super();
      }
      
      private static function makeRanges() : Object
      {
         ranges = {};
         ranges[PetRarityEnum.COMMON.value] = 30;
         ranges[PetRarityEnum.UNCOMMON.value] = 20;
         ranges[PetRarityEnum.RARE.value] = 20;
         ranges[PetRarityEnum.LEGENDARY.value] = 20;
         return ranges;
      }
      
      public static function getStrengthPercentage(param1:PetVO, param2:PetVO) : Number
      {
         var _loc3_:Number = getRarityPointsPercentage(param1);
         var _loc4_:Number = getRarityPointsPercentage(param2);
         return average(_loc3_,_loc4_);
      }
      
      private static function average(param1:Number, param2:Number) : Number
      {
         return (param1 + param2) / 2;
      }
      
      private static function getRarityPointsPercentage(param1:PetVO) : Number
      {
         var _loc2_:int = int(ranges[param1.getRarity()]);
         var _loc3_:int = param1.getMaxAbilityPower() - _loc2_;
         var _loc4_:int = param1.abilityList[0].level - _loc3_;
         return _loc4_ / _loc2_;
      }
   }
}

