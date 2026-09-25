package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.geom.Vector3D;
   
   public class HealParticle extends Particle
   {
      
      public var timeLeft_:int;
      
      public var go_:GameObject;
      
      public var angle_:Number;
      
      public var dist_:Number;
      
      protected var moveVec_:Vector3D = new Vector3D();
      
      public function HealParticle(param1:uint, param2:Number, param3:int, param4:int, param5:Number, param6:GameObject, param7:Number, param8:Number)
      {
         super(param1,param2,param3);
         this.moveVec_.z = param5;
         this.timeLeft_ = param4;
         this.go_ = param6;
         this.angle_ = param7;
         this.dist_ = param8;
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         this.timeLeft_ -= param2;
         if(this.timeLeft_ <= 0)
         {
            return false;
         }
         x_ = this.go_.x_ + this.dist_ * Math.cos(this.angle_);
         y_ = this.go_.y_ + this.dist_ * Math.sin(this.angle_);
         z_ += this.moveVec_.z * param2 * 0.008;
         return true;
      }
   }
}

