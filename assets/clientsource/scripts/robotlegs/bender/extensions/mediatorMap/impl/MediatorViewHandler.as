package robotlegs.bender.extensions.mediatorMap.impl
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
   
   public class MediatorViewHandler implements IMediatorViewHandler
   {
      
      private const _mappings:Array = [];
      
      private var _knownMappings:Dictionary = new Dictionary(true);
      
      private var _factory:IMediatorFactory;
      
      public function MediatorViewHandler(param1:IMediatorFactory)
      {
         super();
         this._factory = param1;
      }
      
      public function addMapping(param1:IMediatorMapping) : void
      {
         var _loc2_:int = this._mappings.indexOf(param1);
         if(_loc2_ > -1)
         {
            return;
         }
         this._mappings.push(param1);
         this.flushCache();
      }
      
      public function removeMapping(param1:IMediatorMapping) : void
      {
         var _loc2_:int = this._mappings.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         this._mappings.splice(_loc2_,1);
         this.flushCache();
      }
      
      public function handleView(param1:DisplayObject, param2:Class) : void
      {
         var _loc3_:Array = this.getInterestedMappingsFor(param1,param2);
         if(_loc3_)
         {
            this._factory.createMediators(param1,param2,_loc3_);
         }
      }
      
      public function handleItem(param1:Object, param2:Class) : void
      {
         var _loc3_:Array = this.getInterestedMappingsFor(param1,param2);
         if(_loc3_)
         {
            this._factory.createMediators(param1,param2,_loc3_);
         }
      }
      
      private function flushCache() : void
      {
         this._knownMappings = new Dictionary(true);
      }
      
      private function getInterestedMappingsFor(param1:Object, param2:Class) : Array
      {
         var _loc3_:IMediatorMapping = null;
         if(this._knownMappings[param2] === false)
         {
            return null;
         }
         if(this._knownMappings[param2] == undefined)
         {
            this._knownMappings[param2] = false;
            for each(_loc3_ in this._mappings)
            {
               _loc3_.validate();
               if(_loc3_.matcher.matches(param1))
               {
                  this._knownMappings[param2] = this._knownMappings[param2] || [];
                  this._knownMappings[param2].push(_loc3_);
               }
            }
            if(this._knownMappings[param2] === false)
            {
               return null;
            }
         }
         return this._knownMappings[param2] as Array;
      }
   }
}

