package robotlegs.bender.extensions.eventDispatcher
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class EventDispatcherExtension implements IExtension
   {
      
      private const _uid:String = UID.create(EventDispatcherExtension);
      
      private var _eventDispatcher:IEventDispatcher;
      
      public function EventDispatcherExtension(param1:IEventDispatcher = null)
      {
         super();
         this._eventDispatcher = param1 || new EventDispatcher();
      }
      
      public function extend(param1:IContext) : void
      {
         param1.injector.map(IEventDispatcher).toValue(this._eventDispatcher);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
   }
}

