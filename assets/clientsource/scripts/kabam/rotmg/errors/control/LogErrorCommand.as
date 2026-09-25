package kabam.rotmg.errors.control
{
   import flash.events.ErrorEvent;
   import robotlegs.bender.framework.api.ILogger;
   
   public class LogErrorCommand
   {
      
      [Inject]
      public var logger:ILogger;
      
      [Inject]
      public var event:ErrorEvent;
      
      public function LogErrorCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.logger.error(this.event.text);
         if(Boolean(this.event["error"]) && this.event["error"] is Error)
         {
            this.logErrorObject(this.event["error"]);
         }
      }
      
      private function logErrorObject(param1:Error) : void
      {
         this.logger.error(param1.message);
         this.logger.error(param1.getStackTrace());
      }
   }
}

