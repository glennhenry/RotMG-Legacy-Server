package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.thrown.BitmapParticle;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class ParticleField extends BitmapParticle
   {
      
      private const SMALL:String = "SMALL";
      
      private const LARGE:String = "LARGE";
      
      private var bitmapSize:String;
      
      private var width:int;
      
      private var height:int;
      
      public var lifetime_:int;
      
      public var timeLeft_:int;
      
      private var spriteSource:Sprite = new Sprite();
      
      private var squares:Array = [];
      
      private var visibleHeight:Number;
      
      private var offset:Number;
      
      private var timer:Timer;
      
      private var doDestroy:Boolean;
      
      public function ParticleField(param1:Number, param2:Number)
      {
         this.setDimensions(param2,param1);
         this.setBitmapSize();
         this.createTimer();
         var _loc3_:BitmapData = new BitmapData(this.width,this.height,true,0);
         _loc3_.draw(this.spriteSource);
         super(_loc3_,0);
      }
      
      private function createTimer() : void
      {
         this.timer = new Timer(this.getInterval());
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      private function setDimensions(param1:Number, param2:Number) : void
      {
         this.visibleHeight = param1 * 5 + 40;
         this.offset = this.visibleHeight * 0.5;
         this.width = param2 * 5 + 40;
         this.height = this.visibleHeight + this.offset;
      }
      
      private function setBitmapSize() : void
      {
         this.bitmapSize = this.width == 8 ? this.SMALL : this.LARGE;
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         var _loc3_:uint = 0;
         if(this.doDestroy)
         {
            return false;
         }
         var _loc4_:uint = this.squares.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.squares[_loc3_])
            {
               this.squares[_loc3_].move();
            }
            _loc3_++;
         }
         _bitmapData = new BitmapData(this.width,this.height,true,0);
         _bitmapData.draw(this.spriteSource);
         return true;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:Square = new Square(this.getStartPoint(),this.getEndPoint(),this.getLifespan());
         _loc2_.complete.add(this.onSquareComplete);
         this.squares.push(_loc2_);
         this.spriteSource.addChild(_loc2_);
      }
      
      private function getLifespan() : uint
      {
         return this.bitmapSize == this.SMALL ? 15 : 30;
      }
      
      private function getInterval() : uint
      {
         return this.bitmapSize == this.SMALL ? 100 : 50;
      }
      
      private function onSquareComplete(param1:Square) : void
      {
         param1.complete.removeAll();
         this.spriteSource.removeChild(param1);
         this.squares.splice(this.squares.indexOf(param1),1);
      }
      
      private function getStartPoint() : Point
      {
         var _loc1_:Array = Math.random() < 0.5 ? ["x","y","width","visibleHeight"] : ["y","x","visibleHeight","width"];
         var _loc2_:Point = new Point(0,0);
         _loc2_[_loc1_[0]] = Math.random() * this[_loc1_[2]];
         _loc2_[_loc1_[1]] = Math.random() < 0.5 ? 0 : this[_loc1_[3]];
         return _loc2_;
      }
      
      private function getEndPoint() : Point
      {
         return new Point(this.width / 2,this.visibleHeight / 2);
      }
      
      public function destroy() : void
      {
         if(this.timer != null)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.stop();
            this.timer = null;
         }
         this.spriteSource = null;
         this.squares = [];
         this.doDestroy = true;
      }
   }
}

import flash.display.Shape;
import flash.geom.Point;
import org.osflash.signals.Signal;

class Square extends Shape
{
   
   public var start:Point;
   
   public var end:Point;
   
   private var lifespan:uint;
   
   private var moveX:Number;
   
   private var moveY:Number;
   
   private var angle:Number;
   
   public var complete:Signal = new Signal();
   
   public function Square(param1:Point, param2:Point, param3:uint)
   {
      super();
      this.start = param1;
      this.end = param2;
      this.lifespan = param3;
      this.moveX = (param2.x - param1.x) / param3;
      this.moveY = (param2.y - param1.y) / param3;
      graphics.beginFill(16777215);
      graphics.drawRect(-2,-2,4,4);
      this.position();
   }
   
   private function position() : void
   {
      this.x = this.start.x;
      this.y = this.start.y;
   }
   
   public function move() : void
   {
      this.x += this.moveX;
      this.y += this.moveY;
      --this.lifespan;
      if(!this.lifespan)
      {
         this.complete.dispatch(this);
      }
   }
}
