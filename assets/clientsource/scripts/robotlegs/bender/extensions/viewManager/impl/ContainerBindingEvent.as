package robotlegs.bender.extensions.viewManager.impl
{
   import flash.events.Event;
   
   public class ContainerBindingEvent extends Event
   {
      
      public static const BINDING_EMPTY:String = "bindingEmpty";
      
      public function ContainerBindingEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new ContainerBindingEvent(type);
      }
   }
}

