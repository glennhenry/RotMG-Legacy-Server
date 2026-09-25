package robotlegs.bender.extensions.mediatorMap.impl
{
   import robotlegs.bender.extensions.matching.ITypeFilter;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
   import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
   import robotlegs.bender.framework.impl.MappingConfigValidator;
   
   public class MediatorMapping implements IMediatorMapping, IMediatorMappingConfig
   {
      
      private var _locked:Boolean = false;
      
      private var _validator:MappingConfigValidator;
      
      private var _matcher:ITypeFilter;
      
      private var _mediatorClass:Class;
      
      private var _guards:Array = [];
      
      private var _hooks:Array = [];
      
      public function MediatorMapping(param1:ITypeFilter, param2:Class)
      {
         super();
         this._matcher = param1;
         this._mediatorClass = param2;
      }
      
      public function get matcher() : ITypeFilter
      {
         return this._matcher;
      }
      
      public function get mediatorClass() : Class
      {
         return this._mediatorClass;
      }
      
      public function get guards() : Array
      {
         return this._guards;
      }
      
      public function get hooks() : Array
      {
         return this._hooks;
      }
      
      public function withGuards(... rest) : IMediatorMappingConfig
      {
         this._validator && this._validator.checkGuards(rest);
         this._guards = this._guards.concat.apply(null,rest);
         return this;
      }
      
      public function withHooks(... rest) : IMediatorMappingConfig
      {
         this._validator && this._validator.checkHooks(rest);
         this._hooks = this._hooks.concat.apply(null,rest);
         return this;
      }
      
      internal function invalidate() : void
      {
         if(this._validator)
         {
            this._validator.invalidate();
         }
         else
         {
            this.createValidator();
         }
         this._guards = [];
         this._hooks = [];
      }
      
      public function validate() : void
      {
         if(!this._validator)
         {
            this.createValidator();
         }
         else if(!this._validator.valid)
         {
            this._validator.validate(this._guards,this._hooks);
         }
      }
      
      private function createValidator() : void
      {
         this._validator = new MappingConfigValidator(this._guards.slice(),this._hooks.slice(),this._matcher,this._mediatorClass);
      }
   }
}

