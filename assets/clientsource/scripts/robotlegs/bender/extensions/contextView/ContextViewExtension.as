package robotlegs.bender.extensions.contextView
{
   import flash.display.DisplayObjectContainer;
   import org.hamcrest.object.instanceOf;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.IExtension;
   import robotlegs.bender.framework.api.ILogger;
   import robotlegs.bender.framework.impl.UID;
   
   public class ContextViewExtension implements IExtension
   {
      
      private const _uid:String = UID.create(ContextViewExtension);
      
      private var _injector:Injector;
      
      private var _logger:ILogger;
      
      public function ContextViewExtension()
      {
         super();
      }
      
      public function extend(param1:IContext) : void
      {
         this._injector = param1.injector;
         this._logger = param1.getLogger(this);
         param1.addConfigHandler(instanceOf(DisplayObjectContainer),this.handleContextView);
      }
      
      public function toString() : String
      {
         return this._uid;
      }
      
      private function handleContextView(param1:DisplayObjectContainer) : void
      {
         if(this._injector.satisfiesDirectly(DisplayObjectContainer))
         {
            this._logger.warn("A contextView has already been mapped, ignoring {0}",[param1]);
         }
         else
         {
            this._logger.debug("Mapping {0} as contextView",[param1]);
            this._injector.map(DisplayObjectContainer).toValue(param1);
         }
      }
   }
}

