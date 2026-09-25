package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class CollapseEffect extends ParticleEffect
   {
      
      public var center_:Point;
      
      public var edgePoint_:Point;
      
      public var color_:int;
      
      public function CollapseEffect(param1:GameObject, param2:WorldPosData, param3:WorldPosData, param4:int)
      {
         super();
         this.center_ = new Point(param2.x_,param2.y_);
         this.edgePoint_ = new Point(param3.x_,param3.y_);
         this.color_ = param4;
      }
      
      override public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:Particle = null;
         x_ = this.center_.x;
         y_ = this.center_.y;
         var _loc3_:Number = Point.distance(this.center_,this.edgePoint_);
         var _loc7_:int = 0;
         while(_loc7_ < 24)
         {
            _loc8_ = _loc7_ * 2 * Math.PI / 24;
            _loc9_ = new Point(this.center_.x + _loc3_ * Math.cos(_loc8_),this.center_.y + _loc3_ * Math.sin(_loc8_));
            _loc10_ = new SparkerParticle(300,this.color_,200,_loc9_,this.center_);
            map_.addObj(_loc10_,x_,y_);
            _loc7_++;
         }
         return false;
      }
      
      override public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:Particle = null;
         x_ = this.center_.x;
         y_ = this.center_.y;
         var _loc3_:Number = Point.distance(this.center_,this.edgePoint_);
         var _loc7_:int = 0;
         while(_loc7_ < 8)
         {
            _loc8_ = _loc7_ * 2 * Math.PI / 8;
            _loc9_ = new Point(this.center_.x + _loc3_ * Math.cos(_loc8_),this.center_.y + _loc3_ * Math.sin(_loc8_));
            _loc10_ = new SparkerParticle(50,this.color_,150,_loc9_,this.center_);
            map_.addObj(_loc10_,x_,y_);
            _loc7_++;
         }
         return false;
      }
   }
}

