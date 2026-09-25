package com.company.assembleegameclient.engine3d
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class TextureMatrix
   {
      
      public var texture_:BitmapData = null;
      
      public var tToS_:Matrix = new Matrix();
      
      private var uvMatrix_:Matrix = null;
      
      private var tempMatrix_:Matrix = new Matrix();
      
      public function TextureMatrix(param1:BitmapData, param2:Vector.<Number>)
      {
         super();
         this.texture_ = param1;
         this.calculateUVMatrix(param2);
      }
      
      public function setUVT(param1:Vector.<Number>) : void
      {
         this.calculateUVMatrix(param1);
      }
      
      public function setVOut(param1:Vector.<Number>) : void
      {
         this.calculateTextureMatrix(param1);
      }
      
      public function calculateTextureMatrix(param1:Vector.<Number>) : void
      {
         this.tToS_.a = this.uvMatrix_.a;
         this.tToS_.b = this.uvMatrix_.b;
         this.tToS_.c = this.uvMatrix_.c;
         this.tToS_.d = this.uvMatrix_.d;
         this.tToS_.tx = this.uvMatrix_.tx;
         this.tToS_.ty = this.uvMatrix_.ty;
         var _loc2_:int = param1.length - 2;
         var _loc3_:int = _loc2_ + 1;
         this.tempMatrix_.a = param1[2] - param1[0];
         this.tempMatrix_.b = param1[3] - param1[1];
         this.tempMatrix_.c = param1[_loc2_] - param1[0];
         this.tempMatrix_.d = param1[_loc3_] - param1[1];
         this.tempMatrix_.tx = param1[0];
         this.tempMatrix_.ty = param1[1];
         this.tToS_.concat(this.tempMatrix_);
      }
      
      public function calculateUVMatrix(param1:Vector.<Number>) : void
      {
         if(this.texture_ == null)
         {
            this.uvMatrix_ = null;
            return;
         }
         var _loc2_:int = param1.length - 3;
         var _loc3_:Number = param1[0] * this.texture_.width;
         var _loc4_:Number = param1[1] * this.texture_.height;
         var _loc5_:Number = param1[3] * this.texture_.width;
         var _loc6_:Number = param1[4] * this.texture_.height;
         var _loc7_:Number = param1[_loc2_] * this.texture_.width;
         var _loc8_:Number = param1[_loc2_ + 1] * this.texture_.height;
         var _loc9_:Number = _loc5_ - _loc3_;
         var _loc10_:Number = _loc6_ - _loc4_;
         var _loc11_:Number = _loc7_ - _loc3_;
         var _loc12_:Number = _loc8_ - _loc4_;
         this.uvMatrix_ = new Matrix(_loc9_,_loc10_,_loc11_,_loc12_,_loc3_,_loc4_);
         this.uvMatrix_.invert();
      }
   }
}

