package robotlegs.bender.extensions.commandCenter.dsl
{
   public interface ICommandMapper
   {
      
      function toCommand(param1:Class) : ICommandMappingConfig;
   }
}

