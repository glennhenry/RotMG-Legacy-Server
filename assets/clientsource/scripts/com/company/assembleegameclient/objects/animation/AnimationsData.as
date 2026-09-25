package com.company.assembleegameclient.objects.animation
{
   public class AnimationsData
   {
      
      public var animations:Vector.<AnimationData>;
      
      public function AnimationsData(param1:XML)
      {
         var _loc2_:XML = null;
         this.animations = new Vector.<AnimationData>();
         super();
         for each(_loc2_ in param1.Animation)
         {
            this.animations.push(new AnimationData(_loc2_));
         }
      }
   }
}

