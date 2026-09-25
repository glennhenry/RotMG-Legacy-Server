package robotlegs.bender.extensions.stageSync
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import org.hamcrest.object.instanceOf;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.api.ILogger;
   import robotlegs.bender.framework.impl.UID;
   
   public class StageSyncExtension implements IExtension
   {
      
      private const _uid:String = UID.create(StageSyncExtension);
      
      private var _context:IContext;
      
      private var _contextView:DisplayObjectContainer;
      
      private var _logger:ILogger;
      
      public function StageSyncExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         this._context = param1;
         this._logger = param1.getLogger(this);
         this._context.addConfigHandler(instanceOf(DisplayObjectContainer),this.handleContextView);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function handleContextView(param1:DisplayObjectContainer) : void
      {
         if(this._contextView)
         {
            this._logger.warn("A contextView has already been set, ignoring {0}",[param1]);
            return;
         }
         this._contextView = param1;
         if(this._contextView.stage)
         {
            this.initializeContext();
         }
         else
         {
            this._logger.debug("Context view is not yet on stage. Waiting...");
            this._contextView.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this._contextView.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.initializeContext();
      }
      
      private function initializeContext() : void
      {
         this._logger.debug("Context view is now on stage. Initializing context...");
         this._context.lifecycle.initialize();
         this._contextView.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this._logger.debug("Context view has left the stage. Destroying context...");
         this._contextView.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this._context.lifecycle.destroy();
      }
   }
}

