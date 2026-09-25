package robotlegs.bender.extensions.logging
{
   import robotlegs.bender.extensions.logging.integration.LoggerProvider;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.api.ILogger;
   import robotlegs.bender.framework.impl.UID;
   
   public class LoggingExtension implements IExtension
   {
      
      private const _uid:String = UID.create(LoggingExtension);
      
      public function LoggingExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         param1.injector.map(ILogger).toProvider(new LoggerProvider(param1));
      }
      
      public function toString() : String
      {
         return this._uid;
      }
   }
}

