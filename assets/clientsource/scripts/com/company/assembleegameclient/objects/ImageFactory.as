package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   
   public class ImageFactory
   {
      
      public function ImageFactory()
      {
         super();
      }
      
      public function getImageFromSet(param1:String, param2:int) : BitmapData
      {
         return AssetLibrary.getImageFromSet(param1,param2);
      }
      
      public function getTexture(param1:int, param2:int) : BitmapData
      {
         var _loc4_:Number = NaN;
         var _loc5_:BitmapData = null;
         var _loc3_:BitmapData = ObjectLibrary.getBitmapData(param1);
         if(_loc3_)
         {
            _loc4_ = (param2 - TextureRedrawer.minSize) / _loc3_.width;
            return ObjectLibrary.getRedrawnTextureFromType(param1,100,true,false,_loc4_);
         }
         return new BitmapDataSpy(param2,param2);
      }
   }
}

