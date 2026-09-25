package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class BurstEffect extends ParticleEffect
   {
      
      public var center_:Point;
      
      public var edgePoint_:Point;
      
      public var color_:int;
      
      public function BurstEffect(param1:GameObject, param2:WorldPosData, param3:WorldPosData, param4:int)
      {
         super();
         this.center_ = new Point(param2.x_,param2.y_);
         this.edgePoint_ = new Point(param3.x_,param3.y_);
         this.color_ = param4;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         var _loc9_:Particle = null;
         x_ = this.center_.x;
         y_ = this.center_.y;
         var _loc3_:Number = Point.distance(this.center_,this.edgePoint_);
         var _loc6_:int = 0;
         while(_loc6_ < 24)
         {
            _loc7_ = _loc6_ * 2 * Math.PI / 24;
            _loc8_ = new Point(this.center_.x + _loc3_ * Math.cos(_loc7_),this.center_.y + _loc3_ * Math.sin(_loc7_));
            _loc9_ = new SparkerParticle(100,this.color_,100 + Math.random() * 200,this.center_,_loc8_);
            map_.addObj(_loc9_,x_,y_);
            _loc6_++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         var _loc9_:Particle = null;
         x_ = this.center_.x;
         y_ = this.center_.y;
         var _loc3_:Number = Point.distance(this.center_,this.edgePoint_);
         var _loc6_:int = 0;
         while(_loc6_ < 10)
         {
            _loc7_ = _loc6_ * 2 * Math.PI / 10;
            _loc8_ = new Point(this.center_.x + _loc3_ * Math.cos(_loc7_),this.center_.y + _loc3_ * Math.sin(_loc7_));
            _loc9_ = new SparkerParticle(10,this.color_,50 + Math.random() * 20,this.center_,_loc8_);
            map_.addObj(_loc9_,x_,y_);
            _loc6_++;
         }
         return false;
      }
   }
}

