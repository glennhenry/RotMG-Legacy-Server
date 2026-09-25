package robotlegs.bender.extensions.commandCenter.dsl
{
   public interface ICommandUnmapper
   {
      
      function fromCommand(param1:Class) : void;
      
      function fromAll() : void;
   }
}

