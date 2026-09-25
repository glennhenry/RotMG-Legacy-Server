package robotlegs.bender.extensions.viewManager.impl
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class ConfigureViewEvent extends Event
   {
      
      public static const CONFIGURE_VIEW:String = "configureView";
      
      private var _view:DisplayObject;
      
      public function ConfigureViewEvent(param1:String, param2:DisplayObject = null)
      {
         super(param1,true,true);
         this._view = param2;
      }
      
      public function get view() : DisplayObject
      {
         return this._view;
      }
      
      override public function clone() : Event
      {
         return new ConfigureViewEvent(type,this._view);
      }
   }
}

