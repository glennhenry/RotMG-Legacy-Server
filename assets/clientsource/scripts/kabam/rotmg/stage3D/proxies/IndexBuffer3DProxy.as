package kabam.rotmg.stage3D.proxies
{
   import flash.display3D.IndexBuffer3D;
   
   public class IndexBuffer3DProxy
   {
      
      private var indexBuffer:IndexBuffer3D;
      
      public function IndexBuffer3DProxy(param1:IndexBuffer3D)
      {
         super();
         this.indexBuffer = param1;
      }
      
      public function uploadFromVector(param1:Vector.<uint>, param2:int, param3:int) : void
      {
         this.indexBuffer.uploadFromVector(param1,param2,param3);
      }
      
      public function getIndexBuffer3D() : IndexBuffer3D
      {
         return this.indexBuffer;
      }
   }
}

