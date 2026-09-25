package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.FreeList;
   
   public class VentEffect extends ParticleEffect
   {
      
      private static const BUBBLE_PERIOD:int = 50;
      
      public var go_:GameObject;
      
      public var lastUpdate_:int = -1;
      
      public function VentEffect(param1:GameObject)
      {
         super();
         this.go_ = param1;
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:VentParticle = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(this.go_.map_ == null)
         {
            return false;
         }
         if(this.lastUpdate_ < 0)
         {
            this.lastUpdate_ = Math.max(0,param1 - 400);
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var _loc3_:int = int(this.lastUpdate_ / BUBBLE_PERIOD);
         while(_loc3_ < int(param1 / BUBBLE_PERIOD))
         {
            _loc4_ = _loc3_ * BUBBLE_PERIOD;
            _loc5_ = FreeList.newObject(VentParticle) as VentParticle;
            _loc5_.restart(_loc4_,param1);
            _loc6_ = Math.random() * Math.PI;
            _loc7_ = Math.random() * 0.4;
            _loc8_ = this.go_.x_ + _loc7_ * Math.cos(_loc6_);
            _loc9_ = this.go_.y_ + _loc7_ * Math.sin(_loc6_);
            map_.addObj(_loc5_,_loc8_,_loc9_);
            _loc3_++;
         }
         this.lastUpdate_ = param1;
         return true;
      }
   }
}

import com.company.assembleegameclient.util.FreeList;

class VentParticle extends Particle
{
   
   public var startTime_:int;
   
   public var speed_:int;
   
   public function VentParticle()
   {
      var _loc1_:Number = Math.random();
      super(2542335,0,75 + _loc1_ * 50);
      this.speed_ = 2.5 - _loc1_ * 1.5;
   }
   
   public function restart(param1:int, param2:int) : void
   {
      this.startTime_ = param1;
      var _loc3_:Number = (param2 - this.startTime_) / 1000;
      z_ = 0 + this.speed_ * _loc3_;
   }
   
   override public function removeFromMap() : void
   {
      super.removeFromMap();
      FreeList.deleteObject(this);
   }
   
   override public function update(param1:int, param2:int) : Boolean
   {
      var _loc3_:Number = (param1 - this.startTime_) / 1000;
      z_ = 0 + this.speed_ * _loc3_;
      return z_ < 1;
   }
}
