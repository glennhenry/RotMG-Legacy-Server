package org.swiftsuspenders.dependencyproviders
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   
   public class ValueProvider implements DependencyProvider
   {
      
      private var _value:Object;
      
      public function ValueProvider(param1:Object)
      {
         super();
         this._value = param1;
      }
      
      public function apply(param1:Class, param2:Injector, param3:Dictionary) : Object
      {
         return this._value;
      }
      
      public function destroy() : void
      {
      }
   }
}

