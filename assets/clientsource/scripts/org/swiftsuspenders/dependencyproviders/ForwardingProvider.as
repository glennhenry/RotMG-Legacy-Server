package org.swiftsuspenders.dependencyproviders
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   
   public class ForwardingProvider implements DependencyProvider
   {
      
      public var provider:DependencyProvider;
      
      public function ForwardingProvider(param1:DependencyProvider)
      {
         super();
         this.provider = param1;
      }
      
      public function apply(param1:Class, param2:Injector, param3:Dictionary) : Object
      {
         return this.provider.apply(param1,param2,param3);
      }
      
      public function destroy() : void
      {
         this.provider.destroy();
      }
   }
}

