package robotlegs.bender.extensions.commandCenter.impl
{
   import flash.utils.Dictionary;
   import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
   import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
   import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
   
   public class CommandMapper implements ICommandMapper, ICommandUnmapper
   {
      
      private const _mappings:Dictionary = new Dictionary();
      
      private var _trigger:ICommandTrigger;
      
      public function CommandMapper(param1:ICommandTrigger)
      {
         super();
         this._trigger = param1;
      }
      
      public function toCommand(param1:Class) : ICommandMappingConfig
      {
         return this.locked(this._mappings[param1]) || this.createMapping(param1);
      }
      
      public function fromCommand(param1:Class) : void
      {
         var _loc2_:ICommandMapping = this._mappings[param1];
         _loc2_ && this._trigger.removeMapping(_loc2_);
         delete this._mappings[param1];
      }
      
      public function fromAll() : void
      {
         var _loc1_:ICommandMapping = null;
         for each(_loc1_ in this._mappings)
         {
            this._trigger.removeMapping(_loc1_);
            delete this._mappings[_loc1_.commandClass];
         }
      }
      
      private function createMapping(param1:Class) : CommandMapping
      {
         var _loc2_:CommandMapping = new CommandMapping(param1);
         this._trigger.addMapping(_loc2_);
         this._mappings[param1] = _loc2_;
         return _loc2_;
      }
      
      private function locked(param1:CommandMapping) : CommandMapping
      {
         if(!param1)
         {
            return null;
         }
         param1.invalidate();
         return param1;
      }
   }
}

