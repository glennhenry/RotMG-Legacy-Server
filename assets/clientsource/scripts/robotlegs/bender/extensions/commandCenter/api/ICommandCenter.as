package robotlegs.bender.extensions.commandCenter.api
{
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
   
   public interface ICommandCenter
   {
      
      function map(param1:ICommandTrigger) : ICommandMapper;
      
      function unmap(param1:ICommandTrigger) : ICommandUnmapper;
   }
}

