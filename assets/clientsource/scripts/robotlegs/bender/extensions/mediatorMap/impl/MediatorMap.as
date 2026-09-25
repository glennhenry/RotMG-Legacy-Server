package robotlegs.bender.extensions.mediatorMap.impl
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import robotlegs.bender.extensions.matching.ITypeMatcher;
   import robotlegs.bender.extensions.matching.TypeMatcher;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
   import robotlegs.bender.extensions.viewManager.api.IViewHandler;
   
   public class MediatorMap implements IMediatorMap, IViewHandler
   {
      
      private const _mappers:Dictionary = new Dictionary();
      
      private var _handler:IMediatorViewHandler;
      
      private var _factory:IMediatorFactory;
      
      private const NULL_UNMAPPER:IMediatorUnmapper = new NullMediatorUnmapper();
      
      public function MediatorMap(param1:IMediatorFactory, param2:IMediatorViewHandler = null)
      {
         super();
         this._factory = param1;
         this._handler = param2 || new MediatorViewHandler(this._factory);
      }
      
      public function mapMatcher(param1:ITypeMatcher) : IMediatorMapper
      {
         return this._mappers[param1.createTypeFilter().descriptor] = this._mappers[param1.createTypeFilter().descriptor] || this.createMapper(param1);
      }
      
      public function map(param1:Class) : IMediatorMapper
      {
         var _loc2_:ITypeMatcher = new TypeMatcher().allOf(param1);
         return this.mapMatcher(_loc2_);
      }
      
      public function unmapMatcher(param1:ITypeMatcher) : IMediatorUnmapper
      {
         return this._mappers[param1.createTypeFilter().descriptor] || this.NULL_UNMAPPER;
      }
      
      public function unmap(param1:Class) : IMediatorUnmapper
      {
         var _loc2_:ITypeMatcher = new TypeMatcher().allOf(param1);
         return this.unmapMatcher(_loc2_);
      }
      
      public function handleView(param1:DisplayObject, param2:Class) : void
      {
         this._handler.handleView(param1,param2);
      }
      
      public function mediate(param1:Object) : void
      {
         var _loc2_:Class = param1.constructor as Class;
         this._handler.handleItem(param1,_loc2_);
      }
      
      public function unmediate(param1:Object) : void
      {
         this._factory.removeMediators(param1);
      }
      
      private function createMapper(param1:ITypeMatcher, param2:Class = null) : IMediatorMapper
      {
         return new MediatorMapper(param1.createTypeFilter(),this._handler);
      }
   }
}

