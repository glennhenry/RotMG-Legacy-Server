package kabam.lib.util
{
   public class VectorAS3Util
   {
      
      public function VectorAS3Util()
      {
         super();
      }
      
      public static function toArray(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
   }
}

