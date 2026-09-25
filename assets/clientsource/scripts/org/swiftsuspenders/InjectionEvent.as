package org.swiftsuspenders
{
   import flash.events.Event;
   
   public class InjectionEvent extends Event
   {
      
      public static const POST_INSTANTIATE:String = "postInstantiate";
      
      public static const PRE_CONSTRUCT:String = "preConstruct";
      
      public static const POST_CONSTRUCT:String = "postConstruct";
      
      public var instance:*;
      
      public var instanceType:Class;
      
      public function InjectionEvent(param1:String, param2:Object, param3:Class)
      {
         super(param1);
         this.instance = param2;
         this.instanceType = param3;
      }
      
      override public function clone() : Event
      {
         return new InjectionEvent(type,this.instance,this.instanceType);
      }
   }
}

