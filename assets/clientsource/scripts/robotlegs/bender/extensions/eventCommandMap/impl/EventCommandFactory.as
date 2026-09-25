package robotlegs.bender.extensions.eventCommandMap.impl
{
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
   import robotlegs.bender.framework.impl.applyHooks;
   import robotlegs.bender.framework.impl.guardsApprove;
   
   public class EventCommandFactory
   {
      
      private var _injector:Injector;
      
      public function EventCommandFactory(param1:Injector)
      {
         super();
         this._injector = param1;
      }
      
      public function create(param1:ICommandMapping) : Object
      {
         var _loc2_:Class = null;
         var _loc3_:Object = null;
         if(guardsApprove(param1.guards,this._injector))
         {
            _loc2_ = param1.commandClass;
            this._injector.map(_loc2_).asSingleton();
            _loc3_ = this._injector.getInstance(_loc2_);
            applyHooks(param1.hooks,this._injector);
            this._injector.unmap(_loc2_);
            return _loc3_;
         }
         return null;
      }
   }
}

