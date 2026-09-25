package org.swiftsuspenders.reflection
{
   import org.swiftsuspenders.typedescriptions.TypeDescription;
   
   public interface Reflector
   {
      
      function getClass(param1:Object) : Class;
      
      function getFQCN(param1:*, param2:Boolean = false) : String;
      
      function typeImplements(param1:Class, param2:Class) : Boolean;
      
      function describeInjections(param1:Class) : TypeDescription;
   }
}

