package robotlegs.bender.extensions.logging
{
   import robotlegs.bender.extensions.logging.impl.TraceLogTarget;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class TraceLoggingExtension implements IExtension
   {
      
      private const _uid:String = UID.create(TraceLoggingExtension);
      
      public function TraceLoggingExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         param1.addLogTarget(new TraceLogTarget(param1));
      }
      
      public function toString() : String
      {
         return this._uid;
      }
   }
}

