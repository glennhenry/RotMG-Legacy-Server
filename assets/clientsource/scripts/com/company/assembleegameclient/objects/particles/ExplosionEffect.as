package com.company.assembleegameclient.objects.particles
{
   public class ExplosionEffect extends ParticleEffect
   {
      
      public var colors_:Vector.<uint>;
      
      public var numParts_:int;
      
      public function ExplosionEffect(param1:Vector.<uint>, param2:int, param3:int)
      {
         super();
         this.colors_ = param1;
         size_ = param2;
         if(ExplosionParticle.total_ >= 250)
         {
            this.numParts_ = 2;
         }
         else if(ExplosionParticle.total_ >= 150)
         {
            this.numParts_ = 4;
         }
         else if(ExplosionParticle.total_ >= 90)
         {
            this.numParts_ = 12;
         }
         else
         {
            this.numParts_ = param3;
         }
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:Particle = null;
         if(this.colors_.length == 0)
         {
            return false;
         }
         if(ExplosionParticle.total_ > 400)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.numParts_)
         {
            _loc4_ = this.colors_[int(this.colors_.length * Math.random())];
            _loc5_ = new ExplosionParticle(_loc4_,0.5,size_,200 + Math.random() * 100,Math.random() - 0.5,Math.random() - 0.5,0);
            map_.addObj(_loc5_,x_,y_);
            _loc3_++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:Particle = null;
         if(this.colors_.length == 0)
         {
            return false;
         }
         if(ExplosionParticle.total_ > 400)
         {
            return false;
         }
         this.numParts_ = 2;
         var _loc3_:int = 0;
         while(_loc3_ < this.numParts_)
         {
            _loc4_ = this.colors_[int(this.colors_.length * Math.random())];
            _loc5_ = new ExplosionParticle(_loc4_,0.5,size_,50 + Math.random() * 100,Math.random() - 0.5,Math.random() - 0.5,0);
            map_.addObj(_loc5_,x_,y_);
            _loc3_++;
         }
         return false;
      }
   }
}

import flash.geom.Vector3D;

class ExplosionParticle extends Particle
{
   
   public static var total_:int = 0;
   
   public var lifetime_:int;
   
   public var timeLeft_:int;
   
   protected var moveVec_:Vector3D = new Vector3D();
   
   private var deleted:Boolean = false;
   
   public function ExplosionParticle(param1:uint, param2:Number, param3:int, param4:int, param5:Number, param6:Number, param7:Number)
   {
      super(param1,param2,param3);
      this.timeLeft_ = this.lifetime_ = param4;
      this.moveVec_.x = param5;
      this.moveVec_.y = param6;
      this.moveVec_.z = param7;
      ++total_;
   }
   
   override public function update(param1:int, param2:int) : Boolean
   {
      this.timeLeft_ -= param2;
      if(this.timeLeft_ <= 0)
      {
         if(!this.deleted)
         {
            --total_;
            this.deleted = true;
         }
         return false;
      }
      x_ += this.moveVec_.x * param2 * 0.008;
      y_ += this.moveVec_.y * param2 * 0.008;
      z_ += this.moveVec_.z * param2 * 0.008;
      return true;
   }
}
