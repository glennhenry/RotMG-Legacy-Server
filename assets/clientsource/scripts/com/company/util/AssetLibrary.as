package com.company.util
{
   import flash.display.BitmapData;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class AssetLibrary
   {
      
      private static var images_:Dictionary = new Dictionary();
      
      private static var imageSets_:Dictionary = new Dictionary();
      
      private static var sounds_:Dictionary = new Dictionary();
      
      private static var imageLookup_:Dictionary = new Dictionary();
      
      public function AssetLibrary(param1:StaticEnforcer)
      {
         super();
      }
      
      public static function addImage(param1:String, param2:BitmapData) : void
      {
         images_[param1] = param2;
         imageLookup_[param2] = param1;
      }
      
      public static function addImageSet(param1:String, param2:BitmapData, param3:int, param4:int) : void
      {
         images_[param1] = param2;
         var _loc5_:ImageSet = new ImageSet();
         _loc5_.addFromBitmapData(param2,param3,param4);
         imageSets_[param1] = _loc5_;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.images_.length)
         {
            imageLookup_[_loc5_.images_[_loc6_]] = [param1,_loc6_];
            _loc6_++;
         }
      }
      
      public static function addToImageSet(param1:String, param2:BitmapData) : void
      {
         var _loc3_:ImageSet = imageSets_[param1];
         if(_loc3_ == null)
         {
            _loc3_ = new ImageSet();
            imageSets_[param1] = _loc3_;
         }
         _loc3_.add(param2);
         var _loc4_:int = _loc3_.images_.length - 1;
         imageLookup_[_loc3_.images_[_loc4_]] = [param1,_loc4_];
      }
      
      public static function addSound(param1:String, param2:Class) : void
      {
         var _loc3_:Array = sounds_[param1];
         if(_loc3_ == null)
         {
            sounds_[param1] = new Array();
         }
         sounds_[param1].push(param2);
      }
      
      public static function lookupImage(param1:BitmapData) : Object
      {
         return imageLookup_[param1];
      }
      
      public static function getImage(param1:String) : BitmapData
      {
         return images_[param1];
      }
      
      public static function getImageSet(param1:String) : ImageSet
      {
         return imageSets_[param1];
      }
      
      public static function getImageFromSet(param1:String, param2:int) : BitmapData
      {
         var _loc3_:ImageSet = imageSets_[param1];
         return _loc3_.images_[param2];
      }
      
      public static function getSound(param1:String) : Sound
      {
         var _loc2_:Array = sounds_[param1];
         var _loc3_:int = Math.random() * _loc2_.length;
         return new sounds_[param1][_loc3_]();
      }
      
      public static function playSound(param1:String, param2:Number = 1) : void
      {
         var _loc3_:Array = sounds_[param1];
         var _loc4_:int = Math.random() * _loc3_.length;
         var _loc5_:Sound = new sounds_[param1][_loc4_]();
         var _loc6_:SoundTransform = null;
         if(param2 != 1)
         {
            _loc6_ = new SoundTransform(param2);
         }
         _loc5_.play(0,0,_loc6_);
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
