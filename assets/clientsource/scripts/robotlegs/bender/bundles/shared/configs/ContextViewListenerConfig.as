package robotlegs.bender.bundles.shared.configs
{
   import flash.display.DisplayObjectContainer;
   import robotlegs.bender.extensions.viewManager.api.IViewManager;
   
   public class ContextViewListenerConfig
   {
      
      [Inject]
      public var contextView:DisplayObjectContainer;
      
      [Inject]
      public var viewManager:IViewManager;
      
      public function ContextViewListenerConfig()
      {
         super();
      }
      
      [PostConstruct]
      public function init() : void
      {
         this.viewManager.addContainer(this.contextView);
      }
   }
}

