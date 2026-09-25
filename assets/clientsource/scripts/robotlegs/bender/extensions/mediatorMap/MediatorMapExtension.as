package robotlegs.bender.extensions.mediatorMap
{
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
   import robotlegs.bender.extensions.mediatorMap.impl.DefaultMediatorManager;
   import robotlegs.bender.extensions.mediatorMap.impl.MediatorFactory;
   import robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;
   import robotlegs.bender.extensions.viewManager.api.IViewHandler;
   import robotlegs.bender.extensions.viewManager.api.IViewManager;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class MediatorMapExtension implements IExtension
   {
      
      private const _uid:String = UID.create(MediatorMapExtension);
      
      private var _injector:Injector;
      
      private var _mediatorMap:IMediatorMap;
      
      private var _viewManager:IViewManager;
      
      private var _mediatorManager:DefaultMediatorManager;
      
      public function MediatorMapExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         this._injector = param1.injector;
         this._injector.map(IMediatorFactory).toSingleton(MediatorFactory);
         this._injector.map(IMediatorMap).toSingleton(MediatorMap);
         param1.lifecycle.beforeInitializing(this.beforeInitializing);
         param1.lifecycle.beforeDestroying(this.beforeDestroying);
         param1.lifecycle.whenDestroying(this.whenDestroying);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function beforeInitializing() : void
      {
         this._mediatorMap = this._injector.getInstance(IMediatorMap);
         this._mediatorManager = this._injector.getInstance(DefaultMediatorManager);
         if(this._injector.satisfiesDirectly(IViewManager))
         {
            this._viewManager = this._injector.getInstance(IViewManager);
            this._viewManager.addViewHandler(this._mediatorMap as IViewHandler);
         }
      }
      
      private function beforeDestroying() : void
      {
         var _loc1_:IMediatorFactory = this._injector.getInstance(IMediatorFactory);
         _loc1_.removeAllMediators();
         if(this._injector.satisfiesDirectly(IViewManager))
         {
            this._viewManager = this._injector.getInstance(IViewManager);
            this._viewManager.removeViewHandler(this._mediatorMap as IViewHandler);
         }
      }
      
      private function whenDestroying() : void
      {
         if(this._injector.satisfiesDirectly(IMediatorMap))
         {
            this._injector.unmap(IMediatorMap);
         }
         if(this._injector.satisfiesDirectly(IMediatorFactory))
         {
            this._injector.unmap(IMediatorFactory);
         }
      }
   }
}

