package robotlegs.bender.framework.api
{
   public interface IMessageDispatcher
   {
      
      function addMessageHandler(param1:Object, param2:Function) : void;
      
      function removeMessageHandler(param1:Object, param2:Function) : void;
      
      function hasMessageHandler(param1:Object) : Boolean;
      
      function dispatchMessage(param1:Object, param2:Function = null, param3:Boolean = false) : void;
   }
}

