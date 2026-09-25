package robotlegs.bender.extensions.signalCommandMap.impl
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
   import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
   import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
   
   public class SignalCommandMap implements ISignalCommandMap
   {
      
      private const _signalTriggers:Dictionary = new Dictionary();
      
      private var _injector:Injector;
      
      private var _commandMap:ICommandCenter;
      
      public function SignalCommandMap(param1:Injector, param2:ICommandCenter)
      {
         super();
         this._injector = param1;
         this._commandMap = param2;
      }
      
      public function map(param1:Class, param2:Boolean = false) : ICommandMapper
      {
         var _loc3_:ICommandTrigger = this._signalTriggers[param1] = this._signalTriggers[param1] || this.createSignalTrigger(param1,param2);
         return this._commandMap.map(_loc3_);
      }
      
      public function unmap(param1:Class) : ICommandUnmapper
      {
         return this._commandMap.unmap(this.getSignalTrigger(param1));
      }
      
      private function createSignalTrigger(param1:Class, param2:Boolean = false) : ICommandTrigger
      {
         return new SignalCommandTrigger(this._injector,param1,param2);
      }
      
      private function getSignalTrigger(param1:Class) : ICommandTrigger
      {
         return this._signalTriggers[param1];
      }
   }
}

