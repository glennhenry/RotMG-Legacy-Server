package robotlegs.bender.extensions.modularity.impl
{
   import flash.display.DisplayObjectContainer;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.ILogger;
   import robotlegs.bender.framework.impl.UID;
   
   public class ContextViewBasedExistenceWatcher
   {
      
      private const _uid:String = UID.create(ContextViewBasedExistenceWatcher);
      
      private var _logger:ILogger;
      
      private var _injector:Injector;
      
      private var _contextView:DisplayObjectContainer;
      
      private var _childContext:IContext;
      
      public function ContextViewBasedExistenceWatcher(param1:IContext, param2:DisplayObjectContainer)
      {
         super();
         this._logger = param1.getLogger(this);
         this._injector = param1.injector;
         this._contextView = param2;
         param1.lifecycle.whenDestroying(this.destroy);
         this.init();
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function init() : void
      {
         this._logger.debug("Listening for context existence events on contextView {0}",[this._contextView]);
         this._contextView.addEventListener(ModularContextEvent.CONTEXT_ADD,this.onContextAdd);
      }
      
      private function destroy() : void
      {
         this._logger.debug("Removing modular context existence event listener from contextView {0}",[this._contextView]);
         this._contextView.removeEventListener(ModularContextEvent.CONTEXT_ADD,this.onContextAdd);
         if(this._childContext)
         {
            this._logger.debug("Unlinking parent injector for child context {0}",[this._childContext]);
            this._childContext.injector.parentInjector = null;
         }
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

