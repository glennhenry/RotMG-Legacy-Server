package robotlegs.bender.extensions.matching
{
   import flash.errors.IllegalOperationError;
   
   public class TypeMatcher implements ITypeMatcher, ITypeMatcherFactory
   {
      
      protected const _allOfTypes:Vector.<Class> = new Vector.<Class>();
      
      protected const _anyOfTypes:Vector.<Class> = new Vector.<Class>();
      
      protected const _noneOfTypes:Vector.<Class> = new Vector.<Class>();
      
      protected var _typeFilter:ITypeFilter;
      
      public function TypeMatcher()
      {
         super();
      }
      
      public function allOf(... rest) : TypeMatcher
      {
         this.pushAddedTypesTo(rest,this._allOfTypes);
         return this;
      }
      
      public function anyOf(... rest) : TypeMatcher
      {
         this.pushAddedTypesTo(rest,this._anyOfTypes);
         return this;
      }
      
      public function noneOf(... rest) : TypeMatcher
      {
         this.pushAddedTypesTo(rest,this._noneOfTypes);
         return this;
      }
      
      public function createTypeFilter() : ITypeFilter
      {
         return this._typeFilter = this._typeFilter || this.buildTypeFilter();
      }
      
      public function lock() : ITypeMatcherFactory
      {
         this.createTypeFilter();
         return this;
      }
      
      public function clone() : TypeMatcher
      {
         return new TypeMatcher().allOf(this._allOfTypes).anyOf(this._anyOfTypes).noneOf(this._noneOfTypes);
      }
      
      protected function buildTypeFilter() : ITypeFilter
      {
         if(this._allOfTypes.length == 0 && this._anyOfTypes.length == 0 && this._noneOfTypes.length == 0)
         {
            throw new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER);
         }
         return new TypeFilter(this._allOfTypes,this._anyOfTypes,this._noneOfTypes);
      }
      
      protected function pushAddedTypesTo(param1:Array, param2:Vector.<Class>) : void
      {
         this._typeFilter && this.throwSealedMatcherError();
         this.pushValuesToClassVector(param1,param2);
      }
      
      protected function throwSealedMatcherError() : void
      {
         throw new IllegalOperationError("This TypeMatcher has been sealed and can no longer be configured");
      }
      
      protected function pushValuesToClassVector(param1:Array, param2:Vector.<Class>) : void
      {
         var _loc3_:Class = null;
         if(param1.length == 1 && (param1[0] is Array || param1[0] is Vector.<Class>))
         {
            for each(_loc3_ in param1[0])
            {
               param2.push(_loc3_);
            }
         }
         else
         {
            for each(_loc3_ in param1)
            {
               param2.push(_loc3_);
            }
         }
      }
   }
}

