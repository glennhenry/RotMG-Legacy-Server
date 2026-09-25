package kabam.rotmg.assets.model
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Animation extends Sprite
   {
      
      private const DEFAULT_SPEED:int = 200;
      
      private const bitmap:Bitmap = this.makeBitmap();
      
      private const frames:Vector.<BitmapData> = new Vector.<BitmapData>(0);
      
      private const timer:Timer = this.makeTimer();
      
      private var started:Boolean;
      
      private var index:int;
      
      private var count:uint;
      
      private var disposed:Boolean;
      
      public function Animation()
      {
         super();
      }
      
      private function makeBitmap() : Bitmap
      {
         var _loc1_:Bitmap = new Bitmap();
         addChild(_loc1_);
         return _loc1_;
      }
      
      private function makeTimer() : Timer
      {
         var _loc1_:Timer = new Timer(this.DEFAULT_SPEED);
         _loc1_.addEventListener(TimerEvent.TIMER,this.iterate);
         return _loc1_;
      }
      
      public function getSpeed() : int
      {
         return this.timer.delay;
      }
      
      public function setSpeed(param1:int) : void
      {
         this.timer.delay = param1;
      }
      
      public function setFrames(... rest) : void
      {
         var _loc2_:BitmapData = null;
         this.frames.length = 0;
         this.index = 0;
         for each(_loc2_ in rest)
         {
            this.count = this.frames.push(_loc2_);
         }
         if(this.started)
         {
            this.start();
         }
         else
         {
            this.iterate();
         }
      }
      
      public function addFrame(param1:BitmapData) : void
      {
         this.count = this.frames.push(param1);
         this.started && this.start();
      }
      
      public function start() : void
      {
         if(!this.started && this.count > 0)
         {
            this.timer.start();
            this.iterate();
         }
         this.started = true;
      }
      
      public function stop() : void
      {
         this.started && this.timer.stop();
         this.started = false;
      }
      
      private function iterate(param1:TimerEvent = null) : void
      {
         this.index = ++this.index % this.count;
         this.bitmap.bitmapData = this.frames[this.index];
      }
      
      public function dispose() : void
      {
         var _loc1_:BitmapData = null;
         this.disposed = true;
         this.stop();
         this.index = 0;
         this.count = 0;
         this.frames.length = 0;
         for each(_loc1_ in this.frames)
         {
            _loc1_.dispose();
         }
      }
      
      public function isStarted() : Boolean
      {
         return this.started;
      }
      
      public function isDisposed() : Boolean
      {
         return this.disposed;
      }
   }
}

