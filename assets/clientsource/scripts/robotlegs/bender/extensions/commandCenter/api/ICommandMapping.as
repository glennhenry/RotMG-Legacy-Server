package robotlegs.bender.extensions.commandCenter.api
{
   public interface ICommandMapping
   {
      
      function get commandClass() : Class;
      
      function get guards() : Array;
      
      function get hooks() : Array;
      
      function get fireOnce() : Boolean;
      
      function validate() : void;
      
      function get next() : ICommandMapping;
      
      function set next(param1:ICommandMapping) : void;
   }
}

