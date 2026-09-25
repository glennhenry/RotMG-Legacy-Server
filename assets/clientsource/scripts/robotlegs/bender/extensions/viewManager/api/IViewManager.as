package robotlegs.bender.extensions.viewManager.api
{
   import flash.display.DisplayObjectContainer;
   import flash.events.IEventDispatcher;
   
   public interface IViewManager extends IEventDispatcher
   {
      
      function get containers() : Vector.<DisplayObjectContainer>;
      
      function addContainer(param1:DisplayObjectContainer) : void;
      
      function removeContainer(param1:DisplayObjectContainer) : void;
      
      function addViewHandler(param1:IViewHandler) : void;
      
      function removeViewHandler(param1:IViewHandler) : void;
      
      function removeAllHandlers() : void;
   }
}

