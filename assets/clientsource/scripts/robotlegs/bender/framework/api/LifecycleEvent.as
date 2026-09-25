package robotlegs.bender.framework.api
{
   import flash.events.Event;
   
   public class LifecycleEvent extends Event
   {
      
      public static const ERROR:String = "error";
      
      public static const PRE_INITIALIZE:String = "preInitialize";
      
      public static const INITIALIZE:String = "initialize";
      
      public static const POST_INITIALIZE:String = "postInitialize";
      
      public static const PRE_SUSPEND:String = "preSuspend";
      
      public static const SUSPEND:String = "suspend";
      
      public static const POST_SUSPEND:String = "postSuspend";
      
      public static const PRE_RESUME:String = "preResume";
      
      public static const RESUME:String = "resume";
      
      public static const POST_RESUME:String = "postResume";
      
      public static const PRE_DESTROY:String = "preDestroy";
      
      public static const DESTROY:String = "destroy";
      
      public static const POST_DESTROY:String = "postDestroy";
      
      public var error:Error;
      
      public function LifecycleEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         var _loc1_:LifecycleEvent = new LifecycleEvent(type);
         _loc1_.error = this.error;
         return _loc1_;
      }
   }
}

