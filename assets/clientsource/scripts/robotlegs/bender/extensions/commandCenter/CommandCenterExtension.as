package robotlegs.bender.extensions.commandCenter
{
   import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
   import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class CommandCenterExtension implements IExtension
   {
      
      private const _uid:String = UID.create(CommandCenterExtension);
      
      public function CommandCenterExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         param1.injector.map(ICommandCenter).toSingleton(CommandCenter);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
   }
}

