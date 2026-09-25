package org.osflash.signals.natives
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import org.osflash.signals.SlotList;
   
   public class NativeMappedSignal extends NativeRelaySignal
   {
      
      private var _mappingFunction:Function = null;
      
      public function NativeMappedSignal(param1:IEventDispatcher, param2:String, param3:Class = null, ... rest)
      {
         super(param1,param2,param3);
         this.valueClasses = rest;
      }
      
      protected function get mappingFunction() : Function
      {
         return this._mappingFunction;
      }
      
      override public function get eventClass() : Class
      {
         return _eventClass;
      }
      
      override public function set eventClass(param1:Class) : void
      {
         _eventClass = param1;
      }
      
      override public function set valueClasses(param1:Array) : void
      {
         _valueClasses = param1 ? param1.slice() : [];
         var _loc2_:* = int(_valueClasses.length);
         while(_loc2_--)
         {
            if(!(_valueClasses[_loc2_] is Class))
            {
               throw new ArgumentError("Invalid valueClasses argument: " + "item at index " + _loc2_ + " should be a Class but was:<" + _valueClasses[_loc2_] + ">." + getQualifiedClassName(_valueClasses[_loc2_]));
            }
         }
      }
      
      public function mapTo(... rest) : NativeMappedSignal
      {
         var objectListOrFunction:Array = rest;
         if(objectListOrFunction.length == 1 && objectListOrFunction[0] is Function)
         {
            this._mappingFunction = objectListOrFunction[0] as Function;
            if(this._mappingFunction.length > 1)
            {
               throw new ArgumentError("Mapping function has " + this._mappingFunction.length + " arguments but it needs zero or one of type Event");
            }
         }
         else
         {
            this._mappingFunction = function():Object
            {
               return objectListOrFunction;
            };
         }
         return this;
      }
      
      protected function mapEvent(param1:Event) : Object
      {
         if(this.mappingFunction != null)
         {
            if(this.mappingFunction.length == 1)
            {
               return this.mappingFunction(param1);
            }
            return this.mappingFunction();
         }
         if(valueClasses.length == 0)
         {
            return [];
         }
         throw new ArgumentError("There are valueClasses set to be dispatched <" + valueClasses + "> but mappingFunction is null.");
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Class = null;
         var _loc7_:int = 0;
         var _loc2_:Object = this.mapEvent(param1);
         var _loc3_:int = int(valueClasses.length);
         if(_loc2_ is Array)
         {
            _loc4_ = _loc2_ as Array;
            _loc7_ = 0;
            while(_loc7_ < _loc3_)
            {
               _loc5_ = _loc4_[_loc7_];
               _loc6_ = valueClasses[_loc7_];
               if(!(_loc5_ === null || _loc5_ is _loc6_))
               {
                  throw new ArgumentError("Value object <" + _loc5_ + "> is not an instance of <" + _loc6_ + ">.");
               }
               _loc7_++;
            }
         }
         else
         {
            if(_loc3_ > 1)
            {
               throw new ArgumentError("Expected more than one value.");
            }
            if(!(_loc2_ is valueClasses[0]))
            {
               throw new ArgumentError("Mapping returned " + getQualifiedClassName(_loc2_) + ", expected " + valueClasses[0] + ".");
            }
         }
         return super.dispatchEvent(param1);
      }
      
      override protected function onNativeEvent(param1:Event) : void
      {
         var _loc4_:Array = null;
         var _loc2_:Object = this.mapEvent(param1);
         var _loc3_:SlotList = slots;
         if(_loc2_ is Array)
         {
            if(valueClasses.length == 1 && valueClasses[0] == Array)
            {
               while(_loc3_.nonEmpty)
               {
                  _loc3_.head.execute1(_loc2_);
                  _loc3_ = _loc3_.tail;
               }
            }
            else
            {
               _loc4_ = _loc2_ as Array;
               while(_loc3_.nonEmpty)
               {
                  _loc3_.head.execute(_loc4_);
                  _loc3_ = _loc3_.tail;
               }
            }
         }
         else
         {
            while(_loc3_.nonEmpty)
            {
               _loc3_.head.execute1(_loc2_);
               _loc3_ = _loc3_.tail;
            }
         }
      }
   }
}

