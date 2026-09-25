package robotlegs.bender.extensions.viewManager
{
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
   import robotlegs.bender.extensions.viewManager.impl.ManualStageObserver;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class ManualStageObserverExtension implements IExtension
   {
      
      private static var _manualStageObserver:ManualStageObserver;
      
      private static var _installCount:uint;
      
      private const _uid:String = UID.create(ManualStageObserverExtension);
      
      private var _injector:Injector;
      
      public function ManualStageObserverExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         ++_installCount;
         this._injector = param1.injector;
         param1.lifecycle.whenInitializing(this.whenInitializing);
         param1.lifecycle.whenDestroying(this.whenDestroying);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function whenInitializing() : void
      {
         var _loc1_:ContainerRegistry = null;
         if(_manualStageObserver == null)
         {
            _loc1_ = this._injector.getInstance(ContainerRegistry);
            _manualStageObserver = new ManualStageObserver(_loc1_);
         }
      }
      
      private function whenDestroying() : void
      {
         --_installCount;
         if(_installCount == 0)
         {
            _manualStageObserver.destroy();
            _manualStageObserver = null;
         }
      }
   }
}

