package robotlegs.bender.extensions.eventCommandMap.impl
{
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
   import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
   import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
   
   public class EventCommandMap implements IEventCommandMap
   {
      
      private const _triggers:Dictionary = new Dictionary();
      
      private var _injector:Injector;
      
      private var _dispatcher:IEventDispatcher;
      
      private var _commandCenter:ICommandCenter;
      
      public function EventCommandMap(param1:Injector, param2:IEventDispatcher, param3:ICommandCenter)
      {
         super();
         this._injector = param1;
         this._dispatcher = param2;
         this._commandCenter = param3;
      }
      
      public function map(param1:String, param2:Class = null) : ICommandMapper
      {
         var _loc3_:ICommandTrigger = this._triggers[param1 + param2] = this._triggers[param1 + param2] || this.createTrigger(param1,param2);
         return this._commandCenter.map(_loc3_);
      }
      
      public function unmap(param1:String, param2:Class = null) : ICommandUnmapper
      {
         return this._commandCenter.unmap(this.getTrigger(param1,param2));
      }
      
      private function createTrigger(param1:String, param2:Class = null) : ICommandTrigger
      {
         return new EventCommandTrigger(this._injector,this._dispatcher,param1,param2);
      }
      
      private function getTrigger(param1:String, param2:Class = null) : ICommandTrigger
      {
         return this._triggers[param1 + param2];
      }
   }
}

