package robotlegs.bender.extensions.localEventMap.impl
{
   import flash.events.IEventDispatcher;
   
   public class EventMapConfig
   {
      
      private var _dispatcher:IEventDispatcher;
      
      private var _eventString:String;
      
      private var _listener:Function;
      
      private var _eventClass:Class;
      
      private var _callback:Function;
      
      private var _useCapture:Boolean;
      
      public function EventMapConfig(param1:IEventDispatcher, param2:String, param3:Function, param4:Class, param5:Function, param6:Boolean)
      {
         super();
         this._dispatcher = param1;
         this._eventString = param2;
         this._listener = param3;
         this._eventClass = param4;
         this._callback = param5;
         this._useCapture = param6;
      }
      
      public function get dispatcher() : IEventDispatcher
      {
         return this._dispatcher;
      }
      
      public function get eventString() : String
      {
         return this._eventString;
      }
      
      public function get listener() : Function
      {
         return this._listener;
      }
      
      public function get eventClass() : Class
      {
         return this._eventClass;
      }
      
      public function get callback() : Function
      {
         return this._callback;
      }
      
      public function get useCapture() : Boolean
      {
         return this._useCapture;
      }
   }
}

