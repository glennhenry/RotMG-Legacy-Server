package org.swiftsuspenders.reflection
{
   import flash.utils.*;
   import org.swiftsuspenders.InjectorError;
   import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
   import org.swiftsuspenders.typedescriptions.MethodInjectionPoint;
   import org.swiftsuspenders.typedescriptions.NoParamsConstructorInjectionPoint;
   import org.swiftsuspenders.typedescriptions.PostConstructInjectionPoint;
   import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
   import org.swiftsuspenders.typedescriptions.PropertyInjectionPoint;
   import org.swiftsuspenders.typedescriptions.TypeDescription;
   
   public class DescribeTypeReflector extends ReflectorBase implements Reflector
   {
      
      private var _currentFactoryXML:XML;
      
      public function DescribeTypeReflector()
      {
         super();
      }
      
      public function typeImplements(param1:Class, param2:Class) : Boolean
      {
         var factoryDescription:XML;
         var type:Class = param1;
         var superType:Class = param2;
         if(type == superType)
         {
            return true;
         }
         factoryDescription = describeType(type).factory[0];
         return factoryDescription.children().(name() == "implementsInterface" || name() == "extendsClass").(attribute("type") == getQualifiedClassName(superType)).length() > 0;
      }
      
      public function describeInjections(param1:Class) : TypeDescription
      {
         this._currentFactoryXML = describeType(param1).factory[0];
         var _loc2_:TypeDescription = new TypeDescription(false);
         this.addCtorInjectionPoint(_loc2_,param1);
         this.addFieldInjectionPoints(_loc2_);
         this.addMethodInjectionPoints(_loc2_);
         this.addPostConstructMethodPoints(_loc2_);
         this.addPreDestroyMethodPoints(_loc2_);
         this._currentFactoryXML = null;
         return _loc2_;
      }
      
      private function addCtorInjectionPoint(param1:TypeDescription, param2:Class) : void
      {
         var parameterNames:Array;
         var parameterNodes:XMLList;
         var requiredParameters:uint;
         var injectParameters:Dictionary = null;
         var parameters:Array = null;
         var description:TypeDescription = param1;
         var type:Class = param2;
         var node:XML = this._currentFactoryXML.constructor[0];
         if(!node)
         {
            if(this._currentFactoryXML.parent().@name == "Object" || this._currentFactoryXML.extendsClass.length() > 0)
            {
               description.ctor = new NoParamsConstructorInjectionPoint();
            }
            return;
         }
         injectParameters = this.extractNodeParameters(node.parent().metadata.arg);
         parameterNames = (injectParameters.name || "").split(",");
         parameterNodes = node.parameter;
         if(parameterNodes.(@type == "*").length() == parameterNodes.@type.length())
         {
            this.createDummyInstance(node,type);
         }
         parameters = this.gatherMethodParameters(parameterNodes,parameterNames);
         requiredParameters = uint(parameters.required);
         delete parameters.required;
         description.ctor = new ConstructorInjectionPoint(parameters,requiredParameters,injectParameters);
      }
      
      private function extractNodeParameters(param1:XMLList) : Dictionary
      {
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:uint = uint(param1.length());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc5_.@key;
            _loc2_[_loc6_] = _loc2_[_loc6_] ? _loc2_[_loc6_] + "," + _loc5_.attribute("value") : _loc5_.attribute("value");
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function addFieldInjectionPoints(param1:TypeDescription) : void
      {
         var node:XML = null;
         var mappingId:String = null;
         var propertyName:String = null;
         var injectParameters:Dictionary = null;
         var injectionPoint:PropertyInjectionPoint = null;
         var description:TypeDescription = param1;
         for each(node in this._currentFactoryXML.*.(name() == "variable" || name() == "accessor").metadata.(@name == "Inject"))
         {
            mappingId = node.parent().@type + "|" + node.arg.(@key == "name").attribute("value");
            propertyName = node.parent().@name;
            injectParameters = this.extractNodeParameters(node.arg);
            injectionPoint = new PropertyInjectionPoint(mappingId,propertyName,injectParameters.optional == "true",injectParameters);
            description.addInjectionPoint(injectionPoint);
         }
      }
      
      private function addMethodInjectionPoints(param1:TypeDescription) : void
      {
         var node:XML = null;
         var injectParameters:Dictionary = null;
         var parameterNames:Array = null;
         var parameters:Array = null;
         var requiredParameters:uint = 0;
         var injectionPoint:MethodInjectionPoint = null;
         var description:TypeDescription = param1;
         for each(node in this._currentFactoryXML.method.metadata.(@name == "Inject"))
         {
            injectParameters = this.extractNodeParameters(node.arg);
            parameterNames = (injectParameters.name || "").split(",");
            parameters = this.gatherMethodParameters(node.parent().parameter,parameterNames);
            requiredParameters = uint(parameters.required);
            delete parameters.required;
            injectionPoint = new MethodInjectionPoint(node.parent().@name,parameters,requiredParameters,injectParameters.optional == "true",injectParameters);
            description.addInjectionPoint(injectionPoint);
         }
      }
      
      private function addPostConstructMethodPoints(param1:TypeDescription) : void
      {
         var _loc2_:Array = this.gatherOrderedInjectionPointsForTag(PostConstructInjectionPoint,"PostConstruct");
         var _loc3_:int = 0;
         var _loc4_:int = int(_loc2_.length);
         while(_loc3_ < _loc4_)
         {
            param1.addInjectionPoint(_loc2_[_loc3_]);
            _loc3_++;
         }
      }
      
      private function addPreDestroyMethodPoints(param1:TypeDescription) : void
      {
         var _loc2_:Array = this.gatherOrderedInjectionPointsForTag(PreDestroyInjectionPoint,"PreDestroy");
         if(!_loc2_.length)
         {
            return;
         }
         param1.preDestroyMethods = _loc2_[0];
         param1.preDestroyMethods.last = _loc2_[0];
         var _loc3_:int = 1;
         var _loc4_:int = int(_loc2_.length);
         while(_loc3_ < _loc4_)
         {
            param1.preDestroyMethods.last.next = _loc2_[_loc3_];
            param1.preDestroyMethods.last = _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      private function gatherMethodParameters(param1:XMLList, param2:Array) : Array
      {
         var _loc4_:uint = 0;
         var _loc7_:XML = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc3_:uint = 0;
         _loc4_ = uint(param1.length());
         var _loc5_:Array = new Array(_loc4_);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param1[_loc6_];
            _loc8_ = param2[_loc6_] || "";
            _loc9_ = _loc7_.@type;
            _loc10_ = _loc7_.@optional == "true";
            if(_loc9_ == "*")
            {
               if(!_loc10_)
               {
                  throw new InjectorError("Error in method definition of injectee \"" + this._currentFactoryXML.@type + "Required parameters can\'t have type \"*\".");
               }
               _loc9_ = null;
            }
            if(!_loc10_)
            {
               _loc3_++;
            }
            _loc5_[_loc6_] = _loc9_ + "|" + _loc8_;
            _loc6_++;
         }
         _loc5_.required = _loc3_;
         return _loc5_;
      }
      
      private function gatherOrderedInjectionPointsForTag(param1:Class, param2:String) : Array
      {
         var node:XML = null;
         var injectParameters:Dictionary = null;
         var parameterNames:Array = null;
         var parameters:Array = null;
         var requiredParameters:uint = 0;
         var order:Number = NaN;
         var injectionPointType:Class = param1;
         var tag:String = param2;
         var injectionPoints:Array = [];
         for each(node in this._currentFactoryXML..metadata.(@name == tag))
         {
            injectParameters = this.extractNodeParameters(node.arg);
            parameterNames = (injectParameters.name || "").split(",");
            parameters = this.gatherMethodParameters(node.parent().parameter,parameterNames);
            requiredParameters = uint(parameters.required);
            delete parameters.required;
            order = parseInt(node.arg.(@key == "order").@value);
            injectionPoints.push(new injectionPointType(node.parent().@name,parameters,requiredParameters,isNaN(order) ? int.MAX_VALUE : order));
         }
         if(injectionPoints.length > 0)
         {
            injectionPoints.sortOn("order",Array.NUMERIC);
         }
         return injectionPoints;
      }
      
      private function createDummyInstance(param1:XML, param2:Class) : void
      {
         var constructorNode:XML = param1;
         var clazz:Class = param2;
         try
         {
            switch(constructorNode.children().length())
            {
               case 0:
                  new clazz();
                  break;
               case 1:
                  new clazz(null);
                  break;
               case 2:
                  new clazz(null,null);
                  break;
               case 3:
                  new clazz(null,null,null);
                  break;
               case 4:
                  new clazz(null,null,null,null);
                  break;
               case 5:
                  new clazz(null,null,null,null,null);
                  break;
               case 6:
                  new clazz(null,null,null,null,null,null);
                  break;
               case 7:
                  new clazz(null,null,null,null,null,null,null);
                  break;
               case 8:
                  new clazz(null,null,null,null,null,null,null,null);
                  break;
               case 9:
                  new clazz(null,null,null,null,null,null,null,null,null);
                  break;
               case 10:
                  new clazz(null,null,null,null,null,null,null,null,null,null);
            }
         }
         catch(error:Error)
         {
            trace("Exception caught while trying to create dummy instance for constructor " + "injection. It\'s almost certainly ok to ignore this exception, but you " + "might want to restructure your constructor to prevent errors from " + "happening. See the Swiftsuspenders documentation for more details.\n" + "The caught exception was:\n" + error);
         }
         constructorNode.setChildren(describeType(clazz).factory.constructor[0].children());
      }
   }
}

