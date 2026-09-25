package com.company.assembleegameclient.util
{
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class AnimatedChars
   {
      
      private static var nameMap_:Dictionary = new Dictionary();
      
      public function AnimatedChars()
      {
         super();
      }
      
      public static function getAnimatedChar(param1:String, param2:int) : AnimatedChar
      {
         var _loc3_:Vector.<AnimatedChar> = nameMap_[param1];
         if(_loc3_ == null || param2 >= _loc3_.length)
         {
            return null;
         }
         return _loc3_[param2];
      }
      
      public static function add(param1:String, param2:BitmapData, param3:BitmapData, param4:int, param5:int, param6:int, param7:int, param8:int) : void
      {
         var _loc11_:MaskedImage = null;
         var _loc9_:Vector.<AnimatedChar> = new Vector.<AnimatedChar>();
         var _loc10_:MaskedImageSet = new MaskedImageSet();
         _loc10_.addFromBitmapData(param2,param3,param6,param7);
         for each(_loc11_ in _loc10_.images_)
         {
            _loc9_.push(new AnimatedChar(_loc11_,param4,param5,param8));
         }
         nameMap_[param1] = _loc9_;
      }
   }
}

