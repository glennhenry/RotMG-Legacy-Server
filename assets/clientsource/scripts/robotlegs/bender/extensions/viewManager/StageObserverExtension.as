package robotlegs.bender.extensions.viewManager
{
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
   import robotlegs.bender.extensions.viewManager.impl.StageObserver;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.impl.UID;
   
   public class StageObserverExtension implements IExtension
   {
      
      private static var _stageObserver:StageObserver;
      
      private static var _installCount:uint;
      
      private const _uid:String = UID.create(StageObserverExtension);
      
      private var _injector:Injector;
      
      public function StageObserverExtension()
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
         if(_stageObserver == null)
         {
            _loc1_ = this._injector.getInstance(ContainerRegistry);
            _stageObserver = new StageObserver(_loc1_);
         }
      }
      
      private function whenDestroying() : void
      {
         --_installCount;
         if(_installCount == 0)
         {
            _stageObserver.destroy();
            _stageObserver = null;
         }
      }
   }
}

