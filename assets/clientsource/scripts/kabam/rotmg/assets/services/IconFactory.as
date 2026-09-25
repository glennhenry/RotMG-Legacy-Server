package kabam.rotmg.assets.services
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import com.company.util.AssetLibrary;
   import com.company.util.BitmapUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class IconFactory
   {
      
      public function IconFactory()
      {
         super();
      }
      
      public static function makeCoin() : BitmapData
      {
         var _loc1_:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3",225),null,40,true,0,0);
         return cropAndGlowIcon(_loc1_);
      }
      
      public static function makeFortune() : BitmapData
      {
         var _loc1_:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiCharBig",32),null,20,true,0,0);
         return cropAndGlowIcon(_loc1_);
      }
      
      public static function makeFame() : BitmapData
      {
         var _loc1_:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3",224),null,40,true,0,0);
         return cropAndGlowIcon(_loc1_);
      }
      
      public static function makeGuildFame() : BitmapData
      {
         var _loc1_:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3",226),null,40,true,0,0);
         return cropAndGlowIcon(_loc1_);
      }
      
      private static function cropAndGlowIcon(param1:BitmapData) : BitmapData
      {
         param1 = GlowRedrawer.outlineGlow(param1,4294967295);
         return BitmapUtil.cropToBitmapData(param1,10,10,param1.width - 20,param1.height - 20);
      }
      
      public function makeIconBitmap(param1:int) : Bitmap
      {
         var _loc2_:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig",param1);
         _loc2_ = TextureRedrawer.redraw(_loc2_,320 / _loc2_.width,true,0);
         return new Bitmap(_loc2_);
      }
   }
}

