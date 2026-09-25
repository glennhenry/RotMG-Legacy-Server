package robotlegs.bender.extensions.eventCommandMap
{
   import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
   import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class EventCommandMapExtension implements IExtension
   {
      
      private const _uid:String = UID.create(EventCommandMapExtension);
      
      public function EventCommandMapExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         param1.injector.map(IEventCommandMap).toSingleton(EventCommandMap);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
   }
}

