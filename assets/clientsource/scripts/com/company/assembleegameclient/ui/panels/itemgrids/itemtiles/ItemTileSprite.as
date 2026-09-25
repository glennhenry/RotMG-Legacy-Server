package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import kabam.rotmg.constants.ItemConstants;
   import kabam.rotmg.text.view.BitmapTextFactory;
   import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
   
   public class ItemTileSprite extends Sprite
   {
      
      protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4,0,0,0,0,0,0.4,0,0,0,0,0,0.4,0,0,0,0,0,1,0])];
      
      private static const IDENTITY_MATRIX:Matrix = new Matrix();
      
      private static const DOSE_MATRIX:Matrix = (function():Matrix
      {
         var _loc1_:* = new Matrix();
         _loc1_.translate(10,5);
         return _loc1_;
      })();
      
      public var itemId:int;
      
      public var itemBitmap:Bitmap;
      
      private var bitmapFactory:BitmapTextFactory;
      
      public function ItemTileSprite()
      {
         super();
         this.itemBitmap = new Bitmap();
         addChild(this.itemBitmap);
         this.itemId = -1;
      }
      
      public function setDim(param1:Boolean) : void
      {
         filters = param1 ? DIM_FILTER : null;
      }
      
      public function setType(param1:int) : void
      {
         this.itemId = param1;
         this.drawTile();
      }
      
      public function drawTile() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:XML = null;
         var _loc3_:BitmapData = null;
         if(this.itemId != ItemConstants.NO_ITEM)
         {
            _loc1_ = ObjectLibrary.getRedrawnTextureFromType(this.itemId,80,true);
            _loc2_ = ObjectLibrary.xmlLibrary_[this.itemId];
            if(Boolean(_loc2_) && Boolean(_loc2_.hasOwnProperty("Doses")) && Boolean(this.bitmapFactory))
            {
               _loc1_ = _loc1_.clone();
               _loc3_ = this.bitmapFactory.make(new StaticStringBuilder(String(_loc2_.Doses)),12,16777215,false,IDENTITY_MATRIX,false);
               _loc1_.draw(_loc3_,DOSE_MATRIX);
            }
            this.itemBitmap.bitmapData = _loc1_;
            this.itemBitmap.x = -_loc1_.width / 2;
            this.itemBitmap.y = -_loc1_.height / 2;
            visible = true;
         }
         else
         {
            visible = false;
         }
      }
      
      public function setBitmapFactory(param1:BitmapTextFactory) : void
      {
         this.bitmapFactory = param1;
      }
   }
}

