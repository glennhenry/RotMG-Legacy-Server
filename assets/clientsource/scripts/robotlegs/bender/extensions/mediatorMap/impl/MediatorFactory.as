package robotlegs.bender.extensions.mediatorMap.impl
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.matching.ITypeFilter;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
   import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
   import robotlegs.bender.framework.impl.applyHooks;
   import robotlegs.bender.framework.impl.guardsApprove;
   
   public class MediatorFactory extends EventDispatcher implements IMediatorFactory
   {
      
      private const _mediators:Dictionary = new Dictionary();
      
      private var _injector:Injector;
      
      public function MediatorFactory(param1:Injector)
      {
         super();
         this._injector = param1;
      }
      
      public function getMediator(param1:Object, param2:IMediatorMapping) : Object
      {
         return this._mediators[param1] ? this._mediators[param1][param2] : null;
      }
      
      public function createMediators(param1:Object, param2:Class, param3:Array) : Array
      {
         var _loc5_:ITypeFilter = null;
         var _loc6_:Object = null;
         var _loc7_:IMediatorMapping = null;
         var _loc4_:Array = [];
         for each(_loc7_ in param3)
         {
            _loc6_ = this.getMediator(param1,_loc7_);
            if(!_loc6_)
            {
               _loc5_ = _loc7_.matcher;
               this.mapTypeForFilterBinding(_loc5_,param2,param1);
               _loc6_ = this.createMediator(param1,_loc7_);
               this.unmapTypeForFilterBinding(_loc5_,param2,param1);
            }
            if(_loc6_)
            {
               _loc4_.push(_loc6_);
            }
         }
         return _loc4_;
      }
      
      public function removeMediators(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Dictionary = this._mediators[param1];
         if(!_loc2_)
         {
            return;
         }
         if(hasEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE))
         {
            for(_loc3_ in _loc2_)
            {
               dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_REMOVE,_loc2_[_loc3_],param1,_loc3_ as IMediatorMapping,this));
            }
         }
         delete this._mediators[param1];
      }
      
      public function removeAllMediators() : void
      {
         var _loc1_:Object = null;
         for(_loc1_ in this._mediators)
         {
            this.removeMediators(_loc1_);
         }
      }
      
      private function createMediator(param1:Object, param2:IMediatorMapping) : Object
      {
         var _loc3_:Object = this.getMediator(param1,param2);
         if(_loc3_)
         {
            return _loc3_;
         }
         if(guardsApprove(param2.guards,this._injector))
         {
            _loc3_ = this._injector.getInstance(param2.mediatorClass);
            this._injector.map(param2.mediatorClass).toValue(_loc3_);
            applyHooks(param2.hooks,this._injector);
            this._injector.unmap(param2.mediatorClass);
            this.addMediator(_loc3_,param1,param2);
         }
         return _loc3_;
      }
      
      private function addMediator(param1:Object, param2:Object, param3:IMediatorMapping) : void
      {
         this._mediators[param2] = this._mediators[param2] || new Dictionary();
         this._mediators[param2][param3] = param1;
         if(hasEventListener(MediatorFactoryEvent.MEDIATOR_CREATE))
         {
            dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_CREATE,param1,param2,param3,this));
         }
      }
      
      private function mapTypeForFilterBinding(param1:ITypeFilter, param2:Class, param3:Object) : void
      {
         var _loc4_:Class = null;
         var _loc5_:Vector.<Class> = this.requiredTypesFor(param1,param2);
         for each(_loc4_ in _loc5_)
         {
            this._injector.map(_loc4_).toValue(param3);
         }
      }
      
      private function unmapTypeForFilterBinding(param1:ITypeFilter, param2:Class, param3:Object) : void
      {
         var _loc4_:Class = null;
         var _loc5_:Vector.<Class> = this.requiredTypesFor(param1,param2);
         for each(_loc4_ in _loc5_)
         {
            if(this._injector.satisfiesDirectly(_loc4_))
            {
               this._injector.unmap(_loc4_);
            }
         }
      }
      
      private function requiredTypesFor(param1:ITypeFilter, param2:Class) : Vector.<Class>
      {
         var _loc3_:Vector.<Class> = param1.allOfTypes.concat(param1.anyOfTypes);
         if(_loc3_.indexOf(param2) == -1)
         {
            _loc3_.push(param2);
         }
         return _loc3_;
      }
   }
}

