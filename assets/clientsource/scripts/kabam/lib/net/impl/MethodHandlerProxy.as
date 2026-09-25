package kabam.lib.net.impl
{
   import kabam.lib.net.api.MessageHandlerProxy;
   
   public class MethodHandlerProxy implements MessageHandlerProxy
   {
      
      private var method:Function;
      
      public function MethodHandlerProxy()
      {
         super();
      }
      
      public function setMethod(param1:Function) : MethodHandlerProxy
      {
         this.method = param1;
         return this;
      }
      
      public function getMethod() : Function
      {
         return this.method;
      }
   }
}

