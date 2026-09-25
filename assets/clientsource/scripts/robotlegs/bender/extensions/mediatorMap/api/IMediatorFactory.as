package robotlegs.bender.extensions.mediatorMap.api
{
   import flash.events.IEventDispatcher;
   
   public interface IMediatorFactory extends IEventDispatcher
   {
      
      function getMediator(param1:Object, param2:IMediatorMapping) : Object;
      
      function createMediators(param1:Object, param2:Class, param3:Array) : Array;
      
      function removeMediators(param1:Object) : void;
      
      function removeAllMediators() : void;
   }
}

