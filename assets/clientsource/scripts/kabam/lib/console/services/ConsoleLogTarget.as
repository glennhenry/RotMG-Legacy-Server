package kabam.lib.console.services
{
   import kabam.lib.console.signals.ConsoleLogSignal;
   import robotlegs.bender.extensions.logging.impl.LogMessageParser;
   import robotlegs.bender.framework.api.IContext;
   import robotlegs.bender.framework.api.ILogTarget;
   import robotlegs.bender.framework.api.LogLevel;
   
   public class ConsoleLogTarget implements ILogTarget
   {
      
      private var consoleLog:ConsoleLogSignal;
      
      private var messageParser:LogMessageParser;
      
      public function ConsoleLogTarget(param1:IContext)
      {
         super();
         this.consoleLog = param1.injector.getInstance(ConsoleLogSignal);
         this.messageParser = new LogMessageParser();
      }
      
      public function log(param1:Object, param2:uint, param3:int, param4:String, param5:Array = null) : void
      {
         var _loc6_:String = LogLevel.NAME[param2] + " " + param1 + " " + this.messageParser.parseMessage(param4,param5);
         this.consoleLog.dispatch(_loc6_);
      }
   }
}

