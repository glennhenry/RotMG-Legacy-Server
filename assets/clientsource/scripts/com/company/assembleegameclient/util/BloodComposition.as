package com.company.assembleegameclient.util
{
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class BloodComposition
   {
      
      private static var idDict_:Dictionary = new Dictionary();
      
      private static var imageDict_:Dictionary = new Dictionary();
      
      public function BloodComposition()
      {
         super();
      }
      
      public static function getBloodComposition(param1:int, param2:BitmapData, param3:Number, param4:uint) : Vector.<uint>
      {
         var _loc5_:Vector.<uint> = idDict_[param1];
         if(_loc5_ != null)
         {
            return _loc5_;
         }
         _loc5_ = new Vector.<uint>();
         var _loc6_:Vector.<uint> = getColors(param2);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            if(Math.random() < param3)
            {
               _loc5_.push(param4);
            }
            else
            {
               _loc5_.push(_loc6_[int(_loc6_.length * Math.random())]);
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      public static function getColors(param1:BitmapData) : Vector.<uint>
      {
         var _loc2_:Vector.<uint> = imageDict_[param1];
         if(_loc2_ == null)
         {
            _loc2_ = buildColors(param1);
            imageDict_[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      private static function buildColors(param1:BitmapData) : Vector.<uint>
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         var _loc3_:int = 0;
         while(_loc3_ < param1.width)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.height)
            {
               _loc5_ = param1.getPixel32(_loc3_,_loc4_);
               if((_loc5_ & 0xFF000000) != 0)
               {
                  _loc2_.push(_loc5_);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

