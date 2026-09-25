package kabam.rotmg.stage3D.proxies
{
   import flash.display3D.VertexBuffer3D;
   
   public class VertexBuffer3DProxy
   {
      
      private var vertexBuffer3D:VertexBuffer3D;
      
      protected var data:Vector.<Number>;
      
      public function VertexBuffer3DProxy(param1:VertexBuffer3D)
      {
         super();
         this.vertexBuffer3D = param1;
      }
      
      public function uploadFromVector(param1:Vector.<Number>, param2:int, param3:int) : void
      {
         this.data = param1;
         this.vertexBuffer3D.uploadFromVector(param1,param2,param3);
      }
      
      public function getVertexBuffer3D() : VertexBuffer3D
      {
         return this.vertexBuffer3D;
      }
      
      public function getData() : Vector.<Number>
      {
         return this.data;
      }
   }
}

