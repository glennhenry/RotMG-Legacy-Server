package kabam.rotmg.servers.api
{
   public final class LatLong
   {
      
      private static const TO_DEGREES:Number = 180 / Math.PI;
      
      private static const TO_RADIANS:Number = Math.PI / 180;
      
      private static const DISTANCE_SCALAR:Number = 60 * 1.1515 * 1.609344 * 1000;
      
      public var latitude:Number;
      
      public var longitude:Number;
      
      public function LatLong(param1:Number, param2:Number)
      {
         super();
         this.latitude = param1;
         this.longitude = param2;
      }
      
      public static function distance(param1:LatLong, param2:LatLong) : Number
      {
         var _loc3_:Number = TO_RADIANS * (param1.longitude - param2.longitude);
         var _loc4_:Number = TO_RADIANS * param1.latitude;
         var _loc5_:Number = TO_RADIANS * param2.latitude;
         var _loc6_:Number = Math.sin(_loc4_) * Math.sin(_loc5_) + Math.cos(_loc4_) * Math.cos(_loc5_) * Math.cos(_loc3_);
         return TO_DEGREES * Math.acos(_loc6_) * DISTANCE_SCALAR;
      }
      
      public function toString() : String
      {
         return "(" + this.latitude + ", " + this.longitude + ")";
      }
   }
}

