package org.osflash.signals
{
   public class Slot implements ISlot
   {
      
      protected var _signal:IOnceSignal;
      
      protected var _enabled:Boolean = true;
      
      protected var _listener:Function;
      
      protected var _once:Boolean = false;
      
      protected var _priority:int = 0;
      
      protected var _params:Array;
      
      public function Slot(param1:Function, param2:IOnceSignal, param3:Boolean = false, param4:int = 0)
      {
         super();
         this._listener = param1;
         this._once = param3;
         this._signal = param2;
         this._priority = param4;
         this.verifyListener(param1);
      }
      
      public function execute0() : void
      {
         if(!this._enabled)
         {
            return;
         }
         if(this._once)
         {
            this.remove();
         }
         if(Boolean(this._params) && Boolean(this._params.length))
         {
            this._listener.apply(null,this._params);
            return;
         }
         this._listener();
      }
      
      public function execute1(param1:Object) : void
      {
         if(!this._enabled)
         {
            return;
         }
         if(this._once)
         {
            this.remove();
         }
         if(Boolean(this._params) && Boolean(this._params.length))
         {
            this._listener.apply(null,[param1].concat(this._params));
            return;
         }
         this._listener(param1);
      }
      
      public function execute(param1:Array) : void
      {
         if(!this._enabled)
         {
            return;
         }
         if(this._once)
         {
            this.remove();
         }
         if(Boolean(this._params) && Boolean(this._params.length))
         {
            param1 = param1.concat(this._params);
         }
         var _loc2_:int = int(param1.length);
         if(_loc2_ == 0)
         {
            this._listener();
         }
         else if(_loc2_ == 1)
         {
            this._listener(param1[0]);
         }
         else if(_loc2_ == 2)
         {
            this._listener(param1[0],param1[1]);
         }
         else if(_loc2_ == 3)
         {
            this._listener(param1[0],param1[1],param1[2]);
         }
         else
         {
            this._listener.apply(null,param1);
         }
      }
      
      public function get listener() : Function
      {
         return this._listener;
      }
      
      public function set listener(param1:Function) : void
      {
         if(null == param1)
         {
            throw new ArgumentError("Given listener is null.\nDid you want to set enabled to false instead?");
         }
         this.verifyListener(param1);
         this._listener = param1;
      }
      
      public function get once() : Boolean
      {
         return this._once;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function toString() : String
      {
         return "[Slot listener: " + this._listener + ", once: " + this._once + ", priority: " + this._priority + ", enabled: " + this._enabled + "]";
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
      }
      
      public function get params() : Array
      {
         return this._params;
      }
      
      public function set params(param1:Array) : void
      {
         this._params = param1;
      }
      
      public function remove() : void
      {
         this._signal.remove(this._listener);
      }
      
      protected function verifyListener(param1:Function) : void
      {
         if(null == param1)
         {
            throw new ArgumentError("Given listener is null.");
         }
         if(null == this._signal)
         {
            throw new Error("Internal signal reference has not been set yet.");
         }
      }
   }
}

