package com.company.assembleegameclient.engine3d
{
   import flash.geom.Vector3D;
   
   public class Plane3D
   {
      
      public static const NONE:int = 0;
      
      public static const POSITIVE:int = 1;
      
      public static const NEGATIVE:int = 2;
      
      public static const EQUAL:int = 3;
      
      public var normal_:Vector3D;
      
      public var d_:Number;
      
      public function Plane3D(param1:Vector3D = null, param2:Vector3D = null, param3:Vector3D = null)
      {
         super();
         if(param1 != null && param2 != null && param3 != null)
         {
            this.normal_ = new Vector3D();
            computeNormal(param1,param2,param3,this.normal_);
            this.d_ = -this.normal_.dotProduct(param1);
         }
      }
      
      public static function computeNormal(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D) : void
      {
         var _loc5_:Number = param2.x - param1.x;
         var _loc6_:Number = param2.y - param1.y;
         var _loc7_:Number = param2.z - param1.z;
         var _loc8_:Number = param3.x - param1.x;
         var _loc9_:Number = param3.y - param1.y;
         var _loc10_:Number = param3.z - param1.z;
         param4.x = _loc6_ * _loc10_ - _loc7_ * _loc9_;
         param4.y = _loc7_ * _loc8_ - _loc5_ * _loc10_;
         param4.z = _loc5_ * _loc9_ - _loc6_ * _loc8_;
         param4.normalize();
      }
      
      public static function computeNormalVec(param1:Vector.<Number>, param2:Vector3D) : void
      {
         var _loc3_:Number = param1[3] - param1[0];
         var _loc4_:Number = param1[4] - param1[1];
         var _loc5_:Number = param1[5] - param1[2];
         var _loc6_:Number = param1[6] - param1[0];
         var _loc7_:Number = param1[7] - param1[1];
         var _loc8_:Number = param1[8] - param1[2];
         param2.x = _loc4_ * _loc8_ - _loc5_ * _loc7_;
         param2.y = _loc5_ * _loc6_ - _loc3_ * _loc8_;
         param2.z = _loc3_ * _loc7_ - _loc4_ * _loc6_;
         param2.normalize();
      }
      
      public function testPoint(param1:Vector3D) : int
      {
         var _loc2_:Number = this.normal_.dotProduct(param1) + this.d_;
         if(_loc2_ > 0.001)
         {
            return POSITIVE;
         }
         if(_loc2_ < -0.001)
         {
            return NEGATIVE;
         }
         return EQUAL;
      }
      
      public function lineIntersect(param1:Line3D) : Number
      {
         var _loc2_:Number = -this.d_ - this.normal_.x * param1.v0_.x - this.normal_.y * param1.v0_.y - this.normal_.z * param1.v0_.z;
         var _loc3_:Number = this.normal_.x * (param1.v1_.x - param1.v0_.x) + this.normal_.y * (param1.v1_.y - param1.v0_.y) + this.normal_.z * (param1.v1_.z - param1.v0_.z);
         if(_loc3_ == 0)
         {
            return NaN;
         }
         return _loc2_ / _loc3_;
      }
      
      public function zAtXY(param1:Number, param2:Number) : Number
      {
         return -(this.d_ + this.normal_.x * param1 + this.normal_.y * param2) / this.normal_.z;
      }
      
      public function toString() : String
      {
         return "Plane(n = " + this.normal_ + ", d = " + this.d_ + ")";
      }
   }
}

