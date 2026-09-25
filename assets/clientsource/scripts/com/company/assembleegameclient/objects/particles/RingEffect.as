package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.geom.Point;
   
   public class RingEffect extends ParticleEffect
   {
      
      public var start_:Point;
      
      public var novaRadius_:Number;
      
      public var color_:int;
      
      public function RingEffect(param1:GameObject, param2:Number, param3:int)
      {
         super();
         this.start_ = new Point(param1.x_,param1.y_);
         this.novaRadius_ = param2;
         this.color_ = param3;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _loc6_:int = 0;
         while(_loc6_ < 12)
         {
            _loc7_ = _loc6_ * 2 * Math.PI / 12;
            _loc8_ = new Point(this.start_.x + this.novaRadius_ * Math.cos(_loc7_),this.start_.y + this.novaRadius_ * Math.sin(_loc7_));
            _loc9_ = new Point(this.start_.x + this.novaRadius_ * 0.9 * Math.cos(_loc7_),this.start_.y + this.novaRadius_ * 0.9 * Math.sin(_loc7_));
            _loc10_ = new SparkerParticle(0,this.color_,200,_loc9_,_loc8_);
            map_.addObj(_loc10_,x_,y_);
            _loc6_++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Particle = null;
         x_ = this.start_.x;
         y_ = this.start_.y;
         var _loc6_:int = 0;
         while(_loc6_ < 10)
         {
            _loc7_ = _loc6_ * 2 * Math.PI / 10;
            _loc8_ = new Point(this.start_.x + this.novaRadius_ * Math.cos(_loc7_),this.start_.y + this.novaRadius_ * Math.sin(_loc7_));
            _loc9_ = new Point(this.start_.x + this.novaRadius_ * 0.9 * Math.cos(_loc7_),this.start_.y + this.novaRadius_ * 0.9 * Math.sin(_loc7_));
            _loc10_ = new SparkerParticle(0,this.color_,50,_loc9_,_loc8_);
            map_.addObj(_loc10_,x_,y_);
            _loc6_++;
         }
         return false;
      }
   }
}

