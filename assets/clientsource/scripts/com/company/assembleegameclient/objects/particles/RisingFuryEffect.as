package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class RisingFuryEffect extends ParticleEffect
   {
      
      public var start_:Point;
      
      public var go:GameObject;
      
      private var startX:Number;
      
      private var startY:Number;
      
      private var particleField:ParticleField;
      
      private var time:uint;
      
      private var timer:Timer;
      
      private var isCharged:Boolean;
      
      public function RisingFuryEffect(param1:GameObject, param2:uint)
      {
         super();
         this.go = param1;
         this.startX = Math.floor(param1.x_ * 10) / 10;
         this.startY = Math.floor(param1.y_ * 10) / 10;
         this.time = param2;
         this.createTimer();
         this.createParticleField();
      }
      
      private function createTimer() : void
      {
         var _loc1_:uint = this.go.texture_.height == 8 ? 50 : 30;
         this.timer = new Timer(_loc1_,Math.round(this.time / _loc1_));
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onChargingComplete);
         this.timer.start();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:Number = Math.floor(this.go.x_ * 10) / 10;
         var _loc3_:Number = Math.floor(this.go.y_ * 10) / 10;
         if(this.startX != _loc2_ || this.startY != _loc3_)
         {
            this.timer.stop();
            this.particleField.destroy();
         }
      }
      
      private function onChargingComplete(param1:TimerEvent) : void
      {
         this.particleField.destroy();
         var _loc2_:Timer = new Timer(33,12);
         _loc2_.addEventListener(TimerEvent.TIMER,this.onShockTimer);
         _loc2_.start();
      }
      
      private function onShockTimer(param1:TimerEvent) : void
      {
         this.isCharged = !this.isCharged;
         this.go.toggleChargingEffect(this.isCharged);
      }
      
      private function createParticleField() : void
      {
         this.particleField = new ParticleField(this.go.texture_.width,this.go.texture_.height);
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         map_.addObj(this.particleField,this.go.x_,this.go.y_);
         return false;
      }
   }
}

