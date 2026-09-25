package robotlegs.bender.extensions.viewManager.impl
{
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import robotlegs.bender.extensions.viewManager.api.IViewHandler;
   import robotlegs.bender.extensions.viewManager.api.IViewManager;
   
   public class ViewManager extends EventDispatcher implements IViewManager
   {
      
      private const _containers:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
      
      private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();
      
      private var _registry:ContainerRegistry;
      
      public function ViewManager(param1:ContainerRegistry)
      {
         super();
         this._registry = param1;
      }
      
      public function get containers() : Vector.<DisplayObjectContainer>
      {
         return this._containers;
      }
      
      public function addContainer(param1:DisplayObjectContainer) : void
      {
         var _loc2_:IViewHandler = null;
         if(!this.validContainer(param1))
         {
            return;
         }
         this._containers.push(param1);
         for each(_loc2_ in this._handlers)
         {
            this._registry.addContainer(param1).addHandler(_loc2_);
         }
         dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_ADD,param1));
      }
      
      public function removeContainer(param1:DisplayObjectContainer) : void
      {
         var _loc4_:IViewHandler = null;
         var _loc2_:int = this._containers.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         this._containers.splice(_loc2_,1);
         var _loc3_:ContainerBinding = this._registry.getBinding(param1);
         for each(_loc4_ in this._handlers)
         {
            _loc3_.removeHandler(_loc4_);
         }
         dispatchEvent(new ViewManagerEvent(ViewManagerEvent.CONTAINER_REMOVE,param1));
      }
      
      public function addViewHandler(param1:IViewHandler) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         if(this._handlers.indexOf(param1) != -1)
         {
            return;
         }
         this._handlers.push(param1);
         for each(_loc2_ in this._containers)
         {
            this._registry.addContainer(_loc2_).addHandler(param1);
         }
         dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_ADD,null,param1));
      }
      
      public function removeViewHandler(param1:IViewHandler) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc2_:int = this._handlers.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         this._handlers.splice(_loc2_,1);
         for each(_loc3_ in this._containers)
         {
            this._registry.getBinding(_loc3_).removeHandler(param1);
         }
         dispatchEvent(new ViewManagerEvent(ViewManagerEvent.HANDLER_REMOVE,null,param1));
      }
      
      public function removeAllHandlers() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:ContainerBinding = null;
         var _loc3_:IViewHandler = null;
         for each(_loc1_ in this._containers)
         {
            _loc2_ = this._registry.getBinding(_loc1_);
            for each(_loc3_ in this._handlers)
            {
               _loc2_.removeHandler(_loc3_);
            }
         }
      }
      
      private function validContainer(param1:DisplayObjectContainer) : Boolean
      {
         var _loc2_:DisplayObjectContainer = null;
         for each(_loc2_ in this._containers)
         {
            if(param1 == _loc2_)
            {
               return false;
            }
            if(_loc2_.contains(param1) || param1.contains(_loc2_))
            {
               throw new Error("Containers can not be nested");
            }
         }
         return true;
      }
   }
}

