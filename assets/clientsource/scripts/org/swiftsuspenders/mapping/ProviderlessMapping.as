package org.swiftsuspenders.mapping
{
   import org.swiftsuspenders.dependencyproviders.DependencyProvider;
   
   public interface ProviderlessMapping
   {
      
      function toType(param1:Class) : UnsealedMapping;
      
      function toValue(param1:Object) : UnsealedMapping;
      
      function toSingleton(param1:Class) : UnsealedMapping;
      
      function asSingleton() : UnsealedMapping;
      
      function toProvider(param1:DependencyProvider) : UnsealedMapping;
      
      function seal() : Object;
   }
}

