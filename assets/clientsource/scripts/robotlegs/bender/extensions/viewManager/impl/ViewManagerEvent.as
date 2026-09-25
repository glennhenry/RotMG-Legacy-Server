package robotlegs.bender.extensions.viewManager.impl
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import robotlegs.bender.extensions.viewManager.api.IViewHandler;
   
   public class ViewManagerEvent extends Event
   {
      
      public static const CONTAINER_ADD:String = "containerAdd";
      
      public static const CONTAINER_REMOVE:String = "containerRemove";
      
      public static const HANDLER_ADD:String = "handlerAdd";
      
      public static const HANDLER_REMOVE:String = "handlerRemove";
      
      private var _container:DisplayObjectContainer;
      
      private var _handler:IViewHandler;
      
      public function ViewManagerEvent(param1:String, param2:DisplayObjectContainer = null, param3:IViewHandler = null)
      {
         super(param1);
         this._container = param2;
         this._handler = param3;
      }
      
      public function get container() : DisplayObjectContainer
      {
         return this._container;
      }
      
      public function get handler() : IViewHandler
      {
         return this._handler;
      }
      
      override public function clone() : Event
      {
         return new ViewManagerEvent(type,this._container,this._handler);
      }
   }
}

