package kabam.rotmg.stage3D.proxies
{
   import flash.display3D.Program3D;
   import flash.utils.ByteArray;
   
   public class Program3DProxy
   {
      
      private var program3D:Program3D;
      
      public function Program3DProxy(param1:Program3D)
      {
         super();
         this.program3D = param1;
      }
      
      public function upload(param1:ByteArray, param2:ByteArray) : void
      {
         this.program3D.upload(param1,param2);
      }
      
      public function getProgram3D() : Program3D
      {
         return this.program3D;
      }
   }
}

