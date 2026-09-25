package com.company.util
{
   import flash.display.BitmapData;
   import flash.filters.BitmapFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class CachingColorTransformer
   {
      
      private static var bds_:Dictionary = new Dictionary();
      
      public function CachingColorTransformer()
      {
         super();
      }
      
      public static function transformBitmapData(param1:BitmapData, param2:ColorTransform) : BitmapData
      {
         var _loc3_:BitmapData = null;
         var _loc4_:Object = bds_[param1];
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_[param2];
         }
         else
         {
            _loc4_ = new Object();
            bds_[param1] = _loc4_;
         }
         if(_loc3_ == null)
         {
            _loc3_ = param1.clone();
            _loc3_.colorTransform(_loc3_.rect,param2);
            _loc4_[param2] = _loc3_;
         }
         return _loc3_;
      }
      
      public static function filterBitmapData(param1:BitmapData, param2:BitmapFilter) : BitmapData
      {
         var _loc3_:BitmapData = null;
         var _loc4_:Object = bds_[param1];
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_[param2];
         }
         else
         {
            _loc4_ = new Object();
            bds_[param1] = _loc4_;
         }
         if(_loc3_ == null)
         {
            _loc3_ = param1.clone();
            _loc3_.applyFilter(_loc3_,_loc3_.rect,new Point(),param2);
            _loc4_[param2] = _loc3_;
         }
         return _loc3_;
      }
      
      public static function alphaBitmapData(param1:BitmapData, param2:Number) : BitmapData
      {
         var _loc3_:int = int(param2 * 100);
         var _loc4_:ColorTransform = new ColorTransform(1,1,1,_loc3_ / 100);
         return transformBitmapData(param1,_loc4_);
      }
      
      public static function clear() : void
      {
         var _loc1_:Object = null;
         var _loc2_:BitmapData = null;
         for each(_loc1_ in bds_)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.dispose();
            }
         }
         bds_ = new Dictionary();
      }
   }
}

