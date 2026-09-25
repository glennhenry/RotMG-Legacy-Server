package robotlegs.bender.extensions.modularity.impl
{
   import flash.display.DisplayObjectContainer;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.viewManager.api.IViewManager;
   import robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.ILogger;
   import robotlegs.bender.framework.impl.UID;
   
   public class ViewManagerBasedExistenceWatcher
   {
      
      private const _uid:String = UID.create(ViewManagerBasedExistenceWatcher);
      
      private var _logger:ILogger;
      
      private var _injector:Injector;
      
      private var _viewManager:IViewManager;
      
      private var _childContext:IContext;
      
      public function ViewManagerBasedExistenceWatcher(param1:IContext, param2:IViewManager)
      {
         super();
         this._logger = param1.getLogger(this);
         this._injector = param1.injector;
         this._viewManager = param2;
         param1.lifecycle.whenDestroying(this.destroy);
         this.init();
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function init() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         for each(_loc1_ in this._viewManager.containers)
         {
            this._logger.debug("Adding context existence event listener to container {0}",[_loc1_]);
            _loc1_.addEventListener(ModularContextEvent.CONTEXT_ADD,this.onContextAdd);
         }
         this._viewManager.addEventListener(ViewManagerEvent.CONTAINER_ADD,this.onContainerAdd);
         this._viewManager.addEventListener(ViewManagerEvent.CONTAINER_REMOVE,this.onContainerRemove);
      }
      
      private function destroy() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         for each(_loc1_ in this._viewManager.containers)
         {
            this._logger.debug("Removing context existence event listener from container {0}",[_loc1_]);
            _loc1_.removeEventListener(ModularContextEvent.CONTEXT_ADD,this.onContextAdd);
         }
         this._viewManager.removeEventListener(ViewManagerEvent.CONTAINER_ADD,this.onContainerAdd);
         this._viewManager.removeEventListener(ViewManagerEvent.CONTAINER_REMOVE,this.onContainerRemove);
         if(this._childContext)
         {
            this._logger.debug("Unlinking parent injector for child context {0}",[this._childContext]);
            this._childContext.injector.parentInjector = null;
         }
      }
      
      private function onContainerAdd(param1:ViewManagerEvent) : void
      {
         this._logger.debug("Adding context existence event listener to container {0}",[param1.container]);
         param1.container.addEventListener(ModularContextEvent.CONTEXT_ADD,this.onContextAdd);
      }
      
      private function onContainerRemove(param1:ViewManagerEvent) : void
      {
         this._logger.debug("Removing context existence event listener from container {0}",[param1.container]);
         param1.container.removeEventListener(ModularContextEvent.CONTEXT_ADD,this.onContextAdd);
      }
      
      private function onContextAdd(param1:ModularContextEvent) : void
      {
         param1.stopImmediatePropagation();
         this._childContext = param1.context;
         this._logger.debug("Context existence event caught. Configuring child context {0}",[this._childContext]);
         this._childContext.injector.parentInjector = this._injector;
      }
   }
}

