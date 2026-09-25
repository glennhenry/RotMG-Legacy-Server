package robotlegs.bender.extensions.signalCommandMap.api
{
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
   
   public interface ISignalCommandMap
   {
      
      function map(param1:Class, param2:Boolean = false) : ICommandMapper;
      
      function unmap(param1:Class) : ICommandUnmapper;
   }
}

