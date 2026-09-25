package com.company.assembleegameclient.objects.particles
{
   public class HitEffect extends ParticleEffect
   {
      
      public var colors_:Vector.<uint>;
      
      public var numParts_:int;
      
      public var angle_:Number;
      
      public var speed_:Number;
      
      public function HitEffect(param1:Vector.<uint>, param2:int, param3:int, param4:Number, param5:Number)
      {
         super();
         this.colors_ = param1;
         size_ = param2;
         this.numParts_ = param3;
         this.angle_ = param4;
         this.speed_ = param5;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         var _loc6_:uint = 0;
         var _loc7_:Particle = null;
         if(this.colors_.length == 0)
         {
            return false;
         }
         var _loc3_:Number = this.speed_ / 600 * Math.cos(this.angle_ + Math.PI);
         var _loc4_:Number = this.speed_ / 600 * Math.sin(this.angle_ + Math.PI);
         var _loc5_:int = 0;
         while(_loc5_ < this.numParts_)
         {
            _loc6_ = this.colors_[int(this.colors_.length * Math.random())];
            _loc7_ = new HitParticle(_loc6_,0.5,size_,200 + Math.random() * 100,_loc3_ + (Math.random() - 0.5) * 0.4,_loc4_ + (Math.random() - 0.5) * 0.4,0);
            map_.addObj(_loc7_,x_,y_);
            _loc5_++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         var _loc6_:uint = 0;
         var _loc7_:Particle = null;
         if(this.colors_.length == 0)
         {
            return false;
         }
         var _loc3_:Number = this.speed_ / 600 * Math.cos(this.angle_ + Math.PI);
         var _loc4_:Number = this.speed_ / 600 * Math.sin(this.angle_ + Math.PI);
         this.numParts_ *= 0.2;
         var _loc5_:int = 0;
         while(_loc5_ < this.numParts_)
         {
            _loc6_ = this.colors_[int(this.colors_.length * Math.random())];
            _loc7_ = new HitParticle(_loc6_,0.5,10,5 + Math.random() * 100,_loc3_ + (Math.random() - 0.5) * 0.4,_loc4_ + (Math.random() - 0.5) * 0.4,0);
            map_.addObj(_loc7_,x_,y_);
            _loc5_++;
         }
         return false;
      }
   }
}

import flash.geom.Vector3D;

class HitParticle extends Particle
{
   
   public var lifetime_:int;
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D = new Vector3D();
   
   public function HitParticle(param1:uint, param2:Number, param3:int, param4:int, param5:Number, param6:Number, param7:Number)
   {
      super(param1,param2,param3);
      this.timeLeft_ = this.lifetime_ = param4;
      this.moveVec_.x = param5;
      this.moveVec_.y = param6;
      this.moveVec_.z = param7;
   }
   
   override public function update(param1:int, param2:int) : Boolean
   {
      this.timeLeft_ -= param2;
      if(this.timeLeft_ <= 0)
      {
         return false;
      }
      x_ += this.moveVec_.x * param2 * 0.008;
      y_ += this.moveVec_.y * param2 * 0.008;
      z_ += this.moveVec_.z * param2 * 0.008;
      return true;
   }
}
