package kabam.rotmg.pets.util
{
   import flash.utils.Dictionary;
   import kabam.rotmg.pets.data.PetRarityEnum;
   
   public class FeedFuseCostModel
   {
      
      private static const feedCosts:Dictionary = makeFeedDictionary();
      
      private static const fuseCosts:Dictionary = makeFuseDictionary();
      
      public function FeedFuseCostModel()
      {
         super();
      }
      
      private static function makeFuseDictionary() : Dictionary
      {
         var _loc1_:Dictionary = new Dictionary();
         _loc1_[PetRarityEnum.COMMON] = {
            "gold":100,
            "fame":300
         };
         _loc1_[PetRarityEnum.UNCOMMON] = {
            "gold":240,
            "fame":1000
         };
         _loc1_[PetRarityEnum.RARE] = {
            "gold":600,
            "fame":4000
         };
         _loc1_[PetRarityEnum.LEGENDARY] = {
            "gold":1800,
            "fame":15000
         };
         return _loc1_;
      }
      
      private static function makeFeedDictionary() : Dictionary
      {
         var _loc1_:Dictionary = new Dictionary();
         _loc1_[PetRarityEnum.COMMON] = {
            "gold":5,
            "fame":10
         };
         _loc1_[PetRarityEnum.UNCOMMON] = {
            "gold":12,
            "fame":30
         };
         _loc1_[PetRarityEnum.RARE] = {
            "gold":30,
            "fame":100
         };
         _loc1_[PetRarityEnum.LEGENDARY] = {
            "gold":60,
            "fame":350
         };
         _loc1_[PetRarityEnum.DIVINE] = {
            "gold":150,
            "fame":1000
         };
         return _loc1_;
      }
      
      public static function getFuseGoldCost(param1:PetRarityEnum) : int
      {
         return fuseCosts[param1] ? int(fuseCosts[param1].gold) : 0;
      }
      
      public static function getFuseFameCost(param1:PetRarityEnum) : int
      {
         return fuseCosts[param1] ? int(fuseCosts[param1].fame) : 0;
      }
      
      public static function getFeedGoldCost(param1:PetRarityEnum) : int
      {
         return feedCosts[param1].gold;
      }
      
      public static function getFeedFameCost(param1:PetRarityEnum) : int
      {
         return feedCosts[param1].fame;
      }
   }
}

