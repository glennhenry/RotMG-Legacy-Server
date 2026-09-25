package robotlegs.bender.extensions.mediatorMap.impl
{
   import flash.utils.Dictionary;
   import robotlegs.bender.extensions.matching.ITypeFilter;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingFinder;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
   
   public class MediatorMapper implements IMediatorMapper, IMediatorMappingFinder, IMediatorUnmapper
   {
      
      private const _mappings:Dictionary = new Dictionary();
      
      private var _matcher:ITypeFilter;
      
      private var _handler:IMediatorViewHandler;
      
      public function MediatorMapper(param1:ITypeFilter, param2:IMediatorViewHandler)
      {
         super();
         this._matcher = param1;
         this._handler = param2;
      }
      
      public function toMediator(param1:Class) : IMediatorMappingConfig
      {
         return this.lockedMappingFor(param1) || this.createMapping(param1);
      }
      
      public function forMediator(param1:Class) : IMediatorMapping
      {
         return this._mappings[param1];
      }
      
      public function fromMediator(param1:Class) : void
      {
         var _loc2_:IMediatorMapping = this._mappings[param1];
         delete this._mappings[param1];
         this._handler.removeMapping(_loc2_);
      }
      
      public function fromMediators() : void
      {
         var _loc1_:IMediatorMapping = null;
         for each(_loc1_ in this._mappings)
         {
            delete this._mappings[_loc1_.mediatorClass];
            this._handler.removeMapping(_loc1_);
         }
      }
      
      private function createMapping(param1:Class) : MediatorMapping
      {
         var _loc2_:MediatorMapping = new MediatorMapping(this._matcher,param1);
         this._handler.addMapping(_loc2_);
         this._mappings[param1] = _loc2_;
         return _loc2_;
      }
      
      private function lockedMappingFor(param1:Class) : MediatorMapping
      {
         var _loc2_:MediatorMapping = this._mappings[param1];
         if(_loc2_)
         {
            _loc2_.invalidate();
         }
         return _loc2_;
      }
   }
}

