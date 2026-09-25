package com.company.assembleegameclient.util
{
   import com.company.util.BitmapUtil;
   import flash.display.BitmapData;
   
   public class MaskedImage
   {
      
      public var image_:BitmapData;
      
      public var mask_:BitmapData;
      
      public function MaskedImage(param1:BitmapData, param2:BitmapData)
      {
         super();
         this.image_ = param1;
         this.mask_ = param2;
      }
      
      public function width() : int
      {
         return this.image_.width;
      }
      
      public function height() : int
      {
         return this.image_.height;
      }
      
      public function mirror(param1:int = 0) : MaskedImage
      {
         var _loc2_:BitmapData = BitmapUtil.mirror(this.image_,param1);
         var _loc3_:BitmapData = this.mask_ == null ? null : BitmapUtil.mirror(this.mask_,param1);
         return new MaskedImage(_loc2_,_loc3_);
      }
      
      public function amountTransparent() : Number
      {
         return BitmapUtil.amountTransparent(this.image_);
      }
   }
}

