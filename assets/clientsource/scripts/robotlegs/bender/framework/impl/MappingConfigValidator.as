package robotlegs.bender.framework.impl
{
   import robotlegs.bender.framework.api.MappingConfigError;
   
   public class MappingConfigValidator
   {
      
      private const CANT_CHANGE_GUARDS_AND_HOOKS:String = "You can\'t change the guards and hooks on an existing mapping. Unmap first.";
      
      private const STORED_ERROR_EXPLANATION:String = " The stacktrace for this error was stored at the time when you duplicated the mapping - you may have failed to add guards and hooks that were already present.";
      
      private var _guards:Array;
      
      private var _hooks:Array;
      
      private var _trigger:*;
      
      private var _action:*;
      
      private var _storedError:MappingConfigError;
      
      private var _valid:Boolean = false;
      
      public function MappingConfigValidator(param1:Array, param2:Array, param3:*, param4:*)
      {
         this._guards = param1;
         this._hooks = param2;
         this._trigger = param3;
         this._action = param4;
         super();
      }
      
      public function get valid() : Boolean
      {
         return this._valid;
      }
      
      public function invalidate() : void
      {
         this._valid = false;
         this._storedError = new MappingConfigError(this.CANT_CHANGE_GUARDS_AND_HOOKS + this.STORED_ERROR_EXPLANATION,this._trigger,this._action);
      }
      
      public function validate(param1:Array, param2:Array) : void
      {
         if(!this.arraysMatch(this._guards,param1) || !this.arraysMatch(this._hooks,param2))
         {
            this.throwStoredError() || this.throwMappingError();
         }
         this._valid = true;
         this._storedError = null;
      }
      
      public function checkGuards(param1:Array) : void
      {
         if(this.changesContent(this._guards,param1))
         {
            this.throwMappingError();
         }
      }
      
      public function checkHooks(param1:Array) : void
      {
         if(this.changesContent(this._hooks,param1))
         {
            this.throwMappingError();
         }
      }
      
      private function changesContent(param1:Array, param2:Array) : Boolean
      {
         var _loc3_:* = undefined;
         param2 = this.flatten(param2);
         for each(_loc3_ in param2)
         {
            if(param1.indexOf(_loc3_) == -1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function arraysMatch(param1:Array, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         param1 = param1.slice();
         if(param1.length != param2.length)
         {
            return false;
         }
         var _loc4_:uint = param2.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = param1.indexOf(param2[_loc5_]);
            if(_loc3_ == -1)
            {
               return false;
            }
            param1.splice(_loc3_,1);
            _loc5_++;
         }
         return true;
      }
      
      public function flatten(param1:Array) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            if(_loc3_ is Array)
            {
               _loc2_ = _loc2_.concat(this.flatten(_loc3_ as Array));
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function throwMappingError() : void
      {
         throw new MappingConfigError(this.CANT_CHANGE_GUARDS_AND_HOOKS,this._trigger,this._action);
      }
      
      private function throwStoredError() : Boolean
      {
         if(this._storedError)
         {
            throw this._storedError;
         }
         return false;
      }
   }
}

