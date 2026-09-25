package robotlegs.bender.framework.api
{
   public interface ILogger
   {
      
      function debug(param1:*, param2:Array = null) : void;
      
      function info(param1:*, param2:Array = null) : void;
      
      function warn(param1:*, param2:Array = null) : void;
      
      function error(param1:*, param2:Array = null) : void;
      
      function fatal(param1:*, param2:Array = null) : void;
   }
}

