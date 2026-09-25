package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.FreeList;
   
   public class BubbleEffect extends ParticleEffect
   {
      
      private static const PERIOD_MAX:Number = 400;
      
      private var poolID:String;
      
      public var go_:GameObject;
      
      public var lastUpdate_:int = -1;
      
      public var rate_:Number;
      
      private var fxProps:EffectProperties;
      
      public function BubbleEffect(param1:GameObject, param2:EffectProperties)
      {
         super();
         this.go_ = param1;
         this.fxProps = param2;
         this.rate_ = (1 - param2.rate) * PERIOD_MAX + 1;
         this.poolID = "BubbleEffect_" + Math.random();
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc11_:BubbleParticle = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         if(this.go_.map_ == null)
         {
            return false;
         }
         if(!this.lastUpdate_)
         {
            this.lastUpdate_ = param1;
            return true;
         }
         _loc3_ = int(this.lastUpdate_ / this.rate_);
         var _loc4_:int = int(param1 / this.rate_);
         _loc8_ = this.go_.x_;
         _loc9_ = this.go_.y_;
         if(this.lastUpdate_ < 0)
         {
            this.lastUpdate_ = Math.max(0,param1 - PERIOD_MAX);
         }
         x_ = _loc8_;
         y_ = _loc9_;
         var _loc10_:int = _loc3_;
         while(_loc10_ < _loc4_)
         {
            _loc5_ = _loc10_ * this.rate_;
            _loc11_ = BubbleParticle.create(this.poolID,this.fxProps.color,this.fxProps.speed,this.fxProps.life,this.fxProps.lifeVariance,this.fxProps.speedVariance,this.fxProps.spread);
            _loc11_.restart(_loc5_,param1);
            _loc6_ = Math.random() * Math.PI;
            _loc7_ = Math.random() * 0.4;
            _loc12_ = _loc8_ + _loc7_ * Math.cos(_loc6_);
            _loc13_ = _loc9_ + _loc7_ * Math.sin(_loc6_);
            map_.addObj(_loc11_,_loc12_,_loc13_);
            _loc10_++;
         }
         this.lastUpdate_ = param1;
         return true;
      }
      
      override public function removeFromMap() : void
      {
         super.removeFromMap();
         FreeList.dump(this.poolID);
      }
   }
}

