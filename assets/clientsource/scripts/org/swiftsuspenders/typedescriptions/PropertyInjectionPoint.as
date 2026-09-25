package org.swiftsuspenders.typedescriptions
{
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import org.swiftsuspenders.Injector;
   import org.swiftsuspenders.dependencyproviders.DependencyProvider;
   import org.swiftsuspenders.errors.InjectorMissingMappingError;
   import org.swiftsuspenders.utils.SsInternal;
   
   public class PropertyInjectionPoint extends InjectionPoint
   {
      
      private var _propertyName:String;
      
      private var _mappingId:String;
      
      private var _optional:Boolean;
      
      public function PropertyInjectionPoint(param1:String, param2:String, param3:Boolean, param4:Dictionary)
      {
         super();
         this._propertyName = param2;
         this._mappingId = param1;
         this._optional = param3;
         this.injectParameters = param4;
      }
      
      override public function applyInjection(param1:Object, param2:Class, param3:Injector) : void
      {
         var _loc4_:DependencyProvider = param3.SsInternal::getProvider(this._mappingId);
         if(!_loc4_)
         {
            if(this._optional)
            {
               return;
            }
            throw new InjectorMissingMappingError("Injector is missing a mapping to handle injection into property \"" + this._propertyName + "\" of object \"" + param1 + "\" with type \"" + getQualifiedClassName(param2) + "\". Target dependency: \"" + this._mappingId + "\"");
         }
         param1[this._propertyName] = _loc4_.apply(param2,param3,injectParameters);
      }
   }
}

