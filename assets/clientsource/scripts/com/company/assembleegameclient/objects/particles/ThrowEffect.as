package com.company.assembleegameclient.objects.particles
{
   import flash.geom.Point;
   
   public class ThrowEffect extends ParticleEffect
   {
      
      public var start_:Point;
      
      public var end_:Point;
      
      public var color_:int;
      
      public function ThrowEffect(param1:Point, param2:Point, param3:int)
      {
         super();
         this.start_ = param1;
         this.end_ = param2;
         this.color_ = param3;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _loc4_:ThrowParticle = new ThrowParticle(200,this.color_,1500,this.start_,this.end_);
         map_.addObj(_loc4_,x_,y_);
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _loc4_:ThrowParticle = new ThrowParticle(10,this.color_,1500,this.start_,this.end_);
         map_.addObj(_loc4_,x_,y_);
         return false;
      }
   }
}

import com.company.assembleegameclient.util.RandomUtil;
import flash.geom.Point;

class ThrowParticle extends Particle
{
   
   public var lifetime_:int;
   
   public var timeLeft_:int;
   
   public var initialSize_:int;
   
   public var start_:Point;
   
   public var end_:Point;
   
   public var dx_:Number;
   
   public var dy_:Number;
   
   public var pathX_:Number;
   
   public var pathY_:Number;
   
   public function ThrowParticle(param1:int, param2:int, param3:int, param4:Point, param5:Point)
   {
      super(param2,0,param1);
      this.lifetime_ = this.timeLeft_ = param3;
      this.initialSize_ = param1;
      this.start_ = param4;
      this.end_ = param5;
      this.dx_ = (this.end_.x - this.start_.x) / this.timeLeft_;
      this.dy_ = (this.end_.y - this.start_.y) / this.timeLeft_;
      var _loc6_:Number = Point.distance(param4,param5) / this.timeLeft_;
      this.pathX_ = x_ = this.start_.x;
      this.pathY_ = y_ = this.start_.y;
   }
   
   override public function update(param1:int, param2:int) : Boolean
   {
      this.timeLeft_ -= param2;
      if(this.timeLeft_ <= 0)
      {
         return false;
      }
      z_ = Math.sin(this.timeLeft_ / this.lifetime_ * Math.PI) * 2;
      setSize(0);
      this.pathX_ += this.dx_ * param2;
      this.pathY_ += this.dy_ * param2;
      moveTo(this.pathX_,this.pathY_);
      map_.addObj(new SparkParticle(100 * (z_ + 1),color_,400,z_,RandomUtil.plusMinus(1),RandomUtil.plusMinus(1)),this.pathX_,this.pathY_);
      return true;
   }
}
