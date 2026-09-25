package robotlegs.bender.extensions.mediatorMap.dsl
{
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
   
   public interface IMediatorMappingFinder
   {
      
      function forMediator(param1:Class) : IMediatorMapping;
   }
}

