package robotlegs.bender.framework.impl
{
   import flash.utils.getTimer;
   import robotlegs.bender.framework.api.ILogTarget;
   import robotlegs.bender.framework.api.ILogger;
   
   public class Logger implements ILogger
   {
      
      private var _source:Object;
      
      private var _target:ILogTarget;
      
      public function Logger(param1:Object, param2:ILogTarget)
      {
         super();
         this._source = param1;
         this._target = param2;
      }
      
      public function debug(param1:*, param2:Array = null) : void
      {
         this._target.log(this._source,32,getTimer(),param1,param2);
      }
      
      public function info(param1:*, param2:Array = null) : void
      {
         this._target.log(this._source,16,getTimer(),param1,param2);
      }
      
      public function warn(param1:*, param2:Array = null) : void
      {
         this._target.log(this._source,8,getTimer(),param1,param2);
      }
      
      public function error(param1:*, param2:Array = null) : void
      {
         this._target.log(this._source,4,getTimer(),param1,param2);
      }
      
      public function fatal(param1:*, param2:Array = null) : void
      {
         this._target.log(this._source,2,getTimer(),param1,param2);
      }
   }
}

