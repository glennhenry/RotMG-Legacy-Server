package kabam.lib.ui
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   
   public class GroupMappedSignal extends Signal
   {
      
      private var eventType:String;
      
      private var mappedTargets:Dictionary = new Dictionary(true);
      
      public function GroupMappedSignal(param1:String, ... rest)
      {
         this.eventType = param1;
         super(rest);
      }
      
      public function map(param1:IEventDispatcher, param2:*) : void
      {
         this.mappedTargets[param1] = param2;
         param1.addEventListener(this.eventType,this.onTarget,false,0,true);
      }
      
      private function onTarget(param1:Event) : void
      {
         dispatch(this.mappedTargets[param1.target]);
      }
   }
}

