package robotlegs.bender.extensions.eventCommandMap.api
{
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
   
   public interface IEventCommandMap
   {
      
      function map(param1:String, param2:Class = null) : ICommandMapper;
      
      function unmap(param1:String, param2:Class = null) : ICommandUnmapper;
   }
}

