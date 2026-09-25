package org.swiftsuspenders.typedescriptions
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   
   public class InjectionPoint
   {
      
      public var next:InjectionPoint;
      
      public var last:InjectionPoint;
      
      public var injectParameters:Dictionary;
      
      public function InjectionPoint()
      {
         super();
      }
      
      public function applyInjection(param1:Object, param2:Class, param3:Injector) : void
      {
      }
   }
}

