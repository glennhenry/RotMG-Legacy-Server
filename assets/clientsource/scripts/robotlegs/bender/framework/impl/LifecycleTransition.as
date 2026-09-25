package robotlegs.bender.framework.impl
{
   import robotlegs.bender.framework.api.LifecycleEvent;
   
   public class LifecycleTransition
   {
      
      private const _fromStates:Vector.<String> = new Vector.<String>();
      
      private const _dispatcher:MessageDispatcher = new MessageDispatcher();
      
      private const _callbacks:Array = [];
      
      private var _name:String;
      
      private var _lifecycle:Lifecycle;
      
      private var _transitionState:String;
      
      private var _finalState:String;
      
      private var _preTransitionEvent:String;
      
      private var _transitionEvent:String;
      
      private var _postTransitionEvent:String;
      
      private var _reverse:Boolean;
      
      public function LifecycleTransition(param1:String, param2:Lifecycle)
      {
         super();
         this._name = param1;
         this._lifecycle = param2;
      }
      
      public function fromStates(... rest) : LifecycleTransition
      {
         var _loc2_:String = null;
         for each(_loc2_ in rest)
         {
            this._fromStates.push(_loc2_);
         }
         return this;
      }
      
      public function toStates(param1:String, param2:String) : LifecycleTransition
      {
         this._transitionState = param1;
         this._finalState = param2;
         return this;
      }
      
      public function withEvents(param1:String, param2:String, param3:String) : LifecycleTransition
      {
         this._preTransitionEvent = param1;
         this._transitionEvent = param2;
         this._postTransitionEvent = param3;
         this._reverse && this._lifecycle.addReversedEventTypes(param1,param2,param3);
         return this;
      }
      
      public function inReverse() : LifecycleTransition
      {
         this._reverse = true;
         this._lifecycle.addReversedEventTypes(this._preTransitionEvent,this._transitionEvent,this._postTransitionEvent);
         return this;
      }
      
      public function addBeforeHandler(param1:Function) : LifecycleTransition
      {
         this._dispatcher.addMessageHandler(this._name,param1);
         return this;
      }
      
      public function enter(param1:Function = null) : void
      {
         var initialState:String = null;
         var callback:Function = param1;
         if(this._lifecycle.state == this._finalState)
         {
            callback && safelyCallBack(callback,null,this._name);
            return;
         }
         if(this._lifecycle.state == this._transitionState)
         {
            callback && this._callbacks.push(callback);
            return;
         }
         if(this.invalidTransition())
         {
            this.reportError("Invalid transition",[callback]);
            return;
         }
         initialState = this._lifecycle.state;
         callback && this._callbacks.push(callback);
         this.setState(this._transitionState);
         this._dispatcher.dispatchMessage(this._name,function(param1:Object):void
         {
            var _loc3_:Function = null;
            if(param1)
            {
               setState(initialState);
               reportError(param1,_callbacks);
               return;
            }
            dispatch(_preTransitionEvent);
            dispatch(_transitionEvent);
            setState(_finalState);
            var _loc2_:Array = _callbacks.concat();
            _callbacks.length = 0;
            for each(_loc3_ in _loc2_)
            {
               safelyCallBack(_loc3_,null,_name);
            }
            dispatch(_postTransitionEvent);
         },this._reverse);
      }
      
      private function invalidTransition() : Boolean
      {
         return this._fromStates.length > 0 && this._fromStates.indexOf(this._lifecycle.state) == -1;
      }
      
      private function setState(param1:String) : void
      {
         param1 && this._lifecycle.setCurrentState(param1);
      }
      
      private function dispatch(param1:String) : void
      {
         if(Boolean(param1) && this._lifecycle.hasEventListener(param1))
         {
            this._lifecycle.dispatchEvent(new LifecycleEvent(param1));
         }
      }
      
      private function reportError(param1:Object, param2:Array = null) : void
      {
         var _loc4_:LifecycleEvent = null;
         var _loc5_:Function = null;
         var _loc3_:Error = param1 is Error ? param1 as Error : new Error(param1);
         if(this._lifecycle.hasEventListener(LifecycleEvent.ERROR))
         {
            _loc4_ = new LifecycleEvent(LifecycleEvent.ERROR);
            _loc4_.error = _loc3_;
            this._lifecycle.dispatchEvent(_loc4_);
            if(param2)
            {
               for each(_loc5_ in param2)
               {
                  _loc5_ && safelyCallBack(_loc5_,_loc3_,this._name);
               }
               param2.length = 0;
            }
            return;
         }
         throw _loc3_;
      }
   }
}

