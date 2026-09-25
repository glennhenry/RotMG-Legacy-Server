package org.swiftsuspenders.mapping
{
   import flash.events.Event;
   
   public class MappingEvent extends Event
   {
      
      public static const PRE_MAPPING_CREATE:String = "preMappingCreate";
      
      public static const POST_MAPPING_CREATE:String = "postMappingCreate";
      
      public static const PRE_MAPPING_CHANGE:String = "preMappingChange";
      
      public static const POST_MAPPING_CHANGE:String = "postMappingChange";
      
      public static const POST_MAPPING_REMOVE:String = "postMappingRemove";
      
      public static const MAPPING_OVERRIDE:String = "mappingOverride";
      
      public var mappedType:Class;
      
      public var mappedName:String;
      
      public var mapping:InjectionMapping;
      
      public function MappingEvent(param1:String, param2:Class, param3:String, param4:InjectionMapping)
      {
         super(param1);
         this.mappedType = param2;
         this.mappedName = param3;
         this.mapping = param4;
      }
      
      override public function clone() : Event
      {
         return new MappingEvent(type,this.mappedType,this.mappedName,this.mapping);
      }
   }
}

