package kabam.rotmg.stage3D.graphic3D
{
   import flash.display.BitmapData;
   import flash.display3D.Context3DTextureFormat;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import kabam.rotmg.stage3D.proxies.Context3DProxy;
   import kabam.rotmg.stage3D.proxies.TextureProxy;
   
   public class TextureFactory
   {
      
      private static var textures:Dictionary = new Dictionary();
      
      private static var flippedTextures:Dictionary = new Dictionary();
      
      private static var count:int = 0;
      
      [Inject]
      public var context3D:Context3DProxy;
      
      public function TextureFactory()
      {
         super();
      }
      
      public static function GetFlippedBitmapData(param1:BitmapData) : BitmapData
      {
         var _loc2_:BitmapData = null;
         if(param1 in flippedTextures)
         {
            return flippedTextures[param1];
         }
         _loc2_ = flipBitmapData(param1,"y");
         flippedTextures[param1] = _loc2_;
         return _loc2_;
      }
      
      private static function flipBitmapData(param1:BitmapData, param2:String = "x") : BitmapData
      {
         var _loc4_:Matrix = null;
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         if(param2 == "x")
         {
            _loc4_ = new Matrix(-1,0,0,1,param1.width,0);
         }
         else
         {
            _loc4_ = new Matrix(1,0,0,-1,0,param1.height);
         }
         _loc3_.draw(param1,_loc4_,null,null,null,true);
         return _loc3_;
      }
      
      private static function getNextPowerOf2(param1:int) : Number
      {
         param1--;
         param1 |= param1 >> 1;
         param1 |= param1 >> 2;
         param1 |= param1 >> 4;
         param1 |= param1 >> 8;
         param1 |= param1 >> 16;
         return ++param1;
      }
      
      public static function disposeTextures() : void
      {
         var _loc1_:TextureProxy = null;
         var _loc2_:BitmapData = null;
         for each(_loc1_ in textures)
         {
            _loc1_.dispose();
         }
         textures = new Dictionary();
         for each(_loc2_ in flippedTextures)
         {
            _loc2_.dispose();
         }
         flippedTextures = new Dictionary();
         count = 0;
      }
      
      public static function disposeNormalTextures() : void
      {
         var _loc1_:TextureProxy = null;
         for each(_loc1_ in textures)
         {
            _loc1_.dispose();
         }
         textures = new Dictionary();
      }
      
      public function make(param1:BitmapData) : TextureProxy
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TextureProxy = null;
         var _loc5_:BitmapData = null;
         if(param1 == null)
         {
            return null;
         }
         if(param1 in textures)
         {
            return textures[param1];
         }
         _loc2_ = getNextPowerOf2(param1.width);
         _loc3_ = getNextPowerOf2(param1.height);
         _loc4_ = this.context3D.createTexture(_loc2_,_loc3_,Context3DTextureFormat.BGRA,false);
         _loc5_ = new BitmapData(_loc2_,_loc3_,true,0);
         _loc5_.copyPixels(param1,param1.rect,new Point(0,0));
         _loc4_.uploadFromBitmapData(_loc5_);
         if(count > 1000)
         {
            disposeNormalTextures();
            count = 0;
         }
         textures[param1] = _loc4_;
         ++count;
         return _loc4_;
      }
   }
}

