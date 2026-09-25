package org.swiftsuspenders.typedescriptions
{
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import org.swiftsuspenders.InjectorError;
   
   public class TypeDescription
   {
      
      public var ctor:ConstructorInjectionPoint;
      
      public var injectionPoints:InjectionPoint;
      
      public var preDestroyMethods:PreDestroyInjectionPoint;
      
      private var _postConstructAdded:Boolean;
      
      public function TypeDescription(param1:Boolean = true)
      {
         super();
         if(param1)
         {
            this.ctor = new NoParamsConstructorInjectionPoint();
         }
      }
      
      public function setConstructor(param1:Array, param2:Array = null, param3:uint = 2147483647, param4:Dictionary = null) : TypeDescription
      {
         this.ctor = new ConstructorInjectionPoint(this.createParameterMappings(param1,param2 || []),param3,param4);
         return this;
      }
      
      public function addFieldInjection(param1:String, param2:Class, param3:String = "", param4:Boolean = false, param5:Dictionary = null) : TypeDescription
      {
         if(this._postConstructAdded)
         {
            throw new InjectorError("Can\'t add injection point after post construct method");
         }
         this.addInjectionPoint(new PropertyInjectionPoint(getQualifiedClassName(param2) + "|" + param3,param1,param4,param5));
         return this;
      }
      
      public function addMethodInjection(param1:String, param2:Array, param3:Array = null, param4:uint = 2147483647, param5:Boolean = false, param6:Dictionary = null) : TypeDescription
      {
         if(this._postConstructAdded)
         {
            throw new InjectorError("Can\'t add injection point after post construct method");
         }
         this.addInjectionPoint(new MethodInjectionPoint(param1,this.createParameterMappings(param2,param3 || []),Math.min(param4,param2.length),param5,param6));
         return this;
      }
      
      public function addPostConstructMethod(param1:String, param2:Array, param3:Array = null, param4:uint = 2147483647) : TypeDescription
      {
         this._postConstructAdded = true;
         this.addInjectionPoint(new PostConstructInjectionPoint(param1,this.createParameterMappings(param2,param3 || []),Math.min(param4,param2.length),0));
         return this;
      }
      
      public function addPreDestroyMethod(param1:String, param2:Array, param3:Array = null, param4:uint = 2147483647) : TypeDescription
      {
         var _loc5_:PreDestroyInjectionPoint = new PreDestroyInjectionPoint(param1,this.createParameterMappings(param2,param3 || []),Math.min(param4,param2.length),0);
         if(this.preDestroyMethods)
         {
            this.preDestroyMethods.last.next = _loc5_;
            this.preDestroyMethods.last = _loc5_;
         }
         else
         {
            this.preDestroyMethods = _loc5_;
            this.preDestroyMethods.last = _loc5_;
         }
         return this;
      }
      
      public function addInjectionPoint(param1:InjectionPoint) : void
      {
         if(this.injectionPoints)
         {
            this.injectionPoints.last.next = param1;
            this.injectionPoints.last = param1;
         }
         else
         {
            this.injectionPoints = param1;
            this.injectionPoints.last = param1;
         }
      }
      
      private function createParameterMappings(param1:Array, param2:Array) : Array
      {
         var _loc3_:Array = new Array(param1.length);
         var _loc4_:* = int(_loc3_.length);
         while(_loc4_--)
         {
            _loc3_[_loc4_] = getQualifiedClassName(param1[_loc4_]) + "|" + (param2[_loc4_] || "");
         }
         return _loc3_;
      }
   }
}

