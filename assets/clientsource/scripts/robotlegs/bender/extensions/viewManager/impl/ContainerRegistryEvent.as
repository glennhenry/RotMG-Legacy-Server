package robotlegs.bender.extensions.viewManager.impl
{
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class ContainerRegistryEvent extends Event
   {
      
      public static const CONTAINER_ADD:String = "containerAdd";
      
      public static const CONTAINER_REMOVE:String = "containerRemove";
      
      public static const ROOT_CONTAINER_ADD:String = "rootContainerAdd";
      
      public static const ROOT_CONTAINER_REMOVE:String = "rootContainerRemove";
      
      private var _container:DisplayObjectContainer;
      
      public function ContainerRegistryEvent(param1:String, param2:DisplayObjectContainer)
      {
         super(param1);
         this._container = param2;
      }
      
      public function get container() : DisplayObjectContainer
      {
         return this._container;
      }
      
      override public function clone() : Event
      {
         return new ContainerRegistryEvent(type,this._container);
      }
   }
}

