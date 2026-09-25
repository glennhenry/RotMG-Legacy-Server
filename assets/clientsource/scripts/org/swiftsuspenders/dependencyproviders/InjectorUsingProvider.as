package org.swiftsuspenders.dependencyproviders
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   
   public class InjectorUsingProvider extends ForwardingProvider
   {
      
      public var injector:Injector;
      
      public function InjectorUsingProvider(param1:Injector, param2:DependencyProvider)
      {
         super(param2);
         this.injector = param1;
      }
      
      override public function apply(param1:Class, param2:Injector, param3:Dictionary) : Object
      {
         return provider.apply(param1,this.injector,param3);
      }
   }
}

