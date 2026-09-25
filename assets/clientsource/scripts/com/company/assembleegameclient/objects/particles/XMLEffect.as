package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class XMLEffect extends ParticleEffect
   {
      
      private var go_:GameObject;
      
      private var partProps_:ParticleProperties;
      
      private var cooldown_:Number;
      
      private var cooldownLeft_:Number;
      
      public function XMLEffect(param1:GameObject, param2:EffectProperties)
      {
         super();
         this.go_ = param1;
         this.partProps_ = ParticleLibrary.propsLibrary_[param2.particle];
         this.cooldown_ = param2.cooldown;
         this.cooldownLeft_ = 0;
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         if(this.go_.map_ == null)
         {
            return false;
         }
         var _loc3_:Number = param2 / 1000;
         this.cooldownLeft_ -= _loc3_;
         if(this.cooldownLeft_ >= 0)
         {
            return true;
         }
         this.cooldownLeft_ = this.cooldown_;
         map_.addObj(new XMLParticle(this.partProps_),this.go_.x_,this.go_.y_);
         return true;
      }
   }
}

