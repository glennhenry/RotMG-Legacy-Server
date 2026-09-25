package robotlegs.bender.extensions.viewManager.impl
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class ManualStageObserver
   {
      
      private var _registry:ContainerRegistry;
      
      public function ManualStageObserver(param1:ContainerRegistry)
      {
         var _loc2_:ContainerBinding = null;
         super();
         this._registry = param1;
         this._registry.addEventListener(ContainerRegistryEvent.CONTAINER_ADD,this.onContainerAdd);
         this._registry.addEventListener(ContainerRegistryEvent.CONTAINER_REMOVE,this.onContainerRemove);
         for each(_loc2_ in this._registry.bindings)
         {
            this.addContainerListener(_loc2_.container);
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:ContainerBinding = null;
         this._registry.removeEventListener(ContainerRegistryEvent.CONTAINER_ADD,this.onContainerAdd);
         this._registry.removeEventListener(ContainerRegistryEvent.CONTAINER_REMOVE,this.onContainerRemove);
         for each(_loc1_ in this._registry.bindings)
         {
            this.removeContainerListener(_loc1_.container);
         }
      }
      
      private function onContainerAdd(param1:ContainerRegistryEvent) : void
      {
         this.addContainerListener(param1.container);
      }
      
      private function onContainerRemove(param1:ContainerRegistryEvent) : void
      {
         this.removeContainerListener(param1.container);
      }
      
      private function addContainerListener(param1:DisplayObjectContainer) : void
      {
         param1.addEventListener(ConfigureViewEvent.CONFIGURE_VIEW,this.onConfigureView);
      }
      
      private function removeContainerListener(param1:DisplayObjectContainer) : void
      {
         param1.removeEventListener(ConfigureViewEvent.CONFIGURE_VIEW,this.onConfigureView);
      }
      
      private function onConfigureView(param1:ConfigureViewEvent) : void
      {
         var _loc3_:DisplayObject = null;
         param1.stopImmediatePropagation();
         var _loc2_:DisplayObjectContainer = param1.currentTarget as DisplayObjectContainer;
         _loc3_ = param1.target as DisplayObject;
         var _loc4_:Class = _loc3_["constructor"];
         this._registry.getBinding(_loc2_).handleView(_loc3_,_loc4_);
      }
   }
}

