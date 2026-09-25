package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class HealingEffect extends ParticleEffect
   {
      
      public var go_:GameObject;
      
      public var lastPart_:int;
      
      public function HealingEffect(param1:GameObject)
      {
         super();
         this.go_ = param1;
         this.lastPart_ = 0;
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:HealParticle = null;
         if(this.go_.map_ == null)
         {
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var _loc3_:int = param1 - this.lastPart_;
         if(_loc3_ > 500)
         {
            _loc4_ = 2 * Math.PI * Math.random();
            _loc5_ = (3 + int(Math.random() * 5)) * 20;
            _loc6_ = 0.3 + 0.4 * Math.random();
            _loc7_ = new HealParticle(16777215,Math.random() * 0.3,_loc5_,1000,0.1 + Math.random() * 0.1,this.go_,_loc4_,_loc6_);
            map_.addObj(_loc7_,x_ + _loc6_ * Math.cos(_loc4_),y_ + _loc6_ * Math.sin(_loc4_));
            this.lastPart_ = param1;
         }
         return true;
      }
   }
}

