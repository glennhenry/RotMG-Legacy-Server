package robotlegs.bender.extensions.viewManager
{
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.viewManager.api.IViewManager;
   import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
   import robotlegs.bender.extensions.viewManager.impl.ViewManager;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class ViewManagerExtension implements IExtension
   {
      
      private static var _containerRegistry:ContainerRegistry;
      
      private const _uid:String = UID.create(ViewManagerExtension);
      
      private var _injector:Injector;
      
      private var _viewManager:IViewManager;
      
      public function ViewManagerExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         this._injector = param1.injector;
         _containerRegistry = _containerRegistry || new ContainerRegistry();
         this._injector.map(ContainerRegistry).toValue(_containerRegistry);
         this._injector.map(IViewManager).toSingleton(ViewManager);
         param1.lifecycle.whenInitializing(this.whenInitializing);
         param1.lifecycle.whenDestroying(this.whenDestroying);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function whenInitializing() : void
      {
         this._viewManager = this._injector.getInstance(IViewManager);
      }
      
      private function whenDestroying() : void
      {
         this._viewManager.removeAllHandlers();
         this._injector.unmap(IViewManager);
         this._injector.unmap(ContainerRegistry);
      }
   }
}

