package kabam.lib.net.impl
{
   import kabam.lib.net.api.MessageHandlerProxy;
   import org.swiftsuspenders.Injector;
   
   public class ClassHandlerProxy implements MessageHandlerProxy
   {
      
      private var injector:Injector;
      
      private var handlerType:Class;
      
      private var handler:Object;
      
      public function ClassHandlerProxy()
      {
         super();
      }
      
      public function setType(param1:Class) : ClassHandlerProxy
      {
         this.handlerType = param1;
         return this;
      }
      
      public function setInjector(param1:Injector) : ClassHandlerProxy
      {
         this.injector = param1;
         return this;
      }
      
      public function getMethod() : Function
      {
         return this.handler ? this.handler.execute : this.makeHandlerAndReturnExecute();
      }
      
      private function makeHandlerAndReturnExecute() : Function
      {
         if(!this.handlerType)
         {
            return null;
         }
         this.handler = this.injector.getInstance(this.handlerType);
         return this.handler.execute;
      }
   }
}

