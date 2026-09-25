package robotlegs.bender.extensions.mediatorMap.api
{
   import robotlegs.bender.extensions.viewManager.api.IViewHandler;
   
   public interface IMediatorViewHandler extends IViewHandler
   {
      
      function addMapping(param1:IMediatorMapping) : void;
      
      function removeMapping(param1:IMediatorMapping) : void;
      
      function handleItem(param1:Object, param2:Class) : void;
   }
}

