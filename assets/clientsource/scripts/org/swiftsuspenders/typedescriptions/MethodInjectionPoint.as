package org.swiftsuspenders.typedescriptions
{
   import avmplus.getQualifiedClassName;
   import flash.utils.Dictionary;
   import org.swiftsuspenders.Injector;
   import org.swiftsuspenders.dependencyproviders.DependencyProvider;
   import org.swiftsuspenders.errors.InjectorMissingMappingError;
   import org.swiftsuspenders.utils.SsInternal;
   
   public class MethodInjectionPoint extends InjectionPoint
   {
      
      private static const _parameterValues:Array = [];
      
      protected var _parameterMappingIDs:Array;
      
      protected var _requiredParameters:int;
      
      private var _isOptional:Boolean;
      
      private var _methodName:String;
      
      public function MethodInjectionPoint(param1:String, param2:Array, param3:uint, param4:Boolean, param5:Dictionary)
      {
         super();
         this._methodName = param1;
         this._parameterMappingIDs = param2;
         this._requiredParameters = param3;
         this._isOptional = param4;
         this.injectParameters = param5;
      }
      
      override public function applyInjection(param1:Object, param2:Class, param3:Injector) : void
      {
         var _loc4_:Array = this.gatherParameterValues(param1,param2,param3);
         if(_loc4_.length >= this._requiredParameters)
         {
            (param1[this._methodName] as Function).apply(param1,_loc4_);
         }
         _loc4_.length = 0;
      }
      
      protected function gatherParameterValues(param1:Object, param2:Class, param3:Injector) : Array
      {
         var _loc7_:String = null;
         var _loc8_:DependencyProvider = null;
         var _loc4_:int = int(this._parameterMappingIDs.length);
         var _loc5_:Array = _parameterValues;
         _loc5_.length = _loc4_;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = this._parameterMappingIDs[_loc6_];
            _loc8_ = param3.SsInternal::getProvider(_loc7_);
            if(!_loc8_)
            {
               if(_loc6_ >= this._requiredParameters || this._isOptional)
               {
                  break;
               }
               throw new InjectorMissingMappingError("Injector is missing a mapping to handle injection into target \"" + param1 + "\" of type \"" + getQualifiedClassName(param2) + "\". \t\t\t\t\t\tTarget dependency: " + _loc7_ + ", method: " + this._methodName + ", parameter: " + (_loc6_ + 1));
            }
            _loc5_[_loc6_] = _loc8_.apply(param2,param3,injectParameters);
            _loc6_++;
         }
         return _loc5_;
      }
   }
}

