package robotlegs.bender.extensions.viewManager.api
{
   import flash.display.DisplayObject;
   
   public interface IViewHandler
   {
      
      function handleView(param1:DisplayObject, param2:Class) : void;
   }
}

