package org.swiftsuspenders.dependencyproviders
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   
   public interface DependencyProvider
   {
      
      function apply(param1:Class, param2:Injector, param3:Dictionary) : Object;
      
      function destroy() : void;
   }
}

