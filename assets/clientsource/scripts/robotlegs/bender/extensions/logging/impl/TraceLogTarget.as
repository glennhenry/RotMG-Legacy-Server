package robotlegs.bender.extensions.logging.impl
{
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.ILogTarget;
   import robotlegs.bender.framework.api.LogLevel;
   
   public class TraceLogTarget implements ILogTarget
   {
      
      private const _messageParser:LogMessageParser = new LogMessageParser();
      
      private var _context:IContext;
      
      public function TraceLogTarget(param1:IContext)
      {
         super();
         this._context = param1;
      }
      
      public function log(param1:Object, param2:uint, param3:int, param4:String, param5:Array = null) : void
      {
         trace(param3 + " " + LogLevel.NAME[param2] + " " + this._context + " " + param1 + " - " + this._messageParser.parseMessage(param4,param5));
      }
   }
}

