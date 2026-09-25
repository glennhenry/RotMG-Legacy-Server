package org.swiftsuspenders.mapping
{
   import org.swiftsuspenders.Injector;
   import org.swiftsuspenders.InjectorError;
   import org.swiftsuspenders.dependencyproviders.ClassProvider;
   import org.swiftsuspenders.dependencyproviders.DependencyProvider;
   import org.swiftsuspenders.dependencyproviders.ForwardingProvider;
   import org.swiftsuspenders.dependencyproviders.InjectorUsingProvider;
   import org.swiftsuspenders.dependencyproviders.LocalOnlyProvider;
   import org.swiftsuspenders.dependencyproviders.SingletonProvider;
   import org.swiftsuspenders.dependencyproviders.SoftDependencyProvider;
   import org.swiftsuspenders.dependencyproviders.ValueProvider;
   import org.swiftsuspenders.utils.SsInternal;
   
   public class InjectionMapping implements ProviderlessMapping, UnsealedMapping
   {
      
      private var _type:Class;
      
      private var _name:String;
      
      private var _mappingId:String;
      
      private var _creatingInjector:Injector;
      
      private var _defaultProviderSet:Boolean;
      
      private var _overridingInjector:Injector;
      
      private var _soft:Boolean;
      
      private var _local:Boolean;
      
      private var _sealed:Boolean;
      
      private var _sealKey:Object;
      
      public function InjectionMapping(param1:Injector, param2:Class, param3:String, param4:String)
      {
         super();
         this._creatingInjector = param1;
         this._type = param2;
         this._name = param3;
         this._mappingId = param4;
         this._defaultProviderSet = true;
         this.mapProvider(new ClassProvider(param2));
      }
      
      public function asSingleton() : UnsealedMapping
      {
         this.toSingleton(this._type);
         return this;
      }
      
      public function toType(param1:Class) : UnsealedMapping
      {
         this.toProvider(new ClassProvider(param1));
         return this;
      }
      
      public function toSingleton(param1:Class) : UnsealedMapping
      {
         this.toProvider(new SingletonProvider(param1,this._creatingInjector));
         return this;
      }
      
      public function toValue(param1:Object) : UnsealedMapping
      {
         this.toProvider(new ValueProvider(param1));
         return this;
      }
      
      public function toProvider(param1:DependencyProvider) : UnsealedMapping
      {
         this._sealed && this.throwSealedError();
         if(this.hasProvider() && param1 != null && !this._defaultProviderSet)
         {
            trace("Warning: Injector already has a mapping for " + this._mappingId + ".\n " + "If you have overridden this mapping intentionally you can use " + "\"injector.unmap()\" prior to your replacement mapping in order to " + "avoid seeing this message.");
            this._creatingInjector.hasEventListener(MappingEvent.MAPPING_OVERRIDE) && this._creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.MAPPING_OVERRIDE,this._type,this._name,this));
         }
         this.dispatchPreChangeEvent();
         this._defaultProviderSet = false;
         this.mapProvider(param1);
         this.dispatchPostChangeEvent();
         return this;
      }
      
      public function softly() : ProviderlessMapping
      {
         var _loc1_:DependencyProvider = null;
         this._sealed && this.throwSealedError();
         if(!this._soft)
         {
            _loc1_ = this.getProvider();
            this.dispatchPreChangeEvent();
            this._soft = true;
            this.mapProvider(_loc1_);
            this.dispatchPostChangeEvent();
         }
         return this;
      }
      
      public function locally() : ProviderlessMapping
      {
         this._sealed && this.throwSealedError();
         if(this._local)
         {
            return this;
         }
         var _loc1_:DependencyProvider = this.getProvider();
         this.dispatchPreChangeEvent();
         this._local = true;
         this.mapProvider(_loc1_);
         this.dispatchPostChangeEvent();
         return this;
      }
      
      public function seal() : Object
      {
         if(this._sealed)
         {
            throw new InjectorError("Mapping is already sealed.");
         }
         this._sealed = true;
         this._sealKey = {};
         return this._sealKey;
      }
      
      public function unseal(param1:Object) : InjectionMapping
      {
         if(!this._sealed)
         {
            throw new InjectorError("Can\'t unseal a non-sealed mapping.");
         }
         if(param1 !== this._sealKey)
         {
            throw new InjectorError("Can\'t unseal mapping without the correct key.");
         }
         this._sealed = false;
         this._sealKey = null;
         return this;
      }
      
      public function get isSealed() : Boolean
      {
         return this._sealed;
      }
      
      public function hasProvider() : Boolean
      {
         return Boolean(this._creatingInjector.SsInternal::providerMappings[this._mappingId]);
      }
      
      public function getProvider() : DependencyProvider
      {
         var _loc1_:DependencyProvider = this._creatingInjector.SsInternal::providerMappings[this._mappingId];
         while(_loc1_ is ForwardingProvider)
         {
            _loc1_ = ForwardingProvider(_loc1_).provider;
         }
         return _loc1_;
      }
      
      public function setInjector(param1:Injector) : InjectionMapping
      {
         this._sealed && this.throwSealedError();
         if(param1 == this._overridingInjector)
         {
            return this;
         }
         var _loc2_:DependencyProvider = this.getProvider();
         this._overridingInjector = param1;
         this.mapProvider(_loc2_);
         return this;
      }
      
      private function mapProvider(param1:DependencyProvider) : void
      {
         if(this._soft)
         {
            param1 = new SoftDependencyProvider(param1);
         }
         if(this._local)
         {
            param1 = new LocalOnlyProvider(param1);
         }
         if(this._overridingInjector)
         {
            param1 = new InjectorUsingProvider(this._overridingInjector,param1);
         }
         this._creatingInjector.SsInternal::providerMappings[this._mappingId] = param1;
      }
      
      private function throwSealedError() : void
      {
         throw new InjectorError("Can\'t change a sealed mapping");
      }
      
      private function dispatchPreChangeEvent() : void
      {
         this._creatingInjector.hasEventListener(MappingEvent.PRE_MAPPING_CHANGE) && this._creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.PRE_MAPPING_CHANGE,this._type,this._name,this));
      }
      
      private function dispatchPostChangeEvent() : void
      {
         this._creatingInjector.hasEventListener(MappingEvent.POST_MAPPING_CHANGE) && this._creatingInjector.dispatchEvent(new MappingEvent(MappingEvent.POST_MAPPING_CHANGE,this._type,this._name,this));
      }
   }
}

