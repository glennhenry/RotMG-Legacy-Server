package robotlegs.bender.extensions.commandCenter.impl
{
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
   
   public class NullCommandUnmapper implements ICommandUnmapper
   {
      
      public function NullCommandUnmapper()
      {
         super();
      }
      
      public function fromCommand(param1:Class) : void
      {
      }
      
      public function fromAll() : void
      {
      }
   }
}

