package kabam.rotmg.pets.data
{
   public class PetRarityEnum
   {
      
      public static const COMMON:PetRarityEnum = new PetRarityEnum("Pets.common",0);
      
      public static const UNCOMMON:PetRarityEnum = new PetRarityEnum("Pets.uncommon",1);
      
      public static const RARE:PetRarityEnum = new PetRarityEnum("Pets.rare",2);
      
      public static const LEGENDARY:PetRarityEnum = new PetRarityEnum("Pets.legendary",3);
      
      public static const DIVINE:PetRarityEnum = new PetRarityEnum("Pets.divine",4);
      
      public static const MAX_ORDINAL:int = 4;
      
      public var value:String;
      
      public var ordinal:int;
      
      public function PetRarityEnum(param1:*, param2:int)
      {
         super();
         this.value = param1;
         this.ordinal = param2;
      }
      
      public static function get list() : Array
      {
         return [COMMON,UNCOMMON,RARE,LEGENDARY,DIVINE];
      }
      
      public static function selectByValue(param1:String) : PetRarityEnum
      {
         var _loc2_:PetRarityEnum = null;
         var _loc3_:PetRarityEnum = null;
         for each(_loc3_ in PetRarityEnum.list)
         {
            if(param1 == _loc3_.value)
            {
               _loc2_ = _loc3_;
            }
         }
         return _loc2_;
      }
      
      public static function selectByOrdinal(param1:int) : PetRarityEnum
      {
         var _loc2_:PetRarityEnum = null;
         var _loc3_:PetRarityEnum = null;
         for each(_loc3_ in PetRarityEnum.list)
         {
            if(param1 == _loc3_.ordinal)
            {
               _loc2_ = _loc3_;
            }
         }
         return _loc2_;
      }
   }
}

