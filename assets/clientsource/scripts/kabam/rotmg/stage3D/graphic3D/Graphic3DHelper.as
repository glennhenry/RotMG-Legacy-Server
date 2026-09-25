package kabam.rotmg.stage3D.graphic3D
{
   import kabam.rotmg.stage3D.proxies.IndexBuffer3DProxy;
   import kabam.rotmg.stage3D.proxies.VertexBuffer3DProxy;
   import org.swiftsuspenders.Injector;
   
   public class Graphic3DHelper
   {
      
      public function Graphic3DHelper()
      {
         super();
      }
      
      public static function map(param1:Injector) : void
      {
         injectSingletonIndexBuffer(param1);
         injectSingletonVertexBuffer(param1);
      }
      
      private static function injectSingletonIndexBuffer(param1:Injector) : void
      {
         var _loc2_:IndexBufferFactory = param1.getInstance(IndexBufferFactory);
         param1.map(IndexBuffer3DProxy).toProvider(_loc2_);
      }
      
      private static function injectSingletonVertexBuffer(param1:Injector) : void
      {
         var _loc2_:VertexBufferFactory = param1.getInstance(VertexBufferFactory);
         param1.map(VertexBuffer3DProxy).toProvider(_loc2_);
      }
   }
}

