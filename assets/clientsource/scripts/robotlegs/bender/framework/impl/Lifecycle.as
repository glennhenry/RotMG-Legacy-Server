package robotlegs.bender.framework.impl
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import robotlegs.bender.framework.api.ILifecycle;
   import robotlegs.bender.framework.api.LifecycleEvent;
   import robotlegs.bender.framework.api.LifecycleState;
   
   public class Lifecycle extends EventDispatcher implements ILifecycle
   {
      
      private var _state:String = "uninitialized";
      
      private var _target:Object;
      
      private const _reversedEventTypes:Dictionary = new Dictionary();
      
      private var _reversePriority:int;
      
      private var _initialize:LifecycleTransition;
      
      private var _suspend:LifecycleTransition;
      
      private var _resume:LifecycleTransition;
      
      private var _destroy:LifecycleTransition;
      
      public function Lifecycle(param1:Object)
      {
         super();
         this._target = param1;
         this.configureTransitions();
      }
      
      public function get state() : String
      {
         return this._state;
      }
      
      public function get target() : Object
      {
         return this._target;
      }
      
      public function get initialized() : Boolean
      {
         return this._state != LifecycleState.UNINITIALIZED && this._state != LifecycleState.INITIALIZING;
      }
      
      public function get active() : Boolean
      {
         return this._state == LifecycleState.ACTIVE;
      }
      
      public function get suspended() : Boolean
      {
         return this._state == LifecycleState.SUSPENDED;
      }
      
      public function get destroyed() : Boolean
      {
         return this._state == LifecycleState.DESTROYED;
      }
      
      public function initialize(param1:Function = null) : void
      {
         this._initialize.enter(param1);
      }
      
      public function suspend(param1:Function = null) : void
      {
         this._suspend.enter(param1);
      }
      
      public function resume(param1:Function = null) : void
      {
         this._resume.enter(param1);
      }
      
      public function destroy(param1:Function = null) : void
      {
         this._destroy.enter(param1);
      }
      
      public function beforeInitializing(param1:Function) : ILifecycle
      {
         this._initialize.addBeforeHandler(param1);
         return this;
      }
      
      public function beforeSuspending(param1:Function) : ILifecycle
      {
         this._suspend.addBeforeHandler(param1);
         return this;
      }
      
      public function beforeResuming(param1:Function) : ILifecycle
      {
         this._resume.addBeforeHandler(param1);
         return this;
      }
      
      public function beforeDestroying(param1:Function) : ILifecycle
      {
         this._destroy.addBeforeHandler(param1);
         return this;
      }
      
      public function whenInitializing(param1:Function) : ILifecycle
      {
         this.addEventListener(LifecycleEvent.INITIALIZE,this.createLifecycleListener(param1,true));
         return this;
      }
      
      public function whenSuspending(param1:Function) : ILifecycle
      {
         this.addEventListener(LifecycleEvent.SUSPEND,this.createLifecycleListener(param1));
         return this;
      }
      
      public function whenResuming(param1:Function) : ILifecycle
      {
         this.addEventListener(LifecycleEvent.RESUME,this.createLifecycleListener(param1));
         return this;
      }
      
      public function whenDestroying(param1:Function) : ILifecycle
      {
         this.addEventListener(LifecycleEvent.DESTROY,this.createLifecycleListener(param1,true));
         return this;
      }
      
      public function afterInitializing(param1:Function) : ILifecycle
      {
         this.addEventListener(LifecycleEvent.POST_INITIALIZE,this.createLifecycleListener(param1,true));
         return this;
      }
      
      public function afterSuspending(param1:Function) : ILifecycle
      {
         this.addEventListener(LifecycleEvent.POST_SUSPEND,this.createLifecycleListener(param1));
         return this;
      }
      
      public function afterResuming(param1:Function) : ILifecycle
      {
         this.addEventListener(LifecycleEvent.POST_RESUME,this.createLifecycleListener(param1));
         return this;
      }
      
      public function afterDestroying(param1:Function) : ILifecycle
      {
         this.addEventListener(LifecycleEvent.POST_DESTROY,this.createLifecycleListener(param1,true));
         return this;
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         param4 = this.flipPriority(param1,param4);
         super.addEventListener(param1,param2,param3,param4,param5);
      }
      
      internal function setCurrentState(param1:String) : void
      {
         if(this._state == param1)
         {
            return;
         }
         this._state = param1;
      }
      
      internal function addReversedEventTypes(... rest) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in rest)
         {
            this._reversedEventTypes[_loc2_] = true;
         }
      }
      
      private function configureTransitions() : void
      {
         this._initialize = new LifecycleTransition(LifecycleEvent.PRE_INITIALIZE,this).fromStates(LifecycleState.UNINITIALIZED).toStates(LifecycleState.INITIALIZING,LifecycleState.ACTIVE).withEvents(LifecycleEvent.PRE_INITIALIZE,LifecycleEvent.INITIALIZE,LifecycleEvent.POST_INITIALIZE);
         this._suspend = new LifecycleTransition(LifecycleEvent.PRE_SUSPEND,this).fromStates(LifecycleState.ACTIVE).toStates(LifecycleState.SUSPENDING,LifecycleState.SUSPENDED).withEvents(LifecycleEvent.PRE_SUSPEND,LifecycleEvent.SUSPEND,LifecycleEvent.POST_SUSPEND).inReverse();
         this._resume = new LifecycleTransition(LifecycleEvent.PRE_RESUME,this).fromStates(LifecycleState.SUSPENDED).toStates(LifecycleState.RESUMING,LifecycleState.ACTIVE).withEvents(LifecycleEvent.PRE_RESUME,LifecycleEvent.RESUME,LifecycleEvent.POST_RESUME);
         this._destroy = new LifecycleTransition(LifecycleEvent.PRE_DESTROY,this).fromStates(LifecycleState.SUSPENDED,LifecycleState.ACTIVE).toStates(LifecycleState.DESTROYING,LifecycleState.DESTROYED).withEvents(LifecycleEvent.PRE_DESTROY,LifecycleEvent.DESTROY,LifecycleEvent.POST_DESTROY).inReverse();
      }
      
      private function flipPriority(param1:String, param2:int) : int
      {
         return param2 == 0 && Boolean(this._reversedEventTypes[param1]) ? int(this._reversePriority++) : param2;
      }
      
      private function createLifecycleListener(param1:Function, param2:Boolean = false) : Function
      {
         var handler:Function = param1;
         var once:Boolean = param2;
         if(handler.length > 1)
         {
            throw new Error("When and After handlers must accept 0-1 arguments");
         }
         if(handler.length == 1)
         {
            return function(param1:LifecycleEvent):void
            {
               once && IEventDispatcher(param1.target).removeEventListener(param1.type,arguments.callee);
               handler(param1.type);
            };
         }
         return function(param1:LifecycleEvent):void
         {
            once && IEventDispatcher(param1.target).removeEventListener(param1.type,arguments.callee);
            handler();
         };
      }
   }
}

