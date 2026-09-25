package robotlegs.bender.extensions.localEventMap.impl
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import robotlegs.bender.extensions.localEventMap.api.IEventMap;
   
   public class EventMap implements IEventMap
   {
      
      private var _eventDispatcher:IEventDispatcher;
      
      private const _listeners:Vector.<EventMapConfig> = new Vector.<EventMapConfig>();
      
      private const _suspendedListeners:Vector.<EventMapConfig> = new Vector.<EventMapConfig>();
      
      private var _suspended:Boolean = false;
      
      public function EventMap(param1:IEventDispatcher)
      {
         super();
         this._eventDispatcher = param1;
      }
      
      public function mapListener(param1:IEventDispatcher, param2:String, param3:Function, param4:Class = null, param5:Boolean = false, param6:int = 0, param7:Boolean = true) : void
      {
         var eventConfig:EventMapConfig = null;
         var callback:Function = null;
         var dispatcher:IEventDispatcher = param1;
         var eventString:String = param2;
         var listener:Function = param3;
         var eventClass:Class = param4;
         var useCapture:Boolean = param5;
         var priority:int = param6;
         var useWeakReference:Boolean = param7;
         eventClass ||= Event;
         var currentListeners:Vector.<EventMapConfig> = this._suspended ? this._suspendedListeners : this._listeners;
         var i:int = int(currentListeners.length);
         while(i--)
         {
            eventConfig = currentListeners[i];
            if(eventConfig.dispatcher == dispatcher && eventConfig.eventString == eventString && eventConfig.listener == listener && eventConfig.useCapture == useCapture && eventConfig.eventClass == eventClass)
            {
               return;
            }
         }
         if(eventClass != Event)
         {
            callback = function(param1:Event):void
            {
               routeEventToListener(param1,listener,eventClass);
            };
         }
         else
         {
            callback = listener;
         }
         eventConfig = new EventMapConfig(dispatcher,eventString,listener,eventClass,callback,useCapture);
         currentListeners.push(eventConfig);
         if(!this._suspended)
         {
            dispatcher.addEventListener(eventString,callback,useCapture,priority,useWeakReference);
         }
      }
      
      public function unmapListener(param1:IEventDispatcher, param2:String, param3:Function, param4:Class = null, param5:Boolean = false) : void
      {
         var _loc6_:EventMapConfig = null;
         param4 ||= Event;
         var _loc7_:Vector.<EventMapConfig> = this._suspended ? this._suspendedListeners : this._listeners;
         var _loc8_:* = int(_loc7_.length);
         while(_loc8_--)
         {
            _loc6_ = _loc7_[_loc8_];
            if(_loc6_.dispatcher == param1 && _loc6_.eventString == param2 && _loc6_.listener == param3 && _loc6_.useCapture == param5 && _loc6_.eventClass == param4)
            {
               if(!this._suspended)
               {
                  param1.removeEventListener(param2,_loc6_.callback,param5);
               }
               _loc7_.splice(_loc8_,1);
               return;
            }
         }
      }
      
      public function unmapListeners() : void
      {
         var _loc2_:EventMapConfig = null;
         var _loc3_:IEventDispatcher = null;
         var _loc1_:Vector.<EventMapConfig> = this._suspended ? this._suspendedListeners : this._listeners;
         while(true)
         {
            _loc2_ = _loc1_.pop();
            if(!_loc2_)
            {
               break;
            }
            if(!this._suspended)
            {
               _loc3_ = _loc2_.dispatcher;
               _loc3_.removeEventListener(_loc2_.eventString,_loc2_.callback,_loc2_.useCapture);
            }
         }
      }
      
      public function suspend() : void
      {
         var _loc1_:EventMapConfig = null;
         var _loc2_:IEventDispatcher = null;
         if(this._suspended)
         {
            return;
         }
         this._suspended = true;
         while(true)
         {
            _loc1_ = this._listeners.pop();
            if(!_loc1_)
            {
               break;
            }
            _loc2_ = _loc1_.dispatcher;
            _loc2_.removeEventListener(_loc1_.eventString,_loc1_.callback,_loc1_.useCapture);
            this._suspendedListeners.push(_loc1_);
         }
      }
      
      public function resume() : void
      {
         var _loc1_:EventMapConfig = null;
         var _loc2_:IEventDispatcher = null;
         if(!this._suspended)
         {
            return;
         }
         this._suspended = false;
         while(true)
         {
            _loc1_ = this._suspendedListeners.pop();
            if(!_loc1_)
            {
               break;
            }
            _loc2_ = _loc1_.dispatcher;
            _loc2_.addEventListener(_loc1_.eventString,_loc1_.callback,_loc1_.useCapture);
            this._listeners.push(_loc1_);
         }
      }
      
      private function routeEventToListener(param1:Event, param2:Function, param3:Class) : void
      {
         if(param1 is param3)
         {
            param2(param1);
         }
      }
   }
}

