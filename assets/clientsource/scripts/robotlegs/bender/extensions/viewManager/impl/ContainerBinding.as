package robotlegs.bender.extensions.viewManager.impl
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import robotlegs.bender.extensions.viewManager.api.IViewHandler;
   
   public class ContainerBinding extends EventDispatcher
   {
      
      private var _parent:ContainerBinding;
      
      private var _container:DisplayObjectContainer;
      
      private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>();
      
      public function ContainerBinding(param1:DisplayObjectContainer)
      {
         super();
         this._container = param1;
      }
      
      public function get parent() : ContainerBinding
      {
         return this._parent;
      }
      
      public function set parent(param1:ContainerBinding) : void
      {
         this._parent = param1;
      }
      
      public function get container() : DisplayObjectContainer
      {
         return this._container;
      }
      
      public function get numHandlers() : uint
      {
         return this._handlers.length;
      }
      
      public function addHandler(param1:IViewHandler) : void
      {
         if(this._handlers.indexOf(param1) > -1)
         {
            return;
         }
         this._handlers.push(param1);
      }
      
      public function removeHandler(param1:IViewHandler) : void
      {
         var _loc2_:int = this._handlers.indexOf(param1);
         if(_loc2_ > -1)
         {
            this._handlers.splice(_loc2_,1);
            if(this._handlers.length == 0)
            {
               dispatchEvent(new ContainerBindingEvent(ContainerBindingEvent.BINDING_EMPTY));
            }
         }
      }
      
      public function handleView(param1:DisplayObject, param2:Class) : void
      {
         var _loc5_:IViewHandler = null;
         var _loc3_:uint = this._handlers.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._handlers[_loc4_] as IViewHandler;
            _loc5_.handleView(param1,param2);
            _loc4_++;
         }
      }
   }
}

