package kabam.rotmg.stage3D.proxies
{
   import flash.display.BitmapData;
   import flash.display3D.textures.Texture;
   import flash.display3D.textures.TextureBase;
   
   public class TextureProxy
   {
      
      private var texture:Texture;
      
      protected var width:int;
      
      protected var height:int;
      
      public function TextureProxy(param1:Texture)
      {
         super();
         this.texture = param1;
      }
      
      public function uploadFromBitmapData(param1:BitmapData) : void
      {
         this.width = param1.width;
         this.height = param1.height;
         this.texture.uploadFromBitmapData(param1);
      }
      
      public function getTexture() : TextureBase
      {
         return this.texture;
      }
      
      public function getWidth() : int
      {
         return this.width;
      }
      
      public function getHeight() : int
      {
         return this.height;
      }
      
      public function dispose() : void
      {
         this.texture.dispose();
      }
   }
}

