package robotlegs.bender.framework.api
{
   import flash.events.IEventDispatcher;
   
   public interface ILifecycle extends IEventDispatcher
   {
      
      function get state() : String;
      
      function get target() : Object;
      
      function get initialized() : Boolean;
      
      function get active() : Boolean;
      
      function get suspended() : Boolean;
      
      function get destroyed() : Boolean;
      
      function initialize(param1:Function = null) : void;
      
      function suspend(param1:Function = null) : void;
      
      function resume(param1:Function = null) : void;
      
      function destroy(param1:Function = null) : void;
      
      function beforeInitializing(param1:Function) : ILifecycle;
      
      function whenInitializing(param1:Function) : ILifecycle;
      
      function afterInitializing(param1:Function) : ILifecycle;
      
      function beforeSuspending(param1:Function) : ILifecycle;
      
      function whenSuspending(param1:Function) : ILifecycle;
      
      function afterSuspending(param1:Function) : ILifecycle;
      
      function beforeResuming(param1:Function) : ILifecycle;
      
      function whenResuming(param1:Function) : ILifecycle;
      
      function afterResuming(param1:Function) : ILifecycle;
      
      function beforeDestroying(param1:Function) : ILifecycle;
      
      function whenDestroying(param1:Function) : ILifecycle;
      
      function afterDestroying(param1:Function) : ILifecycle;
   }
}

