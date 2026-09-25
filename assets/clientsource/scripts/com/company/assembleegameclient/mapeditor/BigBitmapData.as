package com.company.assembleegameclient.mapeditor
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class BigBitmapData
   {
      
      private static const CHUNK_SIZE:int = 256;
      
      public var width_:int;
      
      public var height_:int;
      
      public var fillColor_:uint;
      
      private var maxChunkX_:int;
      
      private var maxChunkY_:int;
      
      private var chunks_:Vector.<BitmapData>;
      
      public function BigBitmapData(param1:int, param2:int, param3:Boolean, param4:uint)
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         super();
         this.width_ = param1;
         this.height_ = param2;
         this.fillColor_ = param4;
         this.maxChunkX_ = Math.ceil(this.width_ / CHUNK_SIZE);
         this.maxChunkY_ = Math.ceil(this.height_ / CHUNK_SIZE);
         this.chunks_ = new Vector.<BitmapData>(this.maxChunkX_ * this.maxChunkY_,true);
         var _loc5_:int = 0;
         while(_loc5_ < this.maxChunkX_)
         {
            _loc6_ = 0;
            while(_loc6_ < this.maxChunkY_)
            {
               _loc7_ = Math.min(CHUNK_SIZE,this.width_ - _loc5_ * CHUNK_SIZE);
               _loc8_ = Math.min(CHUNK_SIZE,this.height_ - _loc6_ * CHUNK_SIZE);
               this.chunks_[_loc5_ + _loc6_ * this.maxChunkX_] = new BitmapDataSpy(_loc7_,_loc8_,param3,this.fillColor_);
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public function copyTo(param1:BitmapData, param2:Rectangle, param3:Rectangle) : void
      {
         var _loc12_:int = 0;
         var _loc13_:BitmapData = null;
         var _loc14_:Rectangle = null;
         var _loc4_:Number = param3.width / param2.width;
         var _loc5_:Number = param3.height / param2.height;
         var _loc6_:int = int(param3.x / CHUNK_SIZE);
         var _loc7_:int = int(param3.y / CHUNK_SIZE);
         var _loc8_:int = Math.ceil(param3.right / CHUNK_SIZE);
         var _loc9_:int = Math.ceil(param3.bottom / CHUNK_SIZE);
         var _loc10_:Matrix = new Matrix();
         var _loc11_:int = _loc6_;
         while(_loc11_ < _loc8_)
         {
            _loc12_ = _loc7_;
            while(_loc12_ < _loc9_)
            {
               _loc13_ = this.chunks_[_loc11_ + _loc12_ * this.maxChunkX_];
               _loc10_.identity();
               _loc10_.scale(_loc4_,_loc5_);
               _loc10_.translate(param3.x - _loc11_ * CHUNK_SIZE - param2.x * _loc4_,param3.y - _loc12_ * CHUNK_SIZE - param2.x * _loc5_);
               _loc14_ = new Rectangle(param3.x - _loc11_ * CHUNK_SIZE,param3.y - _loc12_ * CHUNK_SIZE,param3.width,param3.height);
               _loc13_.draw(param1,_loc10_,null,null,_loc14_,false);
               _loc12_++;
            }
            _loc11_++;
         }
      }
      
      public function copyFrom(param1:Rectangle, param2:BitmapData, param3:Rectangle) : void
      {
         var _loc13_:int = 0;
         var _loc14_:BitmapData = null;
         var _loc4_:Number = param3.width / param1.width;
         var _loc5_:Number = param3.height / param1.height;
         var _loc6_:int = Math.max(0,int(param1.x / CHUNK_SIZE));
         var _loc7_:int = Math.max(0,int(param1.y / CHUNK_SIZE));
         var _loc8_:int = Math.min(this.maxChunkX_ - 1,int(param1.right / CHUNK_SIZE));
         var _loc9_:int = Math.min(this.maxChunkY_ - 1,int(param1.bottom / CHUNK_SIZE));
         var _loc10_:Rectangle = new Rectangle();
         var _loc11_:Matrix = new Matrix();
         var _loc12_:int = _loc6_;
         while(_loc12_ <= _loc8_)
         {
            _loc13_ = _loc7_;
            while(_loc13_ <= _loc9_)
            {
               _loc14_ = this.chunks_[_loc12_ + _loc13_ * this.maxChunkX_];
               _loc11_.identity();
               _loc11_.translate(param3.x / _loc4_ - param1.x + _loc12_ * CHUNK_SIZE,param3.y / _loc5_ - param1.y + _loc13_ * CHUNK_SIZE);
               _loc11_.scale(_loc4_,_loc5_);
               param2.draw(_loc14_,_loc11_,null,null,param3,false);
               _loc13_++;
            }
            _loc12_++;
         }
      }
      
      public function erase(param1:Rectangle) : void
      {
         var _loc8_:int = 0;
         var _loc9_:BitmapData = null;
         var _loc2_:int = int(param1.x / CHUNK_SIZE);
         var _loc3_:int = int(param1.y / CHUNK_SIZE);
         var _loc4_:int = Math.ceil(param1.right / CHUNK_SIZE);
         var _loc5_:int = Math.ceil(param1.bottom / CHUNK_SIZE);
         var _loc6_:Rectangle = new Rectangle();
         var _loc7_:int = _loc2_;
         while(_loc7_ < _loc4_)
         {
            _loc8_ = _loc3_;
            while(_loc8_ < _loc5_)
            {
               _loc9_ = this.chunks_[_loc7_ + _loc8_ * this.maxChunkX_];
               _loc6_.x = param1.x - _loc7_ * CHUNK_SIZE;
               _loc6_.y = param1.y - _loc8_ * CHUNK_SIZE;
               _loc6_.right = param1.right - _loc7_ * CHUNK_SIZE;
               _loc6_.bottom = param1.bottom - _loc8_ * CHUNK_SIZE;
               _loc9_.fillRect(_loc6_,this.fillColor_);
               _loc8_++;
            }
            _loc7_++;
         }
      }
      
      public function getDebugSprite() : Sprite
      {
         var _loc3_:int = 0;
         var _loc4_:BitmapData = null;
         var _loc5_:Bitmap = null;
         var _loc1_:Sprite = new Sprite();
         var _loc2_:int = 0;
         while(_loc2_ < this.maxChunkX_)
         {
            _loc3_ = 0;
            while(_loc3_ < this.maxChunkY_)
            {
               _loc4_ = this.chunks_[_loc2_ + _loc3_ * this.maxChunkX_];
               _loc5_ = new Bitmap(_loc4_);
               _loc5_.x = _loc2_ * CHUNK_SIZE;
               _loc5_.y = _loc3_ * CHUNK_SIZE;
               _loc1_.addChild(_loc5_);
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

