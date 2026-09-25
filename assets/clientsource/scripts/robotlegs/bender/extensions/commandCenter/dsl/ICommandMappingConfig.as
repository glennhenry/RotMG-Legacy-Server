package robotlegs.bender.extensions.commandCenter.dsl
{
   public interface ICommandMappingConfig
   {
      
      function withGuards(... rest) : ICommandMappingConfig;
      
      function withHooks(... rest) : ICommandMappingConfig;
      
      function once(param1:Boolean = true) : ICommandMappingConfig;
   }
}

