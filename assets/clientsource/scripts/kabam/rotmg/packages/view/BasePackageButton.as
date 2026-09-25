package kabam.rotmg.packages.view
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import com.company.util.BitmapUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   
   public class BasePackageButton extends Sprite
   {
      
      public static const IMAGE_NAME:String = "redLootBag";
      
      public static const IMAGE_ID:int = 0;
      
      public function BasePackageButton()
      {
         super();
      }
      
      protected static function makeIcon() : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:BitmapData = AssetLibrary.getImageFromSet(IMAGE_NAME,IMAGE_ID);
         _loc1_ = TextureRedrawer.redraw(_loc1_,40,true,0);
         _loc1_ = BitmapUtil.cropToBitmapData(_loc1_,10,10,_loc1_.width - 20,_loc1_.height - 20);
         _loc2_ = new Bitmap(_loc1_);
         _loc2_.x = 3;
         _loc2_.y = 3;
         return _loc2_;
      }
      
      protected function positionText(param1:DisplayObject, param2:TextFieldDisplayConcrete) : void
      {
         var _loc4_:Number = NaN;
         var _loc3_:Rectangle = param1.getBounds(this);
         _loc4_ = _loc3_.top + _loc3_.height / 2;
         param2.x = _loc3_.right;
         param2.y = _loc4_ - param2.height / 2;
      }
   }
}

