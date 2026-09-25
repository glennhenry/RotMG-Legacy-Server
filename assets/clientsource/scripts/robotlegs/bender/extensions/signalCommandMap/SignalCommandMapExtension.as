package robotlegs.bender.extensions.signalCommandMap
{
   import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
   import robotlegs.bender.extensions.signalCommandMap.impl.SignalCommandMap;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class SignalCommandMapExtension implements IExtension
   {
      
      private const _uid:String = UID.create(SignalCommandMapExtension);
      
      public function SignalCommandMapExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         param1.injector.map(ISignalCommandMap).toSingleton(SignalCommandMap);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
   }
}

