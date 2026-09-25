package org.osflash.signals.natives
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import org.osflash.signals.ISlot;
   import org.osflash.signals.Signal;
   import org.osflash.signals.Slot;
   import org.osflash.signals.SlotList;
   
   public class NativeRelaySignal extends Signal implements INativeDispatcher
   {
      
      protected var _target:IEventDispatcher;
      
      protected var _eventType:String;
      
      protected var _eventClass:Class;
      
      public function NativeRelaySignal(param1:IEventDispatcher, param2:String, param3:Class = null)
      {
         super(param3 || Event);
         this.eventType = param2;
         this.eventClass = param3;
         this.target = param1;
      }
      
      public function get target() : IEventDispatcher
      {
         return this._target;
      }
      
      public function set target(param1:IEventDispatcher) : void
      {
         if(param1 == this._target)
         {
            return;
         }
         if(this._target)
         {
            this.removeAll();
         }
         this._target = param1;
      }
      
      public function get eventType() : String
      {
         return this._eventType;
      }
      
      public function set eventType(param1:String) : void
      {
         this._eventType = param1;
      }
      
      public function get eventClass() : Class
      {
         return this._eventClass;
      }
      
      public function set eventClass(param1:Class) : void
      {
         this._eventClass = param1 || Event;
         _valueClasses = [this._eventClass];
      }
      
      override public function set valueClasses(param1:Array) : void
      {
         this.eventClass = Boolean(param1) && param1.length > 0 ? param1[0] : null;
      }
      
      override public function add(param1:Function) : ISlot
      {
         return this.addWithPriority(param1);
      }
      
      override public function addOnce(param1:Function) : ISlot
      {
         return this.addOnceWithPriority(param1);
      }
      
      public function addWithPriority(param1:Function, param2:int = 0) : ISlot
      {
         return this.registerListenerWithPriority(param1,false,param2);
      }
      
      public function addOnceWithPriority(param1:Function, param2:int = 0) : ISlot
      {
         return this.registerListenerWithPriority(param1,true,param2);
      }
      
      override public function remove(param1:Function) : ISlot
      {
         var _loc2_:Boolean = slots.nonEmpty;
         var _loc3_:ISlot = super.remove(param1);
         if(_loc2_ != slots.nonEmpty)
         {
            this.target.removeEventListener(this.eventType,this.onNativeEvent);
         }
         return _loc3_;
      }
      
      override public function removeAll() : void
      {
         if(this.target)
         {
            this.target.removeEventListener(this.eventType,this.onNativeEvent);
         }
         super.removeAll();
      }
      
      override public function dispatch(... rest) : void
      {
         if(null == rest)
         {
            throw new ArgumentError("Event object expected.");
         }
         if(rest.length != 1)
         {
            throw new ArgumentError("No more than one Event object expected.");
         }
         this.dispatchEvent(rest[0] as Event);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         if(!this.target)
         {
            throw new ArgumentError("Target object cannot be null.");
         }
         if(!param1)
         {
            throw new ArgumentError("Event object cannot be null.");
         }
         if(!(param1 is this.eventClass))
         {
            throw new ArgumentError("Event object " + param1 + " is not an instance of " + this.eventClass + ".");
         }
         if(param1.type != this.eventType)
         {
            throw new ArgumentError("Event object has incorrect type. Expected <" + this.eventType + "> but was <" + param1.type + ">.");
         }
         return this.target.dispatchEvent(param1);
      }
      
      protected function onNativeEvent(param1:Event) : void
      {
         var _loc2_:SlotList = slots;
         while(_loc2_.nonEmpty)
         {
            _loc2_.head.execute1(param1);
            _loc2_ = _loc2_.tail;
         }
      }
      
      protected function registerListenerWithPriority(param1:Function, param2:Boolean = false, param3:int = 0) : ISlot
      {
         if(!this.target)
         {
            throw new ArgumentError("Target object cannot be null.");
         }
         var _loc4_:Boolean = slots.nonEmpty;
         var _loc5_:ISlot = null;
         if(registrationPossible(param1,param2))
         {
            _loc5_ = new Slot(param1,this,param2,param3);
            slots = slots.insertWithPriority(_loc5_);
         }
         else
         {
            _loc5_ = slots.find(param1);
         }
         if(_loc4_ != slots.nonEmpty)
         {
            this.target.addEventListener(this.eventType,this.onNativeEvent,false,param3);
         }
         return _loc5_;
      }
   }
}

