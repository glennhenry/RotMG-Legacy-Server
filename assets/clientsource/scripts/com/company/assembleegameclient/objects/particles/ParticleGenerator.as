package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   
   public class ParticleGenerator extends ParticleEffect
   {
      
      private var particlePool:Vector.<BaseParticle>;
      
      private var liveParticles:Vector.<BaseParticle>;
      
      private var targetGO:GameObject;
      
      private var generatedParticles:Number = 0;
      
      private var totalTime:Number = 0;
      
      private var effectProps:EffectProperties;
      
      private var bitmapData:BitmapData;
      
      private var friction:Number;
      
      public function ParticleGenerator(param1:EffectProperties, param2:GameObject)
      {
         super();
         this.targetGO = param2;
         this.particlePool = new Vector.<BaseParticle>();
         this.liveParticles = new Vector.<BaseParticle>();
         this.effectProps = param1;
         if(this.effectProps.bitmapFile)
         {
            this.bitmapData = AssetLibrary.getImageFromSet(this.effectProps.bitmapFile,this.effectProps.bitmapIndex);
            this.bitmapData = TextureRedrawer.redraw(this.bitmapData,this.effectProps.size,true,0);
         }
         else
         {
            this.bitmapData = TextureRedrawer.redrawSolidSquare(this.effectProps.color,this.effectProps.size);
         }
      }
      
      public static function attachParticleGenerator(param1:EffectProperties, param2:GameObject) : ParticleGenerator
      {
         return new ParticleGenerator(param1,param2);
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc9_:BaseParticle = null;
         var _loc10_:BaseParticle = null;
         var _loc3_:Number = param1 / 1000;
         _loc4_ = param2 / 1000;
         if(this.targetGO.map_ == null)
         {
            return false;
         }
         x_ = this.targetGO.x_;
         y_ = this.targetGO.y_;
         z_ = this.targetGO.z_ + this.effectProps.zOffset;
         this.totalTime += _loc4_;
         var _loc5_:Number = this.effectProps.rate * this.totalTime;
         var _loc6_:int = _loc5_ - this.generatedParticles;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            if(this.particlePool.length)
            {
               _loc9_ = this.particlePool.pop();
            }
            else
            {
               _loc9_ = new BaseParticle(this.bitmapData);
            }
            _loc9_.initialize(this.effectProps.life + this.effectProps.lifeVariance * (2 * Math.random() - 1),this.effectProps.speed + this.effectProps.speedVariance * (2 * Math.random() - 1),this.effectProps.speed + this.effectProps.speedVariance * (2 * Math.random() - 1),this.effectProps.rise + this.effectProps.riseVariance * (2 * Math.random() - 1),z_);
            map_.addObj(_loc9_,x_ + this.effectProps.rangeX * (2 * Math.random() - 1),y_ + this.effectProps.rangeY * (2 * Math.random() - 1));
            this.liveParticles.push(_loc9_);
            _loc7_++;
         }
         this.generatedParticles += _loc6_;
         var _loc8_:* = 0;
         while(_loc8_ < this.liveParticles.length)
         {
            _loc10_ = this.liveParticles[_loc8_];
            _loc10_.timeLeft -= _loc4_;
            if(_loc10_.timeLeft <= 0)
            {
               this.liveParticles.splice(_loc8_,1);
               map_.removeObj(_loc10_.objectId_);
               _loc8_--;
               this.particlePool.push(_loc10_);
            }
            else
            {
               _loc10_.spdZ += this.effectProps.riseAcc * _loc4_;
               _loc10_.x_ += _loc10_.spdX * _loc4_;
               _loc10_.y_ += _loc10_.spdY * _loc4_;
               _loc10_.z_ += _loc10_.spdZ * _loc4_;
            }
            _loc8_++;
         }
         return true;
      }
      
      override public function removeFromMap() : void
      {
         var _loc1_:BaseParticle = null;
         for each(_loc1_ in this.liveParticles)
         {
            map_.removeObj(_loc1_.objectId_);
         }
         this.liveParticles = null;
         this.particlePool = null;
         super.removeFromMap();
      }
   }
}

