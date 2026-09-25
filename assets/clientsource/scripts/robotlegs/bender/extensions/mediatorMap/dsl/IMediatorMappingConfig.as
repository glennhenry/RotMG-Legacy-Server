package robotlegs.bender.extensions.mediatorMap.dsl
{
   public interface IMediatorMappingConfig
   {
      
      function withGuards(... rest) : IMediatorMappingConfig;
      
      function withHooks(... rest) : IMediatorMappingConfig;
   }
}

