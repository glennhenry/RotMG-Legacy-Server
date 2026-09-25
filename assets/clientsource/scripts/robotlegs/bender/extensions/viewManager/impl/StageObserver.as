package robotlegs.bender.extensions.viewManager.impl
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public class StageObserver
   {
      
      private const _filter:RegExp;
      
      private var _registry:ContainerRegistry;
      
      public function StageObserver(param1:ContainerRegistry)
      {
         var _loc2_:ContainerBinding = null;
         this._filter = /^mx\.|^spark\.|^flash\./;
         super();
         this._registry = param1;
         this._registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD,this.onRootContainerAdd);
         this._registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE,this.onRootContainerRemove);
         for each(_loc2_ in this._registry.rootBindings)
         {
            this.addRootListener(_loc2_.container);
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:ContainerBinding = null;
         this._registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD,this.onRootContainerAdd);
         this._registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE,this.onRootContainerRemove);
         for each(_loc1_ in this._registry.rootBindings)
         {
            this.removeRootListener(_loc1_.container);
         }
      }
      
      private function onRootContainerAdd(param1:ContainerRegistryEvent) : void
      {
         this.addRootListener(param1.container);
      }
      
      private function onRootContainerRemove(param1:ContainerRegistryEvent) : void
      {
         this.removeRootListener(param1.container);
      }
      
      private function addRootListener(param1:DisplayObjectContainer) : void
      {
         param1.addEventListener(Event.ADDED_TO_STAGE,this.onViewAddedToStage,true);
         param1.addEventListener(Event.ADDED_TO_STAGE,this.onContainerRootAddedToStage);
      }
      
      private function removeRootListener(param1:DisplayObjectContainer) : void
      {
         param1.removeEventListener(Event.ADDED_TO_STAGE,this.onViewAddedToStage,true);
         param1.removeEventListener(Event.ADDED_TO_STAGE,this.onContainerRootAddedToStage);
      }
      
      private function onViewAddedToStage(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:String = null;
         _loc2_ = param1.target as DisplayObject;
         _loc3_ = getQualifiedClassName(_loc2_);
         var _loc4_:Boolean = this._filter.test(_loc3_);
         if(_loc4_)
         {
            return;
         }
         var _loc5_:Class = _loc2_["constructor"];
         var _loc6_:ContainerBinding = this._registry.findParentBinding(_loc2_);
         while(_loc6_)
         {
            _loc6_.handleView(_loc2_,_loc5_);
            _loc6_ = _loc6_.parent;
         }
      }
      
      private function onContainerRootAddedToStage(param1:Event) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         _loc2_ = param1.target as DisplayObjectContainer;
         _loc2_.removeEventListener(Event.ADDED_TO_STAGE,this.onContainerRootAddedToStage);
         var _loc3_:Class = _loc2_["constructor"];
         var _loc4_:ContainerBinding = this._registry.getBinding(_loc2_);
         _loc4_.handleView(_loc2_,_loc3_);
      }
   }
}

