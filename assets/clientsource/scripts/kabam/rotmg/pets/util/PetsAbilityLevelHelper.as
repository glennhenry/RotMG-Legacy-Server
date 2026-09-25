package kabam.rotmg.pets.util
{
   import kabam.rotmg.util.GeometricSeries;
   
   public class PetsAbilityLevelHelper
   {
      
      private static const levelToPoints:GeometricSeries = new GeometricSeries(20,1.08);
      
      public function PetsAbilityLevelHelper()
      {
         super();
      }
      
      public static function getTotalAbilityPointsForLevel(param1:int) : Number
      {
         return levelToPoints.getSummation(param1);
      }
      
      public static function getCurrentPointsForLevel(param1:int, param2:int) : Number
      {
         var _loc3_:Number = getTotalAbilityPointsForLevel(param2 - 1);
         return param1 - _loc3_;
      }
      
      public static function getAbilityPointsforLevel(param1:int) : Number
      {
         return levelToPoints.getTerm(param1 - 1);
      }
   }
}

