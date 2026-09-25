package com.company.assembleegameclient.util
{
   import flash.utils.Dictionary;
   
   public class FreeList
   {
      
      private static var dict_:Dictionary = new Dictionary();
      
      public function FreeList()
      {
         super();
      }
      
      public static function newObject(param1:Class) : Object
      {
         var _loc2_:Vector.<Object> = dict_[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new Vector.<Object>();
            dict_[param1] = _loc2_;
         }
         else if(_loc2_.length > 0)
         {
            return _loc2_.pop();
         }
         return new param1();
      }
      
      public static function storeObject(param1:*, param2:Object) : void
      {
         var _loc3_:Vector.<Object> = dict_[param1];
         if(_loc3_ == null)
         {
            _loc3_ = new Vector.<Object>();
            dict_[param1] = _loc3_;
         }
         _loc3_.push(param2);
      }
      
      public static function getObject(param1:*) : Object
      {
         var _loc2_:Vector.<Object> = dict_[param1];
         if(_loc2_ != null && _loc2_.length > 0)
         {
            return _loc2_.pop();
         }
         return null;
      }
      
      public static function dump(param1:*) : void
      {
         delete dict_[param1];
      }
      
      public static function deleteObject(param1:Object) : void
      {
         var _loc2_:Class = Object(param1).constructor;
         var _loc3_:Vector.<Object> = dict_[_loc2_];
         if(_loc3_ == null)
         {
            _loc3_ = new Vector.<Object>();
            dict_[_loc2_] = _loc3_;
         }
         _loc3_.push(param1);
      }
   }
}

