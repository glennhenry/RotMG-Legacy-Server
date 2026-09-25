package robotlegs.bender.framework.api
{
   public class MappingConfigError extends Error
   {
      
      private var _trigger:Object;
      
      private var _action:Object;
      
      public function MappingConfigError(param1:String, param2:*, param3:*)
      {
         super(param1);
         this._trigger = param2;
         this._action = param3;
      }
      
      public function get trigger() : Object
      {
         return this._trigger;
      }
      
      public function get action() : Object
      {
         return this._action;
      }
   }
}

