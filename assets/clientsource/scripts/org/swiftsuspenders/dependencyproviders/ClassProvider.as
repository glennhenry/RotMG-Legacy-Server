package org.swiftsuspenders.dependencyproviders
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   import org.swiftsuspenders.utils.SsInternal;
   
   public class ClassProvider implements DependencyProvider
   {
      
      private var _responseType:Class;
      
      public function ClassProvider(param1:Class)
      {
         super();
         this._responseType = param1;
      }
      
      public function apply(param1:Class, param2:Injector, param3:Dictionary) : Object
      {
         return param2.SsInternal::instantiateUnmapped(this._responseType);
      }
      
      public function destroy() : void
      {
      }
   }
}

