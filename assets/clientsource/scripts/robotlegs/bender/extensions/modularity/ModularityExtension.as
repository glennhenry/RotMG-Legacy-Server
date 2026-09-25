package robotlegs.bender.extensions.modularity
{
   import flash.display.DisplayObjectContainer;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.modularity.impl.ContextViewBasedExistenceWatcher;
   import robotlegs.bender.extensions.modularity.impl.ModularContextEvent;
   import robotlegs.bender.extensions.modularity.impl.ViewManagerBasedExistenceWatcher;
   import robotlegs.bender.extensions.viewManager.api.IViewManager;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.api.ILogger;
   import robotlegs.bender.framework.impl.UID;
   
   public class ModularityExtension implements IExtension
   {
      
      private const _uid:String = UID.create(ModularityExtension);
      
      private var _context:IContext;
      
      private var _injector:Injector;
      
      private var _logger:ILogger;
      
      private var _inherit:Boolean;
      
      private var _expose:Boolean;
      
      public function ModularityExtension(param1:Boolean = true, param2:Boolean = true)
      {
         super();
         this._inherit = param1;
         this._expose = param2;
      }
      
      public function extend(param1:IContext) : void
      {
         this._context = param1;
         this._injector = param1.injector;
         this._logger = param1.getLogger(this);
         this._context.lifecycle.beforeInitializing(this.beforeInitializing);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function beforeInitializing() : void
      {
         this._inherit && this.broadcastContextExistence();
         this._expose && this.createContextWatcher();
      }
      
      private function broadcastContextExistence() : void
      {
         var _loc1_:DisplayObjectContainer = null;
         if(this._injector.satisfiesDirectly(DisplayObjectContainer))
         {
            this._logger.debug("Context configured to inherit. Broadcasting existence event...");
            _loc1_ = this._injector.getInstance(DisplayObjectContainer);
            _loc1_.dispatchEvent(new ModularContextEvent(ModularContextEvent.CONTEXT_ADD,this._context));
         }
         else
         {
            this._logger.warn("Context has been configured to inherit dependencies but has no way to do so");
         }
      }
      
      private function createContextWatcher() : void
      {
         var _loc1_:IViewManager = null;
         var _loc2_:DisplayObjectContainer = null;
         if(this._injector.satisfiesDirectly(IViewManager))
         {
            this._logger.debug("Context has a ViewManager. Configuring view manager based context existence watcher...");
            _loc1_ = this._injector.getInstance(IViewManager);
            new ViewManagerBasedExistenceWatcher(this._context,_loc1_);
         }
         else if(this._injector.satisfiesDirectly(DisplayObjectContainer))
         {
            this._logger.debug("Context has a ContextView. Configuring context view based context existence watcher...");
            _loc2_ = this._injector.getInstance(DisplayObjectContainer);
            new ContextViewBasedExistenceWatcher(this._context,_loc2_);
         }
         else
         {
            this._logger.warn("Context has been configured to expose its dependencies but has no way to do so");
         }
      }
   }
}

