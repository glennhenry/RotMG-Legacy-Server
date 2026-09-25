package org.swiftsuspenders.utils
{
   import flash.utils.Dictionary;
   import org.swiftsuspenders.reflection.Reflector;
   import org.swiftsuspenders.typedescriptions.TypeDescription;
   
   public class TypeDescriptor
   {
      
      public var _descriptionsCache:Dictionary;
      
      private var _reflector:Reflector;
      
      public function TypeDescriptor(param1:Reflector, param2:Dictionary)
      {
         super();
         this._descriptionsCache = param2;
         this._reflector = param1;
      }
      
      public function getDescription(param1:Class) : TypeDescription
      {
         return this._descriptionsCache[param1] = this._descriptionsCache[param1] || this._reflector.describeInjections(param1);
      }
      
      public function addDescription(param1:Class, param2:TypeDescription) : void
      {
         this._descriptionsCache[param1] = param2;
      }
   }
}

