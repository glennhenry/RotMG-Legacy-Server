package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.thrown.BitmapParticle;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class ShockParticle extends BitmapParticle
   {
      
      private var numFramesRemaining:int;
      
      private var dx_:Number;
      
      private var dy_:Number;
      
      private var originX:Number;
      
      private var originY:Number;
      
      private var radians:Number;
      
      private var frameUpdateModulator:uint = 0;
      
      private var currentFrame:uint = 0;
      
      private var numFrames:uint;
      
      private var go:GameObject;
      
      private var plusX:Number = 0;
      
      private var plusY:Number = 0;
      
      private var cameraAngle:Number = Parameters.data_.cameraAngle;
      
      private var images:Vector.<BitmapData>;
      
      public function ShockParticle(param1:uint, param2:int, param3:uint, param4:Point, param5:Point, param6:Number, param7:GameObject, param8:Vector.<BitmapData>)
      {
         this.go = param7;
         this.radians = param6;
         this.images = param8;
         super(param8[0],0);
         this.numFrames = param8.length;
         this.numFramesRemaining = param2;
         this.dx_ = (param5.x - param4.x) / this.numFramesRemaining;
         this.dy_ = (param5.y - param4.y) / this.numFramesRemaining;
         this.originX = param4.x - param7.x_;
         this.originY = param4.y - param7.y_;
         _rotation = -param6 - this.cameraAngle;
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         --this.numFramesRemaining;
         if(this.numFramesRemaining <= 0)
         {
            return false;
         }
         ++this.frameUpdateModulator;
         if(this.frameUpdateModulator % 2)
         {
            ++this.currentFrame;
         }
         _bitmapData = this.images[this.currentFrame % this.numFrames];
         this.plusX += this.dx_;
         this.plusY += this.dy_;
         if(Parameters.data_.cameraAngle != this.cameraAngle)
         {
            this.cameraAngle = Parameters.data_.cameraAngle;
            _rotation = -this.radians - this.cameraAngle;
         }
         moveTo(this.go.x_ + this.originX + this.plusX,this.go.y_ + this.originY + this.plusY);
         return true;
      }
   }
}

