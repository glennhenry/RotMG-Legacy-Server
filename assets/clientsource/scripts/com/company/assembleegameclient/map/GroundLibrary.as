package com.company.assembleegameclient.map
{
   import com.company.assembleegameclient.objects.TextureDataConcrete;
   import com.company.util.BitmapUtil;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class GroundLibrary
   {
      
      public static var defaultProps_:GroundProperties;
      
      public static const propsLibrary_:Dictionary = new Dictionary();
      
      public static const xmlLibrary_:Dictionary = new Dictionary();
      
      private static var tileTypeColorDict_:Dictionary = new Dictionary();
      
      public static const typeToTextureData_:Dictionary = new Dictionary();
      
      public static var idToType_:Dictionary = new Dictionary();
      
      public function GroundLibrary()
      {
         super();
      }
      
      public static function parseFromXML(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         for each(_loc2_ in param1.Ground)
         {
            _loc3_ = int(_loc2_.@type);
            propsLibrary_[_loc3_] = new GroundProperties(_loc2_);
            xmlLibrary_[_loc3_] = _loc2_;
            typeToTextureData_[_loc3_] = new TextureDataConcrete(_loc2_);
            idToType_[String(_loc2_.@id)] = _loc3_;
         }
         defaultProps_ = propsLibrary_[255];
      }
      
      public static function getIdFromType(param1:int) : String
      {
         var _loc2_:GroundProperties = propsLibrary_[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return _loc2_.id_;
      }
      
      public static function getBitmapData(param1:int, param2:int = 0) : BitmapData
      {
         return typeToTextureData_[param1].getTexture(param2);
      }
      
      public static function getColor(param1:int) : uint
      {
         var _loc2_:XML = null;
         var _loc3_:uint = 0;
         var _loc4_:BitmapData = null;
         if(!tileTypeColorDict_.hasOwnProperty(param1))
         {
            _loc2_ = xmlLibrary_[param1];
            if(_loc2_.hasOwnProperty("Color"))
            {
               _loc3_ = uint(_loc2_.Color);
            }
            else
            {
               _loc4_ = getBitmapData(param1);
               _loc3_ = BitmapUtil.mostCommonColor(_loc4_);
            }
            tileTypeColorDict_[param1] = _loc3_;
         }
         return tileTypeColorDict_[param1];
      }
   }
}

