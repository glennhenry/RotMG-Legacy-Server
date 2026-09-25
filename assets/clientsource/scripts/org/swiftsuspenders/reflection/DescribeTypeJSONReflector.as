package org.swiftsuspenders.reflection
{
   import avmplus.DescribeTypeJSON;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import org.swiftsuspenders.InjectorError;
   import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
   import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
   import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
   import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
   import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
   import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
   import org.swiftsuspenders.typedescriptions.TypeDescription;
   
   public class DescribeTypeJSONReflector extends ReflectorBase implements Reflector
   {
      
      private const _descriptor:DescribeTypeJSON = new DescribeTypeJSON();
      
      public function DescribeTypeJSONReflector()
      {
         super();
      }
      
      public function typeImplements(param1:Class, param2:Class) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         var _loc3_:String = getQualifiedClassName(param2);
         var _loc4_:Object = this._descriptor.getInstanceDescription(param1).traits;
         return (_loc4_.bases as Array).indexOf(_loc3_) > -1 || (_loc4_.interfaces as Array).indexOf(_loc3_) > -1;
      }
      
      public function describeInjections(param1:Class) : TypeDescription
      {
         var _loc2_:Object = null;
         _loc2_ = this._descriptor.getInstanceDescription(param1);
         var _loc3_:Object = _loc2_.traits;
         var _loc4_:String = _loc2_.name;
         var _loc5_:TypeDescription = new TypeDescription(false);
         this.addCtorInjectionPoint(_loc5_,_loc3_,_loc4_);
         this.addFieldInjectionPoints(_loc5_,_loc3_.variables);
         this.addFieldInjectionPoints(_loc5_,_loc3_.accessors);
         this.addMethodInjectionPoints(_loc5_,_loc3_.methods,_loc4_);
         this.addPostConstructMethodPoints(_loc5_,_loc3_.variables,_loc4_);
         this.addPostConstructMethodPoints(_loc5_,_loc3_.accessors,_loc4_);
         this.addPostConstructMethodPoints(_loc5_,_loc3_.methods,_loc4_);
         this.addPreDestroyMethodPoints(_loc5_,_loc3_.methods,_loc4_);
         return _loc5_;
      }
      
      private function addCtorInjectionPoint(param1:TypeDescription, param2:Object, param3:String) : void
      {
         var _loc5_:Dictionary = null;
         var _loc6_:Array = null;
         var _loc4_:Array = param2.constructor;
         if(!_loc4_)
         {
            param1.ctor = param2.bases.length > 0 ? new NoParamsConstructorInjectionPoint() : null;
            return;
         }
         _loc5_ = this.extractTagParameters("Inject",param2.metadata);
         _loc6_ = ((_loc5_) && _loc5_.name || "").split(",");
         var _loc7_:int = int(this.gatherMethodParameters(_loc4_,_loc6_,param3));
         param1.ctor = new ConstructorInjectionPoint(_loc4_,_loc7_,_loc5_);
      }
      
      private function addMethodInjectionPoints(param1:TypeDescription, param2:Array, param3:String) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Dictionary = null;
         var _loc8_:Boolean = false;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:uint = 0;
         var _loc12_:MethodInjectionPoint = null;
         if(!param2)
         {
            return;
         }
         var _loc4_:uint = param2.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param2[_loc5_];
            _loc7_ = this.extractTagParameters("Inject",_loc6_.metadata);
            if(_loc7_)
            {
               _loc8_ = _loc7_.optional == "true";
               _loc9_ = (_loc7_.name || "").split(",");
               _loc10_ = _loc6_.parameters;
               _loc11_ = this.gatherMethodParameters(_loc10_,_loc9_,param3);
               _loc12_ = new MethodInjectionPoint(_loc6_.name,_loc10_,_loc11_,_loc8_,_loc7_);
               param1.addInjectionPoint(_loc12_);
            }
            _loc5_++;
         }
      }
      
      private function addPostConstructMethodPoints(param1:TypeDescription, param2:Array, param3:String) : void
      {
         var _loc4_:Array = this.gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint,"PostConstruct",param2,param3);
         var _loc5_:int = 0;
         var _loc6_:int = int(_loc4_.length);
         while(_loc5_ < _loc6_)
         {
            param1.addInjectionPoint(_loc4_[_loc5_]);
            _loc5_++;
         }
      }
      
      private function addPreDestroyMethodPoints(param1:TypeDescription, param2:Array, param3:String) : void
      {
         var _loc4_:Array = this.gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint,"PreDestroy",param2,param3);
         if(!_loc4_.length)
         {
            return;
         }
         param1.preDestroyMethods = _loc4_[0];
         param1.preDestroyMethods.last = _loc4_[0];
         var _loc5_:int = 1;
         var _loc6_:int = int(_loc4_.length);
         while(_loc5_ < _loc6_)
         {
            param1.preDestroyMethods.last.next = _loc4_[_loc5_];
            param1.preDestroyMethods.last = _loc4_[_loc5_];
            _loc5_++;
         }
      }
      
      private function addFieldInjectionPoints(param1:TypeDescription, param2:Array) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Dictionary = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:PropertyInjectionPoint = null;
         if(!param2)
         {
            return;
         }
         var _loc3_:uint = param2.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param2[_loc4_];
            _loc6_ = this.extractTagParameters("Inject",_loc5_.metadata);
            if(_loc6_)
            {
               _loc7_ = _loc6_.name || "";
               _loc8_ = _loc6_.optional == "true";
               _loc9_ = new PropertyInjectionPoint(_loc5_.type + "|" + _loc7_,_loc5_.name,_loc8_,_loc6_);
               param1.addInjectionPoint(_loc9_);
            }
            _loc4_++;
         }
      }
      
      private function gatherMethodParameters(param1:Array, param2:Array, param3:String) : uint
      {
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param1[_loc6_];
            _loc8_ = param2[_loc6_] || "";
            _loc9_ = _loc7_.type;
            if(_loc9_ == "*")
            {
               if(!_loc7_.optional)
               {
                  throw new InjectorError("Error in method definition of injectee \"" + param3 + ". Required parameters can\'t have type \"*\".");
               }
               _loc9_ = null;
            }
            if(!_loc7_.optional)
            {
               _loc4_++;
            }
            param1[_loc6_] = _loc9_ + "|" + _loc8_;
            _loc6_++;
         }
         return _loc4_;
      }
      
      private function gatherOrderedInjectionPointsForTag(param1:Class, param2:String, param3:Array, param4:String) : Array
      {
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc5_:Array = [];
         if(!param3)
         {
            return _loc5_;
         }
         var _loc6_:uint = param3.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param3[_loc7_];
            _loc9_ = this.extractTagParameters(param2,_loc8_.metadata);
            if(_loc9_)
            {
               _loc10_ = (_loc9_.name || "").split(",");
               _loc11_ = _loc8_.parameters;
               if(_loc11_)
               {
                  _loc12_ = this.gatherMethodParameters(_loc11_,_loc10_,param4);
               }
               else
               {
                  _loc11_ = [];
                  _loc12_ = 0;
               }
               _loc13_ = parseInt(_loc9_.order,10);
               if(_loc13_.toString(10) != _loc9_.order)
               {
                  _loc13_ = int.MAX_VALUE;
               }
               _loc5_.push(new param1(_loc8_.name,_loc11_,_loc12_,_loc13_));
            }
            _loc7_++;
         }
         if(_loc5_.length > 0)
         {
            _loc5_.sortOn("order",Array.NUMERIC);
         }
         return _loc5_;
      }
      
      private function extractTagParameters(param1:String, param2:Array) : Dictionary
      {
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Dictionary = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc3_:uint = param2 ? param2.length : 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param2[_loc4_];
            if(_loc5_.name == param1)
            {
               _loc6_ = _loc5_.value;
               _loc7_ = new Dictionary();
               _loc8_ = int(_loc6_.length);
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc10_ = _loc6_[_loc9_];
                  _loc7_[_loc10_.key] = _loc7_[_loc10_.key] ? _loc7_[_loc10_.key] + "," + _loc10_.value : _loc10_.value;
                  _loc9_++;
               }
               return _loc7_;
            }
            _loc4_++;
         }
         return null;
      }
   }
}

