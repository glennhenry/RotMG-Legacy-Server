package com.company.assembleegameclient.engine3d
{
   import flash.geom.Vector3D;
   
   public class Lighting3D
   {
      
      public static const LIGHT_VECTOR:Vector3D = createLightVector();
      
      public function Lighting3D()
      {
         super();
      }
      
      public static function shadeValue(param1:Vector3D, param2:Number) : Number
      {
         var _loc3_:Number = Math.max(0,param1.dotProduct(Lighting3D.LIGHT_VECTOR));
         return param2 + (1 - param2) * _loc3_;
      }
      
      private static function createLightVector() : Vector3D
      {
         var _loc1_:Vector3D = new Vector3D(1,3,2);
         _loc1_.normalize();
         return _loc1_;
      }
   }
}

