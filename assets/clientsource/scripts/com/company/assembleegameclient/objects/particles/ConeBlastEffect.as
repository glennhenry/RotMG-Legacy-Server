package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class ConeBlastEffect extends ParticleEffect
   {
      
      public var start_:Point;
      
      public var target_:WorldPosData;
      
      public var blastRadius_:Number;
      
      public var color_:int;
      
      public function ConeBlastEffect(param1:GameObject, param2:WorldPosData, param3:Number, param4:int)
      {
         super();
         this.start_ = new Point(param1.x_,param1.y_);
         this.target_ = param2;
         this.blastRadius_ = param3;
         this.color_ = param4;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc11_:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _loc5_:Number = Math.PI / 3;
         var _loc7_:Number = Math.atan2(this.target_.y_ - this.start_.y,this.target_.x_ - this.start_.x);
         var _loc8_:int = 0;
         while(_loc8_ < 7)
         {
            _loc9_ = _loc7_ - _loc5_ / 2 + _loc8_ * _loc5_ / 7;
            _loc10_ = new Point(this.start_.x + this.blastRadius_ * Math.cos(_loc9_),this.start_.y + this.blastRadius_ * Math.sin(_loc9_));
            _loc11_ = new SparkerParticle(200,this.color_,100,this.start_,_loc10_);
            map_.addObj(_loc11_,x_,y_);
            _loc8_++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc11_:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _loc5_:Number = Math.PI / 3;
         var _loc7_:Number = Math.atan2(this.target_.y_ - this.start_.y,this.target_.x_ - this.start_.x);
         var _loc8_:int = 0;
         while(_loc8_ < 5)
         {
            _loc9_ = _loc7_ - _loc5_ / 2 + _loc8_ * _loc5_ / 5;
            _loc10_ = new Point(this.start_.x + this.blastRadius_ * Math.cos(_loc9_),this.start_.y + this.blastRadius_ * Math.sin(_loc9_));
            _loc11_ = new SparkerParticle(50,this.color_,10,this.start_,_loc10_);
            map_.addObj(_loc11_,x_,y_);
            _loc8_++;
         }
         return false;
      }
   }
}

