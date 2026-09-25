package robotlegs.bender.extensions.mediatorMap.impl
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
   import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
   
   public class DefaultMediatorManager
   {
      
      private static var UIComponentClass:Class;
      
      private static const flexAvailable:Boolean = checkFlex();
      
      private var _factory:IMediatorFactory;
      
      public function DefaultMediatorManager(param1:IMediatorFactory)
      {
         super();
         this._factory = param1;
         this._factory.addEventListener(MediatorFactoryEvent.MEDIATOR_CREATE,this.onMediatorCreate);
         this._factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE,this.onMediatorRemove);
      }
      
      private static function checkFlex() : Boolean
      {
         try
         {
            UIComponentClass = getDefinitionByName("mx.core::UIComponent") as Class;
         }
         catch(error:Error)
         {
         }
         return UIComponentClass != null;
      }
      
      private function onMediatorCreate(param1:MediatorFactoryEvent) : void
      {
         var mediator:Object = null;
         var displayObject:DisplayObject = null;
         var event:MediatorFactoryEvent = param1;
         mediator = event.mediator;
         displayObject = event.view as DisplayObject;
         if(!displayObject)
         {
            this.initializeMediator(event.view,mediator);
            return;
         }
         displayObject.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         if(flexAvailable && displayObject is UIComponentClass && !displayObject["initialized"])
         {
            displayObject.addEventListener("creationComplete",function(param1:Event):void
            {
               displayObject.removeEventListener("creationComplete",arguments.callee);
               if(_factory.getMediator(displayObject,event.mapping))
               {
                  initializeMediator(displayObject,mediator);
               }
            });
         }
         else
         {
            this.initializeMediator(displayObject,mediator);
         }
      }
      
      private function onMediatorRemove(param1:MediatorFactoryEvent) : void
      {
         var _loc2_:DisplayObject = param1.view as DisplayObject;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
         if(param1.mediator)
         {
            this.destroyMediator(param1.mediator);
         }
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this._factory.removeMediators(param1.target);
      }
      
      private function initializeMediator(param1:Object, param2:Object) : void
      {
         if(param2.hasOwnProperty("viewComponent"))
         {
            param2.viewComponent = param1;
         }
         if(param2.hasOwnProperty("initialize"))
         {
            param2.initialize();
         }
      }
      
      private function destroyMediator(param1:Object) : void
      {
         if(param1.hasOwnProperty("destroy"))
         {
            param1.destroy();
         }
      }
   }
}

