package robotlegs.bender.bundles.mvcs
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import robotlegs.bender.extensions.localEventMap.api.IEventMap;
   import robotlegs.bender.extensions.mediatorMap.api.IMediator;
   
   public class Mediator implements IMediator
   {
      
      [Inject]
      public var eventMap:IEventMap;
      
      [Inject]
      public var eventDispatcher:IEventDispatcher;
      
      private var _viewComponent:Object;
      
      public function Mediator()
      {
         super();
      }
      
      public function set viewComponent(param1:Object) : void
      {
         this._viewComponent = param1;
      }
      
      public function initialize() : void
      {
      }
      
      public function destroy() : void
      {
         this.eventMap.unmapListeners();
      }
      
      protected function addViewListener(param1:String, param2:Function, param3:Class = null) : void
      {
         this.eventMap.mapListener(IEventDispatcher(this._viewComponent),param1,param2,param3);
      }
      
      protected function addContextListener(param1:String, param2:Function, param3:Class = null) : void
      {
         this.eventMap.mapListener(this.eventDispatcher,param1,param2,param3);
      }
      
      protected function removeViewListener(param1:String, param2:Function, param3:Class = null) : void
      {
         this.eventMap.unmapListener(IEventDispatcher(this._viewComponent),param1,param2,param3);
      }
      
      protected function removeContextListener(param1:String, param2:Function, param3:Class = null) : void
      {
         this.eventMap.unmapListener(this.eventDispatcher,param1,param2,param3);
      }
      
      protected function dispatch(param1:Event) : void
      {
         if(this.eventDispatcher.hasEventListener(param1.type))
         {
            this.eventDispatcher.dispatchEvent(param1);
         }
      }
   }
}

