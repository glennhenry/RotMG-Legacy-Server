package org.swiftsuspenders.typedescriptions
{
   import org.swiftsuspenders.Injector;
   
   public class NoParamsConstructorInjectionPoint extends ConstructorInjectionPoint
   {
      
      public function NoParamsConstructorInjectionPoint()
      {
         super([],0,injectParameters);
      }
      
      override public function createInstance(param1:Class, param2:Injector) : Object
      {
         return new param1();
      }
   }
}

