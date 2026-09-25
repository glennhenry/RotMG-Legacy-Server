package robotlegs.bender.extensions.viewManager.impl
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class ContainerRegistry extends EventDispatcher
   {
      
      private const _bindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>();
      
      private const _rootBindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>();
      
      private const _bindingByContainer:Dictionary = new Dictionary();
      
      public function ContainerRegistry()
      {
         super();
      }
      
      public function get bindings() : Vector.<ContainerBinding>
      {
         return this._bindings;
      }
      
      public function get rootBindings() : Vector.<ContainerBinding>
      {
         return this._rootBindings;
      }
      
      public function addContainer(param1:DisplayObjectContainer) : ContainerBinding
      {
         return this._bindingByContainer[param1] = this._bindingByContainer[param1] || this.createBinding(param1);
      }
      
      public function removeContainer(param1:DisplayObjectContainer) : ContainerBinding
      {
         var _loc2_:ContainerBinding = this._bindingByContainer[param1];
         _loc2_ && this.removeBinding(_loc2_);
         return _loc2_;
      }
      
      public function findParentBinding(param1:DisplayObject) : ContainerBinding
      {
         var _loc3_:ContainerBinding = null;
         var _loc2_:DisplayObjectContainer = param1.parent;
         while(_loc2_)
         {
            _loc3_ = this._bindingByContainer[_loc2_];
            if(_loc3_)
            {
               return _loc3_;
            }
            _loc2_ = _loc2_.parent;
         }
         return null;
      }
      
      public function getBinding(param1:DisplayObjectContainer) : ContainerBinding
      {
         return this._bindingByContainer[param1];
      }
      
      private function createBinding(param1:DisplayObjectContainer) : ContainerBinding
      {
         var _loc3_:ContainerBinding = null;
         var _loc2_:ContainerBinding = new ContainerBinding(param1);
         this._bindings.push(_loc2_);
         _loc2_.addEventListener(ContainerBindingEvent.BINDING_EMPTY,this.onBindingEmpty);
         _loc2_.parent = this.findParentBinding(param1);
         if(_loc2_.parent == null)
         {
            this.addRootBinding(_loc2_);
         }
         for each(_loc3_ in this._bindingByContainer)
         {
            if(param1.contains(_loc3_.container))
            {
               if(!_loc3_.parent)
               {
                  this.removeRootBinding(_loc3_);
                  _loc3_.parent = _loc2_;
               }
               else if(!param1.contains(_loc3_.parent.container))
               {
                  _loc3_.parent = _loc2_;
               }
            }
         }
         dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_ADD,_loc2_.container));
         return _loc2_;
      }
      
      private function removeBinding(param1:ContainerBinding) : void
      {
         var _loc3_:ContainerBinding = null;
         delete this._bindingByContainer[param1.container];
         var _loc2_:int = this._bindings.indexOf(param1);
         this._bindings.splice(_loc2_,1);
         param1.removeEventListener(ContainerBindingEvent.BINDING_EMPTY,this.onBindingEmpty);
         if(!param1.parent)
         {
            this.removeRootBinding(param1);
         }
         for each(_loc3_ in this._bindingByContainer)
         {
            if(_loc3_.parent == param1)
            {
               _loc3_.parent = param1.parent;
               if(!_loc3_.parent)
               {
                  this.addRootBinding(_loc3_);
               }
            }
         }
         dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_REMOVE,param1.container));
      }
      
      private function addRootBinding(param1:ContainerBinding) : void
      {
         this._rootBindings.push(param1);
         dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_ADD,param1.container));
      }
      
      private function removeRootBinding(param1:ContainerBinding) : void
      {
         var _loc2_:int = this._rootBindings.indexOf(param1);
         this._rootBindings.splice(_loc2_,1);
         dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE,param1.container));
      }
      
      private function onBindingEmpty(param1:ContainerBindingEvent) : void
      {
         this.removeBinding(param1.target as ContainerBinding);
      }
   }
}

