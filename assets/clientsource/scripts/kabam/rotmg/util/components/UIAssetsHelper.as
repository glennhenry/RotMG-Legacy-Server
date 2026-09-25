package kabam.rotmg.util.components
{
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class UIAssetsHelper
   {
      
      public static const LEFT_NEVIGATOR:String = "left";
      
      public static const RIGHT_NEVIGATOR:String = "right";
      
      public function UIAssetsHelper()
      {
         super();
      }
      
      public static function createLeftNevigatorIcon(param1:String = "left", param2:int = 4, param3:Number = 0) : Sprite
      {
         var _loc4_:BitmapData = null;
         if(param1 == LEFT_NEVIGATOR)
         {
            _loc4_ = AssetLibrary.getImageFromSet("lofiInterface",55);
         }
         else
         {
            _loc4_ = AssetLibrary.getImageFromSet("lofiInterface",54);
         }
         var _loc5_:Bitmap = new Bitmap(_loc4_);
         _loc5_.scaleX = param2;
         _loc5_.scaleY = param2;
         _loc5_.rotation = param3;
         var _loc6_:Sprite = new Sprite();
         _loc6_.addChild(_loc5_);
         return _loc6_;
      }
   }
}

