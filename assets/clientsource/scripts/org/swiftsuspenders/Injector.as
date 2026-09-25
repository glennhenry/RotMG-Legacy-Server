package org.swiftsuspenders
{
   import avmplus.DescribeTypeJSON;
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import org.swiftsuspenders.dependencyproviders.ClassProvider;
   import org.swiftsuspenders.dependencyproviders.DependencyProvider;
   import org.swiftsuspenders.dependencyproviders.LocalOnlyProvider;
   import org.swiftsuspenders.dependencyproviders.SoftDependencyProvider;
   import org.swiftsuspenders.errors.InjectorInterfaceConstructionError;
   import org.swiftsuspenders.errors.InjectorMissingMappingError;
   import org.swiftsuspenders.mapping.InjectionMapping;
   import org.swiftsuspenders.mapping.MappingEvent;
   import org.swiftsuspenders.reflection.DescribeTypeJSONReflector;
   import org.swiftsuspenders.reflection.DescribeTypeReflector;
   import org.swiftsuspenders.reflection.Reflector;
   import org.swiftsuspenders.typedescriptions.ConstructorInjectionPoint;
   import org.swiftsuspenders.typedescriptions.InjectionPoint;
   import org.swiftsuspenders.typedescriptions.PreDestroyInjectionPoint;
   import org.swiftsuspenders.typedescriptions.TypeDescription;
   import org.swiftsuspenders.utils.SsInternal;
   import org.swiftsuspenders.utils.TypeDescriptor;
   
   use namespace SsInternal;
   
   public class Injector extends EventDispatcher
   {
      
      private static var INJECTION_POINTS_CACHE:Dictionary = new Dictionary(true);
      
      private var _parentInjector:Injector;
      
      private var _applicationDomain:ApplicationDomain;
      
      private var _classDescriptor:TypeDescriptor;
      
      private var _mappings:Dictionary;
      
      private var _mappingsInProcess:Dictionary;
      
      private var _defaultProviders:Dictionary;
      
      private var _managedObjects:Dictionary;
      
      private var _reflector:Reflector;
      
      SsInternal const providerMappings:Dictionary;
      
      public function Injector()
      {
         this.providerMappings = new Dictionary();
         super();
         this._mappings = new Dictionary();
         this._mappingsInProcess = new Dictionary();
         this._defaultProviders = new Dictionary();
         this._managedObjects = new Dictionary();
         try
         {
            this._reflector = DescribeTypeJSON.available ? new DescribeTypeJSONReflector() : new DescribeTypeReflector();
         }
         catch(e:Error)
         {
            _reflector = new DescribeTypeReflector();
         }
         this._classDescriptor = new TypeDescriptor(this._reflector,INJECTION_POINTS_CACHE);
         this._applicationDomain = ApplicationDomain.currentDomain;
      }
      
      SsInternal static function purgeInjectionPointsCache() : void
      {
         INJECTION_POINTS_CACHE = new Dictionary(true);
      }
      
      public function map(param1:Class, param2:String = "") : InjectionMapping
      {
         var _loc3_:String = getQualifiedClassName(param1) + "|" + param2;
         return this._mappings[_loc3_] || this.createMapping(param1,param2,_loc3_);
      }
      
      public function unmap(param1:Class, param2:String = "") : void
      {
         var _loc3_:String = getQualifiedClassName(param1) + "|" + param2;
         var _loc4_:InjectionMapping = this._mappings[_loc3_];
         if((Boolean(_loc4_)) && _loc4_.isSealed)
         {
            throw new InjectorError("Can\'t unmap a sealed mapping");
         }
         if(!_loc4_)
         {
            throw new InjectorError("Error while removing an injector mapping: " + "No mapping defined for dependency " + _loc3_);
         }
         _loc4_.getProvider().destroy();
         delete this._mappings[_loc3_];
         delete this.providerMappings[_loc3_];
         hasEventListener(MappingEvent.POST_MAPPING_REMOVE) && dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_REMOVE,param1,param2,null));
      }
      
      public function satisfies(param1:Class, param2:String = "") : Boolean
      {
         return this.getProvider(getQualifiedClassName(param1) + "|" + param2) != null;
      }
      
      public function satisfiesDirectly(param1:Class, param2:String = "") : Boolean
      {
         return this.providerMappings[getQualifiedClassName(param1) + "|" + param2] != null;
      }
      
      public function getMapping(param1:Class, param2:String = "") : InjectionMapping
      {
         var _loc3_:String = getQualifiedClassName(param1) + "|" + param2;
         var _loc4_:InjectionMapping = this._mappings[_loc3_];
         if(!_loc4_)
         {
            throw new InjectorMissingMappingError("Error while retrieving an injector mapping: " + "No mapping defined for dependency " + _loc3_);
         }
         return _loc4_;
      }
      
      public function injectInto(param1:Object) : void
      {
         var _loc2_:Class = this._reflector.getClass(param1);
         this.applyInjectionPoints(param1,_loc2_,this._classDescriptor.getDescription(_loc2_));
      }
      
      public function getInstance(param1:Class, param2:String = "", param3:Class = null) : *
      {
         var _loc4_:String = null;
         var _loc6_:ConstructorInjectionPoint = null;
         _loc4_ = getQualifiedClassName(param1) + "|" + param2;
         var _loc5_:DependencyProvider = this.getProvider(_loc4_,false);
         if(_loc5_)
         {
            _loc6_ = this._classDescriptor.getDescription(param1).ctor;
            return _loc5_.apply(param3,this,_loc6_ ? _loc6_.injectParameters : null);
         }
         if(param2)
         {
            throw new InjectorMissingMappingError("No mapping found for request " + _loc4_ + ". getInstance only creates an unmapped instance if no name is given.");
         }
         return this.instantiateUnmapped(param1);
      }
      
      public function destroyInstance(param1:Object) : void
      {
         var _loc2_:Class = null;
         if(!param1)
         {
            return;
         }
         _loc2_ = this._reflector.getClass(param1);
         var _loc3_:TypeDescription = this.getTypeDescription(_loc2_);
         var _loc4_:PreDestroyInjectionPoint = _loc3_.preDestroyMethods;
         while(_loc4_)
         {
            _loc4_.applyInjection(param1,_loc2_,this);
            _loc4_ = PreDestroyInjectionPoint(_loc4_.next);
         }
      }
      
      public function teardown() : void
      {
         var _loc1_:InjectionMapping = null;
         var _loc2_:Object = null;
         for each(_loc1_ in this._mappings)
         {
            _loc1_.getProvider().destroy();
         }
         for each(_loc2_ in this._managedObjects)
         {
            this.destroyInstance(_loc2_);
         }
         this._mappings = new Dictionary();
         this._mappingsInProcess = new Dictionary();
         this._defaultProviders = new Dictionary();
         this._managedObjects = new Dictionary();
      }
      
      public function createChildInjector(param1:ApplicationDomain = null) : Injector
      {
         var _loc2_:Injector = new Injector();
         _loc2_.applicationDomain = param1 || this.applicationDomain;
         _loc2_.parentInjector = this;
         return _loc2_;
      }
      
      public function set parentInjector(param1:Injector) : void
      {
         this._parentInjector = param1;
      }
      
      public function get parentInjector() : Injector
      {
         return this._parentInjector;
      }
      
      public function set applicationDomain(param1:ApplicationDomain) : void
      {
         this._applicationDomain = param1 || ApplicationDomain.currentDomain;
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         return this._applicationDomain;
      }
      
      public function addTypeDescription(param1:Class, param2:TypeDescription) : void
      {
         this._classDescriptor.addDescription(param1,param2);
      }
      
      public function getTypeDescription(param1:Class) : TypeDescription
      {
         return this._reflector.describeInjections(param1);
      }
      
      SsInternal function instantiateUnmapped(param1:Class) : Object
      {
         var _loc2_:TypeDescription = this._classDescriptor.getDescription(param1);
         if(!_loc2_.ctor)
         {
            throw new InjectorInterfaceConstructionError("Can\'t instantiate interface " + getQualifiedClassName(param1));
         }
         var _loc3_:* = _loc2_.ctor.createInstance(param1,this);
         hasEventListener(InjectionEvent.POST_INSTANTIATE) && dispatchEvent(new InjectionEvent(InjectionEvent.POST_INSTANTIATE,_loc3_,param1));
         this.applyInjectionPoints(_loc3_,param1,_loc2_);
         return _loc3_;
      }
      
      SsInternal function getProvider(param1:String, param2:Boolean = true) : DependencyProvider
      {
         var _loc3_:DependencyProvider = null;
         var _loc5_:DependencyProvider = null;
         var _loc4_:Injector = this;
         while(_loc4_)
         {
            _loc5_ = _loc4_.providerMappings[param1];
            if(_loc5_)
            {
               if(_loc5_ is SoftDependencyProvider)
               {
                  _loc3_ = _loc5_;
                  _loc4_ = _loc4_.parentInjector;
               }
               else
               {
                  if(!(_loc5_ is LocalOnlyProvider && _loc4_ !== this))
                  {
                     return _loc5_;
                  }
                  _loc4_ = _loc4_.parentInjector;
               }
            }
            else
            {
               _loc4_ = _loc4_.parentInjector;
            }
         }
         if(_loc3_)
         {
            return _loc3_;
         }
         return param2 ? this.getDefaultProvider(param1) : null;
      }
      
      SsInternal function getDefaultProvider(param1:String) : DependencyProvider
      {
         var name:String;
         var typeName:String;
         var type:Class;
         var description:TypeDescription;
         var parts:Array = null;
         var definition:Object = null;
         var mappingId:String = param1;
         if(mappingId === "String|")
         {
            return null;
         }
         parts = mappingId.split("|");
         name = parts.pop();
         if(name.length !== 0)
         {
            return null;
         }
         typeName = parts.pop();
         try
         {
            definition = this._applicationDomain.hasDefinition(typeName) ? this._applicationDomain.getDefinition(typeName) : getDefinitionByName(typeName);
         }
         catch(e:Error)
         {
            return null;
         }
         if(!definition || !(definition is Class))
         {
            return null;
         }
         type = Class(definition);
         description = this._classDescriptor.getDescription(type);
         if(!description.ctor)
         {
            return null;
         }
         return this._defaultProviders[type] = this._defaultProviders[type] || new ClassProvider(type);
      }
      
      private function createMapping(param1:Class, param2:String, param3:String) : InjectionMapping
      {
         var _loc4_:InjectionMapping = null;
         if(this._mappingsInProcess[param3])
         {
            throw new InjectorError("Can\'t change a mapping from inside a listener to it\'s creation event");
         }
         this._mappingsInProcess[param3] = true;
         hasEventListener(MappingEvent.PRE_MAPPING_CREATE) && dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CREATE,param1,param2,null));
         _loc4_ = new InjectionMapping(this,param1,param2,param3);
         this._mappings[param3] = _loc4_;
         var _loc5_:Object = _loc4_.seal();
         hasEventListener(MappingEvent.POST_MAPPING_CREATE) && dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CREATE,param1,param2,_loc4_));
         delete this._mappingsInProcess[param3];
         _loc4_.unseal(_loc5_);
         return _loc4_;
      }
      
      private function applyInjectionPoints(param1:Object, param2:Class, param3:TypeDescription) : void
      {
         var _loc4_:InjectionPoint = param3.injectionPoints;
         hasEventListener(InjectionEvent.PRE_CONSTRUCT) && dispatchEvent(new InjectionEvent(InjectionEvent.PRE_CONSTRUCT,param1,param2));
         while(_loc4_)
         {
            _loc4_.applyInjection(param1,param2,this);
            _loc4_ = _loc4_.next;
         }
         if(param3.preDestroyMethods)
         {
            this._managedObjects[param1] = param1;
         }
         hasEventListener(InjectionEvent.POST_CONSTRUCT) && dispatchEvent(new InjectionEvent(InjectionEvent.POST_CONSTRUCT,param1,param2));
      }
   }
}

