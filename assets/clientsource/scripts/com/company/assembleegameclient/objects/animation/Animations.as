package com.company.assembleegameclient.objects.animation
{
   import flash.display.BitmapData;
   
   public class Animations
   {
      
      public var animationsData_:AnimationsData;
      
      public var nextRun_:Vector.<int> = null;
      
      public var running_:RunningAnimation = null;
      
      public function Animations(param1:AnimationsData)
      {
         super();
         this.animationsData_ = param1;
      }
      
      public function getTexture(param1:int) : BitmapData
      {
         var _loc2_:AnimationData = null;
         var _loc4_:BitmapData = null;
         var _loc5_:int = 0;
         if(this.nextRun_ == null)
         {
            this.nextRun_ = new Vector.<int>();
            for each(_loc2_ in this.animationsData_.animations)
            {
               this.nextRun_.push(_loc2_.getLastRun(param1));
            }
         }
         if(this.running_ != null)
         {
            _loc4_ = this.running_.getTexture(param1);
            if(_loc4_ != null)
            {
               return _loc4_;
            }
            this.running_ = null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.nextRun_.length)
         {
            if(param1 > this.nextRun_[_loc3_])
            {
               _loc5_ = this.nextRun_[_loc3_];
               _loc2_ = this.animationsData_.animations[_loc3_];
               this.nextRun_[_loc3_] = _loc2_.getNextRun(param1);
               if(!(_loc2_.prob_ != 1 && Math.random() > _loc2_.prob_))
               {
                  this.running_ = new RunningAnimation(_loc2_,_loc5_);
                  return this.running_.getTexture(param1);
               }
            }
            _loc3_++;
         }
         return null;
      }
   }
}

import flash.display.BitmapData;

class RunningAnimation
{
   
   public var animationData_:AnimationData;
   
   public var start_:int;
   
   public var frameId_:int;
   
   public var frameStart_:int;
   
   public var texture_:BitmapData;
   
   public function RunningAnimation(param1:AnimationData, param2:int)
   {
      super();
      this.animationData_ = param1;
      this.start_ = param2;
      this.frameId_ = 0;
      this.frameStart_ = param2;
      this.texture_ = null;
   }
   
   public function getTexture(param1:int) : BitmapData
   {
      var _loc2_:FrameData = this.animationData_.frames[this.frameId_];
      while(param1 - this.frameStart_ > _loc2_.time_)
      {
         if(this.frameId_ >= this.animationData_.frames.length - 1)
         {
            return null;
         }
         this.frameStart_ += _loc2_.time_;
         ++this.frameId_;
         _loc2_ = this.animationData_.frames[this.frameId_];
         this.texture_ = null;
      }
      if(this.texture_ == null)
      {
         this.texture_ = _loc2_.textureData_.getTexture(Math.random() * 100);
      }
      return this.texture_;
   }
}
