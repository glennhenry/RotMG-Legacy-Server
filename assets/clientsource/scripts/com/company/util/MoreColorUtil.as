package com.company.util
{
   import flash.geom.ColorTransform;
   
   public class MoreColorUtil
   {
      
      public static const greyscaleFilterMatrix:Array = [0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0];
      
      public static const redFilterMatrix:Array = [0.3,0.59,0.11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0];
      
      public static const identity:ColorTransform = new ColorTransform();
      
      public static const invisible:ColorTransform = new ColorTransform(1,1,1,0,0,0,0,0);
      
      public static const transparentCT:ColorTransform = new ColorTransform(1,1,1,0.3,0,0,0,0);
      
      public static const slightlyTransparentCT:ColorTransform = new ColorTransform(1,1,1,0.7,0,0,0,0);
      
      public static const greenCT:ColorTransform = new ColorTransform(0.6,1,0.6,1,0,0,0,0);
      
      public static const lightGreenCT:ColorTransform = new ColorTransform(0.8,1,0.8,1,0,0,0,0);
      
      public static const veryGreenCT:ColorTransform = new ColorTransform(0.2,1,0.2,1,0,100,0,0);
      
      public static const transparentGreenCT:ColorTransform = new ColorTransform(0.5,1,0.5,0.3,0,0,0,0);
      
      public static const transparentVeryGreenCT:ColorTransform = new ColorTransform(0.3,1,0.3,0.5,0,0,0,0);
      
      public static const redCT:ColorTransform = new ColorTransform(1,0.5,0.5,1,0,0,0,0);
      
      public static const lightRedCT:ColorTransform = new ColorTransform(1,0.7,0.7,1,0,0,0,0);
      
      public static const veryRedCT:ColorTransform = new ColorTransform(1,0.2,0.2,1,100,0,0,0);
      
      public static const transparentRedCT:ColorTransform = new ColorTransform(1,0.5,0.5,0.3,0,0,0,0);
      
      public static const transparentVeryRedCT:ColorTransform = new ColorTransform(1,0.3,0.3,0.5,0,0,0,0);
      
      public static const blueCT:ColorTransform = new ColorTransform(0.5,0.5,1,1,0,0,0,0);
      
      public static const lightBlueCT:ColorTransform = new ColorTransform(0.7,0.7,1,1,0,0,100,0);
      
      public static const veryBlueCT:ColorTransform = new ColorTransform(0.3,0.3,1,1,0,0,100,0);
      
      public static const transparentBlueCT:ColorTransform = new ColorTransform(0.5,0.5,1,0.3,0,0,0,0);
      
      public static const transparentVeryBlueCT:ColorTransform = new ColorTransform(0.3,0.3,1,0.5,0,0,0,0);
      
      public static const purpleCT:ColorTransform = new ColorTransform(1,0.5,1,1,0,0,0,0);
      
      public static const veryPurpleCT:ColorTransform = new ColorTransform(1,0.2,1,1,100,0,100,0);
      
      public static const darkCT:ColorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
      
      public static const veryDarkCT:ColorTransform = new ColorTransform(0.4,0.4,0.4,1,0,0,0,0);
      
      public static const makeWhiteCT:ColorTransform = new ColorTransform(1,1,1,1,255,255,255,0);
      
      public function MoreColorUtil(param1:StaticEnforcer)
      {
         super();
      }
      
      public static function hsvToRgb(param1:Number, param2:Number, param3:Number) : int
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc4_:int = int(param1 / 60) % 6;
         var _loc5_:Number = param1 / 60 - Math.floor(param1 / 60);
         var _loc6_:Number = param3 * (1 - param2);
         var _loc7_:Number = param3 * (1 - _loc5_ * param2);
         var _loc8_:Number = param3 * (1 - (1 - _loc5_) * param2);
         switch(_loc4_)
         {
            case 0:
               _loc9_ = param3;
               _loc10_ = _loc8_;
               _loc11_ = _loc6_;
               break;
            case 1:
               _loc9_ = _loc7_;
               _loc10_ = param3;
               _loc11_ = _loc6_;
               break;
            case 2:
               _loc9_ = _loc6_;
               _loc10_ = param3;
               _loc11_ = _loc8_;
               break;
            case 3:
               _loc9_ = _loc6_;
               _loc10_ = _loc7_;
               _loc11_ = param3;
               break;
            case 4:
               _loc9_ = _loc8_;
               _loc10_ = _loc6_;
               _loc11_ = param3;
               break;
            case 5:
               _loc9_ = param3;
               _loc10_ = _loc6_;
               _loc11_ = _loc7_;
         }
         return int(Math.min(255,Math.floor(_loc9_ * 255))) << 16 | int(Math.min(255,Math.floor(_loc10_ * 255))) << 8 | int(Math.min(255,Math.floor(_loc11_ * 255)));
      }
      
      public static function randomColor() : uint
      {
         return uint(16777215 * Math.random());
      }
      
      public static function randomColor32() : uint
      {
         return uint(16777215 * Math.random()) | 0xFF000000;
      }
      
      public static function transformColor(param1:ColorTransform, param2:uint) : uint
      {
         var _loc3_:int = ((param2 & 0xFF0000) >> 16) * param1.redMultiplier + param1.redOffset;
         _loc3_ = _loc3_ < 0 ? 0 : (_loc3_ > 255 ? 255 : _loc3_);
         var _loc4_:int = ((param2 & 0xFF00) >> 8) * param1.greenMultiplier + param1.greenOffset;
         _loc4_ = _loc4_ < 0 ? 0 : (_loc4_ > 255 ? 255 : _loc4_);
         var _loc5_:int = (param2 & 0xFF) * param1.blueMultiplier + param1.blueOffset;
         _loc5_ = _loc5_ < 0 ? 0 : (_loc5_ > 255 ? 255 : _loc5_);
         return _loc3_ << 16 | _loc4_ << 8 | _loc5_;
      }
      
      public static function copyColorTransform(param1:ColorTransform) : ColorTransform
      {
         return new ColorTransform(param1.redMultiplier,param1.greenMultiplier,param1.blueMultiplier,param1.alphaMultiplier,param1.redOffset,param1.greenOffset,param1.blueOffset,param1.alphaOffset);
      }
      
      public static function lerpColorTransform(param1:ColorTransform, param2:ColorTransform, param3:Number) : ColorTransform
      {
         if(param1 == null)
         {
            param1 = identity;
         }
         if(param2 == null)
         {
            param2 = identity;
         }
         var _loc4_:Number = 1 - param3;
         return new ColorTransform(param1.redMultiplier * _loc4_ + param2.redMultiplier * param3,param1.greenMultiplier * _loc4_ + param2.greenMultiplier * param3,param1.blueMultiplier * _loc4_ + param2.blueMultiplier * param3,param1.alphaMultiplier * _loc4_ + param2.alphaMultiplier * param3,param1.redOffset * _loc4_ + param2.redOffset * param3,param1.greenOffset * _loc4_ + param2.greenOffset * param3,param1.blueOffset * _loc4_ + param2.blueOffset * param3,param1.alphaOffset * _loc4_ + param2.alphaOffset * param3);
      }
      
      public static function lerpColor(param1:uint, param2:uint, param3:Number) : uint
      {
         var _loc4_:Number = 1 - param3;
         var _loc5_:uint = uint(param1 >> 24 & 0xFF);
         var _loc6_:uint = uint(param1 >> 16 & 0xFF);
         var _loc7_:uint = uint(param1 >> 8 & 0xFF);
         var _loc8_:uint = uint(param1 & 0xFF);
         var _loc9_:uint = uint(param2 >> 24 & 0xFF);
         var _loc10_:uint = uint(param2 >> 16 & 0xFF);
         var _loc11_:uint = uint(param2 >> 8 & 0xFF);
         var _loc12_:uint = uint(param2 & 0xFF);
         var _loc13_:uint = _loc5_ * _loc4_ + _loc9_ * param3;
         var _loc14_:uint = _loc6_ * _loc4_ + _loc10_ * param3;
         var _loc15_:uint = _loc7_ * _loc4_ + _loc11_ * param3;
         var _loc16_:uint = _loc8_ * _loc4_ + _loc12_ * param3;
         return uint(_loc13_ << 24 | _loc14_ << 16 | _loc15_ << 8 | _loc16_);
      }
      
      public static function transformAlpha(param1:ColorTransform, param2:Number) : Number
      {
         var _loc3_:uint = param2 * 255;
         var _loc4_:uint = _loc3_ * param1.alphaMultiplier + param1.alphaOffset;
         _loc4_ = _loc4_ < 0 ? 0 : (_loc4_ > 255 ? 255 : _loc4_);
         return _loc4_ / 255;
      }
      
      public static function multiplyColor(param1:uint, param2:Number) : uint
      {
         var _loc3_:int = ((param1 & 0xFF0000) >> 16) * param2;
         _loc3_ = _loc3_ < 0 ? 0 : (_loc3_ > 255 ? 255 : _loc3_);
         var _loc4_:int = ((param1 & 0xFF00) >> 8) * param2;
         _loc4_ = _loc4_ < 0 ? 0 : (_loc4_ > 255 ? 255 : _loc4_);
         var _loc5_:int = (param1 & 0xFF) * param2;
         _loc5_ = _loc5_ < 0 ? 0 : (_loc5_ > 255 ? 255 : _loc5_);
         return _loc3_ << 16 | _loc4_ << 8 | _loc5_;
      }
      
      public static function adjustBrightness(param1:uint, param2:Number) : uint
      {
         var _loc3_:uint = uint(param1 & 0xFF000000);
         var _loc4_:int = ((param1 & 0xFF0000) >> 16) + param2 * 255;
         _loc4_ = _loc4_ < 0 ? 0 : (_loc4_ > 255 ? 255 : _loc4_);
         var _loc5_:int = ((param1 & 0xFF00) >> 8) + param2 * 255;
         _loc5_ = _loc5_ < 0 ? 0 : (_loc5_ > 255 ? 255 : _loc5_);
         var _loc6_:int = (param1 & 0xFF) + param2 * 255;
         _loc6_ = _loc6_ < 0 ? 0 : (_loc6_ > 255 ? 255 : _loc6_);
         return _loc3_ | _loc4_ << 16 | _loc5_ << 8 | _loc6_;
      }
      
      public static function colorToShaderParameter(param1:uint) : Array
      {
         var _loc2_:Number = (param1 >> 24 & 0xFF) / 256;
         return [_loc2_ * ((param1 >> 16 & 0xFF) / 256),_loc2_ * ((param1 >> 8 & 0xFF) / 256),_loc2_ * ((param1 & 0xFF) / 256),_loc2_];
      }
      
      public static function rgbToGreyscale(param1:uint) : uint
      {
         var _loc2_:uint = ((param1 & 0xFF0000) >> 16) * 0.3 + ((param1 & 0xFF00) >> 8) * 0.59 + (param1 & 0xFF) * 0.11;
         return (param1 && 4278190080) | _loc2_ << 16 | _loc2_ << 8 | _loc2_;
      }
      
      public static function singleColorFilterMatrix(param1:uint) : Array
      {
         return [0,0,0,0,(param1 & 0xFF0000) >> 16,0,0,0,0,(param1 & 0xFF00) >> 8,0,0,0,0,param1 & 0xFF,0,0,0,1,0];
      }
   }
}

class StaticEnforcer
{
   
   public function StaticEnforcer()
   {
      super();
   }
}
