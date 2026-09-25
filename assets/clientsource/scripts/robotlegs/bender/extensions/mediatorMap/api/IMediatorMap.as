package robotlegs.bender.extensions.mediatorMap.api
{
   import robotlegs.bender.extensions.matching.ITypeMatcher;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
   
   public interface IMediatorMap
   {
      
      function mapMatcher(param1:ITypeMatcher) : IMediatorMapper;
      
      function map(param1:Class) : IMediatorMapper;
      
      function unmapMatcher(param1:ITypeMatcher) : IMediatorUnmapper;
      
      function unmap(param1:Class) : IMediatorUnmapper;
      
      function mediate(param1:Object) : void;
      
      function unmediate(param1:Object) : void;
   }
}

